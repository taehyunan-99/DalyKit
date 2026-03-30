# HarnessDA

Claude Code 하네스 플러그인 — 데이터 분석 워크플로우 자동화

## 개요

데이터 분석 워크플로우를 자동화하는 Claude Code 스킬/에이전트 모음.
EDA, 전처리, 통계 분석을 명령어 하나로 수행하며, 모든 결과물은 `harnessda/` 폴더에 저장된다.

## 스킬

| 명령어 | 설명 |
|--------|------|
| `harnessda:init` | 프로젝트 구조 초기화 — `harnessda/` 폴더 생성 |
| `harnessda:eda` | 탐색적 데이터 분석 — 데이터 구조, 결측값, 분포, 상관관계 |
| `harnessda:data-clean` | 데이터 전처리 — 결측값, 중복, 이상치, 타입 변환 |
| `harnessda:stat-analysis` | 통계 분석 — 가설 검정, 상관분석, 회귀분석 |
| `harnessda:report` | 최종 보고서 — 마크다운 |
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
harnessda:init                    프로젝트 구조 초기화
harnessda:help                    스킬 목록 보기
harnessda:eda                     탐색적 데이터 분석 (EDA)
harnessda:eda update              기존 분석 재실행
harnessda:eda notebook            py → ipynb 변환
harnessda:data-clean              데이터 전처리
harnessda:data-clean update       기존 전처리 재실행
harnessda:data-clean notebook     py → ipynb 변환
harnessda:stat-analysis           통계 분석 · 가설 검정
harnessda:stat-analysis update    기존 분석 재실행
harnessda:stat-analysis notebook  py → ipynb 변환
harnessda:report                  최종 마크다운 보고서
```

시작하기:
1. `harnessda:init` 으로 프로젝트 구조 생성
2. `harnessda/data/` 에 CSV 파일 배치
3. `harnessda:eda` → `harnessda:data-clean` → `harnessda:stat-analysis` → `harnessda:report`

## 기술 스택

- Python: pandas, numpy, matplotlib, seaborn, scipy, statsmodels
- 연동: context7(문서 참조)

## 확장 예정

- Tableau 연동
- 피처 엔지니어링 (ML 단계)
