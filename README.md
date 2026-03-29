# HarnessDA

Claude Code 하네스 플러그인 — 데이터 분석 워크플로우 자동화

## 개요

주피터 노트북(.ipynb) 기반 데이터 분석을 자동화하는 Claude Code 스킬/에이전트 모음.
EDA, 전처리, 통계 분석, 시각화를 명령어 하나로 수행한다.

## 스킬

| 명령어 | 설명 |
|--------|------|
| `harnessda:eda` | 탐색적 데이터 분석 — 데이터 구조, 결측값, 분포, 상관관계 |
| `harnessda:clean` | 데이터 전처리 — 결측값, 중복, 이상치, 타입 변환 |
| `harnessda:stat` | 통계 분석 — 가설 검정, 상관분석, 회귀분석 |
| `harnessda:report` | 최종 보고서 — 마크다운/PPTX/HTML |
| `harnessda:help` | 스킬 목록 + 도움말 |

## 에이전트

| 이름 | 설명 |
|------|------|
| `data-profiler` | 종합 데이터 프로파일링 (EDA + 품질 평가) |

## 설치

**macOS / Linux:**
```bash
./scripts/install.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\install.ps1
```

설치 후 Claude Code에서 `harnessda:help`로 사용 가능.

## 제거

**macOS / Linux:**
```bash
./scripts/uninstall.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\uninstall.ps1
```

## 사용법

```
harnessda:help             스킬 목록 보기
harnessda:eda              탐색적 데이터 분석 (EDA)
harnessda:clean            데이터 전처리
harnessda:stat             통계 분석 · 가설 검정
harnessda:report           최종 보고서 (마크다운)
harnessda:report pptx      슬라이드형 HTML 생성
harnessda:report config    보고서 설정 템플릿 생성
harnessda:tracker          work-tracker 업데이트 (개발 전용)
```

모든 스킬은 현재 디렉토리의 데이터/노트북을 자동 탐색합니다.

## 기술 스택

- Python: pandas, numpy, matplotlib, seaborn, scipy, statsmodels
- 작업 환경: Jupyter Notebook (.ipynb)
- 연동: context7(문서 참조)

## 확장 예정

- Tableau 연동
- 피처 엔지니어링 (ML 단계)
