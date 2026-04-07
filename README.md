# DalyKit

### Data Analysis Kit

> 반복되는 분석 코드는 DalyKit에게. 당신은 인사이트에만 집중하세요.  
> Claude Code 플러그인으로 데이터 분석 워크플로우를 가속합니다.

![version](https://img.shields.io/badge/version-0.1.2-blue?style=flat)
![license](https://img.shields.io/badge/license-MIT-green?style=flat)
![python](https://img.shields.io/badge/python-3.10%2B-yellow?style=flat&logo=python&logoColor=white)
![platform](https://img.shields.io/badge/platform-Claude%20Code-orange?style=flat)

[English](./README.en.md) | 한국어

---

## Table of Contents

- [What is DalyKit?](#what-is-dalykit)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Workflow](#workflow)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Skills](#skills)
- [Contact](#contact)

---

## What is DalyKit?

데이터 분석은 반복적입니다. 매번 같은 EDA 코드를 쓰고, 같은 전처리 패턴을 적용하고, 같은 방식으로 모델을 돌립니다.

DalyKit은 이 반복을 없앱니다.

명령어 하나로 분석 코드를 생성하고, 실행 결과를 보고서로 정리하고, 모델 튜닝 루프를 자동으로 돌립니다. 분석가는 데이터와 인사이트에만 집중할 수 있습니다.

### 핵심 특징

- **단계별 워크플로우** — init → eda → clean → stat → feature → ml 전 파이프라인을 스킬 하나씩으로 실행
- **토큰 효율 설계** — 1,000행 이상 데이터는 `.py` 스크립트로 분리 실행, 대화 컨텍스트 오염 방지
- **표준화된 결과물** — 모든 산출물이 `dalykit/` 폴더에 일관된 구조로 저장

<div align="right"><a href="#dalykit">Top</a></div>

---

## Installation

> **필요 조건** [Claude Code](https://claude.ai/code)

```
/plugin marketplace add taehyunan-99/DalyKit
/plugin install dalykit@taehyunan
```

설치 후 `dalykit:init`으로 시작하세요.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Quick Start

```
# 1. 프로젝트 초기화
dalykit:init

# 2. dalykit/data/ 폴더에 CSV 파일 배치

# 3. 도메인 정보 입력 (선택)
dalykit:domain

# 4. EDA 노트북 생성
dalykit:eda

# 5. 생성된 노트북 실행 (dalykit/code/notebooks/eda_analysis.ipynb)

# 6. EDA 보고서 생성
dalykit:eda report
```

생성된 보고서는 `dalykit/docs/`에서 확인할 수 있습니다.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Workflow

```
dalykit:init
│
├── dalykit:domain        도메인 정보 정의 (선택)
│
├── dalykit:eda           탐색적 데이터 분석
│
├── dalykit:clean         데이터 전처리
│
├── dalykit:stat          통계 분석 · 가설 검정
│
├── dalykit:feature       피처 엔지니어링
│
└── dalykit:ml            모델 학습 · 자동 튜닝
```

각 스킬은 독립적으로 호출 가능합니다. 순서대로 전체 파이프라인을 실행하거나, 필요한 단계만 단독으로 사용할 수 있습니다.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Project Structure

`dalykit:init` 실행 후 생성되는 폴더 구조입니다.

```
dalykit/
├── config/          ← domain.md
├── data/            ← 원본 CSV + 전처리 결과 (*_cleaned.csv)
├── code/
│   ├── notebooks/   ← EDA, 전처리, 피처 노트북 (.ipynb)
│   ├── py/          ← 통계 분석, 모델 학습 스크립트 (.py)
│   └── results/     ← 분석 결과 (.json)
├── docs/            ← 각 단계별 보고서 (.md)
├── figures/         ← 시각화 이미지 (.png)
└── models/          ← 학습된 모델 파일 (.joblib)
```

<div align="right"><a href="#dalykit">Top</a></div>

---

## Tech Stack

| 용도 | 라이브러리 |
|------|-----------|
| 데이터 처리 | pandas 2.x, numpy 2.x |
| 시각화 | matplotlib 3.x, seaborn 0.13.x |
| 통계 분석 | scipy 1.x, statsmodels 0.14.x, scikit-posthocs 0.x |
| 머신러닝 | scikit-learn 1.x, xgboost 3.x, lightgbm 4.x, catboost 1.x, joblib 1.x |
| 모델 해석 | shap (선택 설치) |

<div align="right"><a href="#dalykit">Top</a></div>

---

## Skills

| 명령어 | 설명 | 주요 산출물 |
|--------|------|-------------|
| `dalykit:init` | 프로젝트 구조 초기화 | `dalykit/` 폴더 트리 |
| `dalykit:domain` | 도메인 정보 구조화 (자유 입력 → domain.md) | `config/domain.md` |
| `dalykit:eda` | 탐색적 데이터 분석 (EDA) | `code/notebooks/eda_analysis.ipynb` |
| `dalykit:eda report` | 노트북 실행 후 EDA 보고서 생성 | `docs/eda_report.md` |
| `dalykit:clean` | 데이터 전처리 | `code/notebooks/clean_pipeline.ipynb` |
| `dalykit:clean report` | 노트북 실행 후 전처리 보고서 생성 | `docs/preprocessing_report.md` |
| `dalykit:stat` | 통계 분석 · 가설 검정 | `docs/stat_report.md` |
| `dalykit:stat notebook` | py → ipynb 변환 | `code/notebooks/stat_analysis.ipynb` |
| `dalykit:feature` | 피처 엔지니어링 — 인코딩, 스케일링, 파생 변수 | `code/notebooks/feature_pipeline.ipynb` |
| `dalykit:feature report` | 노트북 실행 후 피처 보고서 생성 | `docs/feature_report.md` |
| `dalykit:ml` | 모델 자동 선택 (3-5개 비교) + 튜닝 | `models/*.joblib` |
| `dalykit:ml LR,RF,XGB` | 지정 모델만 비교 + 튜닝 (모델명은 예시) | `models/*.joblib` |
| `dalykit:ml tune` | 기존 결과 기반 튜닝 재실행 | `code/results/model_results.json` |
| `dalykit:ml ensemble` | 베이스라인 상위 모델로 Voting + Stacking 앙상블 비교 | `models/*.joblib` |
| `dalykit:ml report` | 결과 JSON → 보고서 + 시각화 생성 | `docs/model_report.md` |
| `dalykit:help` | 도움말 | — |

<div align="right"><a href="#dalykit">Top</a></div>

---

### Skills in Detail

### `dalykit:init` — 프로젝트 초기화

분석을 시작하기 전 가장 먼저 실행하는 스킬입니다. `dalykit/` 폴더와 하위 구조를 한 번에 생성하고, `dalykit/config/domain.md`를 자동으로 생성합니다.

**동작 방식**

1. `dalykit/` 폴더가 이미 존재하면 중복 실행을 방지하고 종료
2. `config`, `data`, `code/`, `models`, `docs`, `figures` 폴더 생성
3. 플러그인 설치 경로에서 `dalykit/config/domain.md` 및 Guard Hook 복사
4. 프로젝트 레벨 Guard Hook 설치 (잘못된 경로 쓰기 · 대용량 Read 차단)

**실행 결과**
```
dalykit/
├── config/      ← domain.md
├── data/
├── code/
│   ├── notebooks/
│   ├── py/
│   └── results/
├── models/
├── docs/
└── figures/

.claude/
├── hooks/       ← Guard Hook (프로젝트 외부 쓰기 · 대용량 Read 차단)
└── settings.json
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:domain` — 도메인 정보 구조화

분석 전 데이터와 비즈니스 맥락을 정리하는 스킬입니다. 형식 없이 자유롭게 작성한 메모를 Claude가 읽고, 이후 스킬들이 참조할 수 있는 구조화된 형식으로 변환합니다.

**동작 방식**

1. `dalykit/config/domain.md`의 자유 입력 섹션 읽기
2. `dalykit/data/`의 CSV 파일을 탐색해 컬럼명, 타입, 분포 파악
3. 자유 입력 + CSV 정보를 종합해 업종, 타겟 변수, 컬럼 설명, 도메인 규칙 등 구조화
4. `domain.md`의 구조화 섹션만 덮어쓰기 (자유 입력 보존)

자유 입력 없이 실행해도 CSV 컬럼 정보만으로 구조화가 가능합니다. 단, 도메인 규칙이나 비즈니스 제약처럼 데이터에서 추론할 수 없는 항목은 직접 입력하는 것을 권장합니다.

이 파일은 이후 `dalykit:eda`부터 `dalykit:ml`까지 모든 스킬이 참조합니다.

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:eda` — 탐색적 데이터 분석

데이터의 구조, 분포, 결측값, 상관관계를 분석하는 Jupyter 노트북을 자동 생성합니다.

**동작 방식**

1. `dalykit/data/`에서 CSV 파일 탐색
2. `domain.md`가 있으면 도메인 맥락을 반영해 노트북 구성
3. `dalykit/code/notebooks/eda_analysis.ipynb` 생성
4. 사용자가 노트북을 직접 실행한 뒤 `dalykit:eda report`로 보고서 생성

**실행 흐름**
```
dalykit:eda           → eda_analysis.ipynb 생성
  ↓ 사용자가 노트북 실행
dalykit:eda report    → docs/eda_report.md 생성
```

노트북 실행은 사용자가 직접 합니다. 셀 단위로 결과를 확인하고 수정할 수 있어 분석 품질을 높일 수 있습니다.

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:clean` — 데이터 전처리

결측값, 중복, 이상치, 타입 변환을 처리하는 전처리 파이프라인 노트북을 생성합니다. EDA 보고서가 있으면 분석 결과를 반영해 전처리 전략을 자동으로 구성합니다.

**동작 방식**

1. `eda_report.md`가 있으면 결측값·이상치·타입 이슈를 파악해 전략 수립, 없으면 데이터 직접 프로파일링
2. `dalykit/code/notebooks/clean_pipeline.ipynb` 생성
3. 사용자가 노트북을 직접 실행한 뒤 `dalykit:clean report`로 보고서 생성
4. 전처리 결과는 `dalykit/data/{파일명}_cleaned.csv`로 저장

**결측값 처리 전략** (결측 비율 기준 자동 선택)

| 결측 비율 | 전략 |
|-----------|------|
| > 50% | 열 제거 권고 (사용자 확인) |
| 5 ~ 50% | 그룹별 중앙값 대체 → fallback: 단순 중앙값 |
| < 5% | 단순 중앙값 / 최빈값 대체 |
| 복잡한 패턴 | IterativeImputer 셀 별도 제공 (선택 실행) |

**이상치 처리 워크플로우**

이상치는 자동 제거하지 않습니다. 탐지 결과만 출력하고, 처리 옵션(IQR 제거 / 클리핑)을 주석 처리 셀로 미리 제공합니다.

```
dalykit:clean            → clean_pipeline.ipynb 생성
  ↓ 노트북 실행 (이상치 탐지 결과 확인)
dalykit:clean report     → 보고서 확인
  ↓ 노트북에서 이상치 처리 셀 주석 해제 후 재실행
dalykit:clean report     → 보고서 갱신
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:stat` — 통계 분석 · 가설 검정

변수 척도를 파악하고 적합한 통계 검정을 자동 선택해 분석합니다. EDA/전처리 보고서가 있으면 추천 항목을 반영해 분석 계획을 수립합니다.

**동작 방식**

1. EDA·전처리 보고서에서 분석 추천 항목 추출, 없으면 데이터 직접 프로파일링
2. 변수 척도(명목/순서/등간/비율) 파악 → 적합한 검정 자동 선택
3. `dalykit/code/py/stat_analysis.py` 생성 후 자동 실행
4. 결과를 JSON으로 저장하고 `docs/stat_report.md` 자동 생성

eda/clean과 달리 노트북 수동 실행 없이 스크립트 실행부터 보고서 생성까지 자동으로 이어집니다. 결과를 노트북으로 확인하고 싶다면 `dalykit:stat notebook`으로 변환할 수 있습니다.

**실행 흐름**
```
dalykit:stat          → stat_analysis.py 생성 + 실행 → stat_report.md 자동 생성
dalykit:stat notebook → stat_analysis.ipynb 변환
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:feature` — 피처 엔지니어링

전처리된 데이터에서 인코딩, 스케일링, 파생 변수 생성, 피처 선택을 수행하는 노트북을 생성합니다. EDA·전처리·통계 보고서의 요약 섹션을 참조해 데이터에 맞는 전략을 자동으로 구성합니다.

**동작 방식**

1. 이전 보고서(eda, clean, stat) 요약 섹션 참조 → 인코딩 대상, 유의미한 변수 파악
2. `domain.md`에서 타겟 변수, 도메인 규칙 확인
3. `dalykit/code/notebooks/feature_pipeline.ipynb` 생성
4. 사용자가 노트북을 직접 실행한 뒤 `dalykit:feature report`로 보고서 생성
5. 피처 결과는 `dalykit/data/df_featured.csv`로 저장 (ml 스킬의 입력값)

**실행 흐름**
```
dalykit:feature           → feature_pipeline.ipynb 생성
  ↓ 사용자가 노트북 실행
dalykit:feature report    → docs/feature_report.md 생성
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:ml` — 모델 학습 · 자동 튜닝

피처 엔지니어링된 데이터로 머신러닝 모델을 학습하고 자동으로 튜닝합니다. 분류/회귀를 자동 감지하고, 3~5개 후보 모델을 비교한 뒤 상위 모델을 선정해 튜닝 루프를 실행합니다.

**동작 방식**

1. 이전 보고서 요약 섹션 참조 + `domain.md`에서 타겟 변수, 목표 성능 확인
2. 데이터 규모 판단 후 전략 결정 (소규모 n≤10k: 전체 비교 / 중규모 n≤100k: SVM 제외 / 대규모 n>100k: 샘플링 후 선정 재학습)
3. `dalykit/code/py/model_train.py` 생성 후 백그라운드 자동 실행
4. 1회차 결과로 피처 진단 (중요도 수렴, 다중공선성, 과적합, 전체 저성능)
5. 이상 없으면 상위 1~2개 모델 선정 → 튜닝 루프 실행 (최대 5회)
6. 결과는 `dalykit/code/results/model_results.json` + `dalykit/models/{모델명}.joblib`으로 저장

**튜닝 종료 조건**

| 조건 | 동작 |
|------|------|
| 목표 성능 도달 | 종료 |
| 이전 대비 개선폭 ≤ 0.5% 또는 성능 하락 | 수렴 종료 |
| 최대 5회 도달 | 강제 종료 |

**실행 흐름**
```
dalykit:ml              → 자동 모델 선택 + 튜닝 루프
dalykit:ml LR,RF,XGB    → 지정 모델만 비교 + 튜닝
dalykit:ml tune         → 기존 결과 기반 튜닝 재실행
dalykit:ml ensemble     → 베이스라인 상위 모델로 Voting + Stacking 앙상블 비교
dalykit:ml report       → model_results.json → docs/model_report.md 생성
```

**피처 진단 시그널**

1회차 실행 후 아래 시그널이 감지되면 조기 종료하고 피처 수정 피드백을 제공합니다.

| 시그널 | 기준 |
|--------|------|
| 피처 중요도 0 수렴 | 중요도 < 0.01인 피처가 전체의 50% 이상 |
| 다중공선성 | VIF > 10인 피처 쌍 존재 |
| 과적합 | train-test 성능 격차 > 10% |
| 전체 저성능 | 모든 모델이 베이스라인 미달 |

피처 수정이 필요한 경우 `dalykit:feature`로 돌아가 노트북을 수정·재실행한 뒤 `dalykit:ml tune`으로 튜닝을 재실행합니다.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Contact

[![Email](https://img.shields.io/badge/Email-withblua%40gmail.com-D14836?style=flat&logo=gmail&logoColor=white)](mailto:withblua@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-taehyun--an-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/taehyun-an-8b07993a5)
[![Velog](https://img.shields.io/badge/Velog-taehyunan817-20C997?style=flat&logo=velog&logoColor=white)](https://velog.io/@taehyunan817/posts)

<div align="right"><a href="#dalykit">Top</a></div>
