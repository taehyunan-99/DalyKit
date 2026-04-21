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

import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

BASE_DIR = Path("dalykit")
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

## 규칙

1. 원본 데이터는 `data/raw/`에서만 읽는다
2. 결과 JSON은 `eda/eda_results.json` 하나만 저장한다
3. 이미지 저장 경로는 `eda/figures/`
4. 그래프 생성 전 `setup_korean_font()`를 반드시 호출한다
5. 각 분석 셀 끝에서 `save_results(results)`를 호출한다
6. 긴 EDA 중간에 실패해도 이전 셀 결과가 `eda_results.json`에 남아야 한다
