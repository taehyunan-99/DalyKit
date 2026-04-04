# DalyKit

Claude Code 데이터 분석 워크플로우 자동화 플러그인 DalyKit(데일리킷)

## 개요

데이터 분석 워크플로우를 자동화하는 Claude Code 스킬/에이전트 모음.
EDA, 전처리, 통계 분석을 명령어 하나로 수행하며, 모든 결과물은 `dalykit/` 폴더에 저장된다.

## 스킬

| 명령어 | 설명 |
|--------|------|
| `dalykit:init` | 프로젝트 구조 초기화 — `dalykit/` 폴더 생성 |
| `dalykit:domain` | 도메인 정보 입력 → `domain.md` 구조화 |
| `dalykit:eda` | 탐색적 데이터 분석 — 데이터 구조, 결측값, 분포, 상관관계 |
| `dalykit:clean` | 데이터 전처리 — 결측값, 중복, 이상치, 타입 변환 |
| `dalykit:stat` | 통계 분석 — 가설 검정, 상관분석, 회귀분석 |
| `dalykit:feature` | 피처 엔지니어링 — 인코딩, 스케일링, 파생 변수 |
| `dalykit:model` | 모델 학습 · 평가 — 자동 루프, 튜닝 |
| `dalykit:report` | 최종 보고서 — 마크다운 |
| `dalykit:help` | 스킬 목록 + 도움말 |

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

설치 후 Claude Code에서 `dalykit:help`로 사용 가능.

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
dalykit:init               프로젝트 구조 초기화
dalykit:domain             도메인 정보 입력 → domain.md 구조화
dalykit:help               스킬 목록 보기
dalykit:eda                탐색적 데이터 분석 (EDA)
dalykit:eda report         노트북 실행 후 EDA 보고서 생성
dalykit:clean              데이터 전처리
dalykit:clean report       노트북 실행 후 전처리 보고서 생성
dalykit:stat               통계 분석 · 가설 검정
dalykit:stat update        기존 분석 재실행
dalykit:stat notebook      py → ipynb 변환
dalykit:feature            피처 엔지니어링
dalykit:feature report     노트북 실행 후 피처 보고서 생성
dalykit:model              모델 학습 · 평가 (자동 루프)
dalykit:model LR,XGB       지정 모델만 학습
dalykit:model tune         하이퍼파라미터 튜닝
dalykit:model report       모델 평가 보고서 생성
```

시작하기:
1. `dalykit:init` 으로 프로젝트 구조 생성
2. `dalykit/data/` 에 CSV 파일 배치
3. `dalykit:eda` → `dalykit:clean` → `dalykit:stat` → `dalykit:feature` → `dalykit:model`

## 기술 스택

- Python: pandas, numpy, matplotlib, seaborn, scipy, statsmodels, scikit-learn, joblib
- 연동: context7(문서 참조)

## 확장 예정

- 비지도 학습 (클러스터링, 차원 축소), 시계열
