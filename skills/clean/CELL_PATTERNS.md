# 전처리 노트북 셀 패턴

`dalykit:clean` 스킬이 생성하는 ipynb 구조.

## 생성 파일

```
dalykit/
├── code/
│   └── clean_pipeline.ipynb     ← 전처리 노트북 (Write 도구로 생성)
└── data/
    └── cleaned/
        └── 파일명_cleaned.csv   ← 전처리 완료 데이터 (셀 실행 시 저장)
```

## 워크플로우

```
1. Write 도구 → dalykit/code/clean_pipeline.ipynb 생성 (nbformat 4)
2. 사용자가 노트북을 열어 전체 셀 실행
3. dalykit/data/ 에 결과 CSV 저장 확인
4. dalykit:report 호출 → 보고서 생성
```

## ipynb 셀 구조

```python
# 셀 1: 라이브러리 임포트 (code cell)
import os
import pandas as pd
import numpy as np

# 프로젝트 루트 탐색 (Jupyter 실행 위치와 무관하게 동작)
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


# 셀 2: 데이터 로드 (code cell)
DATA_PATH = os.path.join(DATA_DIR, '데이터_파일.csv')  # 실제 파일명으로 대체
df = pd.read_csv(DATA_PATH)
df_clean = df.copy()  # 원본 보존
print(f"원본: {df.shape[0]}행 × {df.shape[1]}열")
df.head()

# 셀 3: 전처리 전 현황 (code cell)
print("=== 결측값 ===")
print(df.isnull().sum())
print(f"\n중복 행: {df.duplicated().sum()}")
print(f"\n데이터 타입:\n{df.dtypes}")

# 셀 4: 중복 제거 (code cell)
dup_count = df_clean.duplicated().sum()
print(f"중복 행 수: {dup_count}")
if dup_count > 0:
    df_clean = df_clean.drop_duplicates()
    print(f"중복 제거 후: {df_clean.shape}")

# 셀 5: 결측값 처리 (code cell)
# 전략은 EDA 결과 및 도메인 지식 기반으로 조정
num_cols = df_clean.select_dtypes(include=np.number).columns
for col in num_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        # 중앙값 대체 (왜곡 분포에 안전)
        df_clean[col] = df_clean[col].fillna(df_clean[col].median())
        print(f"{col}: {n_missing}개 결측값 → 중앙값 대체")

cat_cols = df_clean.select_dtypes(include='object').columns
for col in cat_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        # 최빈값 대체
        df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])
        print(f"{col}: {n_missing}개 결측값 → 최빈값 대체")

# 셀 6: 이상치 탐지 (제거 안 함 — 사용자 판단) (code cell)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile(0.25), series.quantile(0.75)
    IQR = Q3 - Q1
    return int(((series < Q1 - 1.5 * IQR) | (series > Q3 + 1.5 * IQR)).sum())

outliers = {col: detect_outliers_iqr(df_clean[col].dropna()) for col in num_cols}
print("=== 이상치 탐지 결과 (IQR 기준) ===")
pd.Series(outliers, name='이상치 수').sort_values(ascending=False)

# 셀 7: 타입 변환 (필요 시 수정) (code cell)
# 예시: df_clean['날짜컬럼'] = pd.to_datetime(df_clean['날짜컬럼'])
# 예시: df_clean['범주컬럼'] = df_clean['범주컬럼'].astype('category')

# 셀 8: 전처리 후 요약 (code cell)
print("=== 전처리 결과 ===")
print(f"원본: {df.shape} → 처리 후: {df_clean.shape}")
print(f"잔여 결측값: {df_clean.isnull().sum().sum()}")
df_clean.describe()

# 셀 9: 저장 (code cell)
output_path = os.path.join(CLEANED_DIR, f"{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv")
df_clean.to_csv(output_path, index=False)
print(f"저장 완료: {output_path}")
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
      "source": ["# 데이터 전처리 파이프라인\n"],
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
