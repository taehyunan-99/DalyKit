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

수치형 컬럼이 2개 이상이면 아래 코드맵을 그대로 사용해 `heatmap_corr.png`를 생성한다.

```python
num_cols = df.select_dtypes(include=np.number).columns
if len(num_cols) >= 2:
    corr = df[num_cols].corr()
    mask = np.triu(np.ones_like(corr, dtype=bool), k=1)

    fig, ax = plt.subplots(figsize=(12, 10))
    sns.heatmap(corr, mask=mask, cmap="RdYlBu_r", annot=True, fmt=".2f",
                annot_kws={"fontweight": "bold", "fontsize": 8},
                linewidth=1, ax=ax)
    ax.set_title("상관관계 히트맵", fontdict={"fontweight": "bold"})
    plt.tight_layout()
    figure_path = save_fig("heatmap_corr.png")
    results["figures"].append(figure_path)
    results["sections"]["correlation_heatmap"] = {
        "columns": num_cols.tolist(),
        "correlation": corr.to_dict(),
        "figure": figure_path,
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
8. 상관관계 히트맵은 고정 히트맵 셀을 사용해 `heatmap_corr.png`로 저장한다
