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

## 규칙

1. 원본 데이터는 `data/raw/`에서만 읽는다
2. 결과 JSON은 `eda/eda_results.json` 하나만 저장한다
3. 이미지 저장 경로는 `eda/figures/`
