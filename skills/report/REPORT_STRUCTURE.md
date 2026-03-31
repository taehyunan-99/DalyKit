# 보고서 섹션 구조 — 데이터 분석 프로젝트 보고서

## 설계 원칙

1. **스토리라인**: 문제 → 데이터 → 분석 → 발견 → 결론 (기승전결)
2. **문제 정의 우선**: 표지 다음에 "왜 이 분석을 했는가?"로 맥락 설정
3. **결론 = 문제의 답**: 마지막 섹션에서 첫 질문에 직접 답변
4. **1섹션 1메시지**: 정보 과밀 금지
5. **차트 > 텍스트**: 시각 자료 우선, 텍스트는 핵심만

## 기본 섹션 순서

| # | ID | 유형 | 내용 | 소스 |
|---|-----|------|------|------|
| 1 | `cover` | 표지 | 프로젝트명, 작성자, 날짜 | `harnessda/config/report_config.md` / 추론 |
| 2 | `problem` | 문제 정의 | 배경, 목적, 해결하려는 질문, 산업적 가치, 기대 효과 | `harnessda/config/report_config.md` (핵심) |
| 3 | `data_overview` | 데이터 소개 | 출처, 규모(행×열), 주요 변수, 수집 기간 | `harnessda/docs/eda_report.md` §1 |
| 4 | `data_quality` | 데이터 품질 | 결측값 현황, 이상치, 타입 이슈 | `harnessda/docs/eda_report.md` §2-3 |
| 5 | `distributions` | 주요 분포 | 종속변수 중심 분포 차트 | `harnessda/figures/` 히스토그램 |
| 6 | `correlations` | 변수 관계 | 상관 히트맵 + 주요 관계 해석 | `harnessda/figures/` + `harnessda/docs/eda_report.md` §5 |
| 7 | `preprocessing` | 전처리 과정 | 전후 비교표, 핵심 처리 내용 | `harnessda/docs/preprocessing_report.md` §1-2 |
| 8 | `hypothesis` | 가설 수립 및 검증 | 가설 통합 표 (근거·검증방법·채택 여부) | `harnessda/docs/stat_report.md` §3 |
| 9 | `stat_results` | 분석 결과 | 가설 검정 상세 (통계량·p값·효과 크기) | `harnessda/docs/stat_report.md` §4 |
| 10 | `key_findings` | 핵심 발견 | 효과 크기 상위 3개 + 현장 제어 가능성 | `harnessda/docs/stat_report.md` §5 |
| 11 | `application` | 적용 시나리오 | 분석 결과의 실제 활용 방안, 신규 데이터 적용 | `harnessda/config/report_config.md` + 분석 결과 |
| 마지막 | `conclusion` | 결론 | 문제에 대한 답, 한계점(3분류), 후속 제안 | 3개 보고서 종합 |

## 조건부 포함 규칙

| 섹션 | 조건 |
|------|------|
| `cover` | 항상 포함 |
| `problem` | 항상 포함 (`report_config.md` 없으면 보고서에서 추론) |
| `data_overview` | `harnessda/docs/eda_report.md` 존재 시 |
| `data_quality` | `harnessda/docs/eda_report.md` 존재 시 |
| `distributions` | `harnessda/figures/` 히스토그램 존재 시 |
| `correlations` | `harnessda/figures/` 히트맵 또는 `harnessda/docs/eda_report.md` §5 존재 시 |
| `preprocessing` | `harnessda/docs/preprocessing_report.md` 존재 시 |
| `hypothesis` | `harnessda/docs/stat_report.md` §3 가설 통합 표 존재 시 |
| `stat_results` | `harnessda/docs/stat_report.md` 존재 시 |
| `key_findings` | `harnessda/docs/stat_report.md` §5 존재 시 |
| `application` | `harnessda/config/report_config.md` 적용 시나리오 기입 시 또는 key_findings 존재 시 |
| `conclusion` | 항상 포함 |

## 콘텐츠 추출 가이드

### cover
- `harnessda/config/report_config.md` → 프로젝트명, 작성자, 날짜
- 없으면: 데이터 파일명에서 프로젝트명 추론, 날짜는 오늘

### problem
- `harnessda/config/report_config.md` → 목적, 배경, 해결하려는 문제
- **추론 시 참조 우선순위** (`report_config.md` 없거나 항목 미입력 시):
  1. `harnessda/docs/eda_report.md` §1 데이터 개요 + §7 종합 판단 → 분석 목적 추론
  2. `harnessda/docs/stat_report.md` §1 연구 개요 → 핵심 연구 질문 추론
  3. 데이터 파일명 + 주요 변수명 → 도메인(금융/의료/제조 등) 추론
- **서술 구조** (반드시 이 순서로):
  1. **왜?** — 이 분석이 필요하게 된 배경/문제 상황
  2. **무엇을?** — 해결하려는 핵심 질문 (1~2문장)
  3. **어떻게?** — 사용한 데이터와 분석 방법 개요
  4. **가치는?** — 해결 시 기대되는 산업적/비즈니스 효과
- `report_config.md`에 산업적 가치·기대 효과 항목이 있으면 반드시 포함

### data_overview
- `harnessda/docs/eda_report.md` §1 "데이터 개요" → 행/열 수, 변수 유형 분포, 기간
- 핵심 수치만 추출 (전체 복사 금지)

### data_quality
- `harnessda/docs/eda_report.md` §2 결측값 + §3 이상치
- 결측률 높은 상위 3개 변수 + 이상치 주요 발견만

### distributions / correlations
- `harnessda/figures/` 이미지 파일명으로 유형 판별 (Glob으로 탐색):

| 파일명 패턴 | 포함 섹션 | 설명 |
|------------|----------|------|
| `dist_*` | distributions | 변수 분포 히스토그램/바차트 |
| `heatmap_*` | correlations | 상관관계 히트맵 |
| `scatter_*` | correlations | 산점도 (EDA 탐색용) |
| `outlier_*` | data_quality | 이상치 시각화 |
| `missing_*` | data_quality | 결측값 시각화 |
| `stat_h{n}_*` | hypothesis + stat_results | 가설 번호별 검증 차트 (유의/비유의 모두) |
| `stat_insight_*` | key_findings | 효과 크기 상위 핵심 인사이트 차트 |

- 이미지당 1줄 해석 추가 (캡션 수준)
- `stat_h{n}_*` 파일은 해당 가설 번호와 매핑하여 포함: `stat_h1_boxplot.png` → 가설 1 검증 차트

### preprocessing
- `harnessda/docs/preprocessing_report.md` §1 전후 비교표 (행/열/결측/메모리)
- §2 처리 순서 요약 (상세 X, 핵심만)

### hypothesis
- `harnessda/docs/stat_report.md` §3 가설 통합 표 그대로 사용
- 열: 가설, 근거(EDA 관찰), 검증 방법, 결과, 채택 여부
- `stat_h{n}_*` 이미지를 가설 번호와 매핑하여 각 가설 아래 포함 (유의/비유의 모두 포함)
  - 유의: 채택 근거 시각화
  - 비유의: 기각 불가 근거 시각화 ("이 데이터에서는 차이가 없었다"의 증거)

### stat_results
- `harnessda/docs/stat_report.md` §3 개별 검정 결과 요약
- 열: 분석명, 검정, 통계량, p값, 결론, 효과 크기
- `hypothesis` 섹션과 중복 최소화 — 상세 수치 중심으로 작성

### key_findings
- `harnessda/docs/stat_report.md` §5 핵심 발견
- 효과 크기 기준 상위 3개만
- 현장 제어 가능성 표 포함
- 대표본 주의사항 포함
- `stat_insight_*` 이미지를 각 인사이트 항목과 함께 포함
- **서술 원칙**: 수치 나열이 아닌 액션 가능한 해석으로 작성
  - ❌ "변수A의 η²=0.14로 유의함"
  - ✅ "변수A를 현재 수준에서 X% 조정하면 Y 지표 개선이 기대됨 (η²=0.14, 큰 효과)"

### application
- `harnessda/config/report_config.md` 적용 시나리오 항목 참조
- 없으면: key_findings 결과에서 추론하여 작성
- **작성 포맷** (시나리오당 아래 구조 반복, 1~3개):

  ```markdown
  ### 시나리오 N: [시나리오명]
  - **적용 조건**: 어떤 상황/시점에서 이 분석 결과를 사용하는가
  - **활용 방법**: 구체적으로 무엇을 어떻게 바꾸는가
  - **기대 효과**: 정량 추정 또는 정성적 기대 (수치 제시 권장)
  ```

- **추가 항목**:
  - 신규 데이터에 동일 분석 적용 가능성 (조건 명시)
  - 현장 적용 시 주의사항 (계절성, 샘플 편향 등)

### conclusion
- **서술 원칙**: problem 섹션에서 제기한 질문에 직접 답변으로 시작
  - ❌ "분석 결과를 종합하면 다음과 같다"
  - ✅ "핵심 질문 '[질문]'에 대해: [직접 답변 1~2문장]"
- **한계점 3분류** (각 분류당 1~3개 항목):
  - 데이터 한계: 수집 기간, 표본 편향, 변수 누락 등
  - 분석 한계: 인과관계 미확인, 교란변수, 가정 위반 등
  - 추가 데이터 필요성: 더 나은 분석을 위해 필요한 데이터
- 후속 분석: 각 보고서의 추천사항 종합

## 분량 가이드라인

| 항목 | 최소 권장 |
|------|---------|
| 섹션 수 | 8개 이상 |
| 표 수 | 5개 이상 |
| 시각화 수 | 5개 이상 |
