# DalyKit 아키텍처 결정 기록

> 프로젝트의 설계 결정과 그 배경을 시간순으로 기록한다.
> 포트폴리오 작성 시 "왜 이런 구조를 선택했는가"의 근거로 활용.

---

## Phase 1: 초기 설계 (2026-03-27)

### 목표
Claude Code의 스킬/에이전트 시스템을 활용하여 데이터 분석 워크플로우(EDA → 전처리 → 통계 분석 → 보고서)를 자동화하는 플러그인 개발.

### 주요 결정

| 결정 | 근거 |
|------|------|
| 주피터 노트북(.ipynb) 기반 작업 환경 | 데이터 분석의 표준 환경, 인터랙티브 탐색에 최적 |
| NotebookEdit 도구로 셀 직접 생성 | Claude Code가 노트북 셀을 프로그래밍 방식으로 조작 가능 |
| 스킬 단위 분리 (eda, clean, stat, report) | 단계별 독립 실행 + 조합 가능한 파이프라인 구조 |
| stat-analyst를 에이전트로 분리 | 통계 분석의 복잡도가 높아 별도 컨텍스트 필요하다고 판단 |
| data-profiler 에이전트 도입 | EDA 위임 패턴으로 로직 중복 제거 |

### 기술적 결정 상세

- **상관분석: pair-wise dropna** — 독립 dropna 시 변수 간 길이 불일치 버그 발견
- **data-clean: df.copy() 비파괴 패턴** — 원본 데이터 보존 원칙
- **stat-analysis: 귀무가설 우선 워크플로우** — 통계 교재 워크플로우 반영
- **n>5000일 때 Jarque-Bera 분기** — 대표본에서 Shapiro-Wilk의 검정력 과잉 문제 방지
- **Levene + Welch + Tukey 추가** — 등분산 가정 없이도 견고한 검정 체계
- **viz 누적바차트: pivot_table → crosstab** — pivot_table aggfunc='count'의 NaN 취약점 해결

---

## Phase 2: 구조 개선 (2026-03-28)

### 문제 인식
- stat-analyst 에이전트가 불필요한 오버헤드 발생 → 스킬로 통합이 효율적
- 보고서 기능 필요성 대두 (분석 결과를 문서화하는 단계 부재)

### 주요 결정

| 결정 | 근거 |
|------|------|
| stat-analyst 에이전트 → stat-analysis 스킬 통합 | 에이전트 오버헤드 제거, eda/clean과 동일한 스킬 구조로 통일 |
| report 스킬 신규 생성 | 분석 결과 종합 문서화 단계 추가 |
| report 기본값 = 마크다운, pptx/html은 인자 분기 | 가장 범용적인 형식을 기본으로, Heavy-Task-Offload 패턴 적용 |
| python-pptx + 순수 HTML 선택 (Marp/Reveal.js 제외) | Node.js 의존 제거, Python 생태계 통일, 오프라인 동작 보장 |
| report_config.md 커스텀 시스템 도입 | 프로젝트 정보(목적/배경) + 슬라이드 순서를 사용자가 정의 |
| SKILL.md 참조 문서 분리 (SCAN_LOGIC, CELL_PATTERNS 등) | 200줄 초과 방지, 역할별 파일 분리로 유지보수성 확보 |

---

## Phase 3: 네임스페이스 통일 + 실전 테스트 (2026-03-29)

### 문제 인식
- 명령어 호출 방식이 `/da eda`, `dalykit:eda` 등으로 혼재
- da.md 라우터가 스킬 2개분 컨텍스트를 소모하는 비효율 구조
- 실전 테스트(UniversalBank 데이터) 결과, 토큰 과다 소모 확인

### 실전 테스트 결과 (UniversalBank 5000행)
- **전체 파이프라인**: eda → clean → stat → report 완료
- **발견된 문제**: NotebookEdit 방식의 토큰 소모가 전체의 50% 이상
- **PPT 생성**: AI가 매번 2000줄 HTML을 직접 생성 → 토큰 비효율의 핵심 원인

### 주요 결정

| 결정 | 근거 |
|------|------|
| 명령어 네임스페이스 `dalykit:스킬` 형식 통일 | 플러그인 전환 대비, 일관된 호출 패턴 |
| da.md 라우터 제거 → dalykit:help로 대체 | 라우터 불필요, 네임스페이스 자체가 라우팅 역할 |
| viz를 독립 스킬에서 공유 참조 문서로 전환 | 시각화는 eda/stat에서 필요 시 참조하는 구조가 적합 |
| charts/ 개별 파일 분리 (9개) | 필요한 차트만 선택적으로 로드 → 토큰 절약 |
| v2 리팩토링 방향 확정: py 전환 + PPT 템플릿화 | 토큰 과다 소모의 근본 원인 해결 |

---

## Phase 4: v2 리팩토링 착수 (2026-03-30)

### 실행된 개선
- **eda/clean → .py 스크립트 방식 전환 완료** — SKILL.md 경량화 + CELL_PATTERNS.md 분리
- **PPT 템플릿 설계 완료** — template.html(컴포넌트 라이브러리) + report_data.json(명세서) 구조
- **update 인자 도입** — py 파일 수정 후 재실행 가능

### PPT 템플릿 설계 (후에 폐기)
- 도메인 5종 테마/색상 확정
- JSON 스키마 3파일 분리 (SCHEMA_COMMON / SCHEMA_DOMAIN / SCHEMA_PORTFOLIO)
- 목표: AI가 매번 HTML 생성하는 대신, 1개 템플릿으로 도메인 5종 × 용도 2종 커버

---

## Phase 5: 구조 재설계 — PPT 폐기 + init 도입 (2026-03-30)

### 문제 인식
PPT(HTML 슬라이드) 기능의 근본적 한계를 인정:
- **퀄리티 추구 시**: 토큰 소모가 과도 (2000줄+ HTML, 복잡한 JSON 스키마)
- **토큰 절약 시**: 결과물 품질이 수동 제작보다 못함
- **결론**: PPT는 AI 자동화의 ROI가 낮음. 마크다운 보고서 품질 향상에 집중하는 것이 현실적

### 핵심 방향 전환
| Before | After |
|--------|-------|
| 마크다운 + PPT(HTML) 이중 보고서 | 마크다운 보고서 단일화, 품질 집중 |
| 스킬 실행 시 현재 디렉토리 기준 | `dalykit:init`으로 표준 프로젝트 구조 생성 |
| 템플릿 수동 생성 (`eda domain`, `report config`) | init 시 자동 생성 |
| 출력물 위치 산발적 | `dalykit/` 하위에 체계적 정리 |

### 확정된 프로젝트 구조
```
project/
└── dalykit/
    ├── config/          ← domain.md, report_config.md (init 시 자동 생성)
    ├── data/            ← 원본 CSV (사용자가 넣는 곳)
    │   └── cleaned/     ← 전처리 결과
    ├── code/            ← .py 스크립트 (eda, clean, stat)
    ├── docs/            ← 보고서 (eda_report.md, preprocessing_report.md 등)
    └── figures/         ← 시각화 이미지
```

### 삭제 대상
- report 스킬 PPT 관련 파일 전체 (HTML_TEMPLATE.md, JSON_SCHEMA.md, SCHEMA_*.md, template.html 등)
- `dalykit:report pptx` 옵션
- `dalykit:report config` 옵션 (init으로 이전)

### 설계 원칙
- **dalykit/ 폴더 = 분석 워크스페이스**: 모든 입출력이 이 안에서 완결
- **init 필수**: 스킬 실행 시 dalykit/ 존재 여부로 초기화 상태 판단
- **경로 자동 해석**: 스킬이 dalykit/ 하위 경로를 자동으로 참조

---

## Phase 6: v3 구조 재설계 실행 완료 (2026-03-31)

### 실행된 변경

Phase 5 설계를 전면 구현. 10개 태스크 완료.

| 항목 | Before | After |
|------|--------|-------|
| 결과물 경로 | 현재 디렉토리 기준 산발 | `dalykit/` 하위 통일 |
| 프로젝트 초기화 | 없음 | `dalykit:init` 스킬 추가 |
| 보고서 형식 | 마크다운 + PPT(HTML) | 마크다운 단일화 |
| 노트북 변환 | 없음 | `notebook` 인자 → .py → .ipynb |
| 스킬 목록 | eda, clean, stat, report, help, tracker | init, eda, data-clean, stat-analysis, report, help |

### 스킬별 경로 변경 요약

| 스킬 | 주요 경로 변경 |
|------|--------------|
| init | (신규) `dalykit/` 구조 생성 + templates/ 복사 |
| eda | `code/` → `dalykit/code/`, `docs/` → `dalykit/docs/`, `figures/` → `dalykit/figures/` |
| data-clean | `data/cleaned/` → `dalykit/data/cleaned/`, `code/` → `dalykit/code/` |
| stat-analysis | `data/cleaned/` → `dalykit/data/cleaned/`, `code/` → `dalykit/code/` |
| report | PPT 옵션 제거, 출력 → `dalykit/docs/report.md` |

### 폐기된 기능
- `dalykit:report pptx` — PPT/HTML 슬라이드 생성
- `dalykit:tracker` — work-tracker 자동 업데이트 (개발 전용, 배포 제외)
- `HTML_TEMPLATE.md`, `JSON_SCHEMA.md`, `SCHEMA_*.md` — PPT 템플릿 관련 파일 전체

### data-profiler 에이전트 재설계 방향 (진행 예정)
- **유지**: 프로파일링(1단계) + 자율 판단(2단계)
- **제외**: 파이프라인 자율 실행(3단계) — 토큰 ~27,000 소모 + 중간 개입 불가
- **강화**: 분석 흐름 자율 결정 + "왜 이상한지" 해석 포함

---

## Phase 8: data-profiler 에이전트 재설계 완료 (2026-03-31)

### 주요 결정

| 결정 | 근거 |
|------|------|
| NotebookEdit 제거 → .py 스크립트 방식 통일 | v3 전환 일관성. 노트북 직접 편집은 토큰 과다 소모 |
| 3단계 구조 확립 (사전 준비 → 프로파일링 → 자율 판단) | 에이전트는 해석에서 똑똑하고 실행은 스킬에 위임 |
| domain.md 3단계 활용 모델 | 사전 읽기(제외 컬럼·규칙 파악) → 분석 중 적용(이상치 필터) → 사후 맥락화(해석) |
| 이상치 해석 Level B 기본 / Level C 타겟 변수 한정 | Level C(교차 패턴)는 stat 스킬과 중복, 타겟 관련만 가치 있음 |
| 흐름 판단 결정 테이블 도입 | 품질 점수 기준으로 data-clean 필수/선택/생략 판단 자동화 |
| 판단 근거 3구조 필수 명시 | 결정 1문장 + 근거 1-2개 + 주의사항 → 블랙박스 방지, 학습 효과 |
| 출력: JSON + profile_report.md + 5-10줄 요약 반환 | Heavy-Task-Offload 패턴 준수, 컨텍스트 오염 방지 |
| DOMAIN_TEMPLATE.md에 컬럼 설명 섹션 추가 | 제어 가능 여부 컬럼 → stat 현장 제어 가능성 표 자동 연결 |

### 파일 변경

| 파일 | 변경 내용 |
|------|-----------|
| `agents/data-profiler.md` | 전면 재설계. 경로 dalykit/ 기준, NotebookEdit 제거, 3단계 구조·결정 테이블·해석 깊이 규칙 추가 |
| `templates/DOMAIN_TEMPLATE.md` | 컬럼 설명 섹션 추가 (컬럼명·설명·단위·제어 가능 여부 표) |

---

## Phase 7: 보고서 품질 보강 (2026-03-31)

### 문제 인식
기존 보고서가 통계 수치 나열에 그쳐, 기획서 요구 수준(가설 수립·검증, 산업적 가치, 적용 시나리오, 한계점)에 미달.

### 주요 결정

| 결정 | 근거 |
|------|------|
| EDA 보고서에 가설 후보 표 추가 | stat 스킬이 EDA 관찰을 근거로 가설을 수립할 수 있도록 연결 고리 마련 |
| stat 보고서에 가설 통합 표 + 현장 제어 가능성 표 추가 | 단순 검정 결과가 아닌 "무엇을 제어할 수 있는가"의 실용적 해석 강제 |
| SLIDE_STRUCTURE.md → REPORT_STRUCTURE.md 이름 변경 | PPT 시절 잔재 파일명이 혼란 유발, 역할(마크다운 보고서 구조) 명확화 |
| hypothesis 섹션과 stat_results 섹션 분리 유지 | "가설 수립 근거"(EDA 관찰)와 "검정 상세 수치"는 역할이 달라 통합하면 섹션 과밀 |
| report_config.md에 산업적 가치·기대 효과·적용 시나리오 필드 추가 | 보고서에 비즈니스 맥락이 없으면 기술 보고서에 그침 |
| conclusion에 한계점 3분류 구조화 | 데이터 한계 / 분석 한계 / 추가 데이터 필요성을 구분하여 후속 분석 방향을 명확하게 제시 |

### 시각화 저장 전략

**결정**: 가설 검증 근거 + 핵심 인사이트 차트만 저장 (탐색용 임시 차트 저장 금지)

| 저장 대상 | 파일명 컨벤션 | 이유 |
|-----------|--------------|------|
| 가설 검증 시각화 (유의/비유의 모두) | `stat_h{n}_{유형}.png` | 채택/기각 양쪽이 모두 근거 자료 |
| 핵심 인사이트 차트 | `stat_insight_{col}.png` | key_findings 섹션 뒷받침 |
| 타겟 분포 / 상관 히트맵 | `dist_{col}.png`, `heatmap_corr.png` | EDA 핵심 관찰 시각화 |

> 비유의(H0 기각 불가) 결과도 저장: "이 데이터에서는 차이가 없었다"는 것 자체가 근거.

### 파일별 변경 요약

| 파일 | 변경 내용 |
|------|-----------|
| `skills/eda/EDA_REPORT.md` | 가설 후보 표(§7) + figures 파일명 컨벤션 참조 방식 추가 |
| `skills/stat-analysis/REPORT_GUIDE.md` | 가설 통합 표 + 현장 제어 가능성 표 + stat figures 참조 방식 추가 |
| `skills/report/REPORT_STRUCTURE.md` | 신규 생성. hypothesis/application 섹션 추가, 파일명→섹션 매핑 표 정의 |
| `templates/REPORT_CONFIG_TEMPLATE.md` | 산업적 가치·기대 효과·적용 시나리오 필드 추가, PPT 잔재 제거 |
| `skills/eda/CELL_PATTERNS.md` | `save_fig()` 유틸 + 조건부 저장 패턴 추가 |
| `skills/stat-analysis/CODE_PATTERNS.md` | 검정별 시각화 저장 패턴 + 각 함수 return에 `figure_path` 필드 추가 |
