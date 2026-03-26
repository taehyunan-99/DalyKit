---
name: stat-analysis
description: >
  통계 분석 및 가설 검정. 연구 질문에 맞는 적합한 통계 검정을 선택하고
  scipy/statsmodels 코드를 노트북 셀에 생성, 결과를 해석한다.
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
```

## 워크플로우

### 1단계: 연구 질문 파악
사용자의 분석 목적을 파악하고 적합한 검정을 선택한다.

**검정 선택 가이드:**

| 목적 | 조건 | 검정 |
|------|------|------|
| 정규성 확인 | 단일 변수 | Shapiro-Wilk |
| 두 그룹 비교 | 정규분포 + 독립 | Independent t-test |
| 두 그룹 비교 | 비정규 + 독립 | Mann-Whitney U |
| 두 그룹 비교 | 대응 표본 | Paired t-test |
| 3+ 그룹 비교 | 정규분포 | One-way ANOVA |
| 3+ 그룹 비교 | 비정규 | Kruskal-Wallis |
| 연속 변수 관계 | 정규분포 | Pearson 상관 |
| 연속 변수 관계 | 비정규/순서형 | Spearman 상관 |
| 범주형 변수 관계 | 빈도표 | 카이제곱 검정 |
| 예측/설명 | 연속 종속변수 | OLS 회귀분석 |

### 2단계: 전제 조건 확인 셀 생성

**정규성 검정 셀**
```python
from scipy import stats

# 정규성 검정 (Shapiro-Wilk)
target_col = '컬럼명'
stat, p_value = stats.shapiro(df[target_col].dropna())
print(f"Shapiro-Wilk 검정: W={stat:.4f}, p={p_value:.4f}")
print(f"결론: {'정규분포 가정 가능 (p > 0.05)' if p_value > 0.05 else '정규분포 가정 불가 (p ≤ 0.05)'}")
```

### 3단계: 검정 코드 셀 생성 (NotebookEdit)

검정 유형에 따라 적절한 코드를 생성한다. 아래는 참조 패턴:

**Independent t-test**
```python
from scipy import stats

group1 = df[df['그룹변수'] == '값1']['측정변수']
group2 = df[df['그룹변수'] == '값2']['측정변수']

stat, p_value = stats.ttest_ind(group1, group2)
print(f"Independent t-test: t={stat:.4f}, p={p_value:.4f}")
print(f"Group1 평균: {group1.mean():.4f}, Group2 평균: {group2.mean():.4f}")
print(f"결론: {'유의한 차이 있음 (p < 0.05)' if p_value < 0.05 else '유의한 차이 없음 (p ≥ 0.05)'}")
```

**One-way ANOVA**
```python
from scipy import stats

groups = [group['측정변수'].values for name, group in df.groupby('그룹변수')]
stat, p_value = stats.f_oneway(*groups)
print(f"One-way ANOVA: F={stat:.4f}, p={p_value:.4f}")
print(f"결론: {'그룹 간 유의한 차이 있음' if p_value < 0.05 else '그룹 간 유의한 차이 없음'}")
```

**Pearson/Spearman 상관분석**
```python
from scipy import stats

var1, var2 = '변수1', '변수2'
# Pearson
r, p = stats.pearsonr(df[var1].dropna(), df[var2].dropna())
print(f"Pearson: r={r:.4f}, p={p:.4f}")

# Spearman
rho, p_s = stats.spearmanr(df[var1].dropna(), df[var2].dropna())
print(f"Spearman: ρ={rho:.4f}, p={p_s:.4f}")
```

**카이제곱 검정**
```python
from scipy import stats

ct = pd.crosstab(df['변수1'], df['변수2'])
chi2, p, dof, expected = stats.chi2_contingency(ct)
print(f"카이제곱 검정: χ²={chi2:.4f}, p={p:.4f}, df={dof}")
print(f"결론: {'유의한 연관성 있음' if p < 0.05 else '유의한 연관성 없음'}")
```

**OLS 회귀분석**
```python
import statsmodels.api as sm

X = df[['독립변수1', '독립변수2']]
y = df['종속변수']
X = sm.add_constant(X)

model = sm.OLS(y, X).fit()
print(model.summary())
```

### 4단계: 결과 해석
코드 셀 이후 마크다운 텍스트로 결과 해석 제공:
- 검정 결과 요약 (통계량, p-value)
- 효과 크기 (Cohen's d, r² 등 해당 시)
- 실질적 의미 해석 (통계적 유의성 ≠ 실질적 중요성)
- 주의사항 및 한계점

## 코드 생성 규칙

1. **검정 선택 근거**: 왜 이 검정을 선택했는지 주석으로 설명
2. **전제 조건**: 정규성, 등분산성 등 전제 조건 확인 코드를 먼저 생성
3. **유의수준**: 기본 α = 0.05, 사용자 지정 시 변경
4. **결론 자동 출력**: p-value 기반 결론을 print문으로 포함
5. **효과 크기**: 가능하면 효과 크기도 함께 계산
6. **시각화 병행**: 검정 결과를 뒷받침하는 간단한 시각화 포함 (박스플롯, 산점도 등)
7. **한국어 주석**: 모든 주석은 한국어
