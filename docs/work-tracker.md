# DalyKit Work Tracker
<!-- Claude 전용: 새 컨텍스트에서 작업 이어가기 위한 상태 문서 -->
<!-- 마지막 업데이트: 2026-04-05 -->

## 현재 상태 (Current State)
> ML 파이프라인(feature + model 스킬) 구현 완료. 기존 스킬(eda/clean/stat) 경로를 code/notebooks/, code/py/, code/results/ 하위 구조로 마이그레이션. init 스킬에 models/ 폴더 추가.

## 최근 변경 (Recent Changes)
<!-- 직전 세션에서 한 일 — 최대 5개, LIFO -->
| 날짜 | 변경 | 영향 파일 |
|------|------|-----------|
| 2026-04-05 | ML 파이프라인 구현 완료 — feature 스킬(ipynb 방식), model 스킬(.py 루프 방식) 신규 추가. 기존 스킬 경로 마이그레이션(code/notebooks/, code/py/, code/results/). 모든 보고서에 ## 요약 섹션 추가. domain.md에 실행 환경 + ML 목표 섹션 추가 | skills/feature/SKILL.md(신규), skills/feature/CELL_PATTERNS.md(신규), skills/model/SKILL.md(신규), skills/model/MODEL_CATALOG.md(신규), skills/model/REPORT_GUIDE.md(신규), skills/eda/*, skills/clean/*, skills/stat/*, skills/init/SKILL.md, templates/DOMAIN_TEMPLATE.md, agents/data-profiler.md, skills/help/SKILL.md, scripts/*.sh, scripts/*.ps1, CLAUDE.md, README.md |
| 2026-04-04 | Harness Hook 시스템 구현(guard_write.py: 쓰기 경로 제한, guard_read.py: 대용량 Read 차단), init 스킬에 hook 설치 4단계 추가, install/uninstall 스크립트에 hooks 배포/제거 추가, data/cleaned/ → data/ 경로 전면 통일 | hooks/guard_write.py(신규), hooks/guard_read.py(신규), skills/init/SKILL.md, skills/clean/SKILL.md, skills/clean/CELL_PATTERNS.md, skills/clean/PREPROCESSING_REPORT.md, skills/stat/SKILL.md, skills/help/SKILL.md, scripts/*.sh, scripts/*.ps1 |
| 2026-04-04 | viz 폴더 skills/viz/ → shared/viz/ 이동(의미 명확화), install/uninstall 스크립트 정리(domain 추가, report/data-profiler 제거), eda/stat SKILL.md 및 CLAUDE.md 참조 경로 갱신 | shared/viz/(이동), scripts/*.sh, scripts/*.ps1, skills/eda/SKILL.md, skills/stat/SKILL.md, CLAUDE.md |
| 2026-04-04 | domain 스킬 신규 추가(자유 입력→구조화), 가상 시나리오 검토로 eda/clean/stat/help 상대경로 수정, DOMAIN_TEMPLATE.md 자유 입력 섹션 추가, data-profiler 에이전트 ML 단계 보류 결정 | skills/domain/SKILL.md(신규), templates/DOMAIN_TEMPLATE.md, skills/eda/SKILL.md, skills/clean/SKILL.md, skills/stat/SKILL.md, skills/help/SKILL.md, CLAUDE.md, docs/work-tracker.md |
| 2026-04-03 | 스킬명/폴더명 통일(data-clean→clean, stat-analysis→stat), eda/clean에 report 인자 추가, install/uninstall 스크립트에 viz/templates 배포 추가 + 제거 로직 수정, CLAUDE.md/help/README 문서 동기화 | skills/clean/, skills/stat/, eda/SKILL.md, clean/SKILL.md, scripts/*.sh, scripts/*.ps1, CLAUDE.md, help/SKILL.md, README.md |
| 2026-04-02 | EDA/전처리 실행 방식 전환: py→json→보고서 자동 → ipynb 생성 후 사용자 직접 실행. update/notebook 인자 제거. 보고서는 dalykit:report 별도 호출로 분리. CELL_PATTERNS.md ipynb 셀 구조로 전면 교체 | eda/SKILL.md, eda/CELL_PATTERNS.md, data-clean/SKILL.md, data-clean/CELL_PATTERNS.md |
| 2026-03-31 | v3 구조 재설계 완료. init 스킬 추가. 모든 경로 dalykit/ 기준 통일. PPT/HTML/tracker 폐기. notebook 인자 추가(eda/clean/stat). install/uninstall 스크립트 갱신. CLAUDE.md/README.md 갱신 | skills/init/SKILL.md(신규), eda/SKILL.md, eda/CELL_PATTERNS.md, data-clean/SKILL.md, data-clean/CELL_PATTERNS.md, stat-analysis/SKILL.md, stat-analysis/CELL_PATTERNS.md, report/SKILL.md, report/SLIDE_STRUCTURE.md, help/SKILL.md, scripts/*.sh, scripts/*.ps1, CLAUDE.md, README.md |
| 2026-03-30 | P0-2 설계 완료. 도메인 5종 테마/색상 확정. JSON 스키마 설계 + 3파일 분리(SCHEMA_COMMON/DOMAIN/PORTFOLIO). HTML_TEMPLATE.md 전면 개편. SKILL.md pptx 워크플로우 교체. templates/ 통합 | report/SKILL.md, report/HTML_TEMPLATE.md, report/JSON_SCHEMA.md, report/SCHEMA_COMMON.md(신규), report/SCHEMA_DOMAIN.md(신규), report/SCHEMA_PORTFOLIO.md(신규), report/SLIDE_STRUCTURE.md, templates/DOMAIN_TEMPLATE.md(이동), templates/REPORT_CONFIG_TEMPLATE.md(이동) |
| 2026-03-30 | eda/clean SKILL.md → py 방식 전환 (NotebookEdit 제거). CELL_PATTERNS.md 신규 생성. report 인자 제거, update 인자 추가, 자동 보고서 연결 | eda/SKILL.md, eda/CELL_PATTERNS.md(신규), data-clean/SKILL.md, data-clean/CELL_PATTERNS.md(신규), stat-analysis/SKILL.md |
| 2026-03-29 | viz 스킬 → 공유 참조 문서 전환. CHART_PATTERNS.md → charts/ 개별 파일 분리(9개). SKILL.md 삭제 | skills/viz/*, eda/SKILL.md, stat-analysis/SKILL.md, CELL_PATTERNS.md, help/SKILL.md, CLAUDE.md, README.md, data-profiler.md, EDA_REPORT.md, PREPROCESSING_REPORT.md |

## 진행 중 (In Progress)
- 없음

## 대기열 (Backlog)
<!-- 우선순위 순, 각 항목에 WHY 포함 -->
### v3 후속 작업
1. ~~**하네스 시스템 추가**~~ ✅ — guard_write(쓰기 경로 제한) + guard_read(대용량 Read 차단) 구현 완료. PreToolUse hook으로 물리적 차단.
2. **init 인자 확장** — `dalykit:init current` (현재 디렉토리 기준 초기화) + `dalykit:init <name>` (지정 이름으로 프로젝트 생성) 인자 추가
3. **data-profiler 에이전트 재설계** — 경로 dalykit/ 기준 수정 + 자율 판단 강화 (1+2단계: 분석 흐름 결정 + 이상 해석). 3단계(파이프라인 자율 실행)는 토큰 비용으로 제외
4. **전체 파이프라인 통합 테스트** — init → eda → clean → stat → feature → model 새 경로 기준 검증
5. **install.sh macOS 테스트** — 스크립트 작성 완료했으나 실행 검증 미완
6. **report 스킬 경로 수정 + 완성** — 상대경로 → `~/.claude/skills/report/` 절대경로 수정 필요. ML 워크플로우 완성 후 전체 파이프라인 종합 보고서 용도로 활용 예정

### 완료
- ~~**v3 구조 재설계 10개 태스크**~~ ✅ — 2026-03-31 완료
- ~~**eda/clean → py 스크립트 방식 전환**~~ ✅
- ~~**report 마크다운 테스트**~~ ✅
- ~~**전체 파이프라인 통합 테스트 (UniversalBank)**~~ ✅

## 보류/제외 (On Hold)
<!-- 의도적으로 안 하는 것 + 이유 — "왜 안 했지?" 방지 -->
| 항목 | 이유 | 재개 조건 |
|------|------|-----------|
| #3 스킬 네이밍 통일 | 플러그인 미전환 상태에서 콜론 포함 name 사용 불가 | 플러그인화 완료 후 |
| #5 visualize 의존성 | 사용자 보류 결정 | 사용자 요청 시 |
| #11 Linux 폰트 | macOS 전용 환경 | Linux 사용 시 |
| Tableau 연동 | 추후 학습 예정 | 사용자 학습 완료 후 |
| ~~피처 엔지니어링~~ | ~~ML 단계에서 추가~~ | ✅ 2026-04-05 완료 |

## 설계 결정 로그 (Decision Log)
<!-- 중요한 기술적 결정 — "왜 이렇게 했지?" 방지 -->
| 날짜 | 결정 | 근거 |
|------|------|------|
| 2026-04-05 | feature = ipynb, model = .py 루프 방식으로 분리 | 피처 엔지니어링은 시행착오가 많아 사용자 직접 개입이 중요(ipynb). 모델 학습은 자동 루프에 적합(.py). 역할 명확 분리 |
| 2026-04-05 | 1회차 피처 진단 → 조기 종료 분기 | 헛된 튜닝 방지. 피처 문제가 있으면 튜닝해도 개선 없음 |
| 2026-04-05 | 루프 최대 5회 + 수렴 기준 0.5% | 토큰 소모 제한 + 실무에서 5회 이상 반복 시 수확 체감 |
| 2026-04-05 | 모든 보고서에 ## 요약 섹션 필수 | 후속 스킬의 컨텍스트 수집 시 요약 섹션만 Read하여 토큰 절약 (2단계 참조 패턴) |
| 2026-04-04 | viz를 skills/ → shared/로 이동 | viz는 독립 스킬이 아닌 공유 참조 문서. skills/ 안에 두는 것은 의미상 부정확. shared/viz/로 이동하여 구조 명확화 |
| 2026-04-04 | Harness Hook을 ~/.claude/hooks/ 원본 배포 + dalykit:init이 프로젝트에 설치하는 구조 채택 | 글로벌 ~/.claude/settings.json 직접 병합은 기존 설정 파괴 위험. 프로젝트 레벨 .claude/settings.json이 안전하고 git 공유 가능. init 시점에 설치하면 hook이 필요한 프로젝트에만 적용 |
| 2026-04-04 | Harness Hook v1 범위: 쓰기 경로 제한 + 대용량 Read 차단만 구현 | 도구-스킬 매칭(현재 스킬 감지 불가) 등 고난이도 제약은 제외. 효과 대비 난이도가 낮은 2가지만 우선 적용 |
| 2026-04-04 | data/cleaned/ 폴더 폐지 → data/ 단일 폴더로 통합 | 원본/전처리 파일을 같은 폴더에 저장하는 것이 단순하고 관리 용이. 파일명(_cleaned 접미사)으로 구분 |
| 2026-04-04 | data-profiler 에이전트를 install/uninstall 스크립트에서 제거 | ML 단계 재설계 예정이라 현재 배포해도 실질 활용 없음. 재설계 완료 후 재추가 예정 |
| 2026-04-04 | report 스킬을 install/uninstall 스크립트에서 제거 | ML 워크플로우 완성 후 종합 보고서 용도로 사용 예정. 현재 단계에서 배포 불필요 |
| 2026-04-03 | 스킬 폴더명/name 통일: data-clean→clean, stat-analysis→stat | 트리거 호출명(dalykit:clean, dalykit:stat)과 폴더명 불일치로 혼란 발생. 폴더명=스킬명=호출명 일치 원칙으로 정리 |
| 2026-04-03 | eda/clean에 `report` 인자 추가 | ipynb 전환 후 보고서 생성 주체 불명확. `dalykit:eda report` / `dalykit:clean report`로 명시적 호출하여 ipynb 실행 결과를 읽고 보고서 생성 |
| 2026-04-03 | stat은 .py 방식 유지 (ipynb 전환 안 함) | 통계 분석은 가정 검정→본 검정→사후 분석이 자동 분기되어야 하므로 스크립트 실행+JSON 결과 방식이 적합. 사용자 중간 개입이 검정 흐름에서는 불필요 |
| 2026-04-02 | EDA/전처리: py→json→보고서 자동 방식 → ipynb 직접 생성 방식으로 전환 | 토큰 ~30-50% 절감 + 셀 단위 수정/재실행으로 분석 퀄리티 향상. 자동화 편의성 일부 감소는 트레이드오프로 수용 |
| 2026-04-02 | EDA/전처리: update/notebook 인자 제거 | ipynb가 기본이 되면서 두 인자 모두 불필요. 보고서는 dalykit:report 별도 호출로 분리 |
| 2026-03-31 | v3: 모든 결과물 dalykit/ 하위 통일, init 스킬 추가 | 사용자 프로젝트 폴더 오염 방지. dalykit:init 한 번으로 표준 구조 생성 |
| 2026-03-31 | v3: PPT/HTML 슬라이드 완전 폐기 → 마크다운 단일 출력 | 템플릿 방식도 토큰 비용 대비 활용도 낮음. 마크다운으로 충분 |
| 2026-03-31 | data-profiler: 파이프라인 자율 실행(3단계) 제외 | ~27,000 토큰 소모 + 중간 개입 불가. 1+2단계(프로파일링+판단)만 유지 |
| 2026-03-30 | eda/clean: .py 실행 후 report 자동 연결 + update 인자 도입 | 스킬 내부 흐름은 끊지 않고, 스킬 간 전환에서만 사용자 판단. py 파일 잔존으로 수정 후 update 재실행 가능 |
| 2026-03-30 | P0-2: template.html = 슬라이드 컴포넌트 라이브러리, report_data.json = 명세서 구조 확정 | AI가 매번 2000줄 HTML 생성하는 토큰 낭비 제거. 1개 템플릿으로 도메인 5종 × 용도 2종 커버 |
| 2026-03-30 | 스킬 네이밍 통일(#3) → 보류. 플러그인화 이후 작업 | 콜론 포함 name은 플러그인 네임스페이스 전용, 현재 환경에서 매칭 불가 |
| 2026-03-29 | viz를 스킬에서 공유 참조 문서로 전환, charts/ 개별 파일 분리 | 시각화는 독립 스킬이 아닌 eda/stat에서 필요 시 참조하는 구조 |
| 2026-03-29 | v2 리팩토링 방향 확정: py 전환 + PPT 템플릿화 | UniversalBank 테스트에서 토큰 과다 소모 확인, 근본 원인은 노트북 생성 + HTML 직접 생성 |
| 2026-03-29 | 명령어 네임스페이스 `dalykit:스킬` 형식 통일 | 플러그인 전환 대비, 다른 플러그인과 동일한 호출 패턴 |
| 2026-03-29 | da.md 라우터 제거 → dalykit:help 스킬로 대체 | 라우터 커맨드 불필요, 플러그인 구조에서는 네임스페이스 자체가 라우팅 |
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
