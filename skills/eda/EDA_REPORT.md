# EDA 보고서 가이드

## 데이터 소스

- 입력: `dalykit/kits/{kit}/eda/eda_results.json`
- 출력: `dalykit/kits/{kit}/eda/eda_report.md`
- 이미지: `dalykit/kits/{kit}/eda/figures/`

## 필수 섹션

1. 요약
2. 데이터 개요
3. 결측값 분석
4. 수치형 변수 분석
5. 범주형 변수 분석
6. 변수 간 관계
7. 종합 판단 및 다음 단계

## 이미지 참조 규칙

- 보고서와 figures가 같은 stage 디렉토리 아래 있으므로 상대 경로는 `./figures/...`를 사용한다

## 상관관계 히트맵 노출 규칙

`eda_results.json`의 `sections.correlation_heatmap` 구조에 따라 보고서 본문에 노출한다.

- `correlation_heatmap.full`만 있는 경우 (수치형 ≤ 30): 전체 히트맵 한 장만 표시
- `top_pairs` 또는 `groups`가 함께 있는 경우 (수치형 > 30):
  1. 먼저 **전체 히트맵**(`heatmap_corr.png`)을 overview로 표시하고, 라벨/주석이 생략됐음을 한 줄로 안내한다
  2. 그 아래에 **상위 상관 페어 히트맵**(`heatmap_corr_top.png`)을 세부 뷰로 표시하고, `top_pairs.pairs` 상위 5~10개를 표로 함께 제시한다
  3. **클러스터 그룹별 히트맵**(`heatmap_corr_group{N}.png`)을 모두 나열하고 각 그룹의 컬럼 목록을 함께 적는다
  4. 해석/인사이트는 전체가 아닌 **세부 히트맵 기준**으로 작성한다

### 스킵 처리

- `top_pairs` 또는 `groups`에 `skipped` 키가 있으면 해당 세부 히트맵은 생성되지 않은 것이다 (유효 페어/컬럼 부족)
- 이 경우 figure 참조와 표 출력을 모두 생략하고, `skipped` 메시지를 한 줄 안내로만 표시한다
- 예: `> 상위 상관 페어 히트맵: 유효 상관 페어가 부족하여 생략됨`
- `pairs`/`figure` 키가 없는 상태에서 보고서가 이를 참조해서는 안 된다

예:

```markdown
### 변수 간 관계

#### 전체 상관 구조 (overview)
![상관관계 히트맵 (전체)](./figures/heatmap_corr.png)

수치형 컬럼이 많아 셀 주석은 생략됐다. 구체 수치는 아래 세부 히트맵을 참고한다.

#### 상위 상관 페어
![상위 상관 페어](./figures/heatmap_corr_top.png)

| 변수1 | 변수2 | abs(r) |
|-------|-------|--------|
| ... | ... | ... |

#### 그룹별 상관 구조
![그룹 1](./figures/heatmap_corr_group1.png)
- 컬럼: ...

![그룹 2](./figures/heatmap_corr_group2.png)
- 컬럼: ...
```
