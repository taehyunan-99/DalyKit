# HarnessDA Work Tracker
<!-- Claude 전용: 새 컨텍스트에서 작업 이어가기 위한 상태 문서 -->
<!-- 마지막 업데이트: 2026-03-30 -->

## 현재 상태 (Current State)
> P0-2(HTML PPT 템플릿화) 설계 완료. template.html 제작 + 구현 단계 진입 전.

## 최근 변경 (Recent Changes)
<!-- 직전 세션에서 한 일 — 최대 5개, LIFO -->
| 날짜 | 변경 | 영향 파일 |
|------|------|-----------|
| 2026-03-30 | P0-2 설계 완료. 도메인 5종 테마/색상 확정. JSON 스키마 설계 + 3파일 분리(SCHEMA_COMMON/DOMAIN/PORTFOLIO). HTML_TEMPLATE.md 전면 개편. SKILL.md pptx 워크플로우 교체. templates/ 통합 | report/SKILL.md, report/HTML_TEMPLATE.md, report/JSON_SCHEMA.md, report/SCHEMA_COMMON.md(신규), report/SCHEMA_DOMAIN.md(신규), report/SCHEMA_PORTFOLIO.md(신규), report/SLIDE_STRUCTURE.md, templates/DOMAIN_TEMPLATE.md(이동), templates/REPORT_CONFIG_TEMPLATE.md(이동) |
| 2026-03-30 | eda/clean SKILL.md → py 방식 전환 (NotebookEdit 제거). CELL_PATTERNS.md 신규 생성. report 인자 제거, update 인자 추가, 자동 보고서 연결 | eda/SKILL.md, eda/CELL_PATTERNS.md(신규), data-clean/SKILL.md, data-clean/CELL_PATTERNS.md(신규), stat-analysis/SKILL.md |
| 2026-03-29 | viz 스킬 → 공유 참조 문서 전환. CHART_PATTERNS.md → charts/ 개별 파일 분리(9개). SKILL.md 삭제 | skills/viz/*, eda/SKILL.md, stat-analysis/SKILL.md, CELL_PATTERNS.md, help/SKILL.md, CLAUDE.md, README.md, data-profiler.md, EDA_REPORT.md, PREPROCESSING_REPORT.md |
| 2026-03-29 | UniversalBank 데이터로 전체 파이프라인 테스트 완료. v2 리팩토링 사항 도출 (7건) | docs/work-tracker.md |
| 2026-03-29 | 플러그인 네임스페이스 전환: `/da`, `/eda` 등 → `harnessda:스킬` 형식 통일. da.md 삭제, commands/ 제거 | 전체 스킬 SKILL.md, EDA_REPORT.md, PREPROCESSING_REPORT.md, data-profiler.md, CLAUDE.md, README.md, install/uninstall scripts |
| 2026-03-29 | help 스킬 생성 (da.md 라우터 대체) + tracker 스킬 생성 (work-tracker 자동 갱신) | skills/help/SKILL.md(신규), skills/tracker/SKILL.md(신규) |
| 2026-03-28 | report 스킬 생성 (마크다운/PPTX/HTML 보고서) | skills/report/*(5파일), da.md, viz/SKILL.md, CLAUDE.md, README.md, install/uninstall scripts |
| 2026-03-28 | stat-analyst 에이전트 제거 → /stat-analysis 스킬로 통합 | agents/stat-analyst.md(삭제), SKILL.md, SCAN_LOGIC.md, CELL_PATTERNS.md, da.md, CLAUDE.md, README.md |

## 진행 중 (In Progress)
- (없음)

## 대기열 (Backlog)
<!-- 우선순위 순, 각 항목에 WHY 포함 -->
### v2 리팩토링 (P0 — 구조적 변경)
1. ~~**eda/clean → py 스크립트 방식 전환**~~ ✅ — SKILL.md 경량화 + CELL_PATTERNS.md 분리. report 자동 연결 + update 인자 추가
2. **HTML PPT → 템플릿 + JSON 방식 전환** — 설계 완료. 다음 단계: frontend-design으로 template.html 1회 제작 → 구현 검증

### v2 리팩토링 (P1 — 즉시 수정 가능)
3. **스킬 네이밍 통일** — 플러그인화 이후 작업. 현재 콜론 포함 name은 플러그인 네임스페이스 전용으로 매칭 안 됨 (보류)
4. **da 라우터 제거 또는 경량화** — /da → /eda 중첩 로드로 스킬 2개분 컨텍스트 소모
5. **로컬 da-viz 구버전 삭제** — ~/.claude/skills/da-viz 잔존

### v2 리팩토링 (P2 — P0 완료 후)
6. **SKILL.md 경량화** — 코드 패턴 외부 파일 분리 (py 전환 시 자연 해결 가능)
7. **--notebook 옵션 구현** — py 전환 후 검증용 노트북 생성 (py → ipynb 변환)

### 기존 (완료/보류)
8. ~~**report 마크다운 테스트**~~ ✅ — UniversalBank 테스트에서 검증 완료
9. ~~**viz 실행 테스트**~~ ✅ — 공유 참조 문서로 전환 (charts/ 분리)
10. ~~**전체 파이프라인 통합 테스트**~~ ✅ — UniversalBank 데이터로 eda→clean→stat→report 완료
11. ~~**다른 데이터셋 범용성 테스트**~~ ✅ — UniversalBank(APT 외)로 검증 완료
12. **install.sh macOS 테스트** — 스크립트 작성 완료했으나 실행 검증 미완
13. **visualize 플러그인 graceful 처리** (보류) — 플러그인 미설치 시 에러 방지

## 보류/제외 (On Hold)
<!-- 의도적으로 안 하는 것 + 이유 — "왜 안 했지?" 방지 -->
| 항목 | 이유 | 재개 조건 |
|------|------|-----------|
| #3 스킬 네이밍 통일 | 플러그인 미전환 상태에서 콜론 포함 name 사용 불가 | 플러그인화 완료 후 |
| #5 visualize 의존성 | 사용자 보류 결정 | 사용자 요청 시 |
| #11 Linux 폰트 | macOS 전용 환경 | Linux 사용 시 |
| Tableau 연동 | 추후 학습 예정 | 사용자 학습 완료 후 |
| 피처 엔지니어링 | ML 단계에서 추가 | ML 워크플로우 구축 시 |

## 설계 결정 로그 (Decision Log)
<!-- 중요한 기술적 결정 — "왜 이렇게 했지?" 방지 -->
| 날짜 | 결정 | 근거 |
|------|------|------|
| 2026-03-30 | eda/clean: .py 실행 후 report 자동 연결 + update 인자 도입 | 스킬 내부 흐름은 끊지 않고, 스킬 간 전환에서만 사용자 판단. py 파일 잔존으로 수정 후 update 재실행 가능 |
| 2026-03-30 | P0-2: template.html = 슬라이드 컴포넌트 라이브러리, report_data.json = 명세서 구조 확정 | AI가 매번 2000줄 HTML 생성하는 토큰 낭비 제거. 1개 템플릿으로 도메인 5종 × 용도 2종 커버 |
| 2026-03-30 | 스킬 네이밍 통일(#3) → 보류. 플러그인화 이후 작업 | 콜론 포함 name은 플러그인 네임스페이스 전용, 현재 환경에서 매칭 불가 |
| 2026-03-29 | viz를 스킬에서 공유 참조 문서로 전환, charts/ 개별 파일 분리 | 시각화는 독립 스킬이 아닌 eda/stat에서 필요 시 참조하는 구조 |
| 2026-03-29 | v2 리팩토링 방향 확정: py 전환 + PPT 템플릿화 | UniversalBank 테스트에서 토큰 과다 소모 확인, 근본 원인은 노트북 생성 + HTML 직접 생성 |
| 2026-03-29 | 명령어 네임스페이스 `harnessda:스킬` 형식 통일 | 플러그인 전환 대비, 다른 플러그인과 동일한 호출 패턴 |
| 2026-03-29 | da.md 라우터 제거 → harnessda:help 스킬로 대체 | 라우터 커맨드 불필요, 플러그인 구조에서는 네임스페이스 자체가 라우팅 |
| 2026-03-29 | tracker 스킬 도입 (개발 전용) | work-tracker 수동 업데이트 부담 해소, 배포 시 제외 |
| 2026-03-28 | PPTX_PATTERNS.md 삭제 → frontend-design 플러그인으로 대체 | python-pptx 코드 패턴 불필요, 플러그인이 HTML 슬라이드 직접 생성 |
| 2026-03-28 | stat-analysis SKILL.md: 의사결정 트리 → TEST_SELECTION.md 참조 포인터로 교체 | 30줄 중복 제거, 단일 소스 유지 |
| 2026-03-28 | da.md에 실행 패턴 테이블 추가 (NotebookEdit vs .py vs Write) | 스킬 간 실행 방식 차이 명시적 문서화 |
| 2026-03-28 | REPORT_CONFIG_TEMPLATE.md: 하드코딩된 예시 → 제네릭 플레이스홀더 | 도메인 독립적 템플릿 유지 |
| 2026-03-28 | report 스킬: python-pptx + 순수 HTML 선택 (Marp/Reveal.js 제외) | Node.js 의존 제거, Python 생태계 통일, 오프라인 동작 |
| 2026-03-28 | report 스킬: 기본값 마크다운, pptx/html은 인자로 분기 | 가장 범용적인 형식을 기본값으로, Heavy-Task-Offload 패턴 적용 |
| 2026-03-28 | report 스킬: report_config.md 커스텀 시스템 도입 | 프로젝트 정보(목적/배경) + 슬라이드 순서 사용자 정의 |
| 2026-03-28 | stat-analyst 에이전트 제거 → /stat-analysis 스킬 통합 | 에이전트 오버헤드 제거, EDA/clean과 동일 구조 통일 |
| 2026-03-27 | data-profiler → /eda 위임 패턴 | EDA 로직 중복 제거, 단일 소스 유지 |
| 2026-03-27 | viz 누적바차트: pivot_table → crosstab | pivot_table aggfunc='count' NaN 취약점 |
| 2026-03-27 | stat-analyst: 에이전트 본체 + 참조 문서 분리 구조 채택 | 200줄 초과 방지, 역할별 분리 (SCAN_LOGIC, CELL_PATTERNS) |
| 2026-03-27 | stat-analysis SKILL.md: 귀무가설 우선 워크플로우 + n>5000 Jarque-Bera 분기 | 노션 통계 워크플로우 반영, 대표본 검정력 과잉 방지 |
| 2026-03-27 | stat-analysis: Levene + Welch + Tukey 추가 | 통계적 엄밀성 강화 |
| 2026-03-27 | data-clean: df.copy() 비파괴 패턴 | 원본 데이터 보존 원칙 |
| 2026-03-27 | 상관분석: pair-wise dropna | 독립 dropna 시 길이 불일치 버그 |
