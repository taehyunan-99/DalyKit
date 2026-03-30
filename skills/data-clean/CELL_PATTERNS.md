# 파일 생성 패턴

`harnessda:clean` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 처리는 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 전처리 데이터는 cleaned/ 폴더에 CSV로 저장.

## 생성 파일

```
프로젝트/                        ← 프로젝트 루트
├── clean_pipeline.py            ← 전처리 스크립트 (Write 도구로 생성)
├── clean_results.json           ← 처리 결과 요약 (Bash로 실행)
└── data/
    └── cleaned/
        └── 파일명_cleaned.csv   ← 전처리 완료 데이터
```

## 워크플로우

```
1. Write 도구 → clean_pipeline.py 생성
2. Bash 도구 → python clean_pipeline.py 실행
3. 완료 → clean_results.json + data/cleaned/*.csv 저장됨
```

> 결과 활용: `harnessda:clean report` → JSON 읽어 `docs/preprocessing_report.md` 생성

## clean_pipeline.py 구조

```python
import os
import json
import pandas as pd
import numpy as np

# 데이터 로드
DATA_PATH = '데이터_경로.csv'  # 실제 경로로 대체
df = pd.read_csv(DATA_PATH)
df_clean = df.copy()  # 원본 보존

results = {
    'before': {'shape': list(df.shape), 'missing': int(df.isnull().sum().sum()), 'duplicates': int(df.duplicated().sum())},
    'steps': []
}

# 1. 중복 제거
dup_count = df_clean.duplicated().sum()
if dup_count > 0:
    df_clean = df_clean.drop_duplicates()
    results['steps'].append({'step': '중복 제거', 'removed': int(dup_count)})

# 2. 결측값 처리 (전략은 EDA 결과 기반으로 조정)
# 수치형 — 중앙값 대체
num_cols = df_clean.select_dtypes(include=np.number).columns
for col in num_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].median())
        results['steps'].append({'step': f'{col} 결측값 중앙값 대체', 'count': int(n_missing)})

# 범주형 — 최빈값 대체
cat_cols = df_clean.select_dtypes(include='object').columns
for col in cat_cols:
    n_missing = df_clean[col].isnull().sum()
    if n_missing > 0:
        df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])
        results['steps'].append({'step': f'{col} 결측값 최빈값 대체', 'count': int(n_missing)})

# 3. 이상치 탐지 (제거 안 함 — 사용자 판단)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile(0.25), series.quantile(0.75)
    IQR = Q3 - Q1
    return ((series < Q1 - 1.5 * IQR) | (series > Q3 + 1.5 * IQR)).sum()

results['outliers'] = {col: int(detect_outliers_iqr(df_clean[col].dropna())) for col in num_cols}

# 4. 전처리 후 요약
results['after'] = {'shape': list(df_clean.shape), 'missing': int(df_clean.isnull().sum().sum())}

# 저장
os.makedirs('data/cleaned', exist_ok=True)
output_path = f"data/cleaned/{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv"
df_clean.to_csv(output_path, index=False)
results['output_path'] = output_path

with open('clean_results.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"전처리 완료: {df.shape} → {df_clean.shape}")
print(f"데이터 저장: {output_path}")
print(f"결과 저장: clean_results.json")
```
