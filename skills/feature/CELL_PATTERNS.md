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
