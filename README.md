# HarnessDA

Claude Code 하네스 플러그인 — 데이터 분석 워크플로우 자동화

## 개요

주피터 노트북(.ipynb) 기반 데이터 분석을 자동화하는 Claude Code 스킬/에이전트 모음.
EDA, 전처리, 통계 분석, 시각화를 명령어 하나로 수행한다.

## 스킬

| 명령어 | 설명 |
|--------|------|
| `/eda` | 탐색적 데이터 분석 — 데이터 구조, 결측값, 분포, 상관관계 |
| `/data-clean` | 데이터 전처리 — 결측값, 중복, 이상치, 타입 변환 |
| `/stat-analysis` | 통계 분석 — 가설 검정, 상관분석, 회귀분석 |
| `/da-viz` | 데이터 시각화 — matplotlib/seaborn 차트 |
| `/da` | 허브 명령어 — 위 스킬들을 라우팅 |

## 에이전트

| 이름 | 설명 |
|------|------|
| `data-profiler` | 종합 데이터 프로파일링 (EDA + 품질 평가) |
| `stat-analyst` | 통계 분석 전문 (검정 선택 + 해석) |

## 설치

**macOS / Linux:**
```bash
./scripts/install.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\install.ps1
```

설치 후 Claude Code에서 `/da`로 사용 가능.

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
/da                    스킬 목록 보기
/da eda data.csv       EDA 실행
/da clean              데이터 전처리
/da stat "두 그룹 비교"  통계 분석
/da viz                시각화
/da profile data.csv   종합 프로파일링
/da report             최종 보고서 (HTML)
```

## 기술 스택

- Python: pandas, numpy, matplotlib, seaborn, scipy, statsmodels
- 작업 환경: Jupyter Notebook (.ipynb)
- 연동: visualize(보고서), context7(문서 참조)

## 확장 예정

- Tableau 연동
- 피처 엔지니어링 (ML 단계)
