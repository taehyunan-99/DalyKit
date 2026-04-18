---
name: help
description: >
  DalyKit 스킬 목록 및 사용법 안내.
  트리거: "dalykit:help", "스킬 목록", "도움말".
user_invocable: true
---

# DalyKit — 도움말

## 스킬 목록

아래 내용을 출력한다:

```text
DalyKit — 데이터 분석 도구 모음

처음 시작:
  1. dalykit:init
  2. dalykit/data/raw/ 에 CSV 파일 배치
  3. dalykit:next

이후에는 dalykit:next가 다음 할 일을 안내합니다.

기본 명령:
  dalykit:next               다음 단계 추천
  dalykit:eda                탐색적 데이터 분석
  dalykit:clean              데이터 전처리
  dalykit:stat               통계 분석
  dalykit:feature            피처 엔지니어링
  dalykit:ml                 모델 학습
  dalykit:ml report          모델 보고서 + 진행 현황 갱신
  dalykit:help               도움말

막혔을 때:
  dalykit:next               지금 다음에 무엇을 할지 다시 확인
  dalykit:doctor install     의존성 설치/업데이트
  dalykit:kit                현재 활성 kit 확인
  dalykit:progress           progress.md 생성/갱신

고급 명령 (Advanced):
  dalykit:doctor             환경 점검
  dalykit:domain             도메인 정보 구조화
  dalykit:kit new            새 kit 생성
  dalykit:kit new feature    feature 단계부터 새 kit 생성
  dalykit:kit list           전체 kit 목록 확인
  dalykit:kit switch k1      활성 kit 전환
  dalykit:eda report         EDA 보고서 생성
  dalykit:clean report       전처리 보고서 생성
  dalykit:stat notebook      py → ipynb 변환
  dalykit:feature select     피처 조합 비교
  dalykit:feature report     피처 보고서 생성
  dalykit:ml LR,RF,XGB       지정 모델만 비교 + 튜닝
  dalykit:ml ensemble        앙상블 비교
```

## 실행 패턴

| 스킬 | 방식 | 주요 위치 |
|------|------|-----------|
| init | kit 기반 구조 생성 | `dalykit/kits/k1/` |
| next | 현재 상태 기반 다음 단계 추천 | `dalykit/config/active.json`, `dalykit/kits/{kit}/` |
| doctor | 환경 점검 / 의존성 설치 | `dalykit/config/requirements.txt` |
| domain | 자유 입력 + raw 데이터 → 구조화 | `dalykit/config/domain.md` |
| kit | 활성 kit 확인 / 생성 / 전환 | `dalykit/config/active.json`, `dalykit/kits/` |
| progress | 전체 진행 현황 갱신 | `dalykit/config/progress.md` |
| eda | raw 데이터 → EDA 노트북/결과/보고서 | `dalykit/kits/{kit}/eda/` |
| clean | raw 또는 지정 데이터 → 전처리 결과 | `dalykit/kits/{kit}/clean/` |
| stat | clean 결과 기준 통계 분석 | `dalykit/kits/{kit}/stat/` |
| feature | clean 결과 기준 피처 엔지니어링 / 선택 | `dalykit/kits/{kit}/feature/` |
| ml | feature 결과 기준 모델 학습 | `dalykit/kits/{kit}/model/` |

## 프로젝트 구조

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
