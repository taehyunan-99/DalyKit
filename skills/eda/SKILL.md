---
name: eda
description: >
  탐색적 데이터 분석(EDA) 자동화. 노트북에 EDA 코드 셀을 생성하여
  데이터의 구조, 품질, 분포, 상관관계를 파악한다.
  트리거: "/eda", "EDA 해줘", "데이터 탐색", "explore this data",
  "데이터 분석 시작", "what does this data look like".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

주피터 노트북(.ipynb)에 EDA 코드 셀을 NotebookEdit로 직접 작성한다.

## 사용법

```
/eda [데이터 경로]
/eda                    ← 현재 디렉토리의 CSV 자동 탐색
/eda data.csv           ← 특정 파일 지정
/eda df                 ← 노트북 내 기존 DataFrame 변수 사용
/eda domain             ← 현재 디렉토리에 domain.md 템플릿 생성
/eda report             ← EDA 보고서 생성 (셀 실행 후 사용)
```

## 도메인 컨텍스트 (`domain.md`)

- `/eda domain` 실행 시: DOMAIN_TEMPLATE.md를 현재 작업 디렉토리에 `domain.md`로 복사 생성
- EDA 실행 시: 현재 디렉토리에 `domain.md`가 있으면 자동으로 읽고 도메인 맥락을 반영하여 분석
- `domain.md`가 없으면: 일반적인 통계 기준으로 분석 (기존과 동일)

## 워크플로우

### 1단계: 데이터 파악
- 사용자가 경로를 제공하면 해당 파일 사용
- 경로 미제공 시: Glob으로 현재 디렉토리의 CSV/Excel 파일 탐색 → 사용자에게 선택 요청
- 기존 노트북이 없으면 새 .ipynb 생성, 있으면 기존 노트북에 셀 추가
- **현재 디렉토리에 `domain.md`가 있으면 읽고, 이후 모든 분석·판단·보고서에 도메인 맥락을 반영**

### 2단계: 노트북 셀 생성 (NotebookEdit)

**셀 1 — 라이브러리 import + 작업 디렉토리 설정 + 데이터 로드**
```python
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# 작업 디렉토리 설정 (노트북 기준 상대경로)
DATA_DIR = '../data'
os.chdir(DATA_DIR)
print(f"작업 디렉토리: {os.getcwd()}")

# 한국어 폰트 설정
import platform
if platform.system() == 'Darwin':
    plt.rcParams['font.family'] = 'AppleGothic'
else:
    plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['font.size'] = 8
plt.rcParams['font.weight'] = 'bold'
plt.rcParams['legend.loc'] = 'upper center'

df = pd.read_csv('파일명.csv')  # os.chdir 후 파일명만으로 로드
print(f"데이터 로드 완료: {df.shape[0]}행 × {df.shape[1]}열")
```

**셀 2 — 기본 정보**
```python
# 데이터 구조 확인
print("=== Shape ===")
print(df.shape)
print("\n=== Dtypes ===")
print(df.dtypes)
print("\n=== 처음 5행 ===")
df.head()
```

**셀 3 — 결측값 분석**
```python
# 결측값 현황
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
missing_df = pd.DataFrame({'결측수': missing, '결측률(%)': missing_pct})
missing_df[missing_df['결측수'] > 0].sort_values('결측률(%)', ascending=False)
```

**셀 4 — 기술통계**
```python
# 수치형 기술통계
df.describe()
```

```python
# 범주형 기술통계 (범주형 컬럼이 있는 경우)
cat_cols = df.select_dtypes(include='object').columns
if len(cat_cols) > 0:
    for col in cat_cols:
        print(f"\n=== {col} (unique: {df[col].nunique()}) ===")
        print(df[col].value_counts().head(10))
```

**셀 5 — 상관관계**
```python
# 수치형 변수 상관관계 (우상단 마스킹 + 간격 구분)
num_cols = df.select_dtypes(include=np.number).columns
if len(num_cols) >= 2:
    corr = df[num_cols].corr()
    mask = np.triu(np.ones_like(corr, dtype=bool), k=1)

    fig, ax = plt.subplots(figsize=(10, 8))
    sns.heatmap(corr, mask=mask, cmap='RdYlBu', annot=True, fmt='.2f',
                annot_kws={'fontweight': 'bold', 'fontsize': 8},
                linewidth=1, ax=ax)
    ax.set_title('상관관계 히트맵', fontdict={'fontweight': 'bold'})
    plt.tight_layout()
    plt.show()
```

**셀 6 — 분포 시각화**
```python
# 수치형 변수 분포 (개별 출력)
num_cols = df.select_dtypes(include=np.number).columns
for col in num_cols:
    fig, ax = plt.subplots(figsize=(10, 4))
    sns.histplot(df[col].dropna(), kde=True, ax=ax)
    ax.set_title(col, fontdict={'fontweight': 'bold'})
    plt.tight_layout()
    plt.show()
```

**셀 7 — 박스플롯 (이상치 확인)**
```python
# 수치형 변수 박스플롯 (개별 출력)
num_cols = df.select_dtypes(include=np.number).columns
for col in num_cols:
    fig, ax = plt.subplots(figsize=(10, 3))
    sns.boxplot(data=df, x=col, ax=ax)
    ax.set_title(f'{col} — 이상치 확인', fontdict={'fontweight': 'bold'})
    plt.tight_layout()
    plt.show()
```

### 3단계: EDA 보고서 (`/eda report`)

**`/eda report`가 호출되면** 실행한다 (셀 생성과 동시에 자동 실행하지 않음).

사용자가 노트북 셀을 모두 실행한 후 `/eda report`를 호출하면:
1. 노트북의 셀 출력 결과를 읽고 분석
2. EDA 보고서를 작성하여 `docs/eda_report.md`에 저장 (`docs/` 폴더 없으면 생성)
3. 보고서 구조와 작성 규칙은 **EDA_REPORT.md**를 참조

## 코드 생성 규칙

1. **주석은 한국어**로 작성
2. **출력 제한**: `df.head()`, `.describe()`, `.value_counts().head(10)` 등 요약만
3. **대용량 처리**: 1000행 이상이면 `.sample(1000)`이나 요약 통계만 시각화
4. **셀 분리**: 각 분석 단계를 별도 셀로 분리
5. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
6. **시각화 크기**: `figsize`를 적절히 설정하여 가독성 확보
7. **기존 노트북**: 이미 import 셀이 있으면 중복 생성하지 않음
8. **변수명**: 데이터프레임은 `df` 사용 (사용자가 다른 이름 지정 시 따름)

## 색상 규칙 (필수)

- **기본 톤**: 무채색 베이스 (`#D9D9D9` 연회색, `#808080` 중회색, `#333333` 진회색)
- **포인트 컬러**: 강조할 데이터에만 색상 사용, **최대 3색 이내**
- **비교 시**: 대비되는 보색 쌍 사용 — `skyblue` vs `orange`, `steelblue` vs `coral` 등
- **단일 분포**: 무채색(`gray`, `#BDBDBD`) 또는 포인트 1색
- **히트맵**: 발산형 팔레트(`RdYlBu`) 허용 (상관계수 특성상 예외)
- **불필요한 색 남발 금지**: 범주가 많아도 핵심 항목만 색상, 나머지는 회색

## 대용량 데이터 (1000행 이상) 특별 규칙

데이터가 1000행 이상일 때:
- 전체 데이터 출력 코드 생성 금지
- 시각화는 `.sample(n)` 또는 집계 결과만 사용
- 연산이 무거운 경우 (상관관계 등) 별도 .py 스크립트 생성 → 결과 JSON/CSV 저장 → 노트북에서 로드
