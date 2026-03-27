---
name: stat-analysis
description: >
  통계 분석 및 가설 검정. 변수 척도를 파악하고, 귀무가설을 설정한 뒤,
  적합한 통계 검정을 선택하여 scipy/statsmodels 코드를 노트북 셀에 생성, 결과를 해석한다.
  트리거: "/stat-analysis", "통계 분석", "가설 검정", "hypothesis test",
  "상관 분석", "정규성 검정", "t-test", "ANOVA", "회귀 분석".
user_invocable: true
---

# Stat Analysis (통계 분석)

주피터 노트북(.ipynb)에 통계 분석 코드 셀을 NotebookEdit로 직접 작성한다.

## 사용법

```
/stat-analysis [질문/목적]
/stat-analysis 두 그룹 간 평균 차이가 유의한가?
/stat-analysis 변수 간 상관관계 분석
/stat-analysis                          ← 대화형으로 질문 파악
/stat-analysis report                   ← 통계 분석 보고서 생성 (셀 실행 후 사용)
```

## 전체 흐름

```
1단계: 척도 파악 + 연구 질문
  → 2단계: 귀무가설 설정
  → 3단계: 가정 검정 (정규성, 등분산성)
  → 4단계: 검정 실행 + 사후 분석
  → 5단계: 결과 해석 (기각/채택 + 효과 크기 + 실질적 의미)
  → 6단계: 보고서 생성 (/stat-analysis report)
```

## 워크플로우

### 1단계: 척도 파악 + 연구 질문

사용자의 분석 목적을 파악하고, **변수 척도(연속형/범주형)를 먼저 확인**한 뒤 적합한 검정을 선택한다.

**척도 분류:**
| 척도 | 설명 | 예시 | 분류 |
|------|------|------|------|
| 명목 | 순서 없는 범주형 | 성별, 지역, 혈액형 | 범주형 |
| 서열 | 순서 있는 범주형 | 학점(A/B/C), 만족도 | 범주형 |
| 등간 | 균등 간격, 절대 0 없음 | 온도, 연도 | 연속형 |
| 비율 | 균등 간격, 절대 0 있음 | 나이, 소득, 면적 | 연속형 |

**검정 선택 의사결정 트리:**

```
X, Y 척도 확인
│
├── 연속형 — 연속형
│   └── 가정 검정: 각 변수 정규성
│       ├── 정규성 O → Pearson 상관분석
│       └── 정규성 X → Spearman 상관분석
│
├── 범주형 — 연속형
│   └── 가정 검정: 그룹별 정규성 + 등분산성
│       │
│       ├── 2그룹
│       │   ├── 정규성 O, 등분산 O → 독립표본 t-test
│       │   ├── 정규성 O, 등분산 X → Welch's t-test
│       │   └── 정규성 X → Mann-Whitney U
│       │
│       └── 3+ 그룹
│           ├── 정규성 O, 등분산 O → One-way ANOVA → 사후: Tukey HSD
│           ├── 정규성 O, 등분산 X → Welch's ANOVA → 사후: Games-Howell
│           └── 정규성 X → Kruskal-Wallis → 사후: Dunn's test
│
├── 범주형 — 범주형
│   └── 가정 검정 불필요
│       └── 카이제곱 검정
│
├── 대응표본 (전/후)
│   └── 정규성 검정
│       ├── 정규성 O → 대응표본 t-test
│       └── 정규성 X → Wilcoxon 부호순위 검정
│
└── 예측/설명
    └── OLS 회귀분석
```

### 2단계: 귀무가설 설정

검정 코드 생성 **전에** 반드시 귀무가설(H0)과 대립가설(H1)을 명시한다.
노트북에 **마크다운 셀**로 가설을 먼저 작성한 후 코드 셀을 진행한다.

**가설 작성 예시 (마크다운 셀):**
```markdown
### 가설 검정: 시군구별 거래금액 차이

- **연구 질문**: 서울시 25개 자치구별 아파트 거래금액에 유의한 차이가 있는가?
- **독립변수(X)**: 시군구 (범주형, 25그룹)
- **종속변수(Y)**: 거래금액 (연속형)
- **H0 (귀무가설)**: 모든 시군구의 거래금액 분포는 동일하다
- **H1 (대립가설)**: 적어도 하나의 시군구는 다른 시군구와 거래금액이 다르다
- **유의수준**: α = 0.05
```

**검정별 귀무가설 레퍼런스:**

| 검정 | 귀무가설 (H0) | p < 0.05 → 결론 | 사후 분석 |
|------|--------------|-----------------|-----------|
| Pearson / Spearman | 두 변수 간 상관이 없다 (ρ = 0) | 유의한 상관 있음 | — |
| 독립표본 t-test | 두 그룹의 평균이 같다 (μ₁ = μ₂) | 평균 차이 있음 | — |
| Welch's t-test | 두 그룹의 평균이 같다 (μ₁ = μ₂) | 평균 차이 있음 | — |
| Mann-Whitney U | 두 그룹의 분포가 같다 | 분포 차이 있음 | — |
| One-way ANOVA | 모든 그룹의 평균이 같다 (μ₁ = μ₂ = μ₃) | 그룹 간 차이 있음 | Tukey HSD |
| Welch's ANOVA | 모든 그룹의 평균이 같다 (μ₁ = μ₂ = μ₃) | 그룹 간 차이 있음 | Games-Howell |
| Kruskal-Wallis | 모든 그룹의 분포가 같다 | 그룹 간 차이 있음 | Dunn's test |
| 카이제곱 검정 | 두 변수는 독립적이다 | 연관성 있음 | — |
| 대응표본 t-test | 전후 평균 차이가 0이다 (μd = 0) | 전후 차이 있음 | — |
| Wilcoxon 부호순위 | 전후 분포가 같다 | 전후 차이 있음 | — |

### 3단계: 가정 검정 셀 생성

**정규성 검정 — 표본 크기에 따라 분기:**
```python
from scipy import stats

# 정규성 검정 (표본 크기에 따라 검정 방법 선택)
target_col = '컬럼명'
data = df[target_col].dropna()
n = len(data)

if n > 5000:
    # n > 5000: Jarque-Bera 검정 (대표본에 적합)
    stat, p_value = stats.jarque_bera(data)
    test_name = 'Jarque-Bera'
else:
    # n ≤ 5000: Shapiro-Wilk 검정
    stat, p_value = stats.shapiro(data)
    test_name = 'Shapiro-Wilk'

print(f"{test_name} 검정 (n={n:,}): stat={stat:.4f}, p={p_value:.4f}")
print(f"→ {'정규분포 가정 가능 (p > 0.05)' if p_value > 0.05 else '정규분포 가정 불가 (p ≤ 0.05)'}")
```

**등분산성 검정 셀:**
```python
from scipy import stats

# 등분산성 검정 (Levene)
groups = [group['측정변수'].dropna().values for name, group in df.groupby('그룹변수')]
stat, p_value = stats.levene(*groups)
print(f"Levene 검정: W={stat:.4f}, p={p_value:.4f}")
print(f"→ {'등분산 가정 가능 (p > 0.05)' if p_value > 0.05 else '등분산 가정 불가 (p ≤ 0.05) → Welch 계열 검정 권장'}")
```

### 4단계: 검정 코드 셀 생성 (NotebookEdit)

검정 유형에 따라 적절한 코드를 생성한다. **모든 코드 출력에 귀무가설 기각/채택을 명시한다.**

#### 범주형(2그룹) — 연속형

**Independent t-test / Welch's t-test**
```python
from scipy import stats

group1 = df[df['그룹변수'] == '값1']['측정변수'].dropna()
group2 = df[df['그룹변수'] == '값2']['측정변수'].dropna()

# equal_var=True: 독립표본 t-test, equal_var=False: Welch's t-test
stat, p_value = stats.ttest_ind(group1, group2, equal_var=False)
print(f"Welch's t-test: t={stat:.4f}, p={p_value:.4f}")
print(f"그룹1 평균: {group1.mean():.4f}, 그룹2 평균: {group2.mean():.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 두 그룹의 평균에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 두 그룹의 평균에 유의한 차이가 없다 (p ≥ 0.05)")
```

**Mann-Whitney U (비모수)**
```python
from scipy import stats

group1 = df[df['그룹변수'] == '값1']['측정변수'].dropna()
group2 = df[df['그룹변수'] == '값2']['측정변수'].dropna()

stat, p_value = stats.mannwhitneyu(group1, group2, alternative='two-sided')
print(f"Mann-Whitney U: U={stat:.4f}, p={p_value:.4f}")
print(f"그룹1 중위수: {group1.median():.4f}, 그룹2 중위수: {group2.median():.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 두 그룹의 분포에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 두 그룹의 분포에 유의한 차이가 없다 (p ≥ 0.05)")
```

#### 범주형(3+그룹) — 연속형

**One-way ANOVA**
```python
from scipy import stats

groups = [group['측정변수'].values for name, group in df.groupby('그룹변수')]
stat, p_value = stats.f_oneway(*groups)
print(f"One-way ANOVA: F={stat:.4f}, p={p_value:.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 그룹 간 평균에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 그룹 간 평균에 유의한 차이가 없다 (p ≥ 0.05)")
```

**Welch's ANOVA (등분산 불만족 시)**
```python
from scipy import stats

# scipy에는 Welch ANOVA가 없으므로 Alexander-Govern 또는 수동 구현
# 대안: 각 쌍별 Welch t-test + Bonferroni 보정, 또는 Kruskal-Wallis 사용
```

> 💡 scipy에 Welch ANOVA 직접 함수가 없으므로, 정규성 O + 등분산 X인 경우 실무적으로 Kruskal-Wallis를 사용하거나, 각 쌍별 Welch t-test + Bonferroni 보정으로 대체한다.

**Kruskal-Wallis (비모수)**
```python
from scipy import stats

groups = [group['측정변수'].values for name, group in df.groupby('그룹변수')]
stat, p_value = stats.kruskal(*groups)
print(f"Kruskal-Wallis: H={stat:.4f}, p={p_value:.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 그룹 간 분포에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 그룹 간 분포에 유의한 차이가 없다 (p ≥ 0.05)")
```

#### 사후 분석 — 3+ 그룹 검정이 유의할 때

| 원 검정 | 조건 | 사후 분석 | 라이브러리 |
|---------|------|-----------|-----------|
| One-way ANOVA | 정규 O, 등분산 O | Tukey HSD | statsmodels |
| Welch's ANOVA | 정규 O, 등분산 X | Games-Howell | scikit_posthocs |
| Kruskal-Wallis | 정규 X | Dunn's test | scikit_posthocs |

**Tukey HSD (statsmodels)**
```python
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# ANOVA 유의 시 사후 분석: 어떤 그룹 쌍에서 차이가 나는지 확인
tukey = pairwise_tukeyhsd(df['측정변수'].dropna(), df['그룹변수'].dropna())
print(tukey.summary())
# reject=True인 쌍 → 해당 그룹 간 유의한 차이 있음
```

**Games-Howell (scikit_posthocs)**
```python
import scikit_posthocs as sp

# 등분산 불만족 시 사후 분석
result = sp.posthoc_ttest(df, val_col='측정변수', group_col='그룹변수', p_adjust='holm')
print(result)
# p < 0.05인 쌍 → 해당 그룹 간 유의한 차이 있음
```

**Dunn's test (scikit_posthocs)**
```python
import scikit_posthocs as sp

# Kruskal-Wallis 유의 시 비모수 사후 분석
result = sp.posthoc_dunn(df, val_col='측정변수', group_col='그룹변수', p_adjust='bonferroni')
print(result)
# p < 0.05인 쌍 → 해당 그룹 간 유의한 차이 있음
```

#### 연속형 — 연속형

**Pearson / Spearman 상관분석**
```python
from scipy import stats

var1, var2 = '변수1', '변수2'
# 결측값 pair-wise 제거 (각 변수 독립 dropna 시 길이 불일치 에러 방지)
_df = df[[var1, var2]].dropna()

# Pearson (정규성 O) 또는 Spearman (정규성 X)
r, p = stats.pearsonr(_df[var1], _df[var2])
print(f"Pearson: r={r:.4f}, p={p:.4f}")
if p < 0.05:
    print(f"→ 귀무가설 기각: 두 변수 간 유의한 상관이 있다 (r={r:.4f})")
else:
    print(f"→ 귀무가설 채택: 두 변수 간 유의한 상관이 없다")

rho, p_s = stats.spearmanr(_df[var1], _df[var2])
print(f"\nSpearman: ρ={rho:.4f}, p={p_s:.4f}")
if p_s < 0.05:
    print(f"→ 귀무가설 기각: 두 변수 간 유의한 단조 관계가 있다 (ρ={rho:.4f})")
else:
    print(f"→ 귀무가설 채택: 두 변수 간 유의한 단조 관계가 없다")
```

#### 범주형 — 범주형

**카이제곱 검정**
```python
from scipy import stats

ct = pd.crosstab(df['변수1'], df['변수2'])
chi2, p, dof, expected = stats.chi2_contingency(ct)
print(f"카이제곱 검정: χ²={chi2:.4f}, p={p:.4f}, df={dof}")
if p < 0.05:
    print(f"→ 귀무가설 기각: 두 변수 간 유의한 연관성이 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 두 변수는 독립적이다 (p ≥ 0.05)")
```

#### 대응표본 (전/후)

**대응표본 t-test**
```python
from scipy import stats

stat, p_value = stats.ttest_rel(df['before'], df['after'])
print(f"대응표본 t-test: t={stat:.4f}, p={p_value:.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 전후 평균에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 전후 평균에 유의한 차이가 없다 (p ≥ 0.05)")
```

**Wilcoxon 부호순위 검정 (비모수)**
```python
from scipy import stats

stat, p_value = stats.wilcoxon(df['before'], df['after'])
print(f"Wilcoxon 부호순위: W={stat:.4f}, p={p_value:.4f}")
if p_value < 0.05:
    print(f"→ 귀무가설 기각: 전후 분포에 유의한 차이가 있다 (p < 0.05)")
else:
    print(f"→ 귀무가설 채택: 전후 분포에 유의한 차이가 없다 (p ≥ 0.05)")
```

#### 예측/설명

**OLS 회귀분석**
```python
import statsmodels.api as sm

X = df[['독립변수1', '독립변수2']]
y = df['종속변수']
X = sm.add_constant(X)

model = sm.OLS(y, X).fit()
print(model.summary())
```

### 5단계: 결과 해석

코드 셀 이후 **마크다운 셀**로 결과 해석을 제공:

1. **귀무가설 기각/채택 명시**: "H0 기각 → 시군구별 거래금액에 유의한 차이가 있다"
2. **효과 크기** (Cohen's d, η², r² 등 해당 시):
   - Cohen's d: 0.2 작음, 0.5 중간, 0.8 큼
   - η² (ANOVA): 0.01 작음, 0.06 중간, 0.14 큼
   - r² (상관): 설명력 비율
3. **실질적 의미 해석**: 통계적 유의성 ≠ 실질적 중요성. 대표본에서는 작은 차이도 유의해질 수 있으므로 효과 크기와 함께 판단
4. **사후 분석 결과 요약**: 어떤 그룹 쌍에서 차이가 있는지 명시
5. **주의사항 및 한계점**

### 6단계: 통계 분석 보고서 (`/stat-analysis report`)

**`/stat-analysis report`가 호출되면** 실행한다 (셀 생성과 동시에 자동 실행하지 않음).

사용자가 노트북 셀을 모두 실행한 후 `/stat-analysis report`를 호출하면:
1. 노트북의 셀 출력 결과를 읽고 분석
2. 통계 분석 보고서를 작성하여 `docs/stat_report.md`에 저장 (`docs/` 폴더 없으면 생성)
3. 보고서에 포함할 내용:
   - 연구 질문 및 검정 선택 근거
   - 전제 조건 확인 결과 (정규성, 등분산성 등)
   - **가설 검정 요약 테이블**:

     | 연구 질문 | H0 | 검정 | 통계량 | p-value | 결론 | 효과 크기 |
     |----------|-----|------|--------|---------|------|-----------|
     | 시군구별 가격 차이 | 모든 구의 분포 동일 | Kruskal-Wallis | H=xxx | p=xxx | H0 기각 | η²=xxx |

   - 사후 분석 결과 (해당 시)
   - 실질적 해석 및 인사이트
   - 한계점 및 추가 분석 추천

## 코드 생성 규칙

1. **귀무가설 선행**: 코드 셀 전에 반드시 마크다운 셀로 H0/H1을 명시
2. **척도 확인**: 검정 선택 전 X·Y 변수의 척도(연속형/범주형)를 먼저 파악
3. **정규성 분기**: n > 5000이면 Jarque-Bera, n ≤ 5000이면 Shapiro-Wilk
4. **검정 선택 근거**: 왜 이 검정을 선택했는지 주석으로 설명
5. **기각/채택 출력**: 모든 검정 코드에 `"→ 귀무가설 기각/채택: ..."` 포함
6. **사후 분석 자동 연결**: 3+ 그룹 검정 유의 시 적합한 사후 분석 코드를 함께 생성
7. **효과 크기**: 가능하면 효과 크기도 함께 계산
8. **시각화 병행**: 검정 결과를 뒷받침하는 간단한 시각화 포함 (박스플롯, 산점도 등)
9. **유의수준**: 기본 α = 0.05, 사용자 지정 시 변경
10. **한국어 주석**: 모든 주석은 한국어
