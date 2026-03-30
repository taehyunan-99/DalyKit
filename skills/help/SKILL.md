---
name: help
description: >
  HarnessDA 스킬 목록 및 사용법 안내.
  트리거: "harnessda:help", "스킬 목록", "도움말".
user_invocable: true
---

# HarnessDA — 도움말

## 스킬 목록

아래 내용을 출력한다:

```
📊 HarnessDA — 데이터 분석 도구 모음

사용 가능한 스킬:
  harnessda:init                    프로젝트 구조 초기화
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
  harnessda:help                    도움말

에이전트:
  data-profiler               종합 프로파일링 (Agent 도구로 호출)

시작하기:
  1. harnessda:init 으로 프로젝트 구조 생성
  2. harnessda/data/ 에 CSV 파일 배치
  3. harnessda:eda → harnessda:data-clean → harnessda:stat-analysis → harnessda:report
```

## 실행 패턴

| 스킬 | 방식 | 출력 |
|------|------|------|
| init | 폴더 생성 + 템플릿 복사 | harnessda/ 구조 |
| eda | .py → JSON → 보고서 | code/, docs/, figures/ |
| data-clean | .py → JSON → cleaned CSV + 보고서 | code/, data/cleaned/, docs/ |
| stat-analysis | .py → JSON → 보고서 | code/, docs/ |
| report | 보고서 종합 → 최종 보고서 | docs/report.md |

## 프로젝트 구조

```
harnessda/
├── config/          ← domain.md, report_config.md
├── data/            ← 원본 CSV
│   └── cleaned/     ← 전처리 결과
├── code/            ← .py 스크립트 + .json 결과
├── docs/            ← 보고서 (md)
└── figures/         ← 시각화 이미지
```
