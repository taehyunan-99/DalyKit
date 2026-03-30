# HarnessDA v3 구조 재설계 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** PPT 기능 제거, init 스킬 추가, 모든 경로를 `harnessda/` 기준으로 통일, 마크다운 보고서 전용으로 전환

**Architecture:** 6개 스킬(init, eda, clean, stat, report, help) + 1개 에이전트(data-profiler). 모든 스킬은 `harnessda/` 폴더 존재를 전제로 동작. .py 스크립트 → JSON → 보고서 패턴 통일.

**Tech Stack:** Claude Code skills (markdown-based), bash/powershell install scripts

---

## 파일 구조 맵

### 신규 생성
- `skills/init/SKILL.md` — init 스킬

### 삭제
- `skills/report/HTML_TEMPLATE.md`
- `skills/report/JSON_SCHEMA.md`
- `skills/report/SCHEMA_COMMON.md`
- `skills/report/SCHEMA_DOMAIN.md`
- `skills/report/SCHEMA_PORTFOLIO.md`
- `skills/report/template.html`
- `skills/report/report_data.json`
- `skills/report/test_report_data.json`
- `skills/tracker/SKILL.md` (디렉토리 전체)

### 수정
- `skills/eda/SKILL.md` — 경로 변경 + domain 옵션 제거 + notebook 옵션 추가
- `skills/eda/CELL_PATTERNS.md` — 경로 `harnessda/` 기준으로 변경
- `skills/eda/EDA_REPORT.md` — 출력 경로 변경
- `skills/data-clean/SKILL.md` — 경로 변경 + 데이터경로 인자 제거 + notebook 옵션 추가
- `skills/data-clean/CELL_PATTERNS.md` — 경로 변경
- `skills/data-clean/PREPROCESSING_REPORT.md` — 출력 경로 변경
- `skills/stat-analysis/SKILL.md` — 경로 변경 + 인자 제거 + notebook 옵션 추가
- `skills/stat-analysis/CELL_PATTERNS.md` — 경로 변경
- `skills/report/SKILL.md` — PPT 제거, 마크다운 전용, 경로 변경
- `skills/report/SLIDE_STRUCTURE.md` — PPT 참조 제거, 마크다운 보고서 구조로 전환
- `skills/help/SKILL.md` — 스킬 목록 갱신
- `agents/data-profiler.md` — 경로 변경
- `scripts/install.sh` — tracker 제거, init 추가
- `scripts/install.ps1` — tracker 제거, init 추가
- `scripts/uninstall.sh` — tracker 제거, init 추가
- `scripts/uninstall.ps1` — tracker 제거, init 추가
- `CLAUDE.md` — 프로젝트 구조 + 스킬 목록 갱신
- `README.md` — 사용법 갱신
- `docs/work-tracker.md` — 현재 상태 갱신

---

### Task 1: PPT 관련 파일 삭제 + tracker 삭제

**Files:**
- Delete: `skills/report/HTML_TEMPLATE.md`
- Delete: `skills/report/JSON_SCHEMA.md`
- Delete: `skills/report/SCHEMA_COMMON.md`
- Delete: `skills/report/SCHEMA_DOMAIN.md`
- Delete: `skills/report/SCHEMA_PORTFOLIO.md`
- Delete: `skills/report/template.html`
- Delete: `skills/report/report_data.json`
- Delete: `skills/report/test_report_data.json`
- Delete: `skills/tracker/SKILL.md` (디렉토리 전체)

- [ ] **Step 1: PPT 관련 파일 8개 삭제**

```bash
rm skills/report/HTML_TEMPLATE.md
rm skills/report/JSON_SCHEMA.md
rm skills/report/SCHEMA_COMMON.md
rm skills/report/SCHEMA_DOMAIN.md
rm skills/report/SCHEMA_PORTFOLIO.md
rm skills/report/template.html
rm skills/report/report_data.json
rm skills/report/test_report_data.json
```

- [ ] **Step 2: tracker 스킬 디렉토리 삭제**

```bash
rm -rf skills/tracker
```

- [ ] **Step 3: 삭제 확인**

```bash
ls skills/report/
# 기대 결과: SKILL.md  SLIDE_STRUCTURE.md 만 남아야 함
ls skills/tracker
# 기대 결과: 디렉토리 없음
```

- [ ] **Step 4: 커밋**

```bash
git add -A skills/report/ skills/tracker/
git commit -m "chore: PPT 관련 파일 8개 + tracker 스킬 삭제

PPT(HTML 슬라이드) 기능 폐기 — 퀄리티↔토큰 트레이드오프 해결 불가.
마크다운 보고서 품질 향상에 집중하는 방향으로 전환.
tracker는 v3 구조 재설계로 불필요.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 2: init 스킬 생성

**Files:**
- Create: `skills/init/SKILL.md`

- [ ] **Step 1: init SKILL.md 작성**

```markdown
---
name: init
description: >
  HarnessDA 프로젝트 구조 초기화. harnessda/ 폴더와 하위 디렉토리를 생성하고
  config 템플릿을 자동 배치한다.
  트리거: "harnessda:init", "프로젝트 초기화", "init", "시작".
user_invocable: true
---

# Init (프로젝트 초기화)

`harnessda/` 표준 프로젝트 구조를 생성한다.

## 사용법

```
harnessda:init              ← harnessda/ 폴더 + 하위 구조 + config 템플릿 생성
```

## 워크플로우

### 1단계: 존재 확인

- Glob으로 현재 디렉토리에 `harnessda/` 폴더 존재 여부 확인
- **있으면**: "이미 초기화되어 있습니다. (`harnessda/` 폴더가 존재합니다)" 출력 후 종료
- **없으면**: 2단계로 진행

### 2단계: 폴더 생성

Bash 도구로 디렉토리 생성:

```bash
mkdir -p harnessda/config harnessda/data/cleaned harnessda/code harnessda/docs harnessda/figures
```

### 3단계: config 템플릿 복사

플러그인의 `templates/` 디렉토리에서 템플릿을 복사한다.

1. `templates/DOMAIN_TEMPLATE.md`를 Read로 읽는다
2. 내용을 `harnessda/config/domain.md`에 Write로 저장
3. `templates/REPORT_CONFIG_TEMPLATE.md`를 Read로 읽는다
4. 내용을 `harnessda/config/report_config.md`에 Write로 저장

### 4단계: 완료 메시지

아래 내용을 출력한다:

```
✅ HarnessDA 프로젝트 초기화 완료

생성된 구조:
  harnessda/
  ├── config/          ← domain.md, report_config.md
  ├── data/            ← 여기에 CSV 파일을 넣으세요
  │   └── cleaned/
  ├── code/
  ├── docs/
  └── figures/

다음 단계:
  1. harnessda/data/ 에 분석할 CSV 파일을 넣으세요
  2. (선택) harnessda/config/domain.md 를 편집하세요
  3. harnessda:eda 를 실행하세요
```
```

- [ ] **Step 2: 파일 생성 확인**

```bash
cat skills/init/SKILL.md | head -5
# 기대: --- / name: init / description: > ...
```

- [ ] **Step 3: 커밋**

```bash
git add skills/init/SKILL.md
git commit -m "feat: harnessda:init 스킬 추가

프로젝트 표준 구조(harnessda/) 자동 생성.
config 템플릿(domain.md, report_config.md) 자동 배치.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 3: eda 스킬 경로 수정

**Files:**
- Modify: `skills/eda/SKILL.md`
- Modify: `skills/eda/CELL_PATTERNS.md`
- Modify: `skills/eda/EDA_REPORT.md`

- [ ] **Step 1: eda SKILL.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
---
name: eda
description: >
  탐색적 데이터 분석(EDA) 자동화. harnessda/data/에서 데이터를 읽고
  분석 스크립트를 생성하여 보고서까지 자동으로 작성한다.
  트리거: "harnessda:eda", "EDA 해줘", "데이터 탐색", "explore this data",
  "데이터 분석 시작", "what does this data look like".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

> .py 스크립트 생성 → 실행 → JSON → 보고서 자동 생성 (Heavy-Task-Offload).

## 사용법

```
harnessda:eda              ← data/에서 CSV 탐색 → 분석 → 보고서 자동
harnessda:eda update       ← 기존 py 재실행 → 보고서 갱신
harnessda:eda notebook     ← eda_analysis.py → ipynb 변환
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 데이터 | `harnessda/data/` |
| 도메인 설정 | `harnessda/config/domain.md` |
| 스크립트 | `harnessda/code/eda_analysis.py` |
| JSON 결과 | `harnessda/code/eda_results.json` |
| 보고서 | `harnessda/docs/eda_report.md` |
| 시각화 | `harnessda/figures/` |

## 워크플로우

### 1단계: 데이터 파악

- Glob으로 `harnessda/data/`의 CSV/Excel 파일 탐색
- 파일 1개 → 자동 선택, 여러 개 → 사용자에게 선택 요청
- `harnessda/config/domain.md`가 있으면 Read로 읽고 도메인 맥락 반영

### 2단계: .py 스크립트 생성 + 실행

> `CELL_PATTERNS.md`를 Read로 읽고 파일 구조를 따른다.

- Write 도구로 `harnessda/code/eda_analysis.py` 생성
- Bash 도구로 `python harnessda/code/eda_analysis.py` 실행 → `harnessda/code/eda_results.json` 생성

### 3단계: EDA 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

1. `harnessda/code/eda_results.json` 읽고 분석
2. EDA 보고서를 작성하여 `harnessda/docs/eda_report.md`에 저장
3. 보고서 구조와 작성 규칙은 **EDA_REPORT.md** 참조

## update 인자 처리

`harnessda:eda update` 호출 시:

1. `harnessda/code/eda_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: py 재실행 → JSON 갱신 → report 갱신 (py 생성 스킵)
3. **없으면**: "eda_analysis.py를 찾을 수 없습니다. `harnessda:eda`를 먼저 실행하세요." 안내 후 종료

## notebook 인자 처리

`harnessda:eda notebook` 호출 시:

1. `harnessda/code/eda_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `harnessda/code/eda_analysis.ipynb` 변환
3. **없으면**: "eda_analysis.py를 찾을 수 없습니다. `harnessda:eda`를 먼저 실행하세요." 안내 후 종료

변환 방법:
- py 파일을 Read로 읽는다
- `# %%` 로 시작하는 줄을 셀 경계로 인식
- `# %% [markdown]` 으로 시작하면 마크다운 셀
- 나머지는 코드 셀
- nbformat 4 형식의 JSON을 Write로 저장

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json) |
| `EDA_REPORT.md` | EDA 보고서 자동 생성 지침 |

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 모든 데이터 처리는 .py 스크립트에서 수행
2. **주석은 한국어**로 작성
3. **출력 제한**: `.head()`, `.describe()`, `.value_counts().head(10)` 등 요약만
4. **JSON 저장**: 모든 분석 결과를 `harnessda/code/eda_results.json`에 구조화하여 저장
5. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
6. **변수명**: 데이터프레임은 `df` 사용 (사용자가 다른 이름 지정 시 따름)
7. **이미지 저장**: `harnessda/figures/` 에 저장 (`plt.savefig()`)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
> 사용 가능한 차트: histogram, scatter, boxplot, heatmap, bar, line, stacked_bar, pairplot, subplot
```

- [ ] **Step 2: eda CELL_PATTERNS.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
# 파일 생성 패턴

`harnessda:eda` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 분석은 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 노트북은 `notebook` 인자로 별도 변환.

## 생성 파일

```
harnessda/
├── code/
│   ├── eda_analysis.py          ← 분석 스크립트 (Write 도구로 생성)
│   ├── eda_results.json         ← 스크립트 실행 결과 (Bash로 실행)
│   └── eda_analysis.ipynb       ← (notebook 인자 시) py → ipynb 변환
├── docs/
│   └── eda_report.md            ← 보고서 자동 생성
└── figures/
    └── *.png                    ← 시각화 이미지
```

## 워크플로우

```
1. Write 도구 → harnessda/code/eda_analysis.py 생성
2. Bash 도구 → python harnessda/code/eda_analysis.py 실행
3. 완료 → harnessda/code/eda_results.json + harnessda/figures/*.png 저장됨
4. 자동 → harnessda/docs/eda_report.md 보고서 생성
```

## eda_analysis.py 구조

```python
import os
import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import platform

# 폰트 설정
if platform.system() == 'Darwin':
    plt.rcParams['font.family'] = 'AppleGothic'
else:
    plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False

# 경로 설정
BASE_DIR = 'harnessda'
DATA_DIR = os.path.join(BASE_DIR, 'data')
CODE_DIR = os.path.join(BASE_DIR, 'code')
FIGURES_DIR = os.path.join(BASE_DIR, 'figures')

# 데이터 로드
DATA_PATH = os.path.join(DATA_DIR, '데이터_파일.csv')  # 실제 파일명으로 대체
df = pd.read_csv(DATA_PATH)

results = {}

# %% 1. 기본 정보
results['shape'] = list(df.shape)
results['dtypes'] = df.dtypes.astype(str).to_dict()
results['columns'] = list(df.columns)

# %% 2. 결측값 분석
missing = df.isnull().sum()
results['missing'] = {
    col: {'count': int(missing[col]), 'pct': round(missing[col] / len(df) * 100, 2)}
    for col in df.columns if missing[col] > 0
}

# %% 3. 기술통계
results['describe'] = df.describe().round(4).to_dict()

# %% 4. 범주형 분포
cat_cols = df.select_dtypes(include='object').columns.tolist()
results['categorical'] = {}
for col in cat_cols:
    results['categorical'][col] = {
        'nunique': int(df[col].nunique()),
        'top10': df[col].value_counts().head(10).to_dict()
    }

# %% 5. 수치형 상관관계
num_cols = df.select_dtypes(include=np.number).columns.tolist()
if len(num_cols) >= 2:
    results['correlation'] = df[num_cols].corr().round(4).to_dict()

# %% 6. 중복 행
results['duplicates'] = int(df.duplicated().sum())

# %% 결과 저장
with open(os.path.join(CODE_DIR, 'eda_results.json'), 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"EDA 완료: {df.shape[0]}행 × {df.shape[1]}열")
print(f"결과 저장: {CODE_DIR}/eda_results.json")
```

> 시각화 차트는 `viz/charts/` 패턴을 참조하여 `harnessda/figures/`에 저장
```

- [ ] **Step 3: eda EDA_REPORT.md 수정**

보고서 출력 위치 섹션만 수정:

기존:
```
## 보고서 출력 위치
- 작업 디렉토리에 `docs/` 폴더를 생성하고, 보고서는 `docs/` 하위에 마크다운 파일로 저장한다.
- 파일명 예시: `docs/eda_report.md`
```

변경:
```
## 보고서 출력 위치
- `harnessda/docs/` 하위에 마크다운 파일로 저장한다.
- 파일명: `harnessda/docs/eda_report.md`
```

보고서 템플릿 내 다음 단계 추천의 경로도 수정:
- `harnessda:clean` → 동일 (경로 변경 없음, 스킬명이라서)
- 차트 참조: `docs/figures/` → `harnessda/figures/`

- [ ] **Step 4: 커밋**

```bash
git add skills/eda/
git commit -m "refactor: eda 스킬 경로를 harnessda/ 기준으로 변경

- domain 옵션 제거 (init에서 처리)
- 데이터 경로 인자 제거 (harnessda/data/ 고정)
- notebook 변환 옵션 추가
- 모든 입출력 경로를 harnessda/ 하위로 통일

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 4: clean 스킬 경로 수정

**Files:**
- Modify: `skills/data-clean/SKILL.md`
- Modify: `skills/data-clean/CELL_PATTERNS.md`
- Modify: `skills/data-clean/PREPROCESSING_REPORT.md`

- [ ] **Step 1: clean SKILL.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
---
name: data-clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  .py 스크립트를 생성한다.
  트리거: "harnessda:clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

> .py 스크립트 생성 → 실행 → JSON → 보고서 자동 생성 (Heavy-Task-Offload).

## 사용법

```
harnessda:clean            ← data/ → 전처리 → cleaned/ 저장 + 보고서
harnessda:clean update     ← 기존 py 재실행 → 결과 갱신
harnessda:clean notebook   ← clean_pipeline.py → ipynb 변환
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 원본 데이터 | `harnessda/data/` |
| 전처리 결과 | `harnessda/data/cleaned/` |
| 스크립트 | `harnessda/code/clean_pipeline.py` |
| JSON 결과 | `harnessda/code/clean_results.json` |
| 보고서 | `harnessda/docs/preprocessing_report.md` |

## 워크플로우

### 1단계: 현재 상태 파악

- `harnessda/docs/eda_report.md`가 있으면 Read로 읽고, 결측값·이상치·타입 이슈를 파악하여 전처리 전략에 반영
- 없으면 `harnessda/data/` 파일을 직접 프로파일링 (dtypes, 결측값, 중복 수 확인)
- 사용자에게 전처리 방향 확인 (자동/수동 선택)

### 2단계: 전처리 전략 제안

발견된 이슈를 기반으로 처리 방법을 텍스트로 제안:
- 결측값: drop vs impute (평균/중앙값/최빈값/보간)
- 중복: 제거 여부
- 이상치: IQR vs Z-score vs 유지
- 타입 변환: object → datetime, numeric, category 등

### 3단계: .py 스크립트 생성 + 실행

> `CELL_PATTERNS.md`를 Read로 읽고 파일 구조를 따른다.

- Write 도구로 `harnessda/code/clean_pipeline.py` 생성
- Bash 도구로 `python harnessda/code/clean_pipeline.py` 실행 → `harnessda/code/clean_results.json` + `harnessda/data/cleaned/` 저장

### 4단계: 전처리 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

1. `harnessda/code/clean_results.json` 읽고 분석
2. 전처리 보고서를 작성하여 `harnessda/docs/preprocessing_report.md`에 저장
3. 보고서 구조와 작성 규칙은 **PREPROCESSING_REPORT.md** 참조

## update 인자 처리

`harnessda:clean update` 호출 시:

1. `harnessda/code/clean_pipeline.py` 존재 여부 확인 (Glob)
2. **있으면**: py 재실행 → JSON 갱신 → report 갱신 (py 생성 스킵)
3. **없으면**: "clean_pipeline.py를 찾을 수 없습니다. `harnessda:clean`을 먼저 실행하세요." 안내 후 종료

## notebook 인자 처리

`harnessda:clean notebook` 호출 시:

1. `harnessda/code/clean_pipeline.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `harnessda/code/clean_pipeline.ipynb` 변환
3. **없으면**: "clean_pipeline.py를 찾을 수 없습니다. `harnessda:clean`을 먼저 실행하세요." 안내 후 종료

변환 방법은 eda의 notebook 변환과 동일.

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json) |
| `PREPROCESSING_REPORT.md` | 전처리 보고서 자동 생성 지침 |

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 모든 데이터 처리는 .py 스크립트에서 수행
2. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
3. **비파괴적**: `df_clean = df.copy()`로 원본 보존
4. **단계별 JSON 저장**: 처리 결과를 `harnessda/code/clean_results.json`에 구조화하여 저장
5. **이상치**: 자동 제거하지 않고 탐지만 → 사용자에게 판단 요청
6. **저장 경로**: `harnessda/data/cleaned/파일명_cleaned.csv`
```

- [ ] **Step 2: clean CELL_PATTERNS.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
# 파일 생성 패턴

`harnessda:clean` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 처리는 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 전처리 데이터는 cleaned/ 폴더에 CSV로 저장.

## 생성 파일

```
harnessda/
├── code/
│   ├── clean_pipeline.py        ← 전처리 스크립트 (Write 도구로 생성)
│   ├── clean_results.json       ← 처리 결과 요약 (Bash로 실행)
│   └── clean_pipeline.ipynb     ← (notebook 인자 시) py → ipynb 변환
├── data/
│   └── cleaned/
│       └── 파일명_cleaned.csv   ← 전처리 완료 데이터
└── docs/
    └── preprocessing_report.md  ← 보고서 자동 생성
```

## 워크플로우

```
1. Write 도구 → harnessda/code/clean_pipeline.py 생성
2. Bash 도구 → python harnessda/code/clean_pipeline.py 실행
3. 완료 → harnessda/code/clean_results.json + harnessda/data/cleaned/*.csv 저장됨
4. 자동 → harnessda/docs/preprocessing_report.md 보고서 생성
```

## clean_pipeline.py 구조

```python
import os
import json
import pandas as pd
import numpy as np

# 경로 설정
BASE_DIR = 'harnessda'
DATA_DIR = os.path.join(BASE_DIR, 'data')
CLEANED_DIR = os.path.join(DATA_DIR, 'cleaned')
CODE_DIR = os.path.join(BASE_DIR, 'code')

# 데이터 로드
DATA_PATH = os.path.join(DATA_DIR, '데이터_파일.csv')  # 실제 파일명으로 대체
df = pd.read_csv(DATA_PATH)
df_clean = df.copy()  # 원본 보존

results = {
    'before': {'shape': list(df.shape), 'missing': int(df.isnull().sum().sum()), 'duplicates': int(df.duplicated().sum())},
    'steps': []
}

# %% 1. 중복 제거
dup_count = df_clean.duplicated().sum()
if dup_count > 0:
    df_clean = df_clean.drop_duplicates()
    results['steps'].append({'step': '중복 제거', 'removed': int(dup_count)})

# %% 2. 결측값 처리 (전략은 EDA 결과 기반으로 조정)
num_cols = df_clean.select_dtypes(include=np.number).columns
for col in num_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].median())
        results['steps'].append({'step': f'{col} 결측값 중앙값 대체', 'count': int(n_missing)})

cat_cols = df_clean.select_dtypes(include='object').columns
for col in cat_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])
        results['steps'].append({'step': f'{col} 결측값 최빈값 대체', 'count': int(n_missing)})

# %% 3. 이상치 탐지 (제거 안 함 — 사용자 판단)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile(0.25), series.quantile(0.75)
    IQR = Q3 - Q1
    return ((series < Q1 - 1.5 * IQR) | (series > Q3 + 1.5 * IQR)).sum()

results['outliers'] = {col: int(detect_outliers_iqr(df_clean[col].dropna())) for col in num_cols}

# %% 4. 전처리 후 요약
results['after'] = {'shape': list(df_clean.shape), 'missing': int(df_clean.isnull().sum().sum())}

# %% 저장
os.makedirs(CLEANED_DIR, exist_ok=True)
output_path = os.path.join(CLEANED_DIR, f"{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv")
df_clean.to_csv(output_path, index=False)
results['output_path'] = output_path

with open(os.path.join(CODE_DIR, 'clean_results.json'), 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"전처리 완료: {df.shape} → {df_clean.shape}")
print(f"데이터 저장: {output_path}")
print(f"결과 저장: {CODE_DIR}/clean_results.json")
```
```

- [ ] **Step 3: clean PREPROCESSING_REPORT.md 수정**

보고서 출력 위치 섹션 수정:

기존:
```
## 보고서 출력 위치
- 작업 디렉토리에 `docs/` 폴더를 생성하고, 보고서는 `docs/` 하위에 마크다운 파일로 저장한다.
- 파일명 예시: `docs/preprocessing_report.md`
```

변경:
```
## 보고서 출력 위치
- `harnessda/docs/` 하위에 마크다운 파일로 저장한다.
- 파일명: `harnessda/docs/preprocessing_report.md`
```

보고서 템플릿 내 경로도 수정:
- `data/파일명.csv` → `harnessda/data/파일명.csv`
- `data/cleaned/파일명_cleaned.csv` → `harnessda/data/cleaned/파일명_cleaned.csv`
- `notebooks/02_preprocessing.ipynb` → `harnessda/code/clean_pipeline.py`
- `docs/eda_report.md` → `harnessda/docs/eda_report.md`

- [ ] **Step 4: 커밋**

```bash
git add skills/data-clean/
git commit -m "refactor: clean 스킬 경로를 harnessda/ 기준으로 변경

- 데이터 경로 인자 제거 (harnessda/data/ 고정)
- notebook 변환 옵션 추가
- 모든 입출력 경로를 harnessda/ 하위로 통일

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 5: stat-analysis 스킬 경로 수정

**Files:**
- Modify: `skills/stat-analysis/SKILL.md`
- Modify: `skills/stat-analysis/CELL_PATTERNS.md`

- [ ] **Step 1: stat-analysis SKILL.md 수정**

주요 변경사항:
- description에서 "노트북 셀에 생성" → ".py 스크립트를 생성"
- 사용법에서 `[질문/목적]` 인자 제거
- 사전 조건 추가 (harnessda/ 존재 확인)
- 경로 규칙 테이블 추가
- notebook 인자 처리 섹션 추가
- 모든 경로를 `harnessda/` 기준으로 변경:
  - `docs/eda_report.md` → `harnessda/docs/eda_report.md`
  - `docs/preprocessing_report.md` → `harnessda/docs/preprocessing_report.md`
  - `data/cleaned/` → `harnessda/data/cleaned/`
  - `stat_analysis.py` → `harnessda/code/stat_analysis.py`
  - `stat_results.json` → `harnessda/code/stat_results.json`
  - `docs/stat_report.md` → `harnessda/docs/stat_report.md`
- 사용법 섹션:

```
## 사용법

```
harnessda:stat             ← cleaned/ 데이터 → 통계 검정 → 보고서
harnessda:stat update      ← 기존 py 재실행 → 결과 갱신
harnessda:stat notebook    ← stat_analysis.py → ipynb 변환
```
```

- 경로 규칙 테이블:

```
## 경로 규칙

| 항목 | 경로 |
|------|------|
| 전처리 데이터 | `harnessda/data/cleaned/` |
| 스크립트 | `harnessda/code/stat_analysis.py` |
| JSON 결과 | `harnessda/code/stat_results.json` |
| 보고서 | `harnessda/docs/stat_report.md` |
| 시각화 | `harnessda/figures/` |
```

- notebook 인자 처리 섹션 (eda/clean과 동일 패턴):

```
## notebook 인자 처리

`harnessda:stat notebook` 호출 시:

1. `harnessda/code/stat_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `harnessda/code/stat_analysis.ipynb` 변환
3. **없으면**: "stat_analysis.py를 찾을 수 없습니다. `harnessda:stat`을 먼저 실행하세요." 안내 후 종료
```

- [ ] **Step 2: stat-analysis CELL_PATTERNS.md 수정**

경로를 `harnessda/` 기준으로 변경:

```markdown
# 파일 생성 패턴

`harnessda:stat` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 분석은 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 노트북은 `notebook` 인자로 별도 변환.

## 생성 파일

```
harnessda/
├── code/
│   ├── stat_analysis.py         ← 분석 스크립트 (Write 도구로 생성)
│   ├── stat_results.json        ← 스크립트 실행 결과 (Bash로 실행)
│   └── stat_analysis.ipynb      ← (notebook 인자 시) py → ipynb 변환
└── docs/
    └── stat_report.md           ← 보고서 자동 생성
```

## 워크플로우

```
1. Write 도구 → harnessda/code/stat_analysis.py 생성
2. Bash 도구 → python harnessda/code/stat_analysis.py 실행
3. 완료 → harnessda/code/stat_results.json 저장됨
4. 자동 → harnessda/docs/stat_report.md 보고서 생성
```

> 코드 구조는 `CODE_PATTERNS.md`의 ".py 스크립트 전체 구조" 섹션 참조
```

- [ ] **Step 3: 커밋**

```bash
git add skills/stat-analysis/SKILL.md skills/stat-analysis/CELL_PATTERNS.md
git commit -m "refactor: stat-analysis 스킬 경로를 harnessda/ 기준으로 변경

- 질문/목적 인자 제거 (자동 분석만)
- notebook 변환 옵션 추가
- 모든 입출력 경로를 harnessda/ 하위로 통일

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 6: report 스킬 — PPT 제거 + 마크다운 전용

**Files:**
- Modify: `skills/report/SKILL.md`
- Modify: `skills/report/SLIDE_STRUCTURE.md`

- [ ] **Step 1: report SKILL.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
---
name: report
description: >
  최종 보고서 생성. EDA/전처리/통계 분석 결과를 종합하여
  마크다운 보고서를 생성한다.
  트리거: "harnessda:report", "보고서 만들어", "최종 보고서", "report".
user_invocable: true
---

# Report (최종 보고서)

EDA/전처리/통계 분석 보고서를 종합하여 최종 마크다운 보고서를 생성한다.

## 사용법

```
harnessda:report           ← 종합 마크다운 보고서 생성
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 보고서 설정 | `harnessda/config/report_config.md` |
| EDA 보고서 | `harnessda/docs/eda_report.md` |
| 전처리 보고서 | `harnessda/docs/preprocessing_report.md` |
| 통계 보고서 | `harnessda/docs/stat_report.md` |
| 시각화 | `harnessda/figures/` |
| 최종 보고서 | `harnessda/docs/report.md` |

## 참조 문서

| 파일 | 내용 |
|------|------|
| `SLIDE_STRUCTURE.md` | 보고서 섹션 순서 + 콘텐츠 매핑 |

## 워크플로우

### 1단계: 설정 확인

1. `harnessda/config/report_config.md` 확인
   - **있으면**: Read로 읽고 프로젝트 정보 + 커스텀 순서 반영
   - **없으면**: SLIDE_STRUCTURE.md 기본값 사용 (프로젝트 정보는 보고서에서 추론)

### 2단계: 수집

기존 보고서 + 차트 이미지를 Read/Glob으로 수집:

1. `harnessda/docs/eda_report.md` → 데이터 개요, 결측값, 분포, 상관관계
2. `harnessda/docs/preprocessing_report.md` → 전후 비교, 처리 요약
3. `harnessda/docs/stat_report.md` → 검정 결과 요약 테이블, 핵심 발견
4. `harnessda/figures/*.png` → 차트 이미지 목록

**보고서 누락 시**: 해당 섹션 스킵 + 사용자에게 경고 메시지 출력. 최소 1개 보고서는 필요.

### 3단계: 생성

> SLIDE_STRUCTURE.md를 Read로 읽고, 섹션 순서를 따라 `harnessda/docs/report.md`에 Write.

보고서 구조는 SLIDE_STRUCTURE.md의 순서를 따르되, 마크다운 형식으로 작성:
- 각 섹션 → 마크다운 제목 (`##`)
- 차트 이미지 → `![](../figures/chart.png)` 상대경로 참조
- 테이블 → 마크다운 테이블

## 마크다운 보고서 작성 규칙

1. **프로젝트 스토리라인** 유지: 문제 → 데이터 → 분석 → 발견 → 결론
2. `report_config.md`의 프로젝트 정보가 있으면 "문제 정의" 섹션에 반영
3. 없으면 보고서 내용에서 추론하여 간략히 서술
4. **차트 참조**: `harnessda/figures/` 이미지를 상대경로로 포함
5. **결론 섹션**: 문제 정의에서 제기한 질문에 직접 답변
6. **한계점 + 후속 분석**: 각 보고서의 추천사항을 종합
7. 한국어로 작성
```

- [ ] **Step 2: SLIDE_STRUCTURE.md 수정**

PPT/슬라이드 용어를 보고서 섹션 용어로 변경. 경로를 `harnessda/` 기준으로 변경:
- `docs/figures/` → `harnessda/figures/`
- `eda_report.md` → `harnessda/docs/eda_report.md`
- `preprocessing_report.md` → `harnessda/docs/preprocessing_report.md`
- `stat_report.md` → `harnessda/docs/stat_report.md`
- `report_config.md` → `harnessda/config/report_config.md`

파일 제목도 변경: "슬라이드 기본 구조" → "보고서 섹션 구조"

- [ ] **Step 3: 커밋**

```bash
git add skills/report/
git commit -m "refactor: report 스킬 PPT 제거, 마크다운 보고서 전용으로 전환

- HTML/PPTX 관련 옵션 및 참조 제거
- config 옵션 제거 (init에서 처리)
- 경로를 harnessda/ 기준으로 변경

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 7: help 스킬 갱신

**Files:**
- Modify: `skills/help/SKILL.md`

- [ ] **Step 1: help SKILL.md 수정**

전체 파일을 아래 내용으로 교체:

```markdown
---
name: help
description: >
  HarnessDA 스킬 목록 및 사용법 안내.
  트리거: "harnessda:help", "스킬 목록", "도움말".
user_invocable: true
---

# HarnessDA — 도움말

## 스킬 목록

아래 내용을 출력한다:

```
📊 HarnessDA — 데이터 분석 도구 모음

사용 가능한 스킬:
  harnessda:init              프로젝트 구조 초기화
  harnessda:eda               탐색적 데이터 분석 (EDA)
  harnessda:eda update        기존 분석 재실행
  harnessda:eda notebook      py → ipynb 변환
  harnessda:clean             데이터 전처리
  harnessda:clean update      기존 전처리 재실행
  harnessda:clean notebook    py → ipynb 변환
  harnessda:stat              통계 분석 · 가설 검정
  harnessda:stat update       기존 분석 재실행
  harnessda:stat notebook     py → ipynb 변환
  harnessda:report            최종 마크다운 보고서
  harnessda:help              도움말

에이전트:
  data-profiler               종합 프로파일링 (Agent 도구로 호출)

시작하기:
  1. harnessda:init 으로 프로젝트 구조 생성
  2. harnessda/data/ 에 CSV 파일 배치
  3. harnessda:eda → harnessda:clean → harnessda:stat → harnessda:report
```

## 실행 패턴

| 스킬 | 방식 | 출력 |
|------|------|------|
| init | 폴더 생성 + 템플릿 복사 | harnessda/ 구조 |
| eda | .py → JSON → 보고서 | code/, docs/, figures/ |
| clean | .py → JSON → cleaned CSV + 보고서 | code/, data/cleaned/, docs/ |
| stat | .py → JSON → 보고서 | code/, docs/ |
| report | 보고서 종합 → 최종 보고서 | docs/report.md |

## 프로젝트 구조

```
harnessda/
├── config/          ← domain.md, report_config.md
├── data/            ← 원본 CSV
│   └── cleaned/     ← 전처리 결과
├── code/            ← .py 스크립트 + .json 결과
├── docs/            ← 보고서 (md)
└── figures/         ← 시각화 이미지
```
```

- [ ] **Step 2: 커밋**

```bash
git add skills/help/SKILL.md
git commit -m "refactor: help 스킬 갱신 — init 추가, tracker/PPT 제거, 구조 업데이트

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 8: data-profiler 에이전트 경로 수정

**Files:**
- Modify: `agents/data-profiler.md`

- [ ] **Step 1: data-profiler.md 수정**

주요 변경:
- "노트북에 프로파일링 셀들을 자동 생성" → "harnessda/ 구조에서 프로파일링 수행"
- tools에서 `NotebookEdit` 제거
- "노트북(.ipynb)이 있으면 해당 노트북에 셀 추가" → `harnessda/data/` 에서 데이터 탐색
- 수행 절차를 `harnessda/` 경로 기준으로 변경
- 출력 경로: `harnessda/docs/`, `harnessda/figures/`

- [ ] **Step 2: 커밋**

```bash
git add agents/data-profiler.md
git commit -m "refactor: data-profiler 에이전트 harnessda/ 경로 적용

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 9: install/uninstall 스크립트 수정

**Files:**
- Modify: `scripts/install.sh`
- Modify: `scripts/install.ps1`
- Modify: `scripts/uninstall.sh`
- Modify: `scripts/uninstall.ps1`

- [ ] **Step 1: install.sh 수정**

스킬 목록에서 `tracker` 제거, `init` 추가:

```bash
skills=("init" "eda" "data-clean" "stat-analysis" "viz" "report" "help")
```

- [ ] **Step 2: install.ps1 수정**

```powershell
$skills = @("init", "eda", "data-clean", "stat-analysis", "viz", "report", "help")
```

- [ ] **Step 3: uninstall.sh 수정**

```bash
skills=("init" "eda" "data-clean" "stat-analysis" "viz" "report" "help")
```

- [ ] **Step 4: uninstall.ps1 수정**

```powershell
$skills = @("init", "eda", "data-clean", "stat-analysis", "viz", "report", "help")
```

- [ ] **Step 5: 커밋**

```bash
git add scripts/
git commit -m "refactor: install/uninstall 스크립트 — tracker 제거, init 추가

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 10: CLAUDE.md + README.md + work-tracker.md 갱신

**Files:**
- Modify: `CLAUDE.md`
- Modify: `README.md`
- Modify: `docs/work-tracker.md`

- [ ] **Step 1: CLAUDE.md 수정**

프로젝트 구조를 v3 기준으로 갱신:

```markdown
## 프로젝트 구조

```
HarnessDA_Project/
├── CLAUDE.md
├── README.md
├── skills/
│   ├── init/         ← SKILL.md (프로젝트 초기화)
│   ├── eda/          ← SKILL.md, EDA_REPORT.md, CELL_PATTERNS.md
│   ├── data-clean/   ← SKILL.md, PREPROCESSING_REPORT.md, CELL_PATTERNS.md
│   ├── stat-analysis/← SKILL.md (+ 참조 문서 다수)
│   ├── viz/          ← STYLE_GUIDE.md, charts/*.md (공유 시각화 참조 문서)
│   ├── report/       ← SKILL.md, SLIDE_STRUCTURE.md
│   └── help/         ← SKILL.md (스킬 목록 + 도움말)
├── templates/        ← 사용자 입력 템플릿 (init 시 복사)
│   ├── DOMAIN_TEMPLATE.md
│   └── REPORT_CONFIG_TEMPLATE.md
├── agents/
│   └── data-profiler.md
└── scripts/
    ├── install.sh / install.ps1
    └── uninstall.sh / uninstall.ps1
```
```

작업 환경 섹션:
```markdown
### 작업 환경
- **모든 스킬**: .py 스크립트 생성 → 실행 → JSON 저장 → 보고서 자동 생성 (Heavy-Task-Offload 패턴)
- **report**: docs/ 내 보고서들을 종합하여 최종 마크다운 보고서 생성
- **노트북**: `notebook` 인자로 py → ipynb 변환 (선택 사항)
- **harnessda:init**: 프로젝트 시작 시 `harnessda/` 표준 구조 자동 생성
- **데이터 로드**: `harnessda/data/` 에서 자동 탐색
```

스킬 목록:
```markdown
## 스킬 목록
| 명령어 | 설명 |
|--------|------|
| `harnessda:init` | 프로젝트 구조 초기화 |
| `harnessda:eda` | 탐색적 데이터 분석 |
| `harnessda:clean` | 데이터 전처리 |
| `harnessda:stat` | 통계 분석 |
| `harnessda:report` | 최종 보고서 (마크다운) |
| `harnessda:help` | 스킬 목록 + 도움말 |
```

- [ ] **Step 2: README.md 수정**

스킬 목록에 init 추가, tracker/PPT 제거. 사용법 갱신:

```markdown
## 사용법

```
harnessda:init             프로젝트 구조 초기화
harnessda:eda              탐색적 데이터 분석 (EDA)
harnessda:clean            데이터 전처리
harnessda:stat             통계 분석 · 가설 검정
harnessda:report           최종 마크다운 보고서
harnessda:help             스킬 목록 보기
```
```

- [ ] **Step 3: work-tracker.md 갱신**

현재 상태를 v3 기준으로 업데이트. 최근 변경에 v3 구조 재설계 기록 추가.

- [ ] **Step 4: 커밋**

```bash
git add CLAUDE.md README.md docs/work-tracker.md
git commit -m "docs: CLAUDE.md, README.md, work-tracker.md v3 구조 반영

- init 스킬 추가, tracker/PPT 제거
- harnessda/ 프로젝트 구조 문서화
- 스킬 목록 및 사용법 갱신

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```
