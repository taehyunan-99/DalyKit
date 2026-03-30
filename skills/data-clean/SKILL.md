---
name: data-clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  .py 스크립트를 생성한다.
  트리거: "harnessda:clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

> .py 스크립트 생성 → 실행 → JSON → 보고서 자동 생성 (Heavy-Task-Offload).

## 사용법

```
harnessda:clean            ← data/ → 전처리 → cleaned/ 저장 + 보고서
harnessda:clean update     ← 기존 py 재실행 → 결과 갱신
harnessda:clean notebook   ← clean_pipeline.py → ipynb 변환
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 원본 데이터 | `harnessda/data/` |
| 전처리 결과 | `harnessda/data/cleaned/` |
| 스크립트 | `harnessda/code/clean_pipeline.py` |
| JSON 결과 | `harnessda/code/clean_results.json` |
| 보고서 | `harnessda/docs/preprocessing_report.md` |

## 워크플로우

### 1단계: 현재 상태 파악

- `harnessda/docs/eda_report.md`가 있으면 Read로 읽고, 결측값·이상치·타입 이슈를 파악하여 전처리 전략에 반영
- 없으면 `harnessda/data/` 파일을 직접 프로파일링 (dtypes, 결측값, 중복 수 확인)
- 사용자에게 전처리 방향 확인 (자동/수동 선택)

### 2단계: 전처리 전략 제안

발견된 이슈를 기반으로 처리 방법을 텍스트로 제안:
- 결측값: drop vs impute (평균/중앙값/최빈값/보간)
- 중복: 제거 여부
- 이상치: IQR vs Z-score vs 유지
- 타입 변환: object → datetime, numeric, category 등

### 3단계: .py 스크립트 생성 + 실행

> `CELL_PATTERNS.md`를 Read로 읽고 파일 구조를 따른다.

- Write 도구로 `harnessda/code/clean_pipeline.py` 생성
- Bash 도구로 `python harnessda/code/clean_pipeline.py` 실행 → `harnessda/code/clean_results.json` + `harnessda/data/cleaned/` 저장

### 4단계: 전처리 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

1. `harnessda/code/clean_results.json` 읽고 분석
2. 전처리 보고서를 작성하여 `harnessda/docs/preprocessing_report.md`에 저장
3. 보고서 구조와 작성 규칙은 **PREPROCESSING_REPORT.md** 참조

## update 인자 처리

`harnessda:clean update` 호출 시:

1. `harnessda/code/clean_pipeline.py` 존재 여부 확인 (Glob)
2. **있으면**: py 재실행 → JSON 갱신 → report 갱신 (py 생성 스킵)
3. **없으면**: "clean_pipeline.py를 찾을 수 없습니다. `harnessda:clean`을 먼저 실행하세요." 안내 후 종료

## notebook 인자 처리

`harnessda:clean notebook` 호출 시:

1. `harnessda/code/clean_pipeline.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `harnessda/code/clean_pipeline.ipynb` 변환
3. **없으면**: "clean_pipeline.py를 찾을 수 없습니다. `harnessda:clean`을 먼저 실행하세요." 안내 후 종료

변환 방법은 eda의 notebook 변환과 동일.

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json) |
| `PREPROCESSING_REPORT.md` | 전처리 보고서 자동 생성 지침 |

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 모든 데이터 처리는 .py 스크립트에서 수행
2. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
3. **비파괴적**: `df_clean = df.copy()`로 원본 보존
4. **단계별 JSON 저장**: 처리 결과를 `harnessda/code/clean_results.json`에 구조화하여 저장
5. **이상치**: 자동 제거하지 않고 탐지만 → 사용자에게 판단 요청
6. **저장 경로**: `harnessda/data/cleaned/파일명_cleaned.csv`
