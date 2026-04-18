---
name: ml
description: >
  머신러닝 모델 학습 및 평가. 자동 모델 선택 또는 지정 모델로
  학습/평가 루프를 실행하고 결과를 저장한다.
  트리거: "dalykit:ml", "dalykit:ml report", "모델 학습".
user_invocable: true
---

# ML (모델 학습 · 평가)

> 활성 kit 기준으로 `model/` 폴더에 스크립트, 결과 JSON, 모델 파일, 보고서를 저장한다.

## 사용법

```text
dalykit:ml
dalykit:ml LR,RF,XGB
dalykit:ml ensemble
dalykit:ml report
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- 기본 입력 데이터는 `dalykit/kits/{kit}/feature/featured.csv`
- 없으면 `dalykit:feature`를 먼저 실행하라고 안내한다
- 의존성이 불명확하면 `dalykit:doctor install`을 먼저 안내한다

## 경로 규칙

| 항목 | 경로 |
|------|------|
| stage 디렉토리 | `dalykit/kits/{kit}/model/` |
| 스크립트 | `dalykit/kits/{kit}/model/model_train.py` |
| 결과 JSON | `dalykit/kits/{kit}/model/model_results.json` |
| 보고서 | `dalykit/kits/{kit}/model/model_report.md` |
| 모델 파일 | `dalykit/kits/{kit}/model/models/{모델명}.joblib` |
| 시각화 | `dalykit/kits/{kit}/model/figures/` |

## 워크플로우

### `dalykit:ml`

1. 활성 kit 확인
2. feature 결과와 기존 보고서를 읽는다
3. target 컬럼과 task type을 확인한다
4. 회귀면 타깃 분포 왜도와 이상치 영향을 보고 `identity`와 `log1p` 후보를 판단한다
5. `log1p`는 `y.min() >= 0`일 때만 허용하고, 비교 평가는 inverse transform 후 원본 스케일 기준으로 계산한다
6. [MODEL_CATALOG.md](MODEL_CATALOG.md)를 참조해 후보 모델을 구성한다
7. `model_train.py` 생성 후 실행한다
8. `model_results.json`과 모델 파일을 저장한다

### `dalykit:ml ensemble`

- 기존 베이스라인 상위 모델로 Voting/Stacking 비교를 수행한다
- 결과는 같은 `model_results.json`에 반영한다

### `dalykit:ml report`

1. `model_results.json`을 읽는다
2. [REPORT_GUIDE.md](REPORT_GUIDE.md)를 참조해 `model_report.md`를 생성한다
3. `dalykit:progress` 규칙에 따라 `config/progress.md`도 함께 갱신한다
4. `active.json.stages_completed`와 `artifacts.model_results`를 갱신한다

## 완료 기준

- `dalykit:ml`은 학습과 결과 저장을 수행한다
- `dalykit:ml report`까지 생성되어야 `model` 단계 완료로 본다

## 규칙

1. 모델 파일은 `model/models/` 아래에 저장한다
2. 시각화는 `model/figures/`에 저장한다
3. 전역 latest alias는 사용하지 않는다
4. 타깃 변환은 `featured.csv`를 수정하지 않고 학습 루프 내부 후보로만 다룬다
5. 타깃 변환이 적용되면 `model_results.json`에 방법, 판단 이유, 원본 스케일 평가 여부를 기록한다
