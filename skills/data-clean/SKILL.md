---
name: data-clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  노트북을 생성한다.
  트리거: "harnessda:clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

> ipynb 노트북 생성 → 사용자가 직접 실행 → `harnessda:report`로 보고서 생성.

## 사용법

```
harnessda:clean            ← data/ → 전처리 전략 제안 → clean_pipeline.ipynb 생성
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 원본 데이터 | `harnessda/data/` |
| 전처리 결과 | `harnessda/data/cleaned/` |
| 노트북 | `harnessda/code/clean_pipeline.ipynb` |

## 워크플로우

### 1단계: 현재 상태 파악

- `harnessda/docs/eda_report.md`가 있으면 Read로 읽고, 결측값·이상치·타입 이슈를 파악하여 전처리 전략에 반영
- 없으면 `harnessda/data/` 파일을 직접 프로파일링 (dtypes, 결측값, 중복 수 확인)

### 2단계: 전처리 전략 제안

발견된 이슈를 기반으로 처리 방법을 텍스트로 제안 후 사용자 확인:
- 결측값: drop vs impute (평균/중앙값/최빈값/보간)
- 중복: 제거 여부
- 이상치: IQR vs Z-score vs 유지
- 타입 변환: object → datetime, numeric, category 등

### 3단계: ipynb 노트북 생성

> `CELL_PATTERNS.md`를 Read로 읽고 셀 구조를 따른다.

- Write 도구로 `harnessda/code/clean_pipeline.ipynb` 생성 (nbformat 4)
- 생성 완료 후 사용자에게 안내:
  ```
  clean_pipeline.ipynb 생성 완료.
  노트북을 열어 전체 셀을 실행한 뒤 `harnessda:report`를 실행하세요.
  전처리 결과는 harnessda/data/cleaned/ 에 저장됩니다.
  ```

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |
| `PREPROCESSING_REPORT.md` | (report 스킬용) 전처리 보고서 작성 지침 |

## 코드 생성 규칙

1. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
2. **비파괴적**: `df_clean = df.copy()`로 원본 보존
3. **이상치**: 자동 제거하지 않고 탐지만 → 셀 출력으로 사용자에게 확인
4. **저장 경로**: `harnessda/data/cleaned/파일명_cleaned.csv`
