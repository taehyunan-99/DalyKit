# 전처리 노트북 셀 패턴

`dalykit:clean` 스킬이 생성하는 ipynb 구조.

## 생성 파일

```
dalykit/
├── code/
│   ├── notebooks/
│   │   └── clean_pipeline.ipynb     ← 전처리 노트북 (Write 도구로 생성)
│   └── results/
│       └── clean_results.json       ← 셀 실행 시 자동 저장 (report용)
└── data/
    └── 파일명_cleaned.csv           ← 전처리 완료 데이터 (셀 실행 시 저장)
```

## 워크플로우

```
1. Write 도구 → dalykit/code/notebooks/clean_pipeline.ipynb 생성 (nbformat 4)
2. 사용자가 노트북을 열어 전체 셀 실행
3. dalykit/data/ 에 결과 CSV 저장 + dalykit/code/results/clean_results.json 자동 생성
4. dalykit:clean report 호출 → JSON 기반 보고서 생성
```

## ipynb 셀 구조

```python
# 셀 1: 라이브러리 임포트 + save_stats 헬퍼 (code cell)
import os
import json
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
RESULTS_DIR = os.path.join(BASE_DIR, 'code', 'results')
os.makedirs(RESULTS_DIR, exist_ok=True)
STATS_PATH  = os.path.join(RESULTS_DIR, 'clean_results.json')

# JSON 직렬화 헬퍼 (NaN/Inf/numpy 타입 처리)
class _StatsEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, (np.bool_,)): return bool(obj)
        if isinstance(obj, (np.integer,)): return int(obj)
        if isinstance(obj, (np.floating,)):
            if np.isnan(obj): return None
            if np.isinf(obj): return str(obj)
            return float(obj)
        if isinstance(obj, (np.ndarray,)): return obj.tolist()
        if hasattr(obj, 'isoformat'): return obj.isoformat()
        return super().default(obj)

def save_stats(key, data):
    """결과를 JSON에 키별로 누적 저장 (셀 재실행 시 해당 키만 갱신)"""
    existing = {}
    if os.path.exists(STATS_PATH):
        with open(STATS_PATH, 'r', encoding='utf-8') as f:
            existing = json.load(f)
    existing[key] = data
    with open(STATS_PATH, 'w', encoding='utf-8') as f:
        json.dump(existing, f, ensure_ascii=False, indent=2, cls=_StatsEncoder)


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

save_stats('before', {
    'shape': list(df.shape),
    'missing_total': int(df.isnull().sum().sum()),
    'duplicates': int(df.duplicated().sum()),
    'dtypes': df.dtypes.value_counts().to_dict()
})

# 셀 4: 중복 제거 (code cell)
dup_count = df_clean.duplicated().sum()
print(f"중복 행 수: {dup_count}")
if dup_count > 0:
    df_clean = df_clean.drop_duplicates()
    print(f"중복 제거 후: {df_clean.shape}")

save_stats('duplicates_removed', int(dup_count))

# 셀 5: 결측값 처리 (code cell)
# 결측 비율에 따라 전략 자동 선택:
#   > 50%  → 열 제거 권고 (사용자 확인 후 처리)
#   5~50%  → 그룹별 중앙값 대체 (domain.md 타겟 컬럼 기준) → fallback: 단순 중앙값
#   < 5%   → 단순 중앙값/최빈값 대체
#   복잡한 패턴 → IterativeImputer (회귀 대체) 별도 셀 제공

from sklearn.experimental import enable_iterative_imputer  # noqa
from sklearn.impute import IterativeImputer

num_cols = df_clean.select_dtypes(include=np.number).columns
cat_cols = df_clean.select_dtypes(include='object').columns
n_rows = len(df_clean)

# 타겟 컬럼 (domain.md 기반 — 없으면 None)
GROUP_COL = None  # domain.md에서 타겟 컬럼 확인 후 지정

high_missing = []  # 제거 권고 컬럼
missing_handled = {}  # 처리 내역 기록

for col in df_clean.columns:
    n_missing = df_clean[col].isnull().sum()
    if n_missing == 0:
        continue
    ratio = n_missing / n_rows

    if ratio > 0.5:
        # 결측 50% 초과 → 제거 권고
        high_missing.append({'col': col, 'pct': round(ratio * 100, 1)})

    elif ratio >= 0.05:
        if col in num_cols:
            if GROUP_COL and GROUP_COL in df_clean.columns:
                # 그룹별 중앙값 대체
                df_clean[col] = df_clean.groupby(GROUP_COL)[col].transform(
                    lambda x: x.fillna(x.median())
                )
                # 그룹 내 전체 결측 시 전체 중앙값으로 fallback
                df_clean[col] = df_clean[col].fillna(df_clean[col].median())
                method = '그룹별 중앙값 대체'
            else:
                df_clean[col] = df_clean[col].fillna(df_clean[col].median())
                method = '중앙값 대체'
            print(f"{col}: {n_missing}개 결측값 → {method}")
        elif col in cat_cols:
            df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])
            method = '최빈값 대체'
            print(f"{col}: {n_missing}개 결측값 → {method}")
        missing_handled[col] = {'count': int(n_missing), 'method': method, 'ratio': round(ratio, 4)}

    else:
        if col in num_cols:
            df_clean[col] = df_clean[col].fillna(df_clean[col].median())
            method = '중앙값 대체'
            print(f"{col}: {n_missing}개 결측값 → {method} (결측 {ratio*100:.1f}%)")
        elif col in cat_cols:
            df_clean[col] = df_clean[col].fillna(df_clean[col].mode()[0])
            method = '최빈값 대체'
            print(f"{col}: {n_missing}개 결측값 → {method} (결측 {ratio*100:.1f}%)")
        missing_handled[col] = {'count': int(n_missing), 'method': method, 'ratio': round(ratio, 4)}

if high_missing:
    print("\n⚠️  결측 50% 초과 컬럼 — 제거를 권고합니다:")
    for item in high_missing:
        print(f"  {item['col']}: {item['pct']}%")
    print("  → 제거하려면: df_clean.drop(columns=[컬럼명], inplace=True)")

save_stats('missing_handled', missing_handled)
save_stats('high_missing_cols', high_missing)

# 셀 5-1: IterativeImputer (선택 — 복잡한 결측 패턴 시 사용) (code cell)
# 수치형 컬럼에 회귀 기반 대체 적용. 실행 시간이 길 수 있음.
# imputer = IterativeImputer(max_iter=10, random_state=42)
# df_clean[num_cols] = imputer.fit_transform(df_clean[num_cols])
# print("IterativeImputer 적용 완료")

# 셀 6: 이상치 탐지 (제거 안 함 — 사용자 판단) (code cell)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile(0.25), series.quantile(0.75)
    IQR = Q3 - Q1
    lower, upper = Q1 - 1.5 * IQR, Q3 + 1.5 * IQR
    count = int(((series < lower) | (series > upper)).sum())
    return {'count': count, 'lower': round(lower, 4), 'upper': round(upper, 4)}

outlier_info = {col: detect_outliers_iqr(df_clean[col].dropna()) for col in num_cols}
print("=== 이상치 탐지 결과 (IQR 기준) ===")
result = pd.DataFrame(outlier_info).T
result.index.name = '컬럼'
result[result['count'] > 0].sort_values('count', ascending=False)

save_stats('outliers_detected', {
    col: {**info, 'action': '유지'} for col, info in outlier_info.items()
})

# 셀 6-1: 이상치 처리 옵션 (선택 — 보고서 확인 후 주석 해제) (code cell)
# 옵션 1: IQR 기준 제거
# target_cols = ['컬럼명']  # 처리할 컬럼 지정
# for col in target_cols:
#     info = outlier_info[col]
#     before = len(df_clean)
#     df_clean = df_clean[(df_clean[col] >= info['lower']) & (df_clean[col] <= info['upper'])]
#     print(f"{col}: {before - len(df_clean)}행 제거 ({before} → {len(df_clean)})")

# 옵션 2: 상한/하한 클리핑 (행 제거 없이 경계값으로 대체)
# target_cols = ['컬럼명']  # 처리할 컬럼 지정
# for col in target_cols:
#     info = outlier_info[col]
#     df_clean[col] = df_clean[col].clip(lower=info['lower'], upper=info['upper'])
#     print(f"{col}: 클리핑 완료 ({info['lower']} ~ {info['upper']})")

# 셀 7: 타입 변환 (필요 시 수정) (code cell)
# 예시: df_clean['날짜컬럼'] = pd.to_datetime(df_clean['날짜컬럼'])
# 예시: df_clean['범주컬럼'] = df_clean['범주컬럼'].astype('category')
# save_stats('type_conversions', [{'column': '컬럼명', 'from': 'object', 'to': 'datetime64'}])

# 셀 8: 전처리 후 요약 (code cell)
print("=== 전처리 결과 ===")
print(f"원본: {df.shape} → 처리 후: {df_clean.shape}")
print(f"잔여 결측값: {df_clean.isnull().sum().sum()}")

save_stats('after', {
    'shape': list(df_clean.shape),
    'missing_total': int(df_clean.isnull().sum().sum()),
    'describe': df_clean.describe(include='all').T.to_dict()
})

df_clean.describe()

# 셀 9: 저장 (code cell)
output_path = os.path.join(DATA_DIR, f"{os.path.splitext(os.path.basename(DATA_PATH))[0]}_cleaned.csv")
df_clean.to_csv(output_path, index=False)
print(f"저장 완료: {output_path}")

save_stats('output_path', output_path)
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

## JSON 키-셀 매핑

| JSON 키 | 셀 | 저장 데이터 |
|---------|-----|-----------|
| `before` | 셀 3 | shape, missing_total, duplicates, dtypes |
| `duplicates_removed` | 셀 4 | 제거된 중복 수 |
| `missing_handled` | 셀 5 | 컬럼별 결측 수/처리 방법/비율 |
| `high_missing_cols` | 셀 5 | 결측 50% 초과 컬럼 목록 |
| `outliers_detected` | 셀 6 | 컬럼별 이상치 수/경계값/처리 여부 |
| `type_conversions` | 셀 7 | 타입 변환 내역 (사용자 활성화 시) |
| `after` | 셀 8 | shape, missing_total, describe |
| `output_path` | 셀 9 | 저장된 CSV 경로 |
