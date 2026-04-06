---
name: ml
description: >
  머신러닝 모델 학습 및 평가. 자동 모델 선택 또는 사용자 지정 모델로
  학습/평가 루프를 실행하고, 결과를 JSON + joblib로 저장한다.
  트리거: "dalykit:ml", "모델 학습", "model training",
  "머신러닝", "분류 모델", "회귀 모델".
user_invocable: true
---

# Model (모델 학습 · 평가)

> .py 스크립트 생성 → 자동 루프 실행 → JSON + joblib → `model report`로 보고서 생성.

## 사용법

```
dalykit:ml                    ← 자동 모델 선택 3-5개 비교 + 루프
dalykit:ml LR,RF,XGB          ← 지정 모델만 비교 + 루프 (모델 교체 X)
dalykit:ml tune               ← 기존 결과 기반 튜닝 루프 재실행
dalykit:ml ensemble           ← 베이스라인 상위 모델로 Voting + Stacking 비교
dalykit:ml report             ← 최신 결과 JSON → 보고서 + 시각화
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
| CAT | CatBoostClassifier / CatBoostRegressor |

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

### 1.5단계: 데이터 규모 판단

데이터 크기에 따라 학습 전략을 분기한다.

| 데이터 규모 | 기준 | 전략 |
|------------|------|------|
| 소규모 | n ≤ 10,000 | 전체 데이터로 3-5개 모델 병렬 비교 (현행) |
| 중규모 | 10,000 < n ≤ 100,000 | 전체 데이터 사용, SVM 제외 (학습 느림) |
| 대규모 | n > 100,000 | 10-20% 샘플링으로 먼저 베이스라인 → 최적 모델 1-2개만 전체 데이터로 재학습 |

#### 대규모 데이터 처리 흐름

1. `df.sample(frac=0.15, random_state=42, stratify=y)` 로 샘플 추출 (분류 시 stratify)
2. 샘플로 3-5개 모델 베이스라인 비교 → 상위 1-2개 선정
3. 선정 모델만 전체 데이터로 재학습 + 튜닝
4. JSON에 `"sampling": {"used": true, "frac": 0.15, "sample_n": N}` 필드 기록

> 대규모 데이터 시 LGBM 베이스라인 우선 실행 추천: LGBM은 대용량에서 가장 빠르므로,
> 빠르게 성능 기준선을 확보한 뒤 다른 모델과 비교 판단이 가능하다.

### 2단계: 베이스라인 + 피처 진단

1. `~/.claude/skills/ml/MODEL_CATALOG.md`를 Read로 읽는다
2. Write 도구로 `dalykit/code/py/model_train.py` 생성:
   - 데이터 로드 + train/test 분할 (80/20, stratify)
   - 후보 모델 전부 기본 하이퍼파라미터로 학습
   - 교차검증: StratifiedKFold(5) (분류) / KFold(5) (회귀)
   - 평가 지표 산출
   - 피처 중요도 산출 (트리 기반 모델)
   - 결과를 `dalykit/code/results/model_results.json`에 저장
   - 최적 모델을 `dalykit/models/{모델명}.joblib`로 저장
3. Bash 도구로 실행 (run_in_background=true):
   ```bash
   PYTHONIOENCODING=utf-8 {python경로} dalykit/code/py/model_train.py
   ```
   - 학습 완료 알림을 받은 뒤 결과 확인으로 진행
   - 대화 차단 없이 사용자와 다른 작업 가능
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

> **선정 모델 저장 규칙**: `selected_models`에는 **베이스 모델명만** 저장 (예: `"XGBoost"`, `"RandomForest"`). SMOTE 여부는 별도 `"imbalance_method"` 필드에 저장 (예: `"smote"`, `"balanced"`, `"none"`). `_SMOTE` suffix 포함 이름을 selected_models에 넣지 않는다.

### 3단계: 튜닝 루프

> `dalykit:ml tune`으로 직접 호출하거나, 2단계 후 자동 진입.

1. model_train.py를 수정하여 선정 모델의 하이퍼파라미터 탐색:
   - `MODEL_CATALOG.md`의 튜닝 그리드 참조
   - RandomizedSearchCV 사용 (GridSearch보다 효율적)
   - 교차검증 전략도 비교: KFold, StratifiedKFold, RepeatedStratifiedKFold
   - 클래스 불균형 처리도 비교: 없음, class_weight='balanced', SMOTE
2. Bash 도구로 실행 (run_in_background=true):
   ```bash
   PYTHONIOENCODING=utf-8 {python경로} dalykit/code/py/model_train.py
   ```
   - 튜닝 루프도 백그라운드 실행이 기본
3. 종료 조건 확인:
   - 목표 성능 도달 (domain.md 지정값) → **종료**
   - 이전 대비 개선폭 ≤ 0.5% 또는 성능 하락(음수) → **수렴 종료** (`convergence: true`)
   - 최대 5회 도달 → **강제 종료**
4. 미종료 시 → .py 수정 → 재실행 (2단계 반복)

#### 모델 지정 시 (`dalykit:ml LR,XGB`)

- 1단계: 지정 모델만 비교 (자동 3-5개 대신)
- 2단계: 지정 모델 중 상위 1-2개 튜닝 (다른 모델로 교체 X)

### tune 인자 처리

`dalykit:ml tune` 호출 시:

1. `dalykit/code/results/model_results.json` 존재 여부 확인
2. **있으면**: 기존 결과에서 상위 모델 파악 → 튜닝 루프 실행
3. **없으면**: "`dalykit:ml`을 먼저 실행하세요." 안내 후 종료

### ensemble 인자 처리

`dalykit:ml ensemble` 호출 시:

1. `dalykit/code/results/model_results.json` 존재 여부 확인
2. **있으면**: 베이스라인 상위 2-3개 모델을 estimators로 구성
   - VotingClassifier/Regressor (soft voting)
   - StackingClassifier/Regressor (final_estimator=LR/Ridge)
   - 두 앙상블 + 개별 최고 모델 성능 비교
   - 결과를 `model_results.json`의 `history`에 `"phase": "ensemble"` 라운드로 추가
3. **없으면**: "`dalykit:ml`을 먼저 실행하세요." 안내 후 종료
4. 앙상블이 개별 모델보다 높으면 best_model 갱신, 아니면 기존 유지

### 종료 안내

루프 종료 후 아래 안내만 출력하고 종료한다. 보고서를 자동 생성하지 않는다.

```
모델 학습 완료. 결과: dalykit/code/results/model_results.json
보고서 생성: dalykit:ml report
```

### report 인자 워크플로우

`dalykit:ml report` 호출 시:

1. `dalykit/code/results/model_results.json` Read
2. `~/.claude/skills/ml/REPORT_GUIDE.md` Read → 보고서 작성 지침 확인
3. `dalykit/docs/model_report.md` Write → 보고서 생성
4. 시각화 생성 → `dalykit/figures/`에 저장
5. JSON 미존재 시: "`dalykit:ml`을 먼저 실행하세요." 안내 후 종료

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
    },
    {
      "round": 4,
      "phase": "ensemble",
      "models": [
        {"name": "VotingClassifier", "score": 0.89, "estimators": ["XGBoost", "RandomForest"]},
        {"name": "StackingClassifier", "score": 0.90, "estimators": ["XGBoost", "RandomForest"], "final_estimator": "LogisticRegression"}
      ],
      "best_ensemble": "StackingClassifier"
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
4. **SHAP**: 항상 try/except로 시도. 미설치 시 설치 안내 출력 후 계속 진행
5. **시각화**: matplotlib/seaborn, `dalykit/figures/`에 저장
6. **모델 저장**: `joblib.dump(model, 'dalykit/models/{모델명}.joblib')`
7. **train/test 분할**: 80/20, 분류 시 `stratify=y`
8. **교차검증 기본**: StratifiedKFold(5) (분류) / KFold(5) (회귀)
9. **폰트 설정**: 시각화 시 Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
10. **best_model 판정**: 튜닝 완료 후 전체 history(베이스라인 + 튜닝 결과)를 통합하여 **최고 점수 기준**으로 결정. 튜닝 결과가 베이스라인보다 낮으면 베이스라인 모델을 best_model로 선정.
    ```python
    all_scores = {**baseline_results, **tuned_results}
    best_model_name = max(all_scores, key=lambda k: all_scores[k]['f1'])  # 또는 회귀 시 r2
    ```
11. **수렴 판정**: `improvement = current_score - prev_score`. `improvement <= 0.005` (≤ 0.5%) 또는 음수(성능 하락) 시 `convergence: true` 로 종료.
12. **selected_models 저장**: 베이스 모델명만 (`"XGBoost"`, `"RandomForest"`). SMOTE/balanced 여부는 `"imbalance_method"` 필드로 분리.
13. **시각화 파일명 컨벤션**: `model_feature_importance_{모델명소문자}.png` (예: `model_feature_importance_xgboost.png`), `model_tuning_comparison.png` (튜닝 비교 차트)
14. **규모별 학습 방식**:
    - 소규모 (n ≤ 10,000): 모든 후보 모델을 한 스크립트 내에서 순차 실행 (사실상 병렬 비교)
    - 대규모 (n > 100,000): 샘플링 후 후보 비교 → 선정 모델만 전체 데이터로 단일 학습. 한 번에 1개 모델만 학습하여 메모리/시간 절약
15. **단계별 print 출력**: 스크립트 내 주요 단계마다 진행 상황을 출력한다:
    ```python
    print("=" * 50)
    print("[1/4] 데이터 로드 완료: 5000행 × 13열")
    print("=" * 50)
    # ...
    print(f"[2/4] 베이스라인 학습 중... ({model_name})")
    # ...
    print(f"[3/4] 튜닝 라운드 {round_num}: {model_name} (score: {score:.4f})")
    # ...
    print("[4/4] 결과 저장 완료: dalykit/code/results/model_results.json")
    ```
    - 모델별 학습 시작/완료 시 모델명 + 소요시간 출력
    - 튜닝 라운드마다 현재 라운드/최대 라운드 + 현재 점수 출력
    - 최종 결과 저장 경로 출력
16. **Windows 인코딩 대응**: 모든 .py 스크립트 최상단에 인코딩 설정 코드를 포함한다:
    ```python
    import sys
    import io
    if sys.stdout.encoding != 'utf-8':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    ```
    - Bash 실행 시에도 환경변수 추가: `PYTHONIOENCODING=utf-8 {python경로} script.py`
    - conda run 사용 시: `PYTHONIOENCODING=utf-8 conda run -n {env} --no-capture-output python script.py`

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
