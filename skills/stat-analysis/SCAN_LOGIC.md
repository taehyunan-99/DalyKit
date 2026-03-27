# 변수 스캔 로직

stat-analyst 에이전트의 Phase 2에서 참조하는 변수 스캔 알고리즘.

## 스캔 알고리즘

```
scan_variable(target_var, other_var, df):

  # 1. datetime 제외
  if dtype == datetime64 → SKIP ("시계열 분석 별도")

  # 2. 범주형 판별: object dtype OR (int + nunique ≤ 20)
  if dtype == object OR (dtype in [int64, float64] AND nunique ≤ 20):
    if nunique == 1 → SKIP ("단일값")
    if nunique == 2 → 2그룹 트랙
    if 3 ≤ nunique ≤ 20 → 다그룹 트랙
    if nunique > 20 → SKIP ("고카디널리티")

  # 3. 연속형: float64 OR (int + nunique > 20)
  if dtype in [float64, int64] AND nunique > 20:
    → 상관분석 트랙
```

> **핵심**: `int + nunique ≤ 20`은 의미적 범주형으로 분류 (예: 계약년도 5개, 계약월 12개)

## 검정 트랙별 예상 검정

| 트랙 | 조건 | 검정 |
|------|------|------|
| 2그룹 | 정규 O → t-test / Welch, 정규 X → Mann-Whitney U | 가정 검정으로 분기 |
| 다그룹 | 정규 O + 등분산 O → ANOVA, 정규 X → Kruskal-Wallis | 가정 검정으로 분기 |
| 상관분석 | 정규 O → Pearson, 정규 X → Spearman | 가정 검정으로 분기 |

## 우선순위 규칙

- **P1 (보고서 추천)**: EDA/전처리 보고서의 "다음 단계 추천"에서 통계 검정 관련 항목 추출
- **P2 (자동 스캔)**: 타겟 변수 vs 나머지 변수에 스캔 알고리즘 적용
- P1·P2 중복 시 P1 출처 우선 표기

## 분석 계획 출력 형식

```markdown
## 분석 계획

| # | 독립변수(X) | 종속변수(Y) | 척도 조합 | 예상 검정 | 출처 |
|---|-----------|-----------|----------|----------|------|
| 1 | 시군구(25그룹) | 거래금액 | cat-cont | Kruskal-Wallis → Dunn | 보고서 추천 |
| 2 | 재건축(2그룹) | 거래금액 | cat-cont | Mann-Whitney U | 보고서 추천 |
| 3 | 전용면적 | 거래금액 | cont-cont | Spearman | 보고서 추천 |
| ...

### 제외된 변수
| 변수 | 사유 |
|------|------|
| 법정동(332) | 고카디널리티 (>20 그룹) |
| 단지명(6,191) | 고카디널리티 (>20 그룹) |
| 계약일자 | datetime — 시계열 분석 별도 |
```

## 사후 분석 매핑

| 원 검정 | 조건 | 사후 분석 | 라이브러리 |
|---------|------|-----------|-----------|
| One-way ANOVA | 정규 O, 등분산 O | Tukey HSD | statsmodels |
| Welch's ANOVA | 정규 O, 등분산 X | Games-Howell | scikit_posthocs |
| Kruskal-Wallis | 정규 X | Dunn's test | scikit_posthocs |
