# EDA 노트북 셀 패턴

`dalykit:eda`가 생성하는 노트북은 아래 경로 계약을 따른다.

## 생성 파일

```text
dalykit/
├── config/active.json
├── data/raw/{raw_file}
└── kits/{kit}/eda/
    ├── eda_analysis.ipynb
    ├── eda_results.json
    └── figures/
```

## 필수 코드 패턴

```python
import json
import os
from pathlib import Path
from io import StringIO

import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
import numpy as np
import seaborn as sns

BASE_DIR = Path("/absolute/path/to/dalykit")  # 생성 시 실제 dalykit 절대 경로로 치환
ACTIVE_PATH = BASE_DIR / "config" / "active.json"
ACTIVE = json.loads(ACTIVE_PATH.read_text(encoding="utf-8"))
KIT = ACTIVE["kit"]
RAW_FILE = ACTIVE["raw_data"]

STAGE_DIR = BASE_DIR / "kits" / KIT / "eda"
FIGURES_DIR = STAGE_DIR / "figures"
RESULT_PATH = STAGE_DIR / "eda_results.json"
DATA_PATH = BASE_DIR / "data" / "raw" / RAW_FILE

FIGURES_DIR.mkdir(parents=True, exist_ok=True)
```

### 한글 폰트 설정

첫 번째 코드 셀에서 그래프 생성 전에 반드시 실행한다.

```python
def setup_korean_font():
    candidates = [
        "AppleGothic",
        "Malgun Gothic",
        "NanumGothic",
        "Noto Sans CJK KR",
        "Noto Sans KR",
        "DejaVu Sans",
    ]
    available = {font.name for font in fm.fontManager.ttflist}
    selected = "DejaVu Sans"
    for font_name in candidates:
        if font_name in available:
            selected = font_name
            break
    plt.rcParams["font.family"] = selected
    plt.rcParams["axes.unicode_minus"] = False
    return selected

FONT_NAME = setup_korean_font()
```

```python
def save_fig(filename):
    path = FIGURES_DIR / filename
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    return str(path)
```

```python
def save_results(payload):
    RESULT_PATH.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
```

### 셀 단위 저장 패턴

EDA 노트북은 마지막 셀에서 한 번만 저장하지 않는다.
각 분석 셀 끝에서 `results`를 갱신하고 즉시 `save_results(results)`를 호출한다.

```python
results = {
    "metadata": {
        "kit": KIT,
        "raw_data": str(DATA_PATH),
        "font": FONT_NAME,
    },
    "sections": {},
    "figures": [],
}
save_results(results)
```

### 고정 기초통계 셀

EDA 노트북 상단에는 데이터 로드 직후 아래 셀을 반드시 포함한다.
`info()`와 `describe(include="all")`는 컬럼/행을 생략하지 않고 전체 출력한다.

```python
df = pd.read_csv(DATA_PATH)
pd.set_option("display.max_columns", None)
pd.set_option("display.max_rows", None)
pd.set_option("display.max_colwidth", None)
pd.set_option("display.width", 0)

info_buffer = StringIO()
df.info(buf=info_buffer, verbose=True, show_counts=True)
info_text = info_buffer.getvalue()
display(df.describe(include="all").transpose())
print(info_text)

results["sections"]["basic_statistics"] = {
    "shape": list(df.shape),
    "info": info_text,
    "describe": df.describe(include="all").astype(str).to_dict(),
}
save_results(results)
```

```python
# 예: 데이터 개요 셀
results["sections"]["overview"] = {
    "shape": list(df.shape),
    "columns": df.columns.tolist(),
    "dtypes": df.dtypes.astype(str).to_dict(),
    "missing": df.isna().sum().to_dict(),
}
save_results(results)
```

```python
# 예: 시각화 셀
plt.figure(figsize=(10, 6))
df.isna().mean().sort_values(ascending=False).head(20).plot(kind="bar")
figure_path = save_fig("missing_rate_top20.png")
results["figures"].append(figure_path)
results["sections"]["missing_summary"] = {
    "top_missing_columns": df.isna().mean().sort_values(ascending=False).head(20).to_dict(),
}
save_results(results)
```

### 고정 상관관계 히트맵 셀

수치형 컬럼이 2개 이상이면 아래 코드맵을 그대로 사용한다.
컬럼이 30개를 초과하면 전체 히트맵에 더해 **상위 상관 페어 히트맵**과 **클러스터 그룹별 히트맵**을 추가로 생성한다.

#### 1. 타겟 변수 로드

`domain.md`의 `## 핵심 타겟 변수`를 우선 사용하고, 없으면 `## ML 목표`의 `타겟 변수`를 사용한다.
타겟이 수치형이면 모든 히트맵에서 y축 하단(=마지막 행)에 배치하고 셀 테두리를 굵게 강조한다.
타겟이 비수치형이거나 데이터에 없으면 강조 없이 일반 히트맵으로 그린다.

```python
import re

DOMAIN_PATH = BASE_DIR / "config" / "domain.md"

def load_target_from_domain(path):
    if not path.exists():
        return None
    text = path.read_text(encoding="utf-8")
    # 1순위: ## 핵심 타겟 변수 → "- 타겟: <값>"
    m = re.search(r"##\s*핵심 타겟 변수.*?-\s*타겟\s*:\s*(.+)", text, re.S)
    if m:
        value = m.group(1).splitlines()[0].strip()
        if value:
            return value
    # 2순위: ## ML 목표 → "- 타겟 변수: <값>"
    m = re.search(r"##\s*ML 목표.*?-\s*타겟 변수\s*:\s*(.+)", text, re.S)
    if m:
        value = m.group(1).splitlines()[0].strip()
        if value:
            return value
    return None

TARGET_RAW = load_target_from_domain(DOMAIN_PATH)
TARGET = TARGET_RAW if TARGET_RAW in df.columns and pd.api.types.is_numeric_dtype(df[TARGET_RAW]) else None
```

#### 2. 히트맵 헬퍼

타겟이 있으면 컬럼 순서의 마지막에 두고(=y축 하단), 타겟 행/열에 두꺼운 테두리를 그린다.

```python
import matplotlib.patches as mpatches

def order_with_target_last(cols, target):
    if target is None or target not in cols:
        return list(cols)
    return [c for c in cols if c != target] + [target]

def draw_heatmap(corr, title, filename, target=None, figsize=None):
    cols = order_with_target_last(corr.columns.tolist(), target)
    corr = corr.loc[cols, cols]
    mask = np.triu(np.ones_like(corr, dtype=bool), k=1)

    n = len(cols)
    # 컬럼 수에 따라 가독성 정책 분기
    # - n <= 30: 일반 모드 (annot 표시, 폰트 8)
    # - n > 30:  overview 모드 (annot 생략, 라벨 폰트 축소)
    overview = n > 30
    annot = not overview
    annot_fontsize = 8
    tick_fontsize = max(5, min(9, int(180 / max(n, 1))))

    if figsize is None:
        side = max(8, min(20, 0.45 * n + 4))
        figsize = (side, side * 0.85)

    fig, ax = plt.subplots(figsize=figsize)
    sns.heatmap(corr, mask=mask, cmap="RdYlBu_r", annot=annot, fmt=".2f",
                annot_kws={"fontweight": "bold", "fontsize": annot_fontsize},
                linewidth=0.5 if overview else 1,
                vmin=-1, vmax=1, ax=ax)
    ax.set_title(title, fontdict={"fontweight": "bold"})

    # X축 라벨 회전 명시적 0 고정 (seaborn 자동 회전 방지)
    ax.tick_params(axis="x", labelrotation=0, labelsize=tick_fontsize)
    ax.tick_params(axis="y", labelrotation=0, labelsize=tick_fontsize)

    if target in cols:
        idx = cols.index(target)
        # 타겟 행 강조 (마지막 행)
        ax.add_patch(mpatches.Rectangle((0, idx), n, 1, fill=False,
                                        edgecolor="black", linewidth=2.5, clip_on=False))
        # 타겟 열 강조
        ax.add_patch(mpatches.Rectangle((idx, 0), 1, n, fill=False,
                                        edgecolor="black", linewidth=2.5, clip_on=False))
        # 라벨 bold
        for label in ax.get_xticklabels() + ax.get_yticklabels():
            if label.get_text() == target:
                label.set_fontweight("bold")

    plt.tight_layout()
    path = save_fig(filename)
    plt.close()
    return path
```

#### 3. 전체 히트맵 + 적응형 세부 히트맵

```python
num_cols = df.select_dtypes(include=np.number).columns.tolist()
heatmap_summary = {}

if len(num_cols) >= 2:
    corr = df[num_cols].corr()

    # 3-1. 전체 히트맵 (항상 생성)
    full_path = draw_heatmap(corr, "상관관계 히트맵 (전체)", "heatmap_corr.png", target=TARGET)
    results["figures"].append(full_path)
    heatmap_summary["full"] = {"columns": num_cols, "figure": full_path}

    # 컬럼이 30개를 초과하면 세부 히트맵 추가
    if len(num_cols) > 30:
        # 3-2. 상위 상관 페어 히트맵 (등장 컬럼 ≤ 30 보장)
        abs_corr = corr.abs().where(np.triu(np.ones(corr.shape), k=1).astype(bool))
        sorted_pairs = abs_corr.stack().dropna().sort_values(ascending=False)

        # 가독성을 위한 컬럼 상한. 타겟이 있으면 타겟 자리를 미리 확보
        max_top_cols = 30
        non_target_cap = max_top_cols - 1 if TARGET else max_top_cols
        chosen_pairs = []
        chosen_cols = set()
        for (a, b), v in sorted_pairs.items():
            new_cols = chosen_cols | {a, b}
            # 타겟은 마지막에 추가하므로 비타겟 컬럼 상한으로 비교
            non_target_count = len(new_cols - ({TARGET} if TARGET else set()))
            if non_target_count > non_target_cap:
                continue
            chosen_pairs.append(((a, b), float(v)))
            chosen_cols = new_cols
            if len(chosen_pairs) >= 30 or non_target_count >= non_target_cap:
                break

        top_cols = sorted(chosen_cols - ({TARGET} if TARGET else set()))
        if TARGET:
            top_cols.append(TARGET)  # 항상 마지막(=y축 하단)에 위치

        # 유효 페어가 거의 없으면 상위 페어 히트맵 생략
        if len(top_cols) >= 2:
            top_corr = df[top_cols].corr()
            top_path = draw_heatmap(top_corr,
                                    f"상위 상관 {len(chosen_pairs)}쌍 (등장 컬럼 {len(top_cols)}개)",
                                    "heatmap_corr_top.png", target=TARGET)
            results["figures"].append(top_path)
            heatmap_summary["top_pairs"] = {
                "columns": top_cols,
                "pairs": [{"col1": a, "col2": b, "abs_corr": v}
                          for (a, b), v in chosen_pairs],
                "figure": top_path,
            }
        else:
            heatmap_summary["top_pairs"] = {
                "skipped": "유효 상관 페어가 부족하여 상위 페어 히트맵을 생략했습니다.",
            }

        # 3-3. 그룹별 히트맵 (계층 클러스터링)
        # 타겟은 클러스터링 대상에서 제외 (모든 그룹에 공통 추가)
        # 상수 컬럼/유효 표본 부족으로 NaN 상관이 발생하면 클러스터링 실패
        # → 분산 0 또는 NaN 상관이 포함된 컬럼은 사전 제거
        candidate_cols = [c for c in num_cols if c != TARGET]
        nunique = df[candidate_cols].nunique(dropna=True)
        cluster_cols = [c for c in candidate_cols if nunique[c] >= 2]

        if len(cluster_cols) >= 2:
            cluster_corr = df[cluster_cols].corr()
            # 행/열 모두 NaN만 있는 컬럼 제거 (자기 상관 1.0 제외)
            valid_mask = cluster_corr.notna().sum(axis=0) > 1
            cluster_cols = [c for c in cluster_cols if valid_mask.get(c, False)]
            cluster_corr = cluster_corr.loc[cluster_cols, cluster_cols].fillna(0.0)

        if len(cluster_cols) >= 2:
            from scipy.cluster.hierarchy import linkage, fcluster
            from scipy.spatial.distance import squareform

            dist = 1 - cluster_corr.abs()
            np.fill_diagonal(dist.values, 0)
            condensed = squareform(dist.values, checks=False)
            Z = linkage(condensed, method="average")

            # 그룹당 최대 25컬럼이 되도록 클러스터 수 결정
            # 그룹 멤버(=비타겟 컬럼) 최대 25, 타겟은 모든 그룹에 공통 추가되므로
            # 실제 표시 컬럼은 최대 26 (타겟 있을 때)
            max_per_group = 25
            n_clusters = max(2, int(np.ceil(len(cluster_cols) / max_per_group)))
            # 멤버 25 초과 그룹이 남으면 클러스터 수를 늘려 재시도
            for _ in range(10):
                labels = fcluster(Z, t=n_clusters, criterion="maxclust")
                sizes = pd.Series(labels).value_counts()
                if sizes.max() <= max_per_group:
                    break
                n_clusters += 1

            groups = []
            for cid in sorted(set(labels)):
                members = [cluster_cols[i] for i, lab in enumerate(labels) if lab == cid]
                if len(members) < 2:
                    continue
                group_cols = members + ([TARGET] if TARGET else [])
                group_corr = df[group_cols].corr()
                fname = f"heatmap_corr_group{cid}.png"
                gpath = draw_heatmap(group_corr,
                                     f"그룹 {cid} 히트맵 ({len(members)}개 컬럼)",
                                     fname, target=TARGET)
                results["figures"].append(gpath)
                groups.append({"group_id": int(cid), "columns": group_cols, "figure": gpath})

            heatmap_summary["groups"] = groups
        else:
            heatmap_summary["groups"] = {
                "skipped": "유효 수치형 컬럼이 부족하여 그룹별 히트맵을 생략했습니다.",
            }

    results["sections"]["correlation_heatmap"] = {
        "target": TARGET,
        "n_numeric_cols": len(num_cols),
        **heatmap_summary,
    }
    save_results(results)
```

## 규칙

1. 원본 데이터는 `data/raw/`에서만 읽는다
2. 결과 JSON은 `eda/eda_results.json` 하나만 저장한다
3. 이미지 저장 경로는 `eda/figures/`
4. 그래프 생성 전 `setup_korean_font()`를 반드시 호출한다
5. 각 분석 셀 끝에서 `save_results(results)`를 호출한다
6. 긴 EDA 중간에 실패해도 이전 셀 결과가 `eda_results.json`에 남아야 한다
7. 상단 기초통계 셀에서 `info()`와 `describe(include="all")` 전체 결과를 생략 없이 출력한다
8. 상관관계 히트맵은 고정 셀을 사용한다. 전체는 `heatmap_corr.png`(overview)로 항상 저장하고, 수치형 컬럼이 30개를 초과하면 그 아래에 `heatmap_corr_top.png`(상위 페어, 등장 컬럼 ≤ 30)와 `heatmap_corr_group{N}.png`(클러스터 그룹별, 그룹 멤버 ≤ 25 + 타겟 공통 추가)를 세부 뷰로 추가 저장한다. 해석은 세부 히트맵에서 수행한다
9. 컬럼이 30개를 초과하는 전체 히트맵은 overview 모드로 그린다(annot 생략, 라벨 폰트 축소). 셀 값은 같은 셀에서 함께 출력되는 `eda_results.json`의 `correlation_heatmap.full`/`top_pairs.pairs`에서 확인한다
10. 모든 히트맵에서 타겟 변수(domain.md `핵심 타겟 변수` → `ML 목표` 폴백, 수치형일 때만)는 y축 하단에 두고 행/열 테두리를 굵게 강조한다
11. X축 라벨은 회전하지 않는다 (`shared/viz/STYLE_GUIDE.md` 참조). 히트맵에서는 `ax.tick_params(axis="x", labelrotation=0)`로 명시 고정해 seaborn 자동 회전을 차단한다
