# 검정 선택 의사결정 트리

## 척도 분류

| 척도 | 설명 | 예시 | 분류 |
|------|------|------|------|
| 명목 | 순서 없는 범주형 | 성별, 지역, 혈액형 | 범주형 |
| 서열 | 순서 있는 범주형 | 학점(A/B/C), 만족도 | 범주형 |
| 등간 | 균등 간격, 절대 0 없음 | 온도, 연도 | 연속형 |
| 비율 | 균등 간격, 절대 0 있음 | 나이, 소득, 면적 | 연속형 |

## 의사결정 트리

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
│           ├── 정규성 O, 등분산 X → Welch's ANOVA → 사후: Tamhane
│           └── 정규성 X → Kruskal-Wallis → 사후: Nemenyi
│
├── 범주형 — 범주형
│   └── 카이제곱 검정
│
├── 대응표본 (전/후)
│   └── 정규성 검정
│       ├── 정규성 O → 대응표본 t-test
│       └── 정규성 X → Wilcoxon 부호순위 검정
│
└── 예측/설명
    └── OLS 회귀분석
```

## 사후 분석 선택

| 원 검정 | 조건 | 사후 분석 | 라이브러리 |
|---------|------|-----------|-----------|
| One-way ANOVA | 정규 O, 등분산 O | Tukey HSD | scikit_posthocs (`sp.posthoc_tukey`) |
| Welch's ANOVA | 정규 O, 등분산 X | Tamhane | scikit_posthocs (`sp.posthoc_tamhane`) |
| Kruskal-Wallis | 정규 X | Nemenyi | scikit_posthocs (`sp.posthoc_nemenyi`) |
