---
name: data-clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  코드를 노트북 셀에 생성한다.
  트리거: "/data-clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

주피터 노트북(.ipynb)에 전처리 코드 셀을 NotebookEdit로 직접 작성한다.

## 사용법

```
/data-clean [데이터 경로]
/data-clean              ← 현재 노트북의 df 변수 사용
/data-clean data.csv     ← 특정 파일 지정
```

## 워크플로우

### 1단계: 현재 상태 파악
- 기존 EDA 셀 출력이 있으면 참조하여 전처리 전략 결정
- EDA가 없으면 간단한 프로파일링 먼저 수행 (결측값, dtypes, 중복 수 확인)
- 사용자에게 전처리 방향 확인 (자동/수동 선택)

### 2단계: 전처리 전략 제안
발견된 이슈를 기반으로 처리 방법을 텍스트로 제안:
- 결측값: drop vs impute (평균/중앙값/최빈값/보간)
- 중복: 제거 여부
- 이상치: IQR vs Z-score vs 유지
- 타입 변환: object → datetime, numeric, category 등

### 3단계: 노트북 셀 생성 (NotebookEdit)

**셀 1 — 전처리 전 상태 확인**
```python
# 전처리 전 상태
print(f"원본 데이터: {df.shape[0]}행 × {df.shape[1]}열")
print(f"결측값 총 수: {df.isnull().sum().sum()}")
print(f"중복 행 수: {df.duplicated().sum()}")
```

**셀 2 — 결측값 처리**
```python
# 결측값 처리
# 전략: [상황에 따라 선택]

# 방법 1: 결측률 높은 컬럼 제거 (50% 이상)
drop_cols = [col for col in df.columns if df[col].isnull().mean() > 0.5]
if drop_cols:
    print(f"제거할 컬럼 (결측률 > 50%): {drop_cols}")
    df = df.drop(columns=drop_cols)

# 방법 2: 수치형 — 중앙값 대체
num_cols = df.select_dtypes(include=np.number).columns
for col in num_cols:
    if df[col].isnull().sum() > 0:
        df[col] = df[col].fillna(df[col].median())

# 방법 3: 범주형 — 최빈값 대체
cat_cols = df.select_dtypes(include='object').columns
for col in cat_cols:
    if df[col].isnull().sum() > 0:
        df[col] = df[col].fillna(df[col].mode()[0])

print(f"결측값 처리 후: {df.isnull().sum().sum()}개 남음")
```

**셀 3 — 중복 제거**
```python
# 중복 행 제거
dup_count = df.duplicated().sum()
if dup_count > 0:
    df = df.drop_duplicates()
    print(f"중복 {dup_count}행 제거 → {df.shape[0]}행")
else:
    print("중복 행 없음")
```

**셀 4 — 이상치 처리 (필요 시)**
```python
# 이상치 탐지 (IQR 방식)
def detect_outliers_iqr(series):
    Q1 = series.quantile(0.25)
    Q3 = series.quantile(0.75)
    IQR = Q3 - Q1
    lower = Q1 - 1.5 * IQR
    upper = Q3 + 1.5 * IQR
    return (series < lower) | (series > upper)

num_cols = df.select_dtypes(include=np.number).columns
outlier_info = {}
for col in num_cols:
    mask = detect_outliers_iqr(df[col].dropna())
    outlier_info[col] = mask.sum()

outlier_df = pd.Series(outlier_info).sort_values(ascending=False)
print("=== 이상치 수 (IQR) ===")
print(outlier_df[outlier_df > 0])
```

**셀 5 — 타입 변환 (필요 시)**
```python
# 타입 변환
# 날짜형 변환 예시
# df['date_col'] = pd.to_datetime(df['date_col'])

# 범주형 변환 예시
# df['cat_col'] = df['cat_col'].astype('category')

print("=== 최종 dtypes ===")
print(df.dtypes)
```

**셀 6 — 전처리 결과 요약**
```python
# 전처리 완료 요약
print(f"최종 데이터: {df.shape[0]}행 × {df.shape[1]}열")
print(f"결측값: {df.isnull().sum().sum()}")
print(f"메모리 사용: {df.memory_usage(deep=True).sum() / 1024**2:.1f} MB")
```

### 4단계: 결과 요약
- 전처리 전후 비교 (행/열 수, 결측값 수)
- 적용된 처리 방법 목록
- 다음 단계 추천 (시각화, 통계 분석 등)

## 코드 생성 규칙

1. **상황 적응**: EDA 결과를 바탕으로 필요한 셀만 생성 (결측값 없으면 해당 셀 스킵)
2. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
3. **비파괴적**: 원본 데이터 보존을 위해 `df_clean = df.copy()`로 시작하거나, 사용자에게 확인
4. **단계별 출력**: 각 셀에서 처리 결과를 간단히 출력 (몇 건 처리됨 등)
5. **이상치**: 자동 제거하지 않고 탐지만 → 사용자에게 판단 요청
6. **저장**: 전처리 완료 후 `df.to_csv('cleaned_data.csv', index=False)` 셀 제안
