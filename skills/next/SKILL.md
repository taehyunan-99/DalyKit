---
name: next
description: >
  현재 활성 kit과 stage 산출물을 읽어 다음에 실행할 명령을 추천한다.
  트리거: "dalykit:next", "다음 단계", "다음에 뭐해?".
user_invocable: true
---

# Next (다음 단계 추천)

> `active.json`, `data/raw/`, `domain.md`, 각 stage 산출물을 읽어 다음 명령 1개를 추천한다.

## 사용법

```text
dalykit:next
```

## 사전 조건

- `dalykit/config/active.json`과 `dalykit/kits/`가 있으면 그것을 기준으로 판단한다
- 없으면 `dalykit:init`을 먼저 실행하라고 안내한다

## 판단 순서

### 1단계: 초기화 확인

- `dalykit/config/active.json` 또는 `dalykit/kits/`가 없으면:
  - 추천: `dalykit:init`
  - 이유: 프로젝트가 아직 초기화되지 않았다

### 2단계: 원본 데이터 확인

- `dalykit/data/raw/`에 CSV 또는 Excel 파일이 없으면:
  - 추천: `dalykit/data/raw/`에 파일 배치
  - 이유: 분석할 원본 데이터가 아직 없다

### 3단계: 데이터 선택 / 도메인 구조화 확인

- `active.json.raw_data`가 비어 있거나 `domain.md` 구조화 정보가 대부분 비어 있으면:
  - 추천: `dalykit:domain`
  - 이유: 사용할 원본 데이터와 타겟/도메인 맥락이 아직 정리되지 않았다

### 4단계: 분리 보고서 단계 확인

- 아래 결과 파일이 있는데 완료 단계가 비어 있으면 report 명령을 우선 추천한다
  - `eda/eda_results.json` 존재 + `eda` 미완료 → `dalykit:eda report`
  - `clean/clean_results.json` 또는 `clean/cleaned.csv` 존재 + `clean` 미완료 → `dalykit:clean report`
  - `feature/feature_results.json` 또는 `feature/featured.csv` 존재 + `feature` 미완료 → `dalykit:feature report`
  - `model/model_results.json` 존재 + `model` 미완료 → `dalykit:ml report`

### 5단계: 기본 파이프라인 추천

파이프라인 순서:

```text
eda → clean → stat → feature → ml → ml report
```

- 완료 단계가 비어 있으면 → `dalykit:eda`
- `eda`만 완료면 → `dalykit:clean`
- `clean`까지 완료면 → `dalykit:stat`
- `stat`까지 완료면 → `dalykit:feature`
- `feature`까지 완료면 → `dalykit:ml`

### 6단계: 완료 후 안내

- `model`까지 완료면:
  - 추천: `dalykit:kit new {stage}` 또는 `dalykit:progress`
  - 이유: 기본 파이프라인은 완료되었고 이제 분기/비교 단계다

## 출력 형식

아래 형식으로 간결하게 출력한다.

```text
현재 kit: k1
완료 단계: eda, clean
다음 추천: dalykit:stat
이유: clean까지 완료되었고 stat이 아직 실행되지 않았습니다.
```

## 규칙

1. `next`는 파일을 생성하지 않는다
2. `stages_completed`를 직접 수정하지 않는다
3. 결과 파일 존재 여부와 완료 단계를 함께 본다
4. 추천은 항상 1개만 우선 제시한다
