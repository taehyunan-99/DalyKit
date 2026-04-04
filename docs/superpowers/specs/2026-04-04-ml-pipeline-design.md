# DalyKit ML 파이프라인 설계

> 2026-04-04 작성. 지도 학습(분류/회귀) 중심 ML 워크플로우 설계.

---

## 1. 범위

- **v1 범위**: 지도 학습 (분류 / 회귀)
- **추후 확장**: 비지도 학습 (클러스터링, 차원 축소), 시계열

---

## 2. 전체 파이프라인

```
init → domain → eda → clean → stat → feature → model → report
```

### 신규 스킬

| 스킬 | 실행 방식 | 역할 |
|------|----------|------|
| `dalykit:feature` | ipynb | 피처 엔지니어링 (인코딩, 스케일링, 파생 변수) |
| `dalykit:model` | .py + 자동 루프 | 모델 학습, 평가, 하이퍼파라미터 튜닝 |

### 데이터 흐름

```
dalykit/data/*_cleaned.csv
        ↓
   [feature] ipynb → 사용자 실행
        ↓
dalykit/data/df_featured.csv
        ↓
   [model] .py → 자동 루프
        ↓
dalykit/code/results/model_results.json
dalykit/models/*.joblib
dalykit/figures/
```

---

## 3. 폴더 구조 변경

### init이 생성하는 구조 (변경 후)

```
dalykit/
├── config/            ← domain.md, report_config.md
├── data/              ← 원본 CSV + 전처리 + 피처 엔지니어링 결과
├── code/
│   ├── py/            ← .py 파일 (신규)
│   ├── notebooks/     ← .ipynb 파일 (신규)
│   └── results/       ← .json 파일 (신규)
├── models/            ← .joblib 모델 파일 (신규)
├── docs/              ← .md 보고서
└── figures/           ← .png 시각화
```

### 기존 스킬 경로 변경

| 스킬 | Before | After |
|------|--------|-------|
| eda | `code/eda_analysis.ipynb` | `code/notebooks/eda_analysis.ipynb` |
| clean | `code/clean_pipeline.ipynb` | `code/notebooks/clean_pipeline.ipynb` |
| stat | `code/stat_analysis.py` | `code/py/stat_analysis.py` |
| stat | `code/stat_results.json` | `code/results/stat_results.json` |
| data-profiler | `code/run_profile.py` | `code/py/run_profile.py` |
| data-profiler | `code/profile_results.json` | `code/results/profile_results.json` |

---

## 4. domain.md 템플릿 추가 섹션

```markdown
## 실행 환경
- Python 경로: (예: /path/to/venv/bin/python)
- 또는 conda: (예: conda run -n myenv python)

## ML 목표 (선택)
- 타겟 변수:
- 문제 유형: (분류 / 회귀)
- 목표 성능: (예: accuracy ≥ 0.85)
```

- .py 실행하는 스킬(stat, model)은 domain.md의 "실행 환경"을 참조하여 Python 경로 결정
- 미지정 시 시스템 기본 `python3` 사용

---

## 5. feature 스킬

### 사용법

```
dalykit:feature          ← cleaned 데이터 → feature_pipeline.ipynb 생성
dalykit:feature report   ← 실행된 노트북 결과 → feature_report.md 생성
```

### 워크플로우

1. **컨텍스트 수집** (2단계 참조)
   - 1차: eda_report.md, preprocessing_report.md, stat_report.md의 "요약" 섹션만 Read (view_range)
   - 2차: 전략 수립에 상세 정보가 필요하면 해당 섹션만 추가 Read
   - domain.md 참조
2. **전략 제안** — 텍스트로 제안 후 사용자 확인
   - 인코딩: Label / One-Hot / Target 인코딩
   - 스케일링: StandardScaler / MinMaxScaler / RobustScaler
   - 파생 변수: 비율, 구간화, 교호작용 등
   - 피처 선택: stat 결과 기반 비유의 변수 제거 제안
3. **ipynb 생성** — `dalykit/code/notebooks/feature_pipeline.ipynb` Write
4. **사용자 실행** 후 노트북에서 저장:
   - `dalykit/data/df_featured.csv`

### 경로

| 항목 | 경로 |
|------|------|
| 입력 데이터 | `dalykit/data/*_cleaned.csv` |
| 노트북 | `dalykit/code/notebooks/feature_pipeline.ipynb` |
| 출력 데이터 | `dalykit/data/df_featured.csv` |
| 보고서 | `dalykit/docs/feature_report.md` |

### 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |

---

## 6. model 스킬

### 사용법

```
dalykit:model                    ← 자동 모델 선택 3-5개 비교 + 루프
dalykit:model LR,XGB             ← 지정 모델만 + 루프 시 모델 교체 X
dalykit:model tune               ← 기존 결과 기반 튜닝 루프 재실행
dalykit:model report             ← 최신 결과 JSON → 보고서 + 시각화
```

### 워크플로우

#### 1회차: 베이스라인 + 피처 진단

1. **컨텍스트 수집** — domain.md (ML 목표, 실행 환경), df_featured.csv 경로 확인
2. **분류/회귀 판단** — domain.md 명시 > 자동 감지 (타겟 nunique 기준)
3. **.py 스크립트 생성** — `dalykit/code/py/model_train.py`
4. **실행** — 후보 모델 전부 기본 하이퍼파라미터로 학습 + 평가
5. **피처 진단** — 1회차 결과에서 피처 문제 시그널 감지:
   - 피처 중요도 0 수렴 → 해당 피처 제거 추천
   - VIF 높은 피처 쌍 → 다중공선성 제거 추천
   - 학습/검증 성능 격차 과대 → 피처 수 축소 추천
   - 전 모델 일관 저성능 → 피처 자체 재설계 추천
6. **분기**:
   - 피처 문제 감지 → **조기 종료** + 피처 변경 피드백 제공
   - 피처 정상 → 상위 1-2개 모델 선정 → 튜닝 루프 진입

#### 2회차~ : 튜닝 루프

- 선정된 모델만 대상으로 하이퍼파라미터 튜닝
- 교차검증 전략, 클래스 불균형 처리도 루프에서 비교
- .py 수정 → 재실행 → JSON 갱신 → 성능 판단 → 반복

#### 모델 지정 시 루프 동작 차이

| 항목 | `dalykit:model` (자동) | `dalykit:model LR,XGB` (지정) |
|------|----------------------|-------------------------------|
| 1회차 모델 비교 | 자동 3-5개 | 지정 모델만 |
| 상위 모델 선정 | 자동 | 지정 모델 중 선정 |
| 루프 시 모델 교체 | X (1회차에서 결정됨) | X |
| 파라미터 튜닝 | O | O |
| 피처 피드백 | O | O |

### 루프 종료 조건 (3중 안전장치)

| 조건 | 기본값 |
|------|--------|
| 목표 성능 도달 | domain.md에서 지정 (미지정 시 비활성) |
| 개선폭 수렴 | 이전 대비 < 0.5% |
| 최대 반복 횟수 | 5회 |

### 루프 이력 저장

`model_results.json` 내 history 배열로 누적:
```json
{
  "best_model": "XGBoost",
  "best_score": 0.88,
  "problem_type": "classification",
  "history": [
    {"round": 1, "phase": "baseline", "models": [...], "feature_diagnosis": {...}},
    {"round": 2, "phase": "tuning", "model": "XGBoost", "params": {...}, "score": 0.87},
    {"round": 3, "phase": "tuning", "model": "XGBoost", "params": {...}, "score": 0.88}
  ],
  "final_model": {
    "name": "XGBoost",
    "params": {...},
    "metrics": {...},
    "feature_importances": [...],
    "cv_strategy": "StratifiedKFold(5)"
  }
}
```

### 평가 보고서 (`dalykit:model report`)

**필수 항목:**
- 모델별 성능 비교 테이블 (분류: accuracy, precision, recall, F1 / 회귀: RMSE, R², MAE)
- 최종 선택 모델 + 선택 근거
- 혼동 행렬 (분류) / 잔차 플롯 (회귀)
- 피처 중요도 시각화
- 학습 곡선 (과적합/과소적합 진단)
- 루프 이력 (회차별 성능 변화)

**선택 항목 (라이브러리 설치 시):**
- SHAP 해석 (미설치 시 스킵 + 설치 안내)

### 경로

| 항목 | 경로 |
|------|------|
| 입력 데이터 | `dalykit/data/df_featured.csv` |
| 스크립트 | `dalykit/code/py/model_train.py` |
| 결과 JSON | `dalykit/code/results/model_results.json` |
| 모델 파일 | `dalykit/models/{모델명}.joblib` |
| 보고서 | `dalykit/docs/model_report.md` |
| 시각화 | `dalykit/figures/` |

---

## 7. 교차검증 및 불균형 처리

### 기본값

| 항목 | 기본값 |
|------|--------|
| 학습/테스트 분할 | 80/20 (stratify=타겟) |
| 교차검증 | StratifiedKFold(5) (분류) / KFold(5) (회귀) |
| 불균형 처리 | 없음 (1회차 베이스라인) |

### 루프에서 비교 대상

- 교차검증: KFold, StratifiedKFold, RepeatedStratifiedKFold
- 불균형: class_weight='balanced', SMOTE, 없음
- 최적 조합을 루프에서 탐색

---

## 8. 보고서 요약 섹션 규칙 (공통)

모든 보고서 최상단에 `## 요약` 섹션 (5줄 이내) 필수:
- `eda_report.md`, `preprocessing_report.md`, `stat_report.md`, `feature_report.md`, `model_report.md`

후속 스킬의 컨텍스트 수집 시:
1. **1차**: 요약 섹션만 Read (view_range)
2. **2차**: 상세 정보가 필요한 경우에만 해당 섹션 추가 Read

---

## 9. 기존 스킬 영향 범위

| 스킬/파일 | 변경 내용 |
|----------|----------|
| init/SKILL.md | `code/py/`, `code/notebooks/`, `code/results/`, `models/` 폴더 생성 추가 |
| eda/SKILL.md | 노트북 경로 변경, 보고서 요약 섹션 규칙 추가 |
| eda/EDA_REPORT.md | 요약 섹션 템플릿 추가 |
| clean/SKILL.md | 노트북 경로 변경, 보고서 요약 섹션 규칙 추가 |
| clean/PREPROCESSING_REPORT.md | 요약 섹션 템플릿 추가 |
| stat/SKILL.md | 스크립트/결과 경로 변경, 실행 환경 참조 규칙 추가, 보고서 요약 섹션 규칙 추가 |
| stat/REPORT_GUIDE.md | 요약 섹션 템플릿 추가 |
| data-profiler.md | 스크립트/결과 경로 변경 |
| templates/DOMAIN_TEMPLATE.md | 실행 환경 + ML 목표 섹션 추가 |
| report/SKILL.md | 현재 상태 유지 (ML 통합 추후 결정) |

---

## 10. 설계 결정 요약

| 결정 | 근거 |
|------|------|
| 2스킬 분리 (feature + model) | 실행 방식 차이 (ipynb vs .py), SKILL.md 200줄 제한, 역할 명확 분리 |
| feature = ipynb | 시행착오 많은 단계, 사용자 개입 중요, 토큰 효율 |
| model = .py 자동 루프 | 학습→평가 자동 분기, 루프에 적합 |
| 1회차 비교 + 2회차~ 튜닝 분리 | 모델 선택과 튜닝의 역할 명확화, 중복 제거 |
| 지정 모델 시 모델 교체 X | 사용자 의도 존중 |
| 피처 진단 → 조기 종료 | 헛된 튜닝 방지, 토큰 절약 |
| 루프 최대 5회 | 토큰 소모 제한 |
| joblib 저장 | scikit-learn 표준, 추후 ONNX 확장 가능 |
| feature_meta.json 제거 | 현재 범위에서 불필요, YAGNI |
| code/ 하위 구조 분리 | 코드/결과 혼재 방지, 역할별 정리 |
| 보고서 요약 섹션 + 2단계 참조 | 후속 스킬 토큰 절약 |
| 가상환경 설정 in domain.md | 프로젝트별 환경 지원, 라이브러리 미설치 문제 방지 |
| SHAP 선택 항목 | 의존성 무거움, 미설치 시 스킵 |
| report 스킬 현재 유지 | ML 보고서 통합 추후 결정 |
