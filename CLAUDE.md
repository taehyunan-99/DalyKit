# HarnessDA - 데이터 분석 하네스 플러그인

## 개요
주피터 노트북(.ipynb) 기반 데이터 분석 워크플로우 자동화 플러그인.
EDA, 전처리, 통계 분석, 시각화를 스킬/에이전트로 제공한다.

## 핵심 규칙

### 작업 환경
- **주피터 노트북(.ipynb)** 에서 작업하는 것을 전제
- **NotebookEdit** 도구로 셀 직접 작성
- 논리 단위로 셀 분리 (로드/탐색/시각화 각각 별도 셀)

### 코드 규칙
- 주석은 **한국어**로 작성
- 라이브러리: pandas, numpy, matplotlib, seaborn, scipy, statsmodels
- import문은 첫 번째 셀에 모아서 작성

### Heavy-Task-Offload (필수)
- **1000행 이상** 데이터 처리 시 별도 .py 스크립트로 분리
- 노트북에서는 결과 파일만 로드하여 요약 출력
- `df.head()`, `.describe()`, `.value_counts()` 등 요약 함수만 사용
- raw 데이터 전체 출력 **절대 금지**

### 플러그인 연동
- **visualize**: `/da report` (최종 보고서)에서만 사용
- **context7**: scipy, statsmodels 등 API 확인 시 참조
- **code-cleaner**: 분석 코드 정리 시 활용

## 스킬 목록
| 명령어 | 설명 |
|--------|------|
| `/eda` | 탐색적 데이터 분석 |
| `/data-clean` | 데이터 전처리 |
| `/stat-analysis` | 통계 분석 |
| `/da-viz` | 데이터 시각화 |
| `/da` | 허브 명령어 (라우팅) |

## 에이전트 목록
| 이름 | 설명 |
|------|------|
| `data-profiler` | 종합 데이터 프로파일링 |
| `stat-analyst` | 통계 분석 전문 |

## 확장 예정
- Tableau 연동 (추후 학습 후 추가)
- 피처 엔지니어링 (ML 단계에서 추가)
