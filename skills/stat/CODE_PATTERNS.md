# 검정 코드 패턴 (.py 스크립트용)

분석 `.py` 스크립트에서 사용하는 검정별 코드 패턴.
가정 검정 + 본 검정 + 사후 분석을 `if/else`로 자동 분기.

> **Heavy-Task-Offload**: 1000행 이상 데이터는 반드시 .py 스크립트로 처리.
> 노트북에는 결과 JSON만 로드하여 표시.

---

## 공통: 결과 수집 구조

```python
# 각 검정 함수는 dict를 반환
def analyze_xxx(df):
    result = {
        'title': '분석 제목',
        'question': '연구 질문',
        'x_var': 'X변수', 'y_var': 'Y변수',
        'h0': '귀무가설', 'h1': '대립가설',
        'assumptions': {},   # 가정 검정 결과
        'test_name': '',     # 최종 선택된 검정
        'statistic': 0.0, 'p_value': 0.0,
        'conclusion': '',    # 'H0 기각' / 'H0 기각할 수 없음'
        'interpretation': '',
        'effect_size': {'name': '', 'value': 0.0},
        'posthoc': None,     # 사후 분석 결과 (있을 때만)
        'group_stats': {},   # 그룹별 기술통계
    }
    return result
```

---

## 범주형(2그룹) — 연속형

```python
def analyze_two_group(df, x_var, y_var, val1, val2):
    group1 = df[df[x_var] == val1][y_var].dropna()
    group2 = df[df[x_var] == val2][y_var].dropna()
    n = len(group1) + len(group2)

    # ── 가정 검정 ──
    if n > 5000:
        stat_n, p_n = stats.jarque_bera(pd.concat([group1, group2]))
        norm_test = 'Jarque-Bera'
    else:
        stat_n, p_n = stats.shapiro(pd.concat([group1, group2]))
        norm_test = 'Shapiro-Wilk'
    is_normal = p_n > 0.05

    stat_lev, p_lev = stats.levene(group1, group2)
    is_equal_var = p_lev > 0.05

    # ── 본 검정 자동 분기 ──
    if is_normal and is_equal_var:
        stat, p = stats.ttest_ind(group1, group2, equal_var=True)
        test_name = '독립표본 t-test'
    elif is_normal:
        stat, p = stats.ttest_ind(group1, group2, equal_var=False)
        test_name = "Welch's t-test"
    else:
        stat, p = stats.mannwhitneyu(group1, group2, alternative='two-sided')
        test_name = 'Mann-Whitney U'

    # ── 효과 크기 (Cohen's d) ──
    pooled_std = np.sqrt((group1.std()**2 + group2.std()**2) / 2)
    cohens_d = abs(group1.mean() - group2.mean()) / pooled_std if pooled_std > 0 else 0

    return {
        'title': f'{x_var}에 따른 {y_var} 차이 검정',
        'question': f'{x_var}에 따라 {y_var}에 유의한 차이가 있는가?',
        'x_var': x_var, 'y_var': y_var,
        'h0': f'{x_var}에 따른 {y_var}의 평균 차이가 없다',
        'h1': f'{x_var}에 따른 {y_var}의 평균 차이가 있다',
        'assumptions': {
            'normality': {'test': norm_test, 'statistic': float(stat_n), 'p_value': float(p_n), 'pass': is_normal},
            'equal_variance': {'test': 'Levene', 'statistic': float(stat_lev), 'p_value': float(p_lev), 'pass': is_equal_var},
        },
        'test_name': test_name,
        'statistic': float(stat), 'p_value': float(p),
        'conclusion': 'H0 기각' if p < 0.05 else 'H0 기각할 수 없음',
        'interpretation': f'두 그룹 간 유의한 차이가 {"있다" if p < 0.05 else "있다고 볼 수 없다"} (α=0.05)',
        'effect_size': {'name': "Cohen's d", 'value': float(cohens_d)},
        'posthoc': None,
        'group_stats': {
            str(val1): {'n': len(group1), 'mean': float(group1.mean()), 'std': float(group1.std())},
            str(val2): {'n': len(group2), 'mean': float(group2.mean()), 'std': float(group2.std())},
        },
        'figure_path': None,  # 시각화 저장 후 경로 할당 (예: save_fig('stat_h1_boxplot.png'))
    }
```

---

## 범주형(3+그룹) — 연속형

```python
def analyze_multi_group(df, x_var, y_var):
    groups = {name: g[y_var].dropna().values for name, g in df.groupby(x_var)}
    group_list = list(groups.values())
    all_data = df[y_var].dropna()
    n = len(all_data)

    # ── 가정 검정 ──
    if n > 5000:
        stat_n, p_n = stats.jarque_bera(all_data)
        norm_test = 'Jarque-Bera'
    else:
        stat_n, p_n = stats.shapiro(all_data)
        norm_test = 'Shapiro-Wilk'
    is_normal = p_n > 0.05

    stat_lev, p_lev = stats.levene(*group_list)
    is_equal_var = p_lev > 0.05

    # ── 본 검정 자동 분기 ──
    if is_normal and is_equal_var:
        stat, p = stats.f_oneway(*group_list)
        test_name = 'One-way ANOVA'
    elif is_normal:
        res = stats.alexandergovern(*group_list)
        stat, p = res.statistic, res.pvalue
        test_name = "Welch's ANOVA (Alexander-Govern)"
    else:
        stat, p = stats.kruskal(*group_list)
        test_name = 'Kruskal-Wallis'

    # ── 효과 크기 (η²) ──
    grand_mean = all_data.mean()
    ss_between = sum(len(g) * (g.mean() - grand_mean)**2 for g in group_list)
    ss_total = sum((all_data - grand_mean)**2)
    eta_sq = float(ss_between / ss_total) if ss_total > 0 else 0

    # ── 사후 분석 자동 연결 ──
    posthoc_result = None
    if p < 0.05:
        if is_normal and is_equal_var:
            post = sp.posthoc_tukey(df, val_col=y_var, group_col=x_var)
            posthoc_name = 'Tukey HSD'
        elif is_normal:
            post = sp.posthoc_tamhane(df, val_col=y_var, group_col=x_var)
            posthoc_name = 'Tamhane'
        else:
            post = sp.posthoc_nemenyi(df, val_col=y_var, group_col=x_var)
            posthoc_name = 'Nemenyi'
        # p-value 매트릭스를 dict로 변환
        posthoc_result = {'method': posthoc_name, 'matrix': post.to_dict()}

    return {
        'title': f'{x_var}에 따른 {y_var} 차이 검정',
        'question': f'{x_var} 그룹 간 {y_var}에 유의한 차이가 있는가?',
        'x_var': x_var, 'y_var': y_var,
        'h0': f'{x_var} 그룹 간 {y_var}의 평균 차이가 없다',
        'h1': f'{x_var} 그룹 간 {y_var}의 평균 차이가 있다 (최소 한 쌍)',
        'assumptions': {
            'normality': {'test': norm_test, 'statistic': float(stat_n), 'p_value': float(p_n), 'pass': is_normal},
            'equal_variance': {'test': 'Levene', 'statistic': float(stat_lev), 'p_value': float(p_lev), 'pass': is_equal_var},
        },
        'test_name': test_name,
        'statistic': float(stat), 'p_value': float(p),
        'conclusion': 'H0 기각' if p < 0.05 else 'H0 기각할 수 없음',
        'interpretation': f'그룹 간 유의한 차이가 {"있다" if p < 0.05 else "있다고 볼 수 없다"} (α=0.05)',
        'effect_size': {'name': 'η²', 'value': eta_sq},
        'posthoc': posthoc_result,
        'group_stats': {str(k): {'n': len(v), 'mean': float(v.mean()), 'std': float(v.std())} for k, v in groups.items()},
        'figure_path': None,  # 시각화 저장 후 경로 할당 (예: save_fig('stat_h2_boxplot.png'))
    }
```

---

## 연속형 — 연속형 (상관분석)

```python
def analyze_correlation(df, x_var, y_var):
    _df = df[[x_var, y_var]].dropna()
    n = len(_df)

    # ── 가정 검정 ──
    if n > 5000:
        stat_n1, p_n1 = stats.jarque_bera(_df[x_var])
        stat_n2, p_n2 = stats.jarque_bera(_df[y_var])
        norm_test = 'Jarque-Bera'
    else:
        stat_n1, p_n1 = stats.shapiro(_df[x_var])
        stat_n2, p_n2 = stats.shapiro(_df[y_var])
        norm_test = 'Shapiro-Wilk'
    is_normal = (p_n1 > 0.05) and (p_n2 > 0.05)

    # ── 본 검정 자동 분기 ──
    if is_normal:
        r, p = stats.pearsonr(_df[x_var], _df[y_var])
        test_name = 'Pearson'
    else:
        r, p = stats.spearmanr(_df[x_var], _df[y_var])
        test_name = 'Spearman'

    return {
        'title': f'{x_var}와 {y_var}의 상관분석',
        'question': f'{x_var}와 {y_var} 사이에 유의한 상관관계가 있는가?',
        'x_var': x_var, 'y_var': y_var,
        'h0': f'{x_var}와 {y_var} 사이에 유의한 상관이 없다',
        'h1': f'{x_var}와 {y_var} 사이에 유의한 상관이 있다',
        'assumptions': {
            'normality_x': {'test': norm_test, 'statistic': float(stat_n1), 'p_value': float(p_n1), 'pass': p_n1 > 0.05},
            'normality_y': {'test': norm_test, 'statistic': float(stat_n2), 'p_value': float(p_n2), 'pass': p_n2 > 0.05},
        },
        'test_name': test_name,
        'statistic': float(r), 'p_value': float(p),
        'conclusion': 'H0 기각' if p < 0.05 else 'H0 기각할 수 없음',
        'interpretation': f'유의한 상관이 {"있다" if p < 0.05 else "있다고 볼 수 없다"} (α=0.05)',
        'effect_size': {'name': 'r²', 'value': float(r**2)},
        'posthoc': None,
        'group_stats': {'n': n, 'r': float(r)},
        'figure_path': None,  # 시각화 저장 후 경로 할당 (예: save_fig('stat_h3_scatter.png'))
    }
```

---

## 범주형 — 범주형 (카이제곱)

```python
def analyze_chi_square(df, x_var, y_var):
    ct = pd.crosstab(df[x_var], df[y_var])
    chi2, p, dof, expected = stats.chi2_contingency(ct)
    n = ct.sum().sum()
    k = min(ct.shape) - 1
    cramers_v = float(np.sqrt(chi2 / (n * k))) if k > 0 else 0

    return {
        'title': f'{x_var}와 {y_var}의 독립성 검정',
        'question': f'{x_var}와 {y_var}는 독립적인가?',
        'x_var': x_var, 'y_var': y_var,
        'h0': f'{x_var}와 {y_var}는 독립적이다',
        'h1': f'{x_var}와 {y_var}는 연관성이 있다',
        'assumptions': {'min_expected': float(expected.min())},
        'test_name': '카이제곱 검정',
        'statistic': float(chi2), 'p_value': float(p),
        'conclusion': 'H0 기각' if p < 0.05 else 'H0 기각할 수 없음',
        'interpretation': f'두 변수 간 유의한 연관성이 {"있다" if p < 0.05 else "있다고 볼 수 없다"} (α=0.05)',
        'effect_size': {'name': "Cramér's V", 'value': cramers_v},
        'posthoc': None,
        'group_stats': {'dof': int(dof), 'n': int(n)},
        'figure_path': None,  # 시각화 저장 후 경로 할당 (예: save_fig('stat_h4_stacked_bar.png'))
    }
```

---

## 대응표본 (전/후)

```python
def analyze_paired(df, before_var, after_var):
    _df = df[[before_var, after_var]].dropna()
    before, after = _df[before_var], _df[after_var]
    diff = before - after
    n = len(diff)

    # ── 가정 검정 ──
    if n > 5000:
        stat_n, p_n = stats.jarque_bera(diff)
        norm_test = 'Jarque-Bera'
    else:
        stat_n, p_n = stats.shapiro(diff)
        norm_test = 'Shapiro-Wilk'
    is_normal = p_n > 0.05

    # ── 본 검정 자동 분기 ──
    if is_normal:
        stat, p = stats.ttest_rel(before, after)
        test_name = '대응표본 t-test'
    else:
        stat, p = stats.wilcoxon(before, after)
        test_name = 'Wilcoxon 부호순위'

    cohens_d = float(abs(diff.mean()) / diff.std()) if diff.std() > 0 else 0

    return {
        'title': f'{before_var} vs {after_var} 대응 비교',
        'question': f'{before_var}와 {after_var} 사이에 유의한 차이가 있는가?',
        'x_var': before_var, 'y_var': after_var,
        'h0': '전후 차이가 없다',
        'h1': '전후 유의한 차이가 있다',
        'assumptions': {
            'normality_diff': {'test': norm_test, 'statistic': float(stat_n), 'p_value': float(p_n), 'pass': is_normal},
        },
        'test_name': test_name,
        'statistic': float(stat), 'p_value': float(p),
        'conclusion': 'H0 기각' if p < 0.05 else 'H0 기각할 수 없음',
        'interpretation': f'전후 유의한 차이가 {"있다" if p < 0.05 else "있다고 볼 수 없다"} (α=0.05)',
        'effect_size': {'name': "Cohen's d", 'value': cohens_d},
        'posthoc': None,
        'group_stats': {'n': n, 'before_mean': float(before.mean()), 'after_mean': float(after.mean())},
        'figure_path': None,  # 시각화 저장 후 경로 할당 (예: save_fig('stat_h5_boxplot.png'))
    }
```

---

## 시각화 저장 규칙

### 저장 대상 (가설 연결 + 핵심 인사이트만)

통계 분석 단계에서는 **가설 검증 근거와 핵심 인사이트를 뒷받침하는 차트만** 저장한다.

| 저장 대상 | 파일명 컨벤션 | 보고서 섹션 |
|-----------|--------------|------------|
| 가설별 검증 시각화 (유의/비유의 무관) | `stat_h{n}_{유형}.png` | hypothesis / stat_results |
| 효과 크기 상위 핵심 인사이트 차트 | `stat_insight_{col}.png` | key_findings |

> **기준**: 가설 번호(h1, h2, ...)와 1:1 매핑된 차트만 저장.
> 단순 탐색용이나 가설과 무관한 차트는 저장하지 않는다.
> 비유의(H0 기각 불가) 결과도 "근거 없음"의 근거 자료로 저장한다.

### save_fig() 유틸 패턴 (stat 스크립트용)

```python
def save_fig(filename: str) -> str:
    """figures/ 폴더에 저장하고 경로 반환"""
    os.makedirs(FIGURES_DIR, exist_ok=True)
    path = os.path.join(FIGURES_DIR, filename)
    plt.savefig(path, dpi=150, bbox_inches='tight')
    plt.close()
    return path
```

### 검정별 시각화 패턴

#### 범주형 → 연속형 (t-test / ANOVA / Mann-Whitney / Kruskal)

```python
# 가설 h1: X변수에 따른 Y변수 차이 → 박스플롯
fig, ax = plt.subplots(figsize=(8, 5))
sns.boxplot(x=x_var, y=y_var, data=df, ax=ax)
ax.set_title(f'[H1] {x_var}에 따른 {y_var} 분포', fontdict={'fontweight': 'bold'})
figure_path = save_fig('stat_h1_boxplot.png')
# result dict에 경로 포함
result['figure_path'] = figure_path
```

#### 연속형 → 연속형 (Pearson / Spearman)

```python
# 가설 h2: X변수와 Y변수 상관 → 산점도
fig, ax = plt.subplots(figsize=(8, 6))
sns.scatterplot(x=x_var, y=y_var, data=df, alpha=0.5, ax=ax)
ax.set_title(f'[H2] {x_var} vs {y_var}', fontdict={'fontweight': 'bold'})
figure_path = save_fig('stat_h2_scatter.png')
result['figure_path'] = figure_path
```

#### 범주형 → 범주형 (카이제곱)

```python
# 가설 h3: X변수와 Y변수 연관성 → 누적 바차트
ct = pd.crosstab(df[x_var], df[y_var], normalize='index')
fig, ax = plt.subplots(figsize=(8, 5))
ct.plot(kind='bar', stacked=True, ax=ax)
ax.set_title(f'[H3] {x_var}별 {y_var} 비율', fontdict={'fontweight': 'bold'})
figure_path = save_fig('stat_h3_stacked_bar.png')
result['figure_path'] = figure_path
```

#### 핵심 인사이트 차트 (key_findings용)

```python
# 효과 크기 상위 변수 — 별도 저장 (stat_insight_*)
fig, ax = plt.subplots(figsize=(8, 5))
sns.boxplot(x=top_var, y=target_var, data=df, ax=ax)
ax.set_title(f'핵심 인사이트: {top_var}에 따른 {target_var}', fontdict={'fontweight': 'bold'})
save_fig(f'stat_insight_{top_var}.png')
```

---

## .py 스크립트 전체 구조

```python
"""통계 분석 스크립트 — [데이터명]"""
import os, json, sys
import pandas as pd
import numpy as np
from scipy import stats
import scikit_posthocs as sp

# ── 데이터 로드 ──
DATA_PATH = '상대경로/파일명.csv'
df = pd.read_csv(DATA_PATH)
print(f"데이터 로드: {df.shape[0]:,}행 × {df.shape[1]}열")

# ── 분석 함수 정의 ──
# (위 패턴들을 필요한 것만 포함)

# ── 분석 실행 ──
results = []
results.append(analyze_multi_group(df, 'X변수', 'Y변수'))
results.append(analyze_correlation(df, 'X변수', 'Y변수'))
# ... 분석 항목별 호출

# ── 결과 저장 ──
class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.bool_): return bool(obj)
        if isinstance(obj, np.integer): return int(obj)
        if isinstance(obj, np.floating): return float(obj)
        return super().default(obj)

output = {
    'data_info': {'path': DATA_PATH, 'rows': df.shape[0], 'cols': df.shape[1]},
    'alpha': 0.05,
    'results': results,
    'summary': [{'title': r['title'], 'test': r['test_name'],
                  'p_value': r['p_value'], 'conclusion': r['conclusion'],
                  'effect_size': r['effect_size']} for r in results]
}
OUTPUT_PATH = 'dalykit/code/results/stat_results.json'
with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, indent=2, cls=NumpyEncoder)
print(f"결과 저장: {OUTPUT_PATH}")
```
