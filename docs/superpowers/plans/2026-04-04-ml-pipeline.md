# DalyKit ML 파이프라인 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** DalyKit에 feature(피처 엔지니어링) + model(모델링/평가) 스킬을 추가하고, 기존 스킬의 경로를 code/py/, code/notebooks/, code/results/ 하위 구조로 마이그레이션한다.

**Architecture:** 기존 init→domain→eda→clean→stat 파이프라인 뒤에 feature(ipynb)→model(.py 루프) 스킬을 추가한다. code/ 하위에 py/, notebooks/, results/ 폴더를 분리하여 파일 유형별 정리. init에서 models/ 폴더도 추가 생성.

**Tech Stack:** Python (pandas, numpy, scikit-learn, matplotlib, seaborn, scipy, statsmodels, joblib, shap), Jupyter Notebook (nbformat 4)

**Spec:** `docs/superpowers/specs/2026-04-04-ml-pipeline-design.md`

---

## Task 1: init 스킬 — 폴더 구조 변경

**Files:**
- Modify: `skills/init/SKILL.md`

- [ ] **Step 1: init SKILL.md의 폴더 생성 명령 변경**

`skills/init/SKILL.md`의 2단계 폴더 생성 섹션을 수정한다.

Before:
```markdown
### 2단계: 폴더 생성

생성할 하위 디렉토리 목록: `config`, `data`, `code`, `docs`, `figures`

```bash
mkdir -p dalykit/config dalykit/data dalykit/code dalykit/docs dalykit/figures
```
```

After:
```markdown
### 2단계: 폴더 생성

생성할 하위 디렉토리 목록: `config`, `data`, `code/py`, `code/notebooks`, `code/results`, `models`, `docs`, `figures`

```bash
mkdir -p dalykit/config dalykit/data dalykit/code/py dalykit/code/notebooks dalykit/code/results dalykit/models dalykit/docs dalykit/figures
```
```

- [ ] **Step 2: init SKILL.md의 완료 메시지 변경**

5단계 완료 메시지의 구조 트리를 수정한다.

Before:
```
생성된 구조:
  dalykit/
  ├── config/          ← domain.md, report_config.md
  ├── data/            ← 원본 CSV + 전처리된 파일
  ├── code/
  ├── docs/
  └── figures/
```

After:
```
생성된 구조:
  dalykit/
  ├── config/          ← domain.md, report_config.md
  ├── data/            ← 원본 CSV + 전처리 + 피처 결과
  ├── code/
  │   ├── py/          ← .py 스크립트
  │   ├── notebooks/   ← .ipynb 노트북
  │   └── results/     ← .json 결과
  ├── models/          ← .joblib 모델 파일
  ├── docs/
  └── figures/
```

- [ ] **Step 3: 커밋**

```bash
git add skills/init/SKILL.md
git commit -m "feat: init 스킬에 code/ 하위 구조 + models/ 폴더 추가"
```

---

## Task 2: domain.md 템플릿 — 실행 환경 + ML 목표 섹션 추가

**Files:**
- Modify: `templates/DOMAIN_TEMPLATE.md`

- [ ] **Step 1: DOMAIN_TEMPLATE.md 끝에 섹션 추가**

파일 끝 (`## 특이사항` 섹션 아래)에 다음 두 섹션을 추가한다:

```markdown
## 실행 환경
<!-- .py 스크립트 실행 시 사용할 Python 경로 -->
<!-- 미지정 시 시스템 기본 python3을 사용합니다 -->
<!-- 예: /home/user/venv/bin/python -->
<!-- 예: conda run -n myenv python -->
- Python 경로:

## ML 목표 (선택)
<!-- 머신러닝 모델 학습 시 참조합니다. 미입력 시 자동 감지합니다 -->
- 타겟 변수:
- 문제 유형: (분류 / 회귀)
- 목표 성능: (예: accuracy ≥ 0.85)
```

- [ ] **Step 2: 커밋**

```bash
git add templates/DOMAIN_TEMPLATE.md
git commit -m "feat: domain 템플릿에 실행 환경 + ML 목표 섹션 추가"
```

---

## Task 3: 기존 스킬 경로 마이그레이션 — eda

**Files:**
- Modify: `skills/eda/SKILL.md`
- Modify: `skills/eda/CELL_PATTERNS.md`
- Modify: `skills/eda/EDA_REPORT.md`

- [ ] **Step 1: eda/SKILL.md 경로 변경**

경로 규칙 테이블 수정:

Before:
```
| 노트북 | `dalykit/code/eda_analysis.ipynb` |
```

After:
```
| 노트북 | `dalykit/code/notebooks/eda_analysis.ipynb` |
```

워크플로우 2단계 수정:

Before:
```
- Write 도구로 `dalykit/code/eda_analysis.ipynb` 생성 (nbformat 4)
```

After:
```
- Write 도구로 `dalykit/code/notebooks/eda_analysis.ipynb` 생성 (nbformat 4)
```

report 인자 워크플로우 수정:

Before:
```
1. `dalykit/code/eda_analysis.ipynb` Read → 셀 출력(outputs) 분석
```

After:
```
1. `dalykit/code/notebooks/eda_analysis.ipynb` Read → 셀 출력(outputs) 분석
```

- [ ] **Step 2: eda/CELL_PATTERNS.md 경로 변경**

생성 파일 섹션 수정:

Before:
```
dalykit/
├── code/
│   └── eda_analysis.ipynb   ← EDA 노트북 (Write 도구로 생성)
```

After:
```
dalykit/
├── code/
│   └── notebooks/
│       └── eda_analysis.ipynb   ← EDA 노트북 (Write 도구로 생성)
```

워크플로우 수정:

Before:
```
1. Write 도구 → dalykit/code/eda_analysis.ipynb 생성 (nbformat 4)
```

After:
```
1. Write 도구 → dalykit/code/notebooks/eda_analysis.ipynb 생성 (nbformat 4)
```

- [ ] **Step 3: eda/EDA_REPORT.md에 요약 섹션 규칙 추가**

보고서 구조의 `# EDA 보고서` 바로 아래에 요약 섹션을 추가한다:

Before (보고서 구조 첫 부분):
```markdown
# EDA 보고서

## 1. 데이터 개요
```

After:
```markdown
# EDA 보고서

## 요약
<!-- 5줄 이내로 데이터 상태와 핵심 발견을 요약한다 -->
<!-- 후속 스킬(clean, stat, feature, model)이 이 섹션만 Read하여 컨텍스트를 수집한다 -->
- 데이터: [N행 × N열, 도메인 설명]
- 데이터 품질: [결측/이상치/중복 요약]
- 핵심 발견: [가장 중요한 1-2가지]
- 타겟 변수: [타겟 + 분포 특성]
- 추천 다음 단계: [clean/stat 등]

## 1. 데이터 개요
```

- [ ] **Step 4: 커밋**

```bash
git add skills/eda/SKILL.md skills/eda/CELL_PATTERNS.md skills/eda/EDA_REPORT.md
git commit -m "refactor: eda 스킬 경로를 code/notebooks/ 하위로 변경 + 보고서 요약 섹션 추가"
```

---

## Task 4: 기존 스킬 경로 마이그레이션 — clean

**Files:**
- Modify: `skills/clean/SKILL.md`
- Modify: `skills/clean/CELL_PATTERNS.md`
- Modify: `skills/clean/PREPROCESSING_REPORT.md`

- [ ] **Step 1: clean/SKILL.md 경로 변경**

경로 규칙 테이블 수정:

Before:
```
| 노트북 | `dalykit/code/clean_pipeline.ipynb` |
```

After:
```
| 노트북 | `dalykit/code/notebooks/clean_pipeline.ipynb` |
```

워크플로우 3단계 수정:

Before:
```
- Write 도구로 `dalykit/code/clean_pipeline.ipynb` 생성 (nbformat 4)
```

After:
```
- Write 도구로 `dalykit/code/notebooks/clean_pipeline.ipynb` 생성 (nbformat 4)
```

report 인자 워크플로우 수정:

Before:
```
1. `dalykit/code/clean_pipeline.ipynb` Read → 셀 출력(outputs) 분석
```

After:
```
1. `dalykit/code/notebooks/clean_pipeline.ipynb` Read → 셀 출력(outputs) 분석
```

- [ ] **Step 2: clean/CELL_PATTERNS.md 경로 변경**

생성 파일 섹션 수정:

Before:
```
dalykit/
├── code/
│   └── clean_pipeline.ipynb     ← 전처리 노트북 (Write 도구로 생성)
└── data/
    └── cleaned/
        └── 파일명_cleaned.csv   ← 전처리 완료 데이터 (셀 실행 시 저장)
```

After:
```
dalykit/
├── code/
│   └── notebooks/
│       └── clean_pipeline.ipynb     ← 전처리 노트북 (Write 도구로 생성)
└── data/
    └── 파일명_cleaned.csv           ← 전처리 완료 데이터 (셀 실행 시 저장)
```

워크플로우 수정:

Before:
```
1. Write 도구 → dalykit/code/clean_pipeline.ipynb 생성 (nbformat 4)
```

After:
```
1. Write 도구 → dalykit/code/notebooks/clean_pipeline.ipynb 생성 (nbformat 4)
```

**CELL_PATTERNS.md 셀 코드에서 `CLEANED_DIR` 참조 제거** — 셀 9의 저장 경로:

Before:
```python
output_path = os.path.join(CLEANED_DIR, f"{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv")
```

After:
```python
output_path = os.path.join(DATA_DIR, f"{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv")
```

- [ ] **Step 3: clean/PREPROCESSING_REPORT.md에 요약 섹션 추가**

보고서 구조의 `# 전처리 보고서` 바로 아래에 요약 섹션을 추가한다:

Before:
```markdown
# 전처리 보고서

## 1. 전처리 개요
```

After:
```markdown
# 전처리 보고서

## 요약
<!-- 5줄 이내로 전처리 결과를 요약한다 -->
<!-- 후속 스킬(stat, feature, model)이 이 섹션만 Read하여 컨텍스트를 수집한다 -->
- 원본 → 처리 후: [N행×N열 → N행×N열]
- 주요 처리: [결측값/이상치/타입 변환 요약]
- 저장 파일: [경로]
- 잔존 리스크: [있으면 1줄]
- 추천 다음 단계: [stat 등]

## 1. 전처리 개요
```

- [ ] **Step 4: 커밋**

```bash
git add skills/clean/SKILL.md skills/clean/CELL_PATTERNS.md skills/clean/PREPROCESSING_REPORT.md
git commit -m "refactor: clean 스킬 경로를 code/notebooks/ 하위로 변경 + 보고서 요약 섹션 추가"
```

---

## Task 5: 기존 스킬 경로 마이그레이션 — stat

**Files:**
- Modify: `skills/stat/SKILL.md`
- Modify: `skills/stat/CELL_PATTERNS.md`
- Modify: `skills/stat/CODE_PATTERNS.md`
- Modify: `skills/stat/REPORT_GUIDE.md`

- [ ] **Step 1: stat/SKILL.md 경로 변경 + 실행 환경 참조 추가**

경로 규칙 테이블 수정:

Before:
```
| 스크립트 | `dalykit/code/stat_analysis.py` |
| JSON 결과 | `dalykit/code/stat_results.json` |
```

After:
```
| 스크립트 | `dalykit/code/py/stat_analysis.py` |
| JSON 결과 | `dalykit/code/results/stat_results.json` |
```

2단계 스크립트 생성 수정:

Before:
```
- Write 도구로 `dalykit/code/stat_analysis.py` 생성 (분석 함수 + 실행 + JSON 저장)
- Bash 도구로 `python dalykit/code/stat_analysis.py` 실행 → `dalykit/code/stat_results.json` 생성
```

After:
```
- Write 도구로 `dalykit/code/py/stat_analysis.py` 생성 (분석 함수 + 실행 + JSON 저장)
- `dalykit/config/domain.md`의 "실행 환경" 섹션에 Python 경로가 있으면 해당 경로를 사용하여 실행. 없으면 `python3` 사용.
- Bash 도구로 `{python경로} dalykit/code/py/stat_analysis.py` 실행 → `dalykit/code/results/stat_results.json` 생성
```

3단계 보고서 생성 수정:

Before:
```
- `dalykit/code/stat_results.json` 읽어 `dalykit/docs/stat_report.md` 생성
```

After:
```
- `dalykit/code/results/stat_results.json` 읽어 `dalykit/docs/stat_report.md` 생성
```

update 인자 처리 수정:

Before:
```
1. `dalykit/code/stat_analysis.py` 존재 여부 확인 (Glob)
```

After:
```
1. `dalykit/code/py/stat_analysis.py` 존재 여부 확인 (Glob)
```

notebook 인자 처리 수정:

Before:
```
1. `dalykit/code/stat_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `dalykit/code/stat_analysis.ipynb` 변환
```

After:
```
1. `dalykit/code/py/stat_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `dalykit/code/notebooks/stat_analysis.ipynb` 변환
```

- [ ] **Step 2: stat/CELL_PATTERNS.md 경로 변경**

생성 파일 섹션 수정:

Before:
```
dalykit/
├── code/
│   ├── stat_analysis.py         ← 분석 스크립트 (Write 도구로 생성)
│   ├── stat_results.json        ← 스크립트 실행 결과 (Bash로 실행)
│   └── stat_analysis.ipynb      ← (notebook 인자 시) py → ipynb 변환
```

After:
```
dalykit/
├── code/
│   ├── py/
│   │   └── stat_analysis.py         ← 분석 스크립트 (Write 도구로 생성)
│   ├── results/
│   │   └── stat_results.json        ← 스크립트 실행 결과 (Bash로 실행)
│   └── notebooks/
│       └── stat_analysis.ipynb      ← (notebook 인자 시) py → ipynb 변환
```

워크플로우 수정:

Before:
```
1. Write 도구 → dalykit/code/stat_analysis.py 생성
2. Bash 도구 → python dalykit/code/stat_analysis.py 실행
3. 완료 → dalykit/code/stat_results.json 저장됨
```

After:
```
1. Write 도구 → dalykit/code/py/stat_analysis.py 생성
2. Bash 도구 → {python경로} dalykit/code/py/stat_analysis.py 실행
3. 완료 → dalykit/code/results/stat_results.json 저장됨
```

- [ ] **Step 3: stat/CODE_PATTERNS.md의 JSON 저장 경로 변경**

파일 내에서 `stat_results.json` 경로를 참조하는 곳이 있으면 `code/results/stat_results.json`으로 변경한다. Read로 전체 파일을 확인 후 해당 부분만 Edit.

- [ ] **Step 4: stat/REPORT_GUIDE.md에 요약 섹션 추가 + 경로 변경**

보고서 저장 규칙의 경로 수정:

Before:
```
- 경로: 프로젝트의 `docs/stat_report.md`
```

After:
```
- 경로: `dalykit/docs/stat_report.md`
```

결과 파싱 방법 수정:

Before:
```
1. Read로 `stat_results.json` 읽기
```

After:
```
1. Read로 `dalykit/code/results/stat_results.json` 읽기
```

보고서 구조 시작 부분에 요약 섹션 추가 안내:

보고서 생성 시 최상단에 아래 요약 섹션을 포함하도록 규칙 추가:
```markdown
## 요약
<!-- 5줄 이내로 통계 분석 결과를 요약한다 -->
<!-- 후속 스킬(feature, model)이 이 섹션만 Read하여 컨텍스트를 수집한다 -->
- 분석 범위: [검정 N건, 변수 N개]
- 핵심 결과: [유의한 검정 요약]
- 유의미한 변수: [변수 목록]
- 효과 크기: [가장 큰 효과 요약]
- 추천 다음 단계: [feature/model 등]
```

- [ ] **Step 5: 커밋**

```bash
git add skills/stat/SKILL.md skills/stat/CELL_PATTERNS.md skills/stat/CODE_PATTERNS.md skills/stat/REPORT_GUIDE.md
git commit -m "refactor: stat 스킬 경로를 code/py/, code/results/ 하위로 변경 + 실행 환경 참조 + 보고서 요약 섹션 추가"
```

---

## Task 6: 기존 스킬 경로 마이그레이션 — data-profiler + help

**Files:**
- Modify: `agents/data-profiler.md`
- Modify: `skills/help/SKILL.md`

- [ ] **Step 1: data-profiler.md 경로 변경**

2단계 프로파일링 실행 섹션 수정:

Before:
```
`dalykit/code/run_profile.py` 스크립트를 생성·실행하여 결과를 `dalykit/code/profile_results.json`에 저장한다.
```

After:
```
`dalykit/code/py/run_profile.py` 스크립트를 생성·실행하여 결과를 `dalykit/code/results/profile_results.json`에 저장한다.
```

파일 저장 섹션 수정:

Before:
```
- `dalykit/code/profile_results.json` — 구조화 결과 (스크립트 생성)
```

After:
```
- `dalykit/code/results/profile_results.json` — 구조화 결과 (스크립트 생성)
```

실행 환경 참조 규칙 추가 (2단계 프로파일링 실행 섹션에):
```
- `dalykit/config/domain.md`의 "실행 환경" 섹션에 Python 경로가 있으면 해당 경로를 사용하여 실행. 없으면 `python3` 사용.
```

- [ ] **Step 2: help/SKILL.md 업데이트**

스킬 목록 출력에 feature, model 추가 + 프로젝트 구조 변경:

Before:
```
사용 가능한 스킬:
  dalykit:init               프로젝트 구조 초기화
  dalykit:domain             도메인 정보 구조화 (자유 입력 → domain.md)
  dalykit:eda                탐색적 데이터 분석 (EDA)
  dalykit:eda report         노트북 실행 후 EDA 보고서 생성
  dalykit:clean              데이터 전처리
  dalykit:clean report       노트북 실행 후 전처리 보고서 생성
  dalykit:stat               통계 분석 · 가설 검정
  dalykit:stat update        기존 분석 재실행
  dalykit:stat notebook      py → ipynb 변환
  dalykit:help               도움말
```

After:
```
사용 가능한 스킬:
  dalykit:init               프로젝트 구조 초기화
  dalykit:domain             도메인 정보 구조화 (자유 입력 → domain.md)
  dalykit:eda                탐색적 데이터 분석 (EDA)
  dalykit:eda report         노트북 실행 후 EDA 보고서 생성
  dalykit:clean              데이터 전처리
  dalykit:clean report       노트북 실행 후 전처리 보고서 생성
  dalykit:stat               통계 분석 · 가설 검정
  dalykit:stat update        기존 분석 재실행
  dalykit:stat notebook      py → ipynb 변환
  dalykit:feature            피처 엔지니어링
  dalykit:feature report     노트북 실행 후 피처 보고서 생성
  dalykit:model              모델 학습 · 평가 (자동 루프)
  dalykit:model tune         하이퍼파라미터 튜닝 루프
  dalykit:model report       모델 평가 보고서 생성
  dalykit:help               도움말
```

시작하기 수정:

Before:
```
  4. dalykit:eda → dalykit:clean → dalykit:stat
```

After:
```
  4. dalykit:eda → dalykit:clean → dalykit:stat → dalykit:feature → dalykit:model
```

실행 패턴 테이블에 추가:

```
| feature | ipynb 생성 → 사용자 실행 → `feature report`로 보고서 | code/notebooks/, data/, docs/ |
| model | .py → 자동 루프 → JSON → `model report`로 보고서 | code/py/, code/results/, models/, docs/, figures/ |
```

프로젝트 구조 수정:

Before:
```
dalykit/
├── config/          ← domain.md, report_config.md
├── data/            ← 원본 CSV
│   └── cleaned/     ← 전처리 결과
├── code/            ← .ipynb 노트북 + .py 스크립트 + .json 결과
├── docs/            ← 보고서 (md)
└── figures/         ← 시각화 이미지
```

After:
```
dalykit/
├── config/          ← domain.md, report_config.md
├── data/            ← 원본 CSV + 전처리 + 피처 결과
├── code/
│   ├── py/          ← .py 스크립트
│   ├── notebooks/   ← .ipynb 노트북
│   └── results/     ← .json 결과
├── models/          ← .joblib 모델 파일
├── docs/            ← 보고서 (md)
└── figures/         ← 시각화 이미지
```

- [ ] **Step 3: 커밋**

```bash
git add agents/data-profiler.md skills/help/SKILL.md
git commit -m "refactor: data-profiler/help 경로 변경 + feature/model 스킬 목록 추가"
```

---

## Task 7: feature 스킬 — SKILL.md 작성

**Files:**
- Create: `skills/feature/SKILL.md`

- [ ] **Step 1: feature/SKILL.md 작성**

```markdown
---
name: feature
description: >
  피처 엔지니어링. 전처리된 데이터에서 인코딩, 스케일링, 파생 변수 생성,
  피처 선택을 수행하는 노트북을 생성한다.
  트리거: "dalykit:feature", "피처 엔지니어링", "feature engineering",
  "인코딩", "스케일링", "파생 변수".
user_invocable: true
---

# Feature Engineering (피처 엔지니어링)

> ipynb 노트북 생성 → 사용자가 직접 실행 → `dalykit:feature report`로 보고서 생성.

## 사용법

```
dalykit:feature          ← cleaned 데이터 → feature_pipeline.ipynb 생성
dalykit:feature report   ← 실행된 노트북 결과 읽기 → dalykit/docs/feature_report.md 생성
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 입력 데이터 | `dalykit/data/*_cleaned.csv` |
| 도메인 설정 | `dalykit/config/domain.md` |
| 노트북 | `dalykit/code/notebooks/feature_pipeline.ipynb` |
| 출력 데이터 | `dalykit/data/df_featured.csv` |
| 보고서 | `dalykit/docs/feature_report.md` |

## 워크플로우

### 1단계: 컨텍스트 수집 (2단계 참조)

1. **1차 — 요약만 Read (view_range)**:
   - `dalykit/docs/eda_report.md` → `## 요약` 섹션
   - `dalykit/docs/preprocessing_report.md` → `## 요약` 섹션
   - `dalykit/docs/stat_report.md` → `## 요약` 섹션
   - 보고서가 없으면 해당 항목 스킵
2. **2차 — 필요 시 상세 Read**:
   - 인코딩 대상 파악 시 → preprocessing_report.md "최종 컬럼 목록" 섹션
   - 유의미한 변수 파악 시 → stat_report.md "가설 통합 표" 또는 "요약 테이블" 섹션
3. `dalykit/config/domain.md` Read → 타겟 변수, 도메인 규칙 확인
4. `dalykit/data/` Glob → cleaned CSV 파일 탐색

### 2단계: 피처 엔지니어링 전략 제안

발견된 데이터 특성을 기반으로 전략을 텍스트로 제안 후 사용자 확인:

- **인코딩**: Label / One-Hot / Target 인코딩 (범주형 변수별 추천)
- **스케일링**: StandardScaler / MinMaxScaler / RobustScaler (분포 특성별 추천)
- **파생 변수**: 비율, 구간화, 교호작용 등 (도메인 맥락 기반)
- **피처 선택**: stat 결과 기반 비유의 변수 제거 제안, 강한 상관관계 변수 중 하나 제거 제안

### 3단계: ipynb 노트북 생성

> `~/.claude/skills/feature/CELL_PATTERNS.md`를 Read로 읽고 셀 구조를 따른다.

- Write 도구로 `dalykit/code/notebooks/feature_pipeline.ipynb` 생성 (nbformat 4)
- 생성 완료 후 사용자에게 안내:
  ```
  feature_pipeline.ipynb 생성 완료.
  노트북을 열어 전체 셀을 실행한 뒤 `dalykit:feature report`를 실행하세요.
  피처 결과는 dalykit/data/df_featured.csv 에 저장됩니다.
  ```

### report 인자 워크플로우

> `dalykit:feature report` 호출 시 실행. 노트북을 사용자가 실행한 뒤 호출해야 한다.

1. `dalykit/code/notebooks/feature_pipeline.ipynb` Read → 셀 출력(outputs) 분석
2. `dalykit/docs/feature_report.md` Write → 보고서 생성
3. ipynb 미존재 또는 outputs가 비어 있으면: "노트북을 먼저 실행한 뒤 다시 시도하세요." 안내 후 종료

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |

## 코드 생성 규칙

1. **주석은 한국어**로 작성
2. **비파괴적**: `df_feat = df.copy()`로 원본 보존
3. **출력 제한**: `.head()`, `.describe()`, `.value_counts()` 등 요약만
4. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
5. **변수명**: 입력 데이터프레임은 `df`, 피처 결과는 `df_feat`
6. **저장**: 마지막 셀에서 `dalykit/data/df_featured.csv`로 저장
7. **이미지 저장**: `dalykit/figures/`에 저장 (`plt.savefig()`)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `~/.claude/shared/viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
```

- [ ] **Step 2: 커밋**

```bash
git add skills/feature/SKILL.md
git commit -m "feat: feature 스킬 SKILL.md 작성"
```

---

## Task 8: feature 스킬 — CELL_PATTERNS.md 작성

**Files:**
- Create: `skills/feature/CELL_PATTERNS.md`

- [ ] **Step 1: feature/CELL_PATTERNS.md 작성**

```markdown
# 피처 엔지니어링 노트북 셀 패턴

`dalykit:feature` 스킬이 생성하는 ipynb 구조.

## 생성 파일

```
dalykit/
├── code/
│   └── notebooks/
│       └── feature_pipeline.ipynb   ← 피처 노트북 (Write 도구로 생성)
├── data/
│   └── df_featured.csv             ← 피처 엔지니어링 완료 데이터 (셀 실행 시 저장)
└── figures/
    └── *.png                       ← 시각화 이미지
```

## 워크플로우

```
1. Write 도구 → dalykit/code/notebooks/feature_pipeline.ipynb 생성 (nbformat 4)
2. 사용자가 노트북을 열어 전체 셀 실행
3. dalykit/data/df_featured.csv 저장 확인
4. dalykit:feature report 호출 → 보고서 생성
```

## ipynb 셀 구조

```python
# 셀 1: 라이브러리 임포트 (code cell)
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import platform
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler, LabelEncoder, OneHotEncoder

# 폰트 설정
if platform.system() == 'Darwin':
    plt.rcParams['font.family'] = 'AppleGothic'
else:
    plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False

# 프로젝트 루트 탐색
_search = os.getcwd()
while not os.path.exists(os.path.join(_search, 'dalykit')):
    _parent = os.path.dirname(_search)
    if _parent == _search:
        raise FileNotFoundError('dalykit/ 폴더를 찾을 수 없습니다. dalykit:init을 먼저 실행하세요.')
    _search = _parent
os.chdir(_search)

# 경로 설정
BASE_DIR    = 'dalykit'
DATA_DIR    = os.path.join(BASE_DIR, 'data')
FIGURES_DIR = os.path.join(BASE_DIR, 'figures')

# 셀 2: 데이터 로드 (code cell)
DATA_PATH = os.path.join(DATA_DIR, '파일명_cleaned.csv')  # 실제 파일명으로 대체
df = pd.read_csv(DATA_PATH)
df_feat = df.copy()  # 원본 보존
print(f"로드 완료: {df_feat.shape[0]}행 × {df_feat.shape[1]}열")
df_feat.head()

# 셀 3: 타겟 변수 분리 (code cell)
TARGET = '타겟_컬럼명'  # 실제 타겟으로 대체
y = df_feat[TARGET]
print(f"타겟: {TARGET}")
print(f"분포:\n{y.value_counts()}")

# 셀 4: 불필요 컬럼 제거 (code cell)
# ID성 컬럼, 분석 제외 컬럼 제거
drop_cols = ['ID']  # 실제 제거 대상으로 대체
df_feat = df_feat.drop(columns=drop_cols)
print(f"제거: {drop_cols}")
print(f"잔여: {df_feat.shape[1]}열")

# 셀 5: 인코딩 (code cell)
# 범주형 변수 인코딩 — 전략에 따라 수정
cat_cols = df_feat.select_dtypes(include='object').columns.tolist()
print(f"범주형 변수: {cat_cols}")

# One-Hot 인코딩 (낮은 카디널리티)
# ohe_cols = [col for col in cat_cols if df_feat[col].nunique() <= 10]
# df_feat = pd.get_dummies(df_feat, columns=ohe_cols, drop_first=True)

# Label 인코딩 (높은 카디널리티 또는 순서형)
# for col in label_cols:
#     le = LabelEncoder()
#     df_feat[col] = le.fit_transform(df_feat[col])

# 셀 6: 스케일링 (code cell)
# 수치형 변수 스케일링 — 전략에 따라 스케일러 선택
num_cols = df_feat.select_dtypes(include=np.number).columns.tolist()
if TARGET in num_cols:
    num_cols.remove(TARGET)

# scaler = StandardScaler()  # 정규 분포에 가까운 경우
# scaler = RobustScaler()    # 이상치가 있는 경우
# df_feat[num_cols] = scaler.fit_transform(df_feat[num_cols])

# 셀 7: 파생 변수 생성 (code cell)
# 도메인 지식 기반 파생 변수 — 데이터에 따라 추가/수정
# 예: df_feat['Income_per_Family'] = df_feat['Income'] / df_feat['Family']
# 예: df_feat['Age_group'] = pd.cut(df_feat['Age'], bins=[0, 30, 50, 100], labels=['Young', 'Mid', 'Senior'])

# 셀 8: 피처 확인 (code cell)
print(f"최종 피처: {df_feat.shape[1]}열")
print(f"\ndtypes:\n{df_feat.dtypes.value_counts()}")
print(f"\n결측값: {df_feat.isnull().sum().sum()}")
df_feat.head()

# 셀 9: 상관관계 확인 (code cell)
def save_fig(filename):
    path = os.path.join(FIGURES_DIR, filename)
    plt.savefig(path, dpi=150, bbox_inches='tight')
    plt.close()
    return path

num_feat_cols = df_feat.select_dtypes(include=np.number).columns.tolist()
if len(num_feat_cols) >= 2:
    corr = df_feat[num_feat_cols].corr()
    mask = np.triu(np.ones_like(corr, dtype=bool), k=1)
    fig, ax = plt.subplots(figsize=(12, 10))
    sns.heatmap(corr, annot=True, fmt='.2f', cmap='RdYlBu',
                mask=mask, linewidths=1, linecolor='white', ax=ax)
    ax.set_title('피처 상관관계 히트맵')
    save_fig('feature_corr_heatmap.png')

# 셀 10: 저장 (code cell)
output_path = os.path.join(DATA_DIR, 'df_featured.csv')
df_feat.to_csv(output_path, index=False)
print(f"저장 완료: {output_path}")
print(f"최종: {df_feat.shape[0]}행 × {df_feat.shape[1]}열")
```

## nbformat 4 JSON 구조 (Write 도구 사용 시)

```json
{
  "nbformat": 4,
  "nbformat_minor": 5,
  "metadata": {
    "kernelspec": {"display_name": "Python 3", "language": "python", "name": "python3"},
    "language_info": {"name": "python", "version": "3.8.0"}
  },
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {},
      "source": ["# 피처 엔지니어링 파이프라인\n"],
      "id": "cell-md-title"
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": ["# 셀 코드 내용"],
      "id": "cell-01"
    }
  ]
}
```

> 각 셀의 `id`는 고유하게 부여 (cell-01, cell-02, …)
> `source`는 줄 단위 문자열 배열로 작성
> 인코딩/스케일링/파생 변수 셀은 주석 처리된 코드 블록을 포함하여 사용자가 전략에 따라 활성화

## 시각화 저장 규칙

| 저장 대상 | 파일명 |
|-----------|--------|
| 피처 상관관계 히트맵 | `feature_corr_heatmap.png` |
| 피처 분포 | `feature_dist_{col}.png` |
| 피처 중요도 (있을 시) | `feature_importance.png` |
```

- [ ] **Step 2: 커밋**

```bash
git add skills/feature/CELL_PATTERNS.md
git commit -m "feat: feature 스킬 CELL_PATTERNS.md 작성"
```

---

## Task 9: model 스킬 — SKILL.md 작성

**Files:**
- Create: `skills/model/SKILL.md`

- [ ] **Step 1: model/SKILL.md 작성**

```markdown
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

### 0단계: 컨텍스트 수집

1. **보고서 읽기** (2단계 참조):
   - 1차: `dalykit/docs/eda_report.md`, `preprocessing_report.md`, `stat_report.md`, `feature_report.md`의 "요약" 섹션만 Read
   - 2차: 필요 시 상세 섹션 추가 Read
2. `dalykit/config/domain.md` Read → ML 목표 (타겟, 문제 유형, 목표 성능), 실행 환경 확인
3. **분류/회귀 판단**: domain.md 명시 > 자동 감지 (타겟 nunique 기준)
4. **Python 경로 결정**: domain.md "실행 환경" 참조. 미지정 시 `python3`

### 1단계: 베이스라인 + 피처 진단

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

### 2단계: 튜닝 루프

> `dalykit:model tune`으로 직접 호출하거나, 1단계 후 자동 진입.

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
        {"name": "LogisticRegression", "score": 0.78, "metrics": {...}},
        {"name": "RandomForest", "score": 0.83, "metrics": {...}},
        {"name": "XGBoost", "score": 0.85, "metrics": {...}}
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

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
```

- [ ] **Step 2: 커밋**

```bash
git add skills/model/SKILL.md
git commit -m "feat: model 스킬 SKILL.md 작성"
```

---

## Task 10: model 스킬 — MODEL_CATALOG.md 작성

**Files:**
- Create: `skills/model/MODEL_CATALOG.md`

- [ ] **Step 1: model/MODEL_CATALOG.md 작성**

```markdown
# 모델 카탈로그

모델별 기본 하이퍼파라미터 + 튜닝 그리드.

## 분류 모델

### LogisticRegression (LR)
```python
# 기본값
LogisticRegression(max_iter=1000, random_state=42)

# 튜닝 그리드
{
    'C': [0.01, 0.1, 1, 10],
    'penalty': ['l1', 'l2'],
    'solver': ['liblinear', 'saga']
}
```

### RandomForestClassifier (RF)
```python
# 기본값
RandomForestClassifier(n_estimators=100, random_state=42)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [5, 10, 20, None],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}
```

### XGBClassifier (XGB)
```python
# 기본값
XGBClassifier(n_estimators=100, random_state=42, eval_metric='logloss')

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7],
    'learning_rate': [0.01, 0.05, 0.1, 0.2],
    'subsample': [0.7, 0.8, 1.0],
    'colsample_bytree': [0.7, 0.8, 1.0]
}
```

### LGBMClassifier (LGBM)
```python
# 기본값
LGBMClassifier(n_estimators=100, random_state=42, verbose=-1)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7, -1],
    'learning_rate': [0.01, 0.05, 0.1],
    'num_leaves': [15, 31, 63],
    'subsample': [0.7, 0.8, 1.0]
}
```

### SVC (SVM)
```python
# 기본값
SVC(random_state=42, probability=True)

# 튜닝 그리드
{
    'C': [0.1, 1, 10],
    'kernel': ['rbf', 'linear'],
    'gamma': ['scale', 'auto']
}
```

### KNeighborsClassifier (KNN)
```python
# 기본값
KNeighborsClassifier()

# 튜닝 그리드
{
    'n_neighbors': [3, 5, 7, 11],
    'weights': ['uniform', 'distance'],
    'metric': ['euclidean', 'manhattan']
}
```

### DecisionTreeClassifier (DT)
```python
# 기본값
DecisionTreeClassifier(random_state=42)

# 튜닝 그리드
{
    'max_depth': [3, 5, 10, 20, None],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}
```

### GradientBoostingClassifier (GB)
```python
# 기본값
GradientBoostingClassifier(n_estimators=100, random_state=42)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7],
    'learning_rate': [0.01, 0.05, 0.1],
    'subsample': [0.7, 0.8, 1.0]
}
```

---

## 회귀 모델

### LinearRegression (LR)
```python
# 기본값
LinearRegression()

# 튜닝: 없음 (하이퍼파라미터 없음)
# 대안: Ridge, Lasso, ElasticNet
{
    'alpha': [0.01, 0.1, 1, 10, 100]  # Ridge/Lasso용
}
```

### RandomForestRegressor (RF)
```python
# 기본값
RandomForestRegressor(n_estimators=100, random_state=42)

# 튜닝 그리드: 분류와 동일
```

### XGBRegressor (XGB)
```python
# 기본값
XGBRegressor(n_estimators=100, random_state=42)

# 튜닝 그리드: 분류와 동일 (eval_metric='rmse')
```

### LGBMRegressor (LGBM)
```python
# 기본값
LGBMRegressor(n_estimators=100, random_state=42, verbose=-1)

# 튜닝 그리드: 분류와 동일
```

### SVR (SVM)
```python
# 기본값
SVR()

# 튜닝 그리드: 분류와 동일 (probability 제외)
```

### KNeighborsRegressor (KNN)
```python
# 기본값
KNeighborsRegressor()

# 튜닝 그리드: 분류와 동일
```

---

## 자동 모델 선택 기본 후보

### 분류 (3-5개)
1. LogisticRegression — 베이스라인 (선형)
2. RandomForest — 앙상블 (비선형)
3. XGBoost — 부스팅
4. LightGBM — 부스팅 (대용량에 빠름)
5. SVC — 커널 기반

### 회귀 (3-5개)
1. LinearRegression — 베이스라인 (선형)
2. RandomForestRegressor — 앙상블
3. XGBRegressor — 부스팅
4. LGBMRegressor — 부스팅
5. SVR — 커널 기반

> 데이터 크기에 따라 후보 조정: n > 10,000이면 SVM 제외 (학습 느림)
```

- [ ] **Step 2: 커밋**

```bash
git add skills/model/MODEL_CATALOG.md
git commit -m "feat: model 스킬 MODEL_CATALOG.md 작성"
```

---

## Task 11: model 스킬 — REPORT_GUIDE.md 작성

**Files:**
- Create: `skills/model/REPORT_GUIDE.md`

- [ ] **Step 1: model/REPORT_GUIDE.md 작성**

```markdown
# 모델 평가 보고서 가이드

`dalykit:model report` 호출 시 실행.
model_results.json을 분석하여 보고서를 생성한다.

## 결과 파싱 방법

1. Read로 `dalykit/code/results/model_results.json` 읽기
2. `history[0]` → 1회차 베이스라인 결과
3. `history[n]` → 각 튜닝 라운드 결과
4. `final_model` → 최종 선택 모델 상세
5. `feature_diagnosis` → 피처 진단 결과

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
![피처 중요도](../figures/model_feature_importance.png)

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

![튜닝 이력](../figures/model_tuning_history.png)

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

## 6. SHAP 해석 (선택)

> SHAP 라이브러리가 설치된 경우에만 생성.
> 미설치 시: "SHAP 해석을 보려면 `pip install shap`을 실행하세요."

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
| `model_feature_importance.png` | 피처 중요도 바차트 |
| `model_confusion_matrix.png` | 혼동 행렬 히트맵 (분류) |
| `model_residual_plot.png` | 잔차 플롯 (회귀) |
| `model_learning_curve.png` | 학습 곡선 |
| `model_tuning_history.png` | 튜닝 라운드별 성능 변화 |
| `model_shap_summary.png` | SHAP summary plot |
| `model_roc_curve.png` | ROC 커브 (분류) |
```

- [ ] **Step 2: 커밋**

```bash
git add skills/model/REPORT_GUIDE.md
git commit -m "feat: model 스킬 REPORT_GUIDE.md 작성"
```

---

## Task 12: install/uninstall 스크립트 업데이트

**Files:**
- Modify: `scripts/install.sh`
- Modify: `scripts/install.ps1`
- Modify: `scripts/uninstall.sh`
- Modify: `scripts/uninstall.ps1`

- [ ] **Step 1: install.sh에 feature, model 스킬 추가**

스킬 목록 변경:

Before:
```bash
skills=("init" "domain" "eda" "clean" "stat" "help")
```

After:
```bash
skills=("init" "domain" "eda" "clean" "stat" "feature" "model" "help")
```

- [ ] **Step 2: install.ps1에 feature, model 스킬 추가**

스킬 목록 변경:

Before:
```powershell
$skills = @("init", "domain", "eda", "clean", "stat", "help")
```

After:
```powershell
$skills = @("init", "domain", "eda", "clean", "stat", "feature", "model", "help")
```

- [ ] **Step 3: uninstall.sh에 feature, model 추가**

Read로 uninstall.sh를 확인하고, 스킬 제거 목록에 `feature`, `model`을 추가한다.

- [ ] **Step 4: uninstall.ps1에 feature, model 추가**

Read로 uninstall.ps1을 확인하고, 스킬 제거 목록에 `feature`, `model`을 추가한다.

- [ ] **Step 5: 커밋**

```bash
git add scripts/install.sh scripts/install.ps1 scripts/uninstall.sh scripts/uninstall.ps1
git commit -m "feat: install/uninstall 스크립트에 feature, model 스킬 추가"
```

---

## Task 13: CLAUDE.md + README.md 문서 동기화

**Files:**
- Modify: `CLAUDE.md`
- Modify: `README.md`

- [ ] **Step 1: CLAUDE.md 프로젝트 구조 업데이트**

프로젝트 구조 섹션에서 `skills/feature/`, `skills/model/` 추가:

```
├── skills/
│   ├── init/         ← SKILL.md
│   ├── domain/       ← SKILL.md
│   ├── eda/          ← SKILL.md, EDA_REPORT.md, CELL_PATTERNS.md
│   ├── clean/        ← SKILL.md, PREPROCESSING_REPORT.md, CELL_PATTERNS.md
│   ├── stat/         ← SKILL.md (+ 참조 문서 다수)
│   ├── feature/      ← SKILL.md, CELL_PATTERNS.md
│   ├── model/        ← SKILL.md, MODEL_CATALOG.md, REPORT_GUIDE.md
│   ├── report/       ← SKILL.md, REPORT_STRUCTURE.md
│   └── help/         ← SKILL.md
```

스킬 목록 테이블에 추가:

```
| `dalykit:feature` | 피처 엔지니어링 |
| `dalykit:model` | 모델 학습 · 평가 |
```

- [ ] **Step 2: README.md 스킬 테이블 + 사용법 업데이트**

스킬 테이블에 추가:

```
| `dalykit:feature` | 피처 엔지니어링 — 인코딩, 스케일링, 파생 변수 |
| `dalykit:model` | 모델 학습 · 평가 — 자동 루프, 튜닝 |
```

사용법 섹션에 추가:

```
dalykit:feature            피처 엔지니어링
dalykit:feature report     노트북 실행 후 피처 보고서 생성
dalykit:model              모델 학습 · 평가 (자동 루프)
dalykit:model LR,XGB       지정 모델만 학습
dalykit:model tune         하이퍼파라미터 튜닝
dalykit:model report       모델 평가 보고서 생성
```

시작하기에서 파이프라인 업데이트:

```
3. `dalykit:eda` → `dalykit:clean` → `dalykit:stat` → `dalykit:feature` → `dalykit:model`
```

기술 스택에 scikit-learn, joblib 추가.

- [ ] **Step 3: 커밋**

```bash
git add CLAUDE.md README.md
git commit -m "docs: CLAUDE.md, README.md에 feature/model 스킬 반영"
```

---

## Task 14: work-tracker 업데이트

**Files:**
- Modify: `docs/work-tracker.md`

- [ ] **Step 1: work-tracker에 ML 파이프라인 작업 기록**

최근 변경에 이번 작업 추가. 백로그에서 완료된 항목 체크. 설계 결정 로그에 ML 관련 결정 추가.

- [ ] **Step 2: 커밋 + 푸시**

```bash
git add docs/work-tracker.md
git commit -m "docs: work-tracker에 ML 파이프라인 구현 기록"
git push origin main
```
