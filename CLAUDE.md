# HarnessDA - 데이터 분석 하네스 플러그인

## 작업 추적
- 상세 내용: @docs/work-tracker.md

## 개요
데이터 분석 워크플로우 자동화 플러그인.
EDA, 전처리, 통계 분석을 스킬/에이전트로 제공하며, 모든 결과물은 `harnessda/` 폴더에 저장된다.

## 프로젝트 구조

```
HarnessDA_Project/
├── CLAUDE.md
├── README.md
├── skills/
│   ├── init/         ← SKILL.md (harnessda/ 구조 초기화)
│   ├── eda/          ← SKILL.md, EDA_REPORT.md, CELL_PATTERNS.md
│   ├── clean/        ← SKILL.md, PREPROCESSING_REPORT.md, CELL_PATTERNS.md
│   ├── stat/         ← SKILL.md (+ 참조 문서 다수)
│   ├── viz/          ← STYLE_GUIDE.md, charts/*.md (공유 시각화 참조 문서)
│   ├── report/       ← SKILL.md, REPORT_STRUCTURE.md
│   └── help/         ← SKILL.md (스킬 목록 + 도움말)
├── templates/        ← 사용자 입력 템플릿 (프로젝트 공유 자산)
│   └── REPORT_CONFIG_TEMPLATE.md ← harnessda:init 으로 복사
├── agents/
│   └── data-profiler.md
└── scripts/
    ├── install.sh / install.ps1
    └── uninstall.sh / uninstall.ps1
```

## 핵심 규칙

### 작업 환경
- **모든 결과물**: `harnessda/` 폴더 하위에 저장 (`harnessda:init`으로 구조 생성)
- **eda/clean**: ipynb 노트북 생성 → 사용자 직접 실행 → `eda report` / `clean report`로 보고서 생성
- **stat**: .py 스크립트 생성 → 실행 → JSON 저장 → 보고서 자동 생성 (Heavy-Task-Offload 패턴)
- **stat notebook 인자**: .py → .ipynb 변환 (결과 확인용, 선택 사항)
- **report**: 기존 보고서 종합 → 마크다운 최종 보고서 생성
- **데이터 로드**: `harnessda/data/` 기준 상대경로 사용

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
| `harnessda:init` | 프로젝트 구조 초기화 |
| `harnessda:eda` | 탐색적 데이터 분석 |
| `harnessda:clean` | 데이터 전처리 |
| `harnessda:stat` | 통계 분석 |
| `harnessda:report` | 최종 보고서 (마크다운) |
| `harnessda:help` | 스킬 목록 + 도움말 |

## 에이전트 목록
| 이름 | 설명 |
|------|------|
| `data-profiler` | 종합 데이터 프로파일링 |

