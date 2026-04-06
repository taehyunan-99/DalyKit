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

```
📊 DalyKit — 데이터 분석 도구 모음

사용 가능한 스킬:
  dalykit:init               프로젝트 구조 초기화
  dalykit:domain             도메인 정보 구조화 (자유 입력 → domain.md)
  dalykit:eda                탐색적 데이터 분석 (EDA)
  dalykit:eda report         노트북 실행 후 EDA 보고서 생성
  dalykit:clean              데이터 전처리
  dalykit:clean report       노트북 실행 후 전처리 보고서 생성
  dalykit:stat               통계 분석 · 가설 검정
  dalykit:stat notebook      py → ipynb 변환
  dalykit:feature            피처 엔지니어링 — 인코딩, 스케일링, 파생 변수
  dalykit:feature report     노트북 실행 후 피처 보고서 생성
  dalykit:ml                 모델 자동 선택 (3-5개 비교) + 튜닝
  dalykit:ml LR,RF,XGB       지정 모델만 비교 + 튜닝
  dalykit:ml tune            기존 결과 기반 튜닝 재실행
  dalykit:ml ensemble        베이스라인 상위 모델로 앙상블 비교
  dalykit:ml report          결과 JSON → 보고서 + 시각화 생성
  dalykit:help               도움말

시작하기:
  1. dalykit:init 으로 프로젝트 구조 생성
  2. dalykit/data/ 에 CSV 파일 배치
  3. (선택) dalykit:domain 으로 도메인 정보 정리
  4. dalykit:eda → dalykit:clean → dalykit:stat
```

## 실행 패턴

| 스킬 | 방식 | 출력 |
|------|------|------|
| init | 폴더 생성 + 템플릿 복사 | dalykit/ 구조 |
| domain | 자유 입력 + CSV → domain.md 구조화 | config/domain.md |
| eda | ipynb 생성 → 사용자 실행 → `eda report`로 보고서 | code/, docs/, figures/ |
| clean | ipynb 생성 → 사용자 실행 → `clean report`로 보고서 | code/, data/, docs/ |
| stat | .py → JSON → 보고서 자동 | code/, docs/ |
| feature | ipynb 생성 → 사용자 실행 → `feature report`로 보고서 | code/, data/, docs/ |
| model | .py → 루프 실행 → JSON 저장 → `model report`로 보고서 | code/, docs/, models/, figures/ |

## 프로젝트 구조

```
dalykit/
├── config/          ← domain.md
├── data/            ← 원본 CSV + 전처리 결과 (_cleaned 접미사)
├── code/
│   ├── notebooks/   ← .ipynb 노트북 (eda, clean, stat)
│   ├── py/          ← .py 스크립트 (stat, feature, model)
│   └── results/     ← .json 결과
├── docs/            ← 보고서 (md)
└── figures/         ← 시각화 이미지
```
