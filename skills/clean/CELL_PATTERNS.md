# Clean 노트북 셀 패턴

`dalykit:clean`이 생성하는 노트북은 아래 경로 계약을 따른다.

## 생성 파일

```text
dalykit/
└── kits/{kit}/clean/
    ├── clean_pipeline.ipynb
    ├── clean_results.json
    ├── cleaned.csv
    └── figures/
```

## 필수 코드 패턴

```python
import json
from pathlib import Path

BASE_DIR = Path("dalykit")
ACTIVE = json.loads((BASE_DIR / "config" / "active.json").read_text(encoding="utf-8"))
KIT = ACTIVE["kit"]

STAGE_DIR = BASE_DIR / "kits" / KIT / "clean"
FIGURES_DIR = STAGE_DIR / "figures"
RESULT_PATH = STAGE_DIR / "clean_results.json"
OUTPUT_PATH = STAGE_DIR / "cleaned.csv"

FIGURES_DIR.mkdir(parents=True, exist_ok=True)
```

```python
def save_results(payload):
    RESULT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

df_clean.to_csv(OUTPUT_PATH, index=False)
```

## 규칙

1. 결과 데이터 파일명은 항상 `cleaned.csv`
2. 결과 JSON은 `clean_results.json`
3. 시각화는 `clean/figures/`에 저장
