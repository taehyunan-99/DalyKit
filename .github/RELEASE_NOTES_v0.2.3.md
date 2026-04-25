## 새 기능
-

## 개선
- EDA 상관관계 히트맵 적응형 다중 출력: 전체(overview) + 상위 페어 + 클러스터 그룹별 히트맵 (수치형 컬럼 > 30 트리거)
- 전체 히트맵 overview 모드: 컬럼 30 초과 시 annot 생략, 라벨 폰트 축소, X축 라벨 회전 명시 고정
- 타겟 변수(domain.md) y축 하단 배치 + 행/열 테두리 강조 (모든 히트맵 공통)
- 상위 페어 히트맵 컬럼 상한(≤ 30, 비타겟 ≤ 29로 타겟 자리 항상 확보)
- 클러스터링 전 상수/NaN 컬럼 사전 필터링 + 빈 입력 가드

## 버그 수정
- X축 라벨 회전 제거 (bar/boxplot/line 차트 패턴 전체)
- squareform/linkage 실패 방지 (cluster_cols < 2 스킵)

## 문서
- STYLE_GUIDE.md X축 라벨 회전 금지 규칙 추가
- EDA_REPORT.md 세부 히트맵 노출 규칙 + skipped 처리 규칙 추가

---

## New Features
-

## Improvements
- EDA correlation heatmap adaptive multi-output: full (overview) + top pairs + cluster group heatmaps (trigger: numeric cols > 30)
- Full heatmap overview mode: annot omitted, label font scaled down, X-axis label rotation explicitly fixed at 0 when cols > 30
- Target variable (domain.md) placed at y-axis bottom with thick border highlight across all heatmaps
- Top pairs heatmap column cap (≤ 30, non-target ≤ 29 to always reserve target slot)
- Pre-clustering filter for constant/NaN columns + empty input guards

## Bug Fixes
- Removed X-axis label rotation from bar/boxplot/line chart patterns
- Prevent squareform/linkage failure when cluster_cols < 2

## Documentation
- STYLE_GUIDE.md: added X-axis label rotation ban rule
- EDA_REPORT.md: added detail heatmap display rules + skipped handling rules
