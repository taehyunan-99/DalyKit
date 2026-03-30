# 슬라이드 기본 구조 — 데이터 분석 프로젝트 발표

## 설계 원칙

1. **스토리라인**: 문제 → 데이터 → 분석 → 발견 → 결론 (기승전결)
2. **문제 정의 우선**: 표지 다음에 "왜 이 분석을 했는가?"로 맥락 설정
3. **결론 = 문제의 답**: 마지막 슬라이드에서 첫 질문에 직접 답변
4. **1슬라이드 1메시지**: 정보 과밀 금지
5. **차트 > 텍스트**: 시각 자료 우선, 텍스트는 핵심만

## 기본 슬라이드 순서

| # | ID | 유형 | 내용 | 소스 |
|---|-----|------|------|------|
| 1 | `cover` | 표지 | 프로젝트명, 발표자, 날짜 | `report_config.md` / 추론 |
| 2 | `problem` | 문제 정의 | 배경, 목적, 해결하려는 질문 | `report_config.md` (핵심) |
| 3 | `data_overview` | 데이터 소개 | 출처, 규모(행×열), 주요 변수, 수집 기간 | `eda_report.md` §1 |
| 4 | `data_quality` | 데이터 품질 | 결측값 현황, 이상치, 타입 이슈 | `eda_report.md` §2-3 |
| 5 | `distributions` | 주요 분포 | 종속변수 중심 분포 차트 | `docs/figures/` 히스토그램 |
| 6 | `correlations` | 변수 관계 | 상관 히트맵 + 주요 관계 해석 | `docs/figures/` + `eda_report.md` §5 |
| 7 | `preprocessing` | 전처리 과정 | 전후 비교표, 핵심 처리 내용 | `preprocessing_report.md` §1-2 |
| 8 | `stat_results` | 분석 결과 | 가설 검정 요약 테이블 | `stat_report.md` §4 |
| 9 | `key_findings` | 핵심 발견 | 효과 크기 상위 3개 + 실질적 해석 | `stat_report.md` §5 |
| 마지막 | `conclusion` | 결론 | 문제에 대한 답, 한계점, 후속 제안 | 3개 보고서 종합 |

## 조건부 포함 규칙

| 슬라이드 | 조건 |
|----------|------|
| `cover` | 항상 포함 |
| `problem` | 항상 포함 (`report_config.md` 없으면 보고서에서 추론) |
| `data_overview` | `eda_report.md` 존재 시 |
| `data_quality` | `eda_report.md` 존재 시 |
| `distributions` | `docs/figures/` 히스토그램 존재 시 |
| `correlations` | `docs/figures/` 히트맵 또는 `eda_report.md` §5 존재 시 |
| `preprocessing` | `preprocessing_report.md` 존재 시 |
| `stat_results` | `stat_report.md` 존재 시 |
| `key_findings` | `stat_report.md` §5 존재 시 |
| `conclusion` | 항상 포함 |

## 콘텐츠 추출 가이드

### cover
- `report_config.md` → 프로젝트명, 발표자, 발표일
- 없으면: 데이터 파일명에서 프로젝트명 추론, 날짜는 오늘

### problem
- `report_config.md` → 목적, 배경, 해결하려는 문제
- 없으면: `eda_report.md` "분석 목적" 또는 `stat_report.md` "연구 개요"에서 추론
- **필수 요소**: "왜?" → "무엇을?" → "어떻게?"

### data_overview
- `eda_report.md` §1 "데이터 개요" → 행/열 수, 변수 유형 분포, 기간
- 핵심 수치만 추출 (전체 복사 금지)

### data_quality
- `eda_report.md` §2 결측값 + §3 이상치
- 결측률 높은 상위 3개 변수 + 이상치 주요 발견만

### distributions / correlations
- `docs/figures/` 이미지 파일명으로 유형 판별:
  - `hist_*`, `dist_*` → distributions
  - `heatmap_*`, `corr_*` → correlations
  - 나머지 → additional_charts
- 이미지당 1슬라이드 (대형 차트는 전체 슬라이드 사용)

### preprocessing
- `preprocessing_report.md` §1 전후 비교표 (행/열/결측/메모리)
- §2 처리 순서 요약 (상세 X, 핵심만)

### stat_results
- `stat_report.md` §4 요약 테이블 그대로 사용
- 열: 분석명, 검정, 통계량, p값, 결론, 효과 크기

### key_findings
- `stat_report.md` §5 핵심 발견
- 효과 크기 기준 상위 3개만
- 대표본 주의사항 포함

### conclusion
- 문제 정의에서 제기한 질문에 직접 답변
- 한계점: 각 보고서의 한계점 종합
- 후속 분석: 각 보고서의 추천사항 종합
