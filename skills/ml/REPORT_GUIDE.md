# 모델 평가 보고서 가이드

`dalykit:ml report` 호출 시 실행.
model_results.json을 분석하여 보고서를 생성한다.

## 결과 파싱 방법

1. Read로 `dalykit/code/results/model_results.json` 읽기
2. `history[0]` → 1회차 베이스라인 결과
3. `history[0]["feature_diagnosis"]` → 피처 진단 결과 (history[0] 내부에 중첩)
4. `history[n]` (n≥1) → 각 튜닝 라운드 결과
5. `final_model` → 최종 선택 모델 상세

## 보고서 출력 위치

- 파일명: `dalykit/docs/model_report.md`

---

## 보고서 구조

```markdown
# 모델 평가 보고서

## 요약
<!-- 5줄 이내로 모델 학습 결과를 요약한다 -->
- 문제 유형: [분류/회귀, 타겟 변수]
- 최종 모델: [모델명 + 핵심 성능 지표]
- 후보 비교: [N개 모델 비교, 최고/최저]
- 튜닝: [N회차, 개선폭]
- 피처 진단: [정상/문제 감지 요약]

## 1. 학습 개요

| 항목 | 값 |
|------|-----|
| 문제 유형 | 분류 / 회귀 |
| 타겟 변수 | 변수명 |
| 데이터 크기 | N행 × N열 |
| 학습/테스트 분할 | 80/20 (stratify=타겟) |
| 교차검증 | StratifiedKFold(5) |

## 2. 모델 비교 (베이스라인)

### 분류일 때:
| 모델 | Accuracy | Precision | Recall | F1 | 학습 시간 |
|------|----------|-----------|--------|----|---------| 
| ... | ... | ... | ... | ... | ... |

### 회귀일 때:
| 모델 | RMSE | R² | MAE | 학습 시간 |
|------|------|-----|-----|---------| 
| ... | ... | ... | ... | ... |

> 최고 성능 모델을 **볼드** 처리.

## 3. 피처 진단

### 피처 중요도
![피처 중요도](../figures/model_feature_importance_{모델명}.png)
<!-- 실제 파일명으로 대체: model_feature_importance_xgboost.png 등 -->

| 순위 | 피처 | 중요도 |
|------|------|--------|
| 1 | ... | ... |

### 진단 결과
| 항목 | 상태 | 상세 |
|------|------|------|
| 저중요도 피처 | 🟢/🟡/🔴 | ... |
| 다중공선성 | 🟢/🟡/🔴 | ... |
| 과적합 | 🟢/🟡/🔴 | ... |

## 4. 튜닝 이력

| 라운드 | 모델 | 주요 변경 | 성능 | 개선폭 |
|--------|------|----------|------|--------|
| 1 | 베이스라인 | 기본 파라미터 | 0.85 | — |
| 2 | XGBoost | max_depth=5, lr=0.1 | 0.87 | +2.0% |
| 3 | XGBoost | n_est=200, subsample=0.8 | 0.88 | +1.0% |

![튜닝 비교](../figures/model_tuning_comparison.png)

## 4.5 앙상블 비교 (ensemble 실행 시)

> `dalykit:ml ensemble` 실행 시에만 포함. 미실행 시 이 섹션은 생략한다.

| 모델 | 유형 | estimators | 성능 |
|------|------|------------|------|
| VotingClassifier | Soft Voting | XGBoost, RandomForest | 0.89 |
| StackingClassifier | Stacking (LR meta) | XGBoost, RandomForest | 0.90 |
| XGBoost (개별 최고) | 단일 모델 | — | 0.88 |

> 앙상블이 개별 모델보다 성능이 높으면 **볼드** 처리.
> 앙상블 선택 시 최종 모델 상세(5번)에 앙상블 모델 정보 기재.

![앙상블 비교](../figures/model_ensemble_comparison.png)

## 5. 최종 모델 상세

| 항목 | 값 |
|------|-----|
| 모델 | XGBoost |
| 하이퍼파라미터 | {...} |
| 교차검증 점수 | 0.88 ± 0.02 |
| 테스트 점수 | 0.87 |
| 모델 파일 | `dalykit/models/XGBoost.joblib` |

### 혼동 행렬 (분류)
![혼동 행렬](../figures/model_confusion_matrix.png)

### 잔차 플롯 (회귀)
![잔차 플롯](../figures/model_residual_plot.png)

### 학습 곡선
![학습 곡선](../figures/model_learning_curve.png)

## 6. SHAP 해석

> 항상 시도한다. 미설치 시 보고서에 "SHAP 해석을 보려면 `pip install shap` 후 `dalykit:ml report`를 재실행하세요." 한 줄만 포함하고 섹션은 유지한다.

![SHAP Summary](../figures/model_shap_summary.png)

## 7. 한계점 및 추가 분석 추천

| 항목 | 내용 |
|------|------|
| 데이터 한계 | ... |
| 모델 한계 | ... |
| 추가 데이터 | ... |
| 추천 | ... |
```

---

## 보고서 작성 규칙

1. **독립 완결성**: 이 보고서만 읽으면 모델 학습 전체를 파악할 수 있어야 한다
2. **숫자 근거 필수**: 모든 판단에 실제 수치를 함께 기재
3. **최종 모델 선택 근거**: 왜 이 모델을 선택했는지 명확히 서술
4. **시각화 참조**: 차트 이미지를 `![](../figures/파일명.png)` 상대경로로 포함
5. **루프 이력 포함**: 몇 회차를 돌았고 각 회차에서 무엇이 바뀌었는지 기록
6. **피처 진단 포함**: 1회차 피처 진단 결과와 조치 사항 기록
7. **신호등 체계**: 🔴 문제 / 🟡 주의 / 🟢 양호
8. **SHAP 선택적**: 미설치 시 스킵, 설치 안내 메시지만 포함

## 시각화 파일명 컨벤션

| 파일명 | 설명 |
|--------|------|
| `model_feature_importance_{모델명소문자}.png` | 피처 중요도 바차트 (예: `model_feature_importance_xgboost.png`) |
| `model_confusion_matrix.png` | 혼동 행렬 히트맵 (분류) |
| `model_residual_plot.png` | 잔차 플롯 (회귀) |
| `model_learning_curve.png` | 학습 곡선 |
| `model_tuning_comparison.png` | 튜닝 라운드별 모델 성능 비교 |
| `model_ensemble_comparison.png` | 앙상블 vs 개별 모델 성능 비교 바차트 |
| `model_shap_summary.png` | SHAP summary plot |
| `model_roc_curve.png` | ROC 커브 (분류) |

> 보고서에서 이미지 경로 참조 시 실제 생성된 파일명을 `dalykit/figures/`에서 확인 후 삽입한다.
