# HarnessDA 아키텍처 결정 기록

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
- 명령어 호출 방식이 `/da eda`, `harnessda:eda` 등으로 혼재
- da.md 라우터가 스킬 2개분 컨텍스트를 소모하는 비효율 구조
- 실전 테스트(UniversalBank 데이터) 결과, 토큰 과다 소모 확인

### 실전 테스트 결과 (UniversalBank 5000행)
- **전체 파이프라인**: eda → clean → stat → report 완료
- **발견된 문제**: NotebookEdit 방식의 토큰 소모가 전체의 50% 이상
- **PPT 생성**: AI가 매번 2000줄 HTML을 직접 생성 → 토큰 비효율의 핵심 원인

### 주요 결정

| 결정 | 근거 |
|------|------|
| 명령어 네임스페이스 `harnessda:스킬` 형식 통일 | 플러그인 전환 대비, 일관된 호출 패턴 |
| da.md 라우터 제거 → harnessda:help로 대체 | 라우터 불필요, 네임스페이스 자체가 라우팅 역할 |
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
| 스킬 실행 시 현재 디렉토리 기준 | `harnessda:init`으로 표준 프로젝트 구조 생성 |
| 템플릿 수동 생성 (`eda domain`, `report config`) | init 시 자동 생성 |
| 출력물 위치 산발적 | `harnessda/` 하위에 체계적 정리 |

### 확정된 프로젝트 구조
```
project/
└── harnessda/
    ├── config/          ← domain.md, report_config.md (init 시 자동 생성)
    ├── data/            ← 원본 CSV (사용자가 넣는 곳)
    │   └── cleaned/     ← 전처리 결과
    ├── code/            ← .py 스크립트 (eda, clean, stat)
    ├── docs/            ← 보고서 (eda_report.md, preprocessing_report.md 등)
    └── figures/         ← 시각화 이미지
```

### 삭제 대상
- report 스킬 PPT 관련 파일 전체 (HTML_TEMPLATE.md, JSON_SCHEMA.md, SCHEMA_*.md, template.html 등)
- `harnessda:report pptx` 옵션
- `harnessda:report config` 옵션 (init으로 이전)

### 설계 원칙
- **harnessda/ 폴더 = 분석 워크스페이스**: 모든 입출력이 이 안에서 완결
- **init 필수**: 스킬 실행 시 harnessda/ 존재 여부로 초기화 상태 판단
- **경로 자동 해석**: 스킬이 harnessda/ 하위 경로를 자동으로 참조
