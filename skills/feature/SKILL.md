---
name: feature
description: >
  피처 엔지니어링. 전처리된 데이터에서 인코딩, 스케일링, 파생 변수 생성,
  피처 선택을 수행하는 노트북을 생성한다.
  트리거: "dalykit:feature", "피처 엔지니어링".
user_invocable: true
---

# Feature (피처 엔지니어링)

> 활성 kit 기준으로 `feature/` 폴더에 노트북, 결과 JSON, featured.csv, 보고서를 저장한다.

## 사용법

```text
dalykit:feature
dalykit:feature kits/k1/clean/cleaned.csv
dalykit:feature select
dalykit:feature select kits/k1/feature/featured.csv
dalykit:feature report
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- 입력 데이터가 있어야 한다
  - 기본: `dalykit/kits/{kit}/clean/cleaned.csv`
  - 선택: 사용자가 지정한 CSV 경로
- 필요 시 EDA, clean, stat 보고서를 함께 참조한다

## 경로 규칙

| 항목 | 경로 |
|------|------|
| stage 디렉토리 | `dalykit/kits/{kit}/feature/` |
| 노트북 | `dalykit/kits/{kit}/feature/feature_pipeline.ipynb` |
| 결과 JSON | `dalykit/kits/{kit}/feature/feature_results.json` |
| 결과 데이터 | `dalykit/kits/{kit}/feature/featured.csv` |
| 선택 스크립트 | `dalykit/kits/{kit}/feature/feature_select.py` |
| 선택 결과 JSON | `dalykit/kits/{kit}/feature/feature_select_results.json` |
| 추천 피처 목록 | `dalykit/kits/{kit}/feature/selected_features.txt` |
| 보고서 | `dalykit/kits/{kit}/feature/feature_report.md` |
| 시각화 | `dalykit/kits/{kit}/feature/figures/` |

## 워크플로우

### `dalykit:feature`

1. 활성 kit 확인
2. 인자 없으면 현재 kit의 `clean/cleaned.csv`를 사용한다
3. 인자 있으면 해당 CSV를 입력으로 사용하고, 입력 출처를 manifest에 기록한다
4. 기존 EDA, clean, stat 보고서가 있으면 함께 읽는다
5. [CELL_PATTERNS.md](CELL_PATTERNS.md)를 참조해 노트북 생성
6. 노트북은 인코딩·스케일링·파생 변수·피처 제거 셀 끝마다 `feature_results.json`을 중간 저장하도록 구성한다

### `dalykit:feature select`

1. 활성 kit 확인
2. 인자 없으면 현재 kit의 `feature/featured.csv`를 사용한다
3. 인자 있으면 해당 CSV를 입력으로 사용하고 입력 출처를 기록한다
4. task type과 target을 확인하고 CV 전략을 자동 선택한다
5. 경량 모델 1개로 후보 피처 중요도를 계산한 뒤 `greedy_forward`로 조합을 비교한다
6. `feature_select.py`, `feature_select_results.json`, `selected_features.txt`를 저장한다
7. `featured.csv`는 자동으로 덮어쓰지 않는다

### `dalykit:feature report`

1. `feature_results.json`을 읽는다
2. `feature_select_results.json`이 있으면 함께 읽는다
3. [REPORT_GUIDE.md](REPORT_GUIDE.md)를 참조해 보고서를 생성한다
4. `feature_report.md`에 저장한다
5. `active.json.stages_completed`와 `artifacts.feature_data`를 갱신한다

## 완료 기준

- `dalykit:feature`는 노트북 생성만 수행하므로 완료 단계로 기록하지 않는다
- `dalykit:feature select`는 보조 분석이므로 완료 단계로 기록하지 않는다
- `dalykit:feature report`까지 생성되어야 `feature` 단계 완료로 본다

## 규칙

1. 결과 데이터 파일명은 항상 `featured.csv`
2. figures는 `feature/figures/`에 저장한다
3. 입력이 다른 kit 산출물이면 출처를 현재 kit의 `manifest.json`에 남긴다
4. `feature select`는 추천 결과만 남기고 `featured.csv`를 자동 수정하지 않는다
5. 셀 단위 저장은 `feature_results.json`을 덮어쓰는 방식으로 누적한다
