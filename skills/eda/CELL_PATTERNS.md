# EDA 노트북 셀 패턴

`dalykit:eda` 스킬이 생성하는 ipynb 구조.

## 생성 파일

```
dalykit/
├── code/
│   ├── notebooks/
│   │   └── eda_analysis.ipynb   ← EDA 노트북 (Write 도구로 생성)
│   └── results/
│       └── eda_results.json     ← 셀 실행 시 자동 저장 (report용)
└── figures/
    └── *.png                ← 시각화 이미지
```

## 워크플로우

```
1. Write 도구 → dalykit/code/notebooks/eda_analysis.ipynb 생성 (nbformat 4)
2. 사용자가 노트북을 열어 전체 셀 실행
3. dalykit/code/results/eda_results.json 자동 생성
4. dalykit:eda report 호출 → JSON 기반 보고서 생성
```

## ipynb 셀 구조

```python
# 셀 1: 라이브러리 임포트 + save_stats 헬퍼 (code cell)
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
FIGURES_DIR = os.path.join(BASE_DIR, 'figures')
RESULTS_DIR = os.path.join(BASE_DIR, 'code', 'results')
os.makedirs(RESULTS_DIR, exist_ok=True)
STATS_PATH  = os.path.join(RESULTS_DIR, 'eda_results.json')

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

# save_fig 헬퍼
def save_fig(filename):
    path = os.path.join(FIGURES_DIR, filename)
    plt.savefig(path, dpi=150, bbox_inches='tight')
    plt.close()
    return path

# 셀 2: 데이터 로드 (code cell)
DATA_PATH = os.path.join(DATA_DIR, '데이터_파일.csv')  # 실제 파일명으로 대체
df = pd.read_csv(DATA_PATH)
print(f"로드 완료: {df.shape[0]}행 × {df.shape[1]}열")

save_stats('data_info', {
    'path': DATA_PATH,
    'shape': list(df.shape),
    'dtypes': df.dtypes.value_counts().to_dict()
})

df.head()

# 셀 3: 기본 정보 (code cell)
print("=== 컬럼 정보 ===")
df.info()

# 셀 4: 기술통계 (code cell)
desc = df.describe(include='all').T
save_stats('describe', desc.to_dict())
desc

# 셀 5: 결측값 분석 (code cell)
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
missing_df = pd.DataFrame({'결측수': missing, '결측률(%)': missing_pct})
missing_with = missing_df[missing_df['결측수'] > 0].sort_values('결측률(%)', ascending=False)

save_stats('missing', {
    col: {'count': int(row['결측수']), 'percentage': float(row['결측률(%)'])}
    for col, row in missing_with.iterrows()
})

missing_with

# 셀 6: 중복 행 확인 (code cell)
dup_count = int(df.duplicated().sum())
print(f"중복 행 수: {dup_count}")

save_stats('duplicates', {
    'count': dup_count,
    'percentage': round(dup_count / len(df) * 100, 2)
})

# 셀 7: 범주형 변수 분포 (code cell)
cat_cols = df.select_dtypes(include='object').columns.tolist()
cat_stats = {}
for col in cat_cols:
    vc = df[col].value_counts().head(10)
    cat_stats[col] = {
        'nunique': int(df[col].nunique()),
        'top_values': vc.to_dict()
    }
    print(f"\n[{col}] nunique={df[col].nunique()}")
    print(vc)

save_stats('categorical', cat_stats)

# 셀 7-1: 범주형 변수 시각화 (code cell)
# ============================================================
# ⚠️ countplot 안티패턴 (사용 금지 — FutureWarning 발생)
# ❌ sns.countplot(data=df, x=col, palette=colors)          ← hue 없이 palette만 전달
# ❌ sns.countplot(data=df, x=col, hue=col, palette=colors) ← legend=False 누락
#
# ✅ 올바른 패턴 (반드시 이 형태 사용):
# sns.countplot(data=df, x=col, hue=col, order=order, palette=colors, legend=False, ax=ax)
# ============================================================
for col in cat_cols[:5]:  # 상위 5개만
    order = df[col].value_counts().index
    colors = ['#D9D9D9'] * len(order)
    colors[0] = 'skyblue'  # Top 1 강조
    fig, ax = plt.subplots(figsize=(10, 4))
    sns.countplot(data=df, x=col, hue=col, order=order, palette=colors, legend=False, ax=ax)
    ax.set_title(f'{col} 분포', fontdict={'fontweight': 'bold'})
    plt.xticks(rotation=45)
    plt.tight_layout()
    save_fig(f'cat_{col}.png')

# 셀 8: 수치형 변수 분포 시각화 (code cell)
num_cols = df.select_dtypes(include=np.number).columns.tolist()
for col in num_cols[:5]:  # 상위 5개만 (필요 시 조정)
    fig, ax = plt.subplots(figsize=(8, 4))
    sns.histplot(df[col].dropna(), kde=True, ax=ax)
    ax.set_title(f'{col} 분포')
    save_fig(f'dist_{col}.png')

# 셀 9: 상관관계 히트맵 (code cell)
if len(num_cols) >= 2:
    corr = df[num_cols].corr()

    # 전체 쌍 수집 (대각선 제외)
    all_pairs = []
    for i in range(len(num_cols)):
        for j in range(i + 1, len(num_cols)):
            r = corr.iloc[i, j]
            all_pairs.append({
                'var1': num_cols[i], 'var2': num_cols[j], 'r': round(float(r), 4)
            })

    # 절댓값 기준 내림차순 정렬
    all_pairs.sort(key=lambda x: abs(x['r']), reverse=True)
    max_r = all_pairs[0]['r'] if all_pairs else 0

    save_stats('correlation', {
        'top_pairs': all_pairs[:20],                                      # 상위 20쌍 항상 저장 (임계값 무관)
        'max_r': round(max_r, 4),                                         # 전체 최대 상관계수
        'strong_pairs': [p for p in all_pairs if abs(p['r']) > 0.3]      # |r| > 0.3 쌍
        # matrix는 저장 제외 — heatmap_corr.png 이미지로 대체 (토큰 절감)
    })

    mask = np.triu(np.ones_like(corr, dtype=bool), k=1)
    fig, ax = plt.subplots(figsize=(12, 10))
    sns.heatmap(corr, annot=True, fmt='.2f', cmap='RdYlBu',
                mask=mask, linewidths=1, linecolor='white', ax=ax)
    ax.set_title('상관관계 히트맵')
    save_fig('heatmap_corr.png')

# 셀 10: 이상치 탐지 (code cell)
def detect_outliers_iqr(series):
    Q1, Q3 = series.quantile(0.25), series.quantile(0.75)
    IQR = Q3 - Q1
    lower, upper = Q1 - 1.5 * IQR, Q3 + 1.5 * IQR
    count = int(((series < lower) | (series > upper)).sum())
    return {'count': count, 'lower': round(float(lower), 4), 'upper': round(float(upper), 4)}

outlier_stats = {col: detect_outliers_iqr(df[col].dropna()) for col in num_cols}

save_stats('outliers', outlier_stats)

pd.Series({col: v['count'] for col, v in outlier_stats.items()},
          name='이상치 수').sort_values(ascending=False)
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
      "source": ["# EDA — 탐색적 데이터 분석\n"],
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

## 시각화 저장 규칙

| 저장 대상 | 파일명 |
|-----------|--------|
| 타겟 변수 분포 | `dist_{target}.png` |
| 수치형 변수 분포 | `dist_{col}.png` |
| 상관관계 히트맵 | `heatmap_corr.png` |
| 결측값 히트맵 | `missing_heatmap.png` |
| 이상치 시각화 | `outlier_{col}.png` |

## JSON 키-셀 매핑

| JSON 키 | 셀 | 저장 데이터 |
|---------|-----|-----------|
| `data_info` | 셀 2 | path, shape, dtypes 요약 |
| `describe` | 셀 4 | `df.describe(include='all').T.to_dict()` |
| `missing` | 셀 5 | 결측 있는 컬럼별 결측수/결측률 |
| `duplicates` | 셀 6 | 중복 행 수/비율 |
| `categorical` | 셀 7 | 컬럼별 nunique + top 10 value_counts |
| `correlation` | 셀 9 | top_pairs(상위 20쌍), max_r(전체 최대), strong_pairs(\|r\| > 0.3) — matrix는 이미지로 대체 |
| `outliers` | 셀 10 | 컬럼별 이상치 수/IQR 경계값 |
