---
name: clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  노트북을 생성한다.
  트리거: "dalykit:clean", "전처리", "결측값 처리".
user_invocable: true
---

# Clean (데이터 전처리)

> 활성 kit 기준으로 `clean/` 폴더에 전처리 노트북, 결과 JSON, cleaned.csv, 보고서를 저장한다.

## 사용법

```text
dalykit:clean
dalykit:clean dalykit/data/raw/bank_customers.csv
dalykit:clean report
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- 입력 데이터가 있어야 한다
  - 기본: `dalykit/data/raw/{raw_data}`
  - 선택: 사용자가 지정한 CSV 경로
- 의존성이 불명확하면 `dalykit:doctor`를 먼저 안내한다

## 경로 규칙

| 항목 | 경로 |
|------|------|
| stage 디렉토리 | `dalykit/kits/{kit}/clean/` |
| 노트북 | `dalykit/kits/{kit}/clean/clean_pipeline.ipynb` |
| 결과 JSON | `dalykit/kits/{kit}/clean/clean_results.json` |
| 결과 데이터 | `dalykit/kits/{kit}/clean/cleaned.csv` |
| 보고서 | `dalykit/kits/{kit}/clean/clean_report.md` |
| 시각화 | `dalykit/kits/{kit}/clean/figures/` |

## 워크플로우

### `dalykit:clean`

1. 활성 kit 확인
2. 인자 없으면 raw 데이터를 사용한다
3. EDA 보고서가 있으면 함께 읽어 결측값·이상치·타입 이슈를 반영한다
4. [CELL_PATTERNS.md](CELL_PATTERNS.md)를 참조해 노트북 생성
5. 노트북은 각 주요 처리 셀(결측값·중복·이상치·타입 변환) 끝에서 `clean_results.json`을 중간 저장하도록 구성한다
6. 노트북은 실행 시 `clean_results.json`, `cleaned.csv`, `figures/`를 저장하도록 구성

### `dalykit:clean report`

1. `clean_results.json`을 읽는다
2. [PREPROCESSING_REPORT.md](PREPROCESSING_REPORT.md)를 참조해 보고서를 생성한다
3. `clean_report.md`에 저장한다
4. `active.json.stages_completed`와 `artifacts.clean_data`를 갱신한다

## 완료 기준

- `dalykit:clean`은 노트북 생성만 수행하므로 완료 단계로 기록하지 않는다
- `dalykit:clean report`까지 생성되어야 `clean` 단계 완료로 본다

## 규칙

1. 결과 데이터 파일명은 항상 `cleaned.csv`
2. 보고서 파일명은 항상 `clean_report.md`
3. figures는 `clean/figures/`에 저장한다
4. 결과 JSON이 없으면 보고서 생성 전에 노트북 실행을 안내한다
5. 셀 단위 저장은 `clean_results.json`을 덮어쓰는 방식으로 누적한다
