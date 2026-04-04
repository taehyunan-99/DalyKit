---
name: model
description: >
  머신러닝 모델 학습 및 평가. 자동 모델 선택 또는 사용자 지정 모델로
  학습/평가 루프를 실행하고, 결과를 JSON + joblib로 저장한다.
  트리거: "dalykit:model", "모델 학습", "model training",
  "머신러닝", "분류 모델", "회귀 모델".
user_invocable: true
---

# Model (모델 학습 · 평가)

> .py 스크립트 생성 → 자동 루프 실행 → JSON + joblib → `model report`로 보고서 생성.

## 사용법

```
dalykit:model                    ← 자동 모델 선택 3-5개 비교 + 루프
dalykit:model LR,RF,XGB          ← 지정 모델만 비교 + 루프 (모델 교체 X)
dalykit:model tune               ← 기존 결과 기반 튜닝 루프 재실행
dalykit:model report             ← 최신 결과 JSON → 보고서 + 시각화
```

## 모델 약어

| 약어 | 모델 |
|------|------|
| LR | LogisticRegression / LinearRegression |
| RF | RandomForestClassifier / RandomForestRegressor |
| XGB | XGBClassifier / XGBRegressor |
| LGBM | LGBMClassifier / LGBMRegressor |
| SVM | SVC / SVR |
| KNN | KNeighborsClassifier / KNeighborsRegressor |
| DT | DecisionTreeClassifier / DecisionTreeRegressor |
| GB | GradientBoostingClassifier / GradientBoostingRegressor |

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료
- `dalykit/data/df_featured.csv`가 존재해야 한다
- 없으면: "`dalykit:feature`를 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 입력 데이터 | `dalykit/data/df_featured.csv` |
| 도메인 설정 | `dalykit/config/domain.md` |
| 스크립트 | `dalykit/code/py/model_train.py` |
| 결과 JSON | `dalykit/code/results/model_results.json` |
| 모델 파일 | `dalykit/models/{모델명}.joblib` |
| 보고서 | `dalykit/docs/model_report.md` |
| 시각화 | `dalykit/figures/` |

## 참조 문서

| 파일 | 내용 |
|------|------|
| `MODEL_CATALOG.md` | 모델별 기본 하이퍼파라미터 + 튜닝 그리드 |
| `REPORT_GUIDE.md` | 모델 평가 보고서 작성 지침 |

## 워크플로우

### 1단계: 컨텍스트 수집

1. **보고서 읽기** (2단계 참조):
   - 1차: `dalykit/docs/eda_report.md`, `preprocessing_report.md`, `stat_report.md`, `feature_report.md`의 "요약" 섹션만 Read
   - 2차: 필요 시 상세 섹션 추가 Read
2. `dalykit/config/domain.md` Read → ML 목표 (타겟, 문제 유형, 목표 성능), 실행 환경 확인
3. **분류/회귀 판단**: domain.md 명시 > 자동 감지 (타겟 nunique 기준)
4. **Python 경로 결정**: domain.md "실행 환경" 참조. 미지정 시 `python3`

### 2단계: 베이스라인 + 피처 진단

1. `~/.claude/skills/model/MODEL_CATALOG.md`를 Read로 읽는다
2. Write 도구로 `dalykit/code/py/model_train.py` 생성:
   - 데이터 로드 + train/test 분할 (80/20, stratify)
   - 후보 모델 전부 기본 하이퍼파라미터로 학습
   - 교차검증: StratifiedKFold(5) (분류) / KFold(5) (회귀)
   - 평가 지표 산출
   - 피처 중요도 산출 (트리 기반 모델)
   - 결과를 `dalykit/code/results/model_results.json`에 저장
   - 최적 모델을 `dalykit/models/{모델명}.joblib`로 저장
3. Bash 도구로 `{python경로} dalykit/code/py/model_train.py` 실행
4. `dalykit/code/results/model_results.json` Read → 결과 분석

#### 피처 진단 (1회차 결과 기반)

아래 시그널 중 하나라도 감지되면 **조기 종료** + 피처 변경 피드백 제공:

| 시그널 | 기준 | 피드백 |
|--------|------|--------|
| 피처 중요도 0 수렴 | 중요도 < 0.01인 피처가 전체의 50% 이상 | 해당 피처 제거 추천 |
| 다중공선성 | VIF > 10인 피처 쌍 존재 | 하나 제거 추천 |
| 과적합 | train-test 성능 격차 > 10% | 피처 수 축소 또는 정규화 추천 |
| 전체 저성능 | 모든 모델 베이스라인 미달 (분류: acc < 0.6, 회귀: R² < 0.3) | 피처 재설계 추천 |

피처 정상 시 → 상위 1-2개 모델 선정 → 2단계 튜닝 루프 진입.

### 3단계: 튜닝 루프

> `dalykit:model tune`으로 직접 호출하거나, 2단계 후 자동 진입.

1. model_train.py를 수정하여 선정 모델의 하이퍼파라미터 탐색:
   - `MODEL_CATALOG.md`의 튜닝 그리드 참조
   - RandomizedSearchCV 사용 (GridSearch보다 효율적)
   - 교차검증 전략도 비교: KFold, StratifiedKFold, RepeatedStratifiedKFold
   - 클래스 불균형 처리도 비교: 없음, class_weight='balanced', SMOTE
2. Bash 도구로 실행 → JSON 갱신
3. 종료 조건 확인:
   - 목표 성능 도달 (domain.md 지정값) → **종료**
   - 이전 대비 개선폭 < 0.5% → **수렴 종료**
   - 최대 5회 도달 → **강제 종료**
4. 미종료 시 → .py 수정 → 재실행 (2단계 반복)

#### 모델 지정 시 (`dalykit:model LR,XGB`)

- 1단계: 지정 모델만 비교 (자동 3-5개 대신)
- 2단계: 지정 모델 중 상위 1-2개 튜닝 (다른 모델로 교체 X)

### tune 인자 처리

`dalykit:model tune` 호출 시:

1. `dalykit/code/results/model_results.json` 존재 여부 확인
2. **있으면**: 기존 결과에서 상위 모델 파악 → 튜닝 루프 실행
3. **없으면**: "`dalykit:model`을 먼저 실행하세요." 안내 후 종료

### report 인자 워크플로우

`dalykit:model report` 호출 시:

1. `dalykit/code/results/model_results.json` Read
2. `~/.claude/skills/model/REPORT_GUIDE.md` Read → 보고서 작성 지침 확인
3. `dalykit/docs/model_report.md` Write → 보고서 생성
4. 시각화 생성 → `dalykit/figures/`에 저장
5. JSON 미존재 시: "`dalykit:model`을 먼저 실행하세요." 안내 후 종료

## 루프 이력 저장

`model_results.json` 구조:

```json
{
  "best_model": "XGBoost",
  "best_score": 0.88,
  "problem_type": "classification",
  "target": "Personal_Loan",
  "history": [
    {
      "round": 1,
      "phase": "baseline",
      "models": [
        {"name": "LogisticRegression", "score": 0.78, "metrics": {}},
        {"name": "RandomForest", "score": 0.83, "metrics": {}},
        {"name": "XGBoost", "score": 0.85, "metrics": {}}
      ],
      "feature_diagnosis": {
        "low_importance": [],
        "high_vif": [],
        "overfitting": false,
        "all_low_performance": false
      },
      "selected_models": ["XGBoost", "RandomForest"]
    },
    {
      "round": 2,
      "phase": "tuning",
      "model": "XGBoost",
      "params": {"n_estimators": 200, "max_depth": 5, "learning_rate": 0.1},
      "score": 0.87,
      "cv_strategy": "StratifiedKFold(5)",
      "imbalance_handling": "none"
    }
  ],
  "final_model": {
    "name": "XGBoost",
    "params": {"n_estimators": 200, "max_depth": 5, "learning_rate": 0.1},
    "metrics": {
      "accuracy": 0.88, "precision": 0.85, "recall": 0.82, "f1": 0.83,
      "train_score": 0.91, "test_score": 0.88
    },
    "feature_importances": [{"feature": "Income", "importance": 0.35}],
    "cv_strategy": "StratifiedKFold(5)",
    "model_path": "dalykit/models/XGBoost.joblib"
  }
}
```

## 코드 생성 규칙

1. **Heavy-Task-Offload**: .py 스크립트로 학습, 결과 JSON 저장
2. **한국어 주석**
3. **라이브러리**: scikit-learn, xgboost, lightgbm, joblib
4. **SHAP**: 미설치 시 try/except로 스킵 + 설치 안내 출력
5. **시각화**: matplotlib/seaborn, `dalykit/figures/`에 저장
6. **모델 저장**: `joblib.dump(model, 'dalykit/models/{모델명}.joblib')`
7. **train/test 분할**: 80/20, 분류 시 `stratify=y`
8. **교차검증 기본**: StratifiedKFold(5) (분류) / KFold(5) (회귀)
9. **폰트 설정**: 시각화 시 Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
