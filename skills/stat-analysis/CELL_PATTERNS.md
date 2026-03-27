# 셀 생성 패턴

stat-analyst 에이전트의 Phase 4에서 참조하는 노트북 셀 생성 패턴.

## 전체 셀 구조

```
셀 0: [마크다운] 제목 + 분석 개요 테이블
셀 1: [코드] import + 데이터 로드 + stat_results = []

--- 분석 1 ---
셀 2: [마크다운] H0/H1 가설 설정
셀 3: [코드] 가정 검정 (정규성 + 등분산)
셀 4: [코드] 본 검정 + 효과 크기 + "→ 귀무가설 기각/채택" + stat_results.append()
셀 5: [코드] 사후 검정 (3+그룹이고 유의한 경우만, if p < 0.05)

--- 분석 2~N: 동일 패턴 ---

셀 M-1: [코드] 전체 검정 결과 요약 테이블
셀 M: [마크다운] 다음 단계 안내
```

## 셀 0 — 마크다운: 제목 + 개요

```markdown
# 통계 분석 — [데이터명]

| 항목 | 값 |
|------|-----|
| 데이터 | `data/cleaned/파일명_cleaned.csv` |
| 종속변수 | 거래금액 |
| 분석 수 | N개 |
| 유의수준 | α = 0.05 |
```

## 셀 1 — 코드: import + 데이터 로드

```python
import os
import pandas as pd
import numpy as np
from scipy import stats
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import matplotlib.pyplot as plt
import seaborn as sns

# 한국어 폰트
import platform
if platform.system() == 'Darwin':
    plt.rcParams['font.family'] = 'AppleGothic'
else:
    plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False

# 데이터 로드
DATA_DIR = '../data/cleaned'
os.chdir(DATA_DIR)
df = pd.read_csv('파일명_cleaned.csv')
print(f"데이터: {df.shape[0]:,}행 × {df.shape[1]}열")

# 결과 수집용
stat_results = []
```

## 각 분석 항목 — 마크다운 셀 (H0/H1)

SKILL.md 2단계 형식:

```markdown
### 가설 검정 N: [분석 제목]

- **연구 질문**: [질문]
- **독립변수(X)**: [변수명] ([척도], [그룹 수])
- **종속변수(Y)**: [변수명] ([척도])
- **H0 (귀무가설)**: [귀무가설]
- **H1 (대립가설)**: [대립가설]
- **유의수준**: α = 0.05
```

## 각 분석 항목 — 코드 셀

SKILL.md 3~4단계의 코드 템플릿을 참조하여 생성:
- 정규성 검정: n > 5000 → Jarque-Bera, n ≤ 5000 → Shapiro-Wilk
- 등분산성 검정: Levene (그룹 비교 시)
- 본 검정: 가정 결과에 따라 모수/비모수 분기
- 효과 크기: Cohen's d (2그룹), η² (다그룹), r² (상관분석)
- 모든 출력에 `"→ 귀무가설 기각/채택: ..."` 포함

**결과 수집 패턴 (모든 검정 셀 끝에 추가):**

```python
stat_results.append({
    '연구질문': '...',
    'H0': '...',
    '검정': '...',
    '통계량': f'{stat:.4f}',
    'p값': f'{p_value:.4f}',
    '결론': 'H0 기각' if p_value < 0.05 else 'H0 채택',
    '효과크기': f'{effect_size:.4f}'
})
```

## 셀 M-1 — 코드: 결과 요약 테이블

```python
# 전체 검정 결과 요약
summary_df = pd.DataFrame(stat_results)
print("=" * 80)
print("전체 가설 검정 결과 요약")
print("=" * 80)
print(summary_df.to_markdown(index=False))
```

## 셀 M — 마크다운: 다음 단계

```markdown
## 다음 단계

1. 위 셀들을 모두 실행한 뒤 `/stat-analysis report`를 호출하면 `docs/stat_report.md` 보고서가 생성됩니다.
2. 인사이트 시각화: `/da-viz`로 주요 발견을 차트로 뒷받침
```
