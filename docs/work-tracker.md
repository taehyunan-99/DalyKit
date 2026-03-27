# HarnessDA Work Tracker
<!-- Claude 전용: 새 컨텍스트에서 작업 이어가기 위한 상태 문서 -->
<!-- 마지막 업데이트: 2026-03-27 -->

## 현재 상태 (Current State)
> stat-analyst 에이전트 전체 자동화 완료. 다음 단계: APT 데이터에 `/da stat-deep` 실행 (실제 통계 분석 노트북 생성).

## 최근 변경 (Recent Changes)
<!-- 직전 세션에서 한 일 — 최대 5개, LIFO -->
| 날짜 | 변경 | 영향 파일 |
|------|------|-----------|
| 2026-03-27 | stat-analyst 에이전트 전체 자동화 재작성 + 참조 문서 분리 | agents/stat-analyst.md, skills/stat-analysis/SCAN_LOGIC.md, skills/stat-analysis/CELL_PATTERNS.md |
| 2026-03-27 | /da stat-deep 설명 업데이트 (인자 없음=전체 자동, 인자 있음=단일) | commands/da.md |
| 2026-03-27 | skills/stat-analysis/SKILL.md 대규모 개선 (귀무가설 강화, 의사결정 트리, n 기준 분기) | skills/stat-analysis/SKILL.md |
| 2026-03-27 | 품질 리뷰 12개 이슈 수정 (#5, #11 제외) | skills/*, agents/*, commands/*, CLAUDE.md, README.md |
| 2026-03-27 | macOS/Linux install.sh, uninstall.sh 작성 | scripts/install.sh, scripts/uninstall.sh |

## 진행 중 (In Progress)
- (없음)

## 대기열 (Backlog)
<!-- 우선순위 순, 각 항목에 WHY 포함 -->
1. **APT 데이터 통계 분석 실행** — `/da stat-deep` 호출하여 `stat_apt.ipynb` 생성 + 셀 실행 + `/stat-analysis report`
2. **인사이트 시각화** — 통계 분석 결과 기반 `/da-viz` 실행 (시군구별 박스플롯, 상관 산점도 등)
3. **최종 보고서 스킬 설계** — 자체 HTML + PPT 생성 스킬 구축 (`/da report` 개선)
4. **install.sh macOS 테스트** — 스크립트 작성 완료했으나 실행 검증 미완
5. **visualize 플러그인 graceful 처리** (#5 보류) — 플러그인 미설치 시 에러 방지

## 보류/제외 (On Hold)
<!-- 의도적으로 안 하는 것 + 이유 — "왜 안 했지?" 방지 -->
| 항목 | 이유 | 재개 조건 |
|------|------|-----------|
| #5 visualize 의존성 | 사용자 보류 결정 | 사용자 요청 시 |
| #11 Linux 폰트 | macOS 전용 환경 | Linux 사용 시 |
| Tableau 연동 | 추후 학습 예정 | 사용자 학습 완료 후 |
| 피처 엔지니어링 | ML 단계에서 추가 | ML 워크플로우 구축 시 |

## 설계 결정 로그 (Decision Log)
<!-- 중요한 기술적 결정 — "왜 이렇게 했지?" 방지 -->
| 날짜 | 결정 | 근거 |
|------|------|------|
| 2026-03-27 | data-profiler → /eda 위임 패턴 | EDA 로직 중복 제거, 단일 소스 유지 |
| 2026-03-27 | da-viz 누적바차트: pivot_table → crosstab | pivot_table aggfunc='count' NaN 취약점 |
| 2026-03-27 | stat-analyst: 에이전트 본체 + 참조 문서 분리 구조 채택 | 200줄 초과 방지, 역할별 분리 (SCAN_LOGIC, CELL_PATTERNS) |
| 2026-03-27 | stat-analysis SKILL.md: 귀무가설 우선 워크플로우 + n>5000 Jarque-Bera 분기 | 노션 통계 워크플로우 반영, 대표본 검정력 과잉 방지 |
| 2026-03-27 | stat-analysis: Levene + Welch + Tukey 추가 | 통계적 엄밀성 강화 |
| 2026-03-27 | data-clean: df.copy() 비파괴 패턴 | 원본 데이터 보존 원칙 |
| 2026-03-27 | 상관분석: pair-wise dropna | 독립 dropna 시 길이 불일치 버그 |
