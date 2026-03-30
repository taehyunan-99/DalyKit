# 파일 생성 패턴

`harnessda:eda` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 분석은 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 노트북은 생성하지 않는다.

## 생성 파일

```
프로젝트/                        ← 프로젝트 루트 (노트북과 같은 디렉토리)
├── eda_analysis.py              ← 분석 스크립트 (Write 도구로 생성)
├── eda_results.json             ← 스크립트 실행 결과 (Bash로 실행)
└── docs/
    └── eda_report.md            ← harnessda:eda report로 생성
```

## 워크플로우

```
1. Write 도구 → eda_analysis.py 생성
2. Bash 도구 → python eda_analysis.py 실행
3. 완료 → eda_results.json 저장됨
```

> 결과 활용: `harnessda:eda report` → JSON 읽어 `docs/eda_report.md` 생성
> 시각화: `viz/charts/` 하위에서 적합한 차트 파일을 Read로 읽고 패턴을 따른다

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

# 데이터 로드
DATA_PATH = '데이터_경로.csv'  # 실제 경로로 대체
df = pd.read_csv(DATA_PATH)

results = {}

# 1. 기본 정보
results['shape'] = list(df.shape)
results['dtypes'] = df.dtypes.astype(str).to_dict()
results['columns'] = list(df.columns)

# 2. 결측값 분석
missing = df.isnull().sum()
results['missing'] = {
    col: {'count': int(missing[col]), 'pct': round(missing[col] / len(df) * 100, 2)}
    for col in df.columns if missing[col] > 0
}

# 3. 기술통계
results['describe'] = df.describe().round(4).to_dict()

# 4. 범주형 분포
cat_cols = df.select_dtypes(include='object').columns.tolist()
results['categorical'] = {}
for col in cat_cols:
    results['categorical'][col] = {
        'nunique': int(df[col].nunique()),
        'top10': df[col].value_counts().head(10).to_dict()
    }

# 5. 수치형 상관관계
num_cols = df.select_dtypes(include=np.number).columns.tolist()
if len(num_cols) >= 2:
    results['correlation'] = df[num_cols].corr().round(4).to_dict()

# 6. 중복 행
results['duplicates'] = int(df.duplicated().sum())

# 결과 저장
with open('eda_results.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print(f"EDA 완료: {df.shape[0]}행 × {df.shape[1]}열")
print(f"결과 저장: eda_results.json")
```

> 시각화 차트는 별도 셀 또는 스크립트에서 `viz/charts/` 패턴을 참조하여 생성
