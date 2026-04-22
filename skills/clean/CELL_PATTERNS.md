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

BASE_DIR = Path("/absolute/path/to/dalykit")  # 생성 시 실제 dalykit 절대 경로로 치환
ACTIVE = json.loads((BASE_DIR / "config" / "active.json").read_text(encoding="utf-8"))
KIT = ACTIVE["kit"]

RAW_FILE = ACTIVE.get("raw_data", "")
INPUT_PATH = BASE_DIR / "data" / "raw" / RAW_FILE  # 사용자가 CSV를 직접 지정했으면 해당 경로로 치환

STAGE_DIR = BASE_DIR / "kits" / KIT / "clean"
FIGURES_DIR = STAGE_DIR / "figures"
RESULT_PATH = STAGE_DIR / "clean_results.json"
OUTPUT_PATH = STAGE_DIR / "cleaned.csv"

FIGURES_DIR.mkdir(parents=True, exist_ok=True)
```

```python
def save_results(payload):
    RESULT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
```

```python
# 최종 저장 셀
df_clean.to_csv(OUTPUT_PATH, index=False)
save_results(results)
```

## 셀 단위 저장 규칙

전처리 노트북도 마지막 셀에서만 저장하지 않는다. 주요 처리 셀마다 `results`를 갱신하고 `save_results(results)`를 호출한다.

```python
# 초기화 셀 — 설정 셀 직후에 위치
results = {
    "metadata": {"kit": KIT, "input": str(INPUT_PATH)},
    "steps": {},
}
save_results(results)
```

```python
# 예: 결측값 처리 셀
results["steps"]["missing"] = {
    "dropped_columns": [...],
    "filled_columns": {...},
}
save_results(results)
```

```python
# 예: 중복 제거 셀
results["steps"]["duplicates"] = {"removed": int(n_dup)}
save_results(results)
```

```python
# 예: 이상치 처리 셀
results["steps"]["outliers"] = {"method": "IQR", "removed": int(n_out)}
save_results(results)
```

## 규칙

1. 결과 데이터 파일명은 항상 `cleaned.csv`
2. 결과 JSON은 `clean_results.json`
3. 시각화는 `clean/figures/`에 저장
4. 주요 처리 셀 끝에서 `save_results(results)`를 호출한다
