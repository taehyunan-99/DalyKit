---
name: data-clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  코드를 노트북 셀에 생성한다.
  트리거: "harnessda:clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

주피터 노트북(.ipynb)에 전처리 코드 셀을 NotebookEdit로 직접 작성한다.

## 사용법

```
harnessda:clean [데이터 경로]
harnessda:clean              ← 현재 노트북의 df 변수 사용
harnessda:clean data.csv     ← 특정 파일 지정
harnessda:clean report       ← 전처리 보고서 생성 (셀 실행 후 사용)
```

## 노트북 구조

전처리는 EDA 노트북과 **별도 노트북**으로 분리한다.
```
project/
├── 01_eda.ipynb            ← EDA 노트북
├── 02_preprocessing.ipynb  ← 전처리 노트북 (이 스킬이 생성)
├── 03_modeling.ipynb       ← (이후 단계)
├── data/                   ← 원본 데이터
├── data/cleaned/           ← 전처리 완료 데이터
└── docs/                   ← EDA 보고서 등
```

- 파일명은 `NN_단계명.ipynb` 형태 (예: `02_preprocessing.ipynb`, `02_clean_apt.ipynb`)
- 기존 EDA 노트북이 `eda_apt.ipynb`처럼 번호 없이 되어 있으면 그 패턴을 따른다 (예: `clean_apt.ipynb`)
- EDA 결과 df를 직접 넘기지 않고, **원본 CSV를 다시 로드**하여 전처리 파이프라인을 독립 실행 가능하게 한다

## 워크플로우

### 1단계: 현재 상태 파악
- 작업 디렉토리에 `docs/eda_report.md`가 있으면 Read로 읽고, 결측값·이상치·타입 이슈를 파악하여 전처리 전략에 반영
- `docs/eda_report.md`가 없으면 기존 EDA 셀 출력을 참조하거나, 간단한 프로파일링 먼저 수행 (결측값, dtypes, 중복 수 확인)
- 사용자에게 전처리 방향 확인 (자동/수동 선택)

### 2단계: 전처리 전략 제안
발견된 이슈를 기반으로 처리 방법을 텍스트로 제안:
- 결측값: drop vs impute (평균/중앙값/최빈값/보간)
- 중복: 제거 여부
- 이상치: IQR vs Z-score vs 유지
- 타입 변환: object → datetime, numeric, category 등

### 3단계: 노트북 셀 생성 (NotebookEdit)

**셀 1 — 라이브러리 import + 작업 디렉토리 설정 + 데이터 로드**
```python
import os
import pandas as pd
import numpy as np

# 작업 디렉토리 설정 (노트북 기준 상대경로)
DATA_DIR = '../data'
os.chdir(DATA_DIR)
print(f"작업 디렉토리: {os.getcwd()}")

# 원본 데이터 로드
df = pd.read_csv('파일명.csv')
print(f"데이터 로드 완료: {df.shape[0]}행 × {df.shape[1]}열")
```

**셀 2 — 전처리 전 상태 확인**
```python
# 전처리 전 상태
print(f"원본 데이터: {df.shape[0]}행 × {df.shape[1]}열")
print(f"결측값 총 수: {df.isnull().sum().sum()}")
print(f"중복 행 수: {df.duplicated().sum()}")
```

**셀 3 — 결측값 처리**
```python
# 원본 보존 후 전처리 시작
df_clean = df.copy()

# 결측값 처리
# 전략: [상황에 따라 선택]

# 방법 1: 결측률 높은 컬럼 제거 (50% 이상)
drop_cols = [col for col in df_clean.columns if df_clean[col].isnull().mean() > 0.5]
if drop_cols:
    print(f"제거할 컬럼 (결측률 > 50%): {drop_cols}")
    df_clean = df_clean.drop(columns=drop_cols)

# 방법 2: 수치형 — 중앙값 대체
num_cols = df_clean.select_dtypes(include=np.number).columns
for col in num_cols:
    if df_clean[col].isnull().sum() > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].median())

# 방법 3: 범주형 — 최빈값 대체
cat_cols = df_clean.select_dtypes(include='object').columns
for col in cat_cols:
    if df_clean[col].isnull().sum() > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])

print(f"결측값 처리 후: {df_clean.isnull().sum().sum()}개 남음")
```

**셀 4 — 중복 제거**
```python
# 중복 행 제거
dup_count = df_clean.duplicated().sum()
if dup_count > 0:
    df_clean = df_clean.drop_duplicates()
    print(f"중복 {dup_count}행 제거 → {df_clean.shape[0]}행")
else:
    print("중복 행 없음")
```

**셀 5 — 이상치 처리 (필요 시)**
```python
# 이상치 탐지 (IQR 방식)
def detect_outliers_iqr(series):
    Q1 = series.quantile(0.25)
    Q3 = series.quantile(0.75)
    IQR = Q3 - Q1
    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR
    return (series < lower) | (series > upper)

num_cols = df_clean.select_dtypes(include=np.number).columns
outlier_info = {}
for col in num_cols:
    mask = detect_outliers_iqr(df_clean[col].dropna())
    outlier_info[col] = mask.sum()

outlier_df = pd.Series(outlier_info).sort_values(ascending=False)
print("=== 이상치 수 (IQR) ===")
print(outlier_df[outlier_df > 0])
```

**셀 6 — 타입 변환 (필요 시)**
```python
# 타입 변환
# 날짜형 변환 예시
# df_clean['date_col'] = pd.to_datetime(df_clean['date_col'])

# 범주형 변환 예시
# df_clean['cat_col'] = df_clean['cat_col'].astype('category')

print("=== 최종 dtypes ===")
print(df_clean.dtypes)
```

**셀 7 — 전처리 결과 요약 + 저장**
```python
# 전처리 완료 요약
print(f"원본 데이터: {df.shape[0]}행 × {df.shape[1]}열")
print(f"전처리 후:  {df_clean.shape[0]}행 × {df_clean.shape[1]}열")
print(f"결측값: {df_clean.isnull().sum().sum()}")
print(f"메모리 사용: {df_clean.memory_usage(deep=True).sum() / 1024**2:.1f} MB")

# 전처리 데이터 저장
os.makedirs('cleaned', exist_ok=True)
df_clean.to_csv('cleaned/파일명_cleaned.csv', index=False)
print(f"저장 완료: cleaned/파일명_cleaned.csv")
```

### 4단계: 전처리 보고서 (`harnessda:clean report`)

**`harnessda:clean report`가 호출되면** 실행한다 (셀 생성과 동시에 자동 실행하지 않음).

사용자가 노트북 셀을 모두 실행한 후 `harnessda:clean report`를 호출하면:
1. 노트북의 셀 출력 결과를 읽고 분석
2. 전처리 보고서를 작성하여 `docs/preprocessing_report.md`에 저장 (`docs/` 폴더 없으면 생성)
3. 보고서 구조와 작성 규칙은 **PREPROCESSING_REPORT.md**를 참조

## 코드 생성 규칙

1. **상황 적응**: EDA 결과를 바탕으로 필요한 셀만 생성 (결측값 없으면 해당 셀 스킵)
2. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
3. **비파괴적**: 원본 데이터 보존을 위해 `df_clean = df.copy()`로 시작하거나, 사용자에게 확인
4. **단계별 출력**: 각 셀에서 처리 결과를 간단히 출력 (몇 건 처리됨 등)
5. **이상치**: 자동 제거하지 않고 탐지만 → 사용자에게 판단 요청
6. **저장**: 전처리 완료 후 `df.to_csv('cleaned_data.csv', index=False)` 셀 제안
