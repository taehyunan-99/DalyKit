---
name: clean
description: >
  데이터 전처리 파이프라인. 결측값, 중복, 이상치, 타입 변환을 처리하는
  노트북을 생성한다.
  트리거: "dalykit:clean", "전처리", "결측값 처리", "clean this data",
  "데이터 정제", "missing values", "이상치 제거".
user_invocable: true
---

# Data Clean (데이터 전처리)

> ipynb 노트북 생성 → 사용자가 직접 실행 → `dalykit:clean report`로 보고서 생성.

## 사용법

```
dalykit:clean              ← data/ → 전처리 전략 제안 → clean_pipeline.ipynb 생성
dalykit:clean report       ← 실행된 노트북 결과 읽기 → dalykit/docs/preprocessing_report.md 생성
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 원본 데이터 | `dalykit/data/` |
| 전처리 결과 | `dalykit/data/` |
| 노트북 | `dalykit/code/notebooks/clean_pipeline.ipynb` |
| JSON 결과 | `dalykit/code/results/clean_results.json` |

## 워크플로우

### 1단계: 현재 상태 파악

- `dalykit/docs/eda_report.md`가 있으면 Read로 읽고, 결측값·이상치·타입 이슈를 파악하여 전처리 전략에 반영
- 없으면 `dalykit/data/` 파일을 직접 프로파일링 (dtypes, 결측값, 중복 수 확인)

### 2단계: ipynb 노트북 생성

> `~/.claude/skills/clean/CELL_PATTERNS.md`를 Read로 읽고 셀 구조를 따른다.

- Write 도구로 `dalykit/code/notebooks/clean_pipeline.ipynb` 생성 (nbformat 4)
- 생성 완료 후 사용자에게 안내:
  ```
  clean_pipeline.ipynb 생성 완료.
  노트북을 열어 전체 셀을 실행한 뒤 `dalykit:clean report`를 실행하세요.
  전처리 결과는 dalykit/data/ 에 저장됩니다.
  ```

### report 인자 워크플로우

> `dalykit:clean report` 호출 시 실행. 노트북을 사용자가 실행한 뒤 호출해야 한다.

1. `dalykit/code/results/clean_results.json` Read → 전처리 결과 데이터 확인
2. `~/.claude/skills/clean/PREPROCESSING_REPORT.md` Read → 보고서 작성 지침 확인
3. `dalykit/docs/preprocessing_report.md` Write → 보고서 생성
4. JSON 미존재 시: "노트북을 먼저 실행한 뒤 다시 시도하세요." 안내 후 종료

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |
| `PREPROCESSING_REPORT.md` | (report 스킬용) 전처리 보고서 작성 지침 |

## 코드 생성 규칙

1. **주석은 한국어**: 각 처리 단계에 왜 이 방법을 선택했는지 주석으로 설명
2. **비파괴적**: `df_clean = df.copy()`로 원본 보존
3. **결측값 전략**: 결측 비율 기준으로 자동 선택
   - > 50%: 열 제거 권고 (셀 출력으로 사용자 확인)
   - 5~50%: 그룹별 중앙값 (domain.md 타겟 기준) → fallback 단순 중앙값
   - < 5%: 단순 중앙값/최빈값 대체
   - 복잡한 패턴: IterativeImputer 셀 별도 제공 (주석 처리, 선택 실행)
4. **이상치**: 탐지만 자동 실행 → 처리 옵션(IQR 제거 / 클리핑) 셀을 주석 처리로 미리 제공 → 사용자가 보고서 확인 후 주석 해제 → 노트북 재실행 → `dalykit:clean report` 재실행으로 보고서 갱신
5. **저장 경로**: `dalykit/data/파일명_cleaned.csv`
