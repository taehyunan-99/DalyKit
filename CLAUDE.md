# HarnessDA - 데이터 분석 하네스 플러그인

## 작업 추적
- 상세 내용: @docs/work-tracker.md

## 개요
주피터 노트북(.ipynb) 기반 데이터 분석 워크플로우 자동화 플러그인.
EDA, 전처리, 통계 분석, 시각화를 스킬/에이전트로 제공한다.

## 프로젝트 구조

```
HarnessDA_Project/
├── CLAUDE.md
├── README.md
├── skills/
│   ├── eda/          ← SKILL.md, EDA_REPORT.md, CELL_PATTERNS.md
│   ├── data-clean/   ← SKILL.md, PREPROCESSING_REPORT.md, CELL_PATTERNS.md
│   ├── stat-analysis/← SKILL.md (+ 참조 문서 다수)
│   ├── viz/          ← STYLE_GUIDE.md, charts/*.md (공유 시각화 참조 문서)
│   ├── report/       ← SKILL.md, SLIDE_STRUCTURE.md, HTML_TEMPLATE.md
│   ├── help/         ← SKILL.md (스킬 목록 + 도움말)
│   └── tracker/      ← SKILL.md (work-tracker 자동 업데이트, 개발 전용)
├── templates/        ← 사용자 입력 템플릿 (프로젝트 공유 자산)
│   ├── DOMAIN_TEMPLATE.md       ← harnessda:eda domain 으로 복사
│   └── REPORT_CONFIG_TEMPLATE.md ← harnessda:report config 으로 복사
├── agents/
│   └── data-profiler.md
└── scripts/
    ├── install.sh / install.ps1
    └── uninstall.sh / uninstall.ps1
```

## 핵심 규칙

### 작업 환경
- **eda/clean/stat**: .py 스크립트 생성 → 실행 → JSON 저장 → 보고서 자동 생성 (Heavy-Task-Offload 패턴)
- **report**: JSON 읽어 마크다운/HTML 보고서 생성
- **노트북**: 결과 확인용으로만 사용 (선택 사항)
- **데이터 로드**: `os.chdir(DATA_DIR)` 후 파일명만으로 로드. DATA_DIR은 프로젝트 기준 상대경로 사용 (예: `'data/'`)

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
- **context7**: scipy, statsmodels 등 API 확인 시 참조
- **code-cleaner**: 분석 코드 정리 시 활용

## 스킬 목록
| 명령어 | 설명 |
|--------|------|
| `harnessda:eda` | 탐색적 데이터 분석 |
| `harnessda:clean` | 데이터 전처리 |
| `harnessda:stat` | 통계 분석 |
| `harnessda:report` | 최종 보고서 (마크다운/PPTX/HTML) |
| `harnessda:help` | 스킬 목록 + 도움말 |
| `harnessda:tracker` | work-tracker.md 자동 업데이트 (개발 전용) |

## 에이전트 목록
| 이름 | 설명 |
|------|------|
| `data-profiler` | 종합 데이터 프로파일링 |

