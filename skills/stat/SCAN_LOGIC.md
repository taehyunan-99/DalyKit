# 변수 스캔 로직

`dalykit:stat` 전체 자동 분석의 1단계(분석 계획 수립)에서 참조하는 변수 스캔 알고리즘.

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
| 1 | [범주형 변수](N그룹) | [타겟] | cat-cont | 가정 검정으로 분기 | 보고서 추천 |
| 2 | [2그룹 변수] | [타겟] | cat-cont | 가정 검정으로 분기 | 자동 스캔 |
| 3 | [연속형 변수] | [타겟] | cont-cont | 가정 검정으로 분기 | 자동 스캔 |
| ...

### 제외된 변수
| 변수 | 사유 |
|------|------|
| [변수명](N) | 고카디널리티 (>20 그룹) |
| [변수명] | datetime — 시계열 분석 별도 |
| [변수명] | 단일값 |
```

## 사후 분석 매핑

> `TEST_SELECTION.md`의 "사후 분석 선택" 테이블 참조
