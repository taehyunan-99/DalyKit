# DalyKit

### Data Analysis Kit

> Claude Code 플러그인으로 데이터 분석 워크플로우를 kit 단위로 관리합니다.

![version](https://img.shields.io/badge/version-0.2.0-blue?style=flat)
![license](https://img.shields.io/badge/license-MIT-green?style=flat)
![python](https://img.shields.io/badge/python-3.10%2B-yellow?style=flat&logo=python&logoColor=white)
![platform](https://img.shields.io/badge/platform-Claude%20Code-orange?style=flat)

[English](./README.en.md) | 한국어

---

## What is DalyKit?

DalyKit은 EDA, 전처리, 통계 분석, 피처 엔지니어링, 머신러닝을 Claude Code 플러그인 형태로 묶은 데이터 분석 워크플로우 도구입니다.

이번 구조에서는 결과를 단계별 실행 이력이 아니라 `kit` 단위로 관리합니다. 즉, `k1`, `k2` 같은 분석 사이클이 독립된 폴더를 가지며, 피처를 다시 설계하거나 전처리 전략을 바꿔도 이전 시도와 섞이지 않습니다.

---

## Installation

> **필요 조건** [Claude Code](https://claude.ai/code)

```text
/plugin marketplace add taehyunan-99/DalyKit
/plugin install dalykit@taehyunan
```

설치 후 `dalykit:init`으로 시작합니다.

---

## Quick Start

```text
1. dalykit:init
2. dalykit/data/raw/ 에 CSV 파일 배치
3. dalykit:next
```

이후에는 `dalykit:next`가 다음 할 일을 1단계씩 안내합니다.

---

## Workflow

기본 흐름:

```text
dalykit:init → dalykit:next (반복)
```

`dalykit:next`가 안내하는 기본 순서:

```text
domain → eda → clean → stat → feature → ml → ml report
```

핵심 개념:

- 원본 데이터는 `dalykit/data/raw/`에 둡니다
- 각 분석 사이클은 `dalykit/kits/k1/`, `dalykit/kits/k2/`처럼 독립 관리합니다
- 현재 활성 kit은 `dalykit/config/active.json`이 가리킵니다
- 전체 진행 상황은 `dalykit/config/progress.md`로 요약합니다

---

## Project Structure

```text
dalykit/
├── config/
│   ├── domain.md
│   ├── requirements.txt
│   ├── active.json
│   └── progress.md
├── data/
│   └── raw/
└── kits/
    └── k1/
        ├── manifest.json
        ├── eda/
        ├── clean/
        ├── stat/
        ├── feature/
        └── model/
```

각 stage 내부에는 다음 산출물이 들어갑니다.

- `eda/`: `eda_analysis.ipynb`, `eda_results.json`, `eda_report.md`, `figures/`
- `clean/`: `clean_pipeline.ipynb`, `clean_results.json`, `clean_report.md`, `cleaned.csv`, `figures/`
- `stat/`: `stat_analysis.py`, `stat_analysis.ipynb`, `stat_results.json`, `stat_report.md`, `figures/`
- `feature/`: `feature_pipeline.ipynb`, `feature_results.json`, `feature_select.py`, `feature_select_results.json`, `selected_features.txt`, `feature_report.md`, `featured.csv`, `figures/`
- `model/`: `model_train.py`, `model_results.json`, `model_report.md`, `models/`, `figures/`

---

## Skills

### 기본

| 명령어 | 설명 | 주요 산출물 |
|--------|------|-------------|
| `dalykit:init` | kit 기반 프로젝트 구조 초기화 | `dalykit/kits/k1/` |
| `dalykit:next` | 다음 단계 추천 | — |
| `dalykit:eda` | EDA 노트북 생성 | `kits/{kit}/eda/eda_analysis.ipynb` |
| `dalykit:clean` | 전처리 노트북 생성 | `kits/{kit}/clean/clean_pipeline.ipynb` |
| `dalykit:stat` | 통계 분석 스크립트 생성/실행 + 자동 보고서 | `kits/{kit}/stat/` |
| `dalykit:feature` | 피처 엔지니어링 노트북 생성 | `kits/{kit}/feature/feature_pipeline.ipynb` |
| `dalykit:ml` | 모델 학습 및 비교 | `kits/{kit}/model/` |
| `dalykit:ml report` | 모델 보고서 생성 + progress 갱신 | `kits/{kit}/model/model_report.md` |
| `dalykit:help` | 도움말 | — |

### 고급 (Advanced)

| 명령어 | 설명 | 주요 산출물 |
|--------|------|-------------|
| `dalykit:doctor` | 환경 점검 | Python / 패키지 상태 |
| `dalykit:doctor install` | 의존성 설치 | 현재 Python/conda 환경 |
| `dalykit:domain` | 도메인 정보 구조화 | `config/domain.md` |
| `dalykit:kit` | 활성 kit 확인 | `config/active.json` |
| `dalykit:kit new` | 새 kit 생성 | `kits/kN/` |
| `dalykit:kit list` | kit 목록 요약 | `kits/` 스캔 결과 |
| `dalykit:kit switch k1` | 활성 kit 전환 | `config/active.json` |
| `dalykit:progress` | 진행 현황 문서 갱신 | `config/progress.md` |
| `dalykit:eda report` | EDA 보고서 생성 | `kits/{kit}/eda/eda_report.md` |
| `dalykit:clean report` | 전처리 보고서 생성 | `kits/{kit}/clean/clean_report.md` |
| `dalykit:stat notebook` | stat py → ipynb 변환 | `kits/{kit}/stat/stat_analysis.ipynb` |
| `dalykit:feature select` | 피처 조합 CV 비교 | `kits/{kit}/feature/feature_select_results.json` |
| `dalykit:feature report` | 피처 보고서 생성 | `kits/{kit}/feature/feature_report.md` |
| `dalykit:ml LR,RF,XGB` | 지정 모델만 비교 | `kits/{kit}/model/` |
| `dalykit:ml ensemble` | 앙상블 비교 | `kits/{kit}/model/model_results.json` |

---

## Kit Management

`dalykit:kit`은 DalyKit의 핵심 관리 명령입니다.

예:

```text
dalykit:kit new feature
```

이 명령은 새 kit을 만들고, 이전 kit의 필요한 선행 산출물을 복사한 뒤 feature 단계부터 다시 시작하게 합니다.

이 구조의 장점:

- `k1`이 마음에 들지 않으면 `k2`를 새로 만들어 독립적으로 시도 가능
- 이전 kit을 버려도 새 kit이 자체 입력 파일을 가지고 있어 유지 가능
- 보고서, figures, 모델 파일이 모두 같은 kit 아래 묶여 추적이 쉬움

---

## Contact

- GitHub: [taehyunan-99/DalyKit](https://github.com/taehyunan-99/DalyKit)
