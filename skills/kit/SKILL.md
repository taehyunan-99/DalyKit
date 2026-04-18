---
name: kit
description: >
  DalyKit kit 관리. 현재 활성 kit 확인, 새 kit 생성, 목록 조회, 전환을 수행한다.
  트리거: "dalykit:kit", "dalykit:kit new", "dalykit:kit list", "dalykit:kit switch".
user_invocable: true
---

# Kit (kit 관리)

> `config/active.json`과 `kits/` 디렉토리를 기준으로 분석 kit을 관리한다.

## 사용법

```text
dalykit:kit
dalykit:kit new
dalykit:kit new feature
dalykit:kit list
dalykit:kit switch k1
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- `dalykit/kits/`가 있어야 한다
- 없으면 `dalykit:init`을 먼저 실행하라고 안내한다

## 동작 규칙

### `dalykit:kit`

- 현재 활성 kit
- raw_data
- 완료 단계
- 주요 산출물 경로

를 요약 출력한다.

### `dalykit:kit list`

- `dalykit/kits/` 하위의 `k*` 디렉토리를 스캔한다
- 각 kit별 완료 단계와 마지막 수정 시각을 표로 요약한다

### `dalykit:kit new`

1. 현재 최대 kit 번호를 확인하고 다음 번호를 계산한다
2. `dalykit/kits/k{n}/` 생성
3. `manifest.json` 생성
4. `active.json.kit`을 새 kit으로 변경
5. `start_stage`는 기본 `eda`
6. `stages_completed`와 `artifacts`는 비운다

### `dalykit:kit new {stage}`

지원 시작 단계:

- `clean`
- `stat`
- `feature`
- `model`

규칙:

1. 새 kit 생성
2. 이전 활성 kit에서 해당 단계의 입력으로 필요한 산출물만 새 kit 내부에 복사
3. 복사한 입력 경로를 새 kit의 `manifest.json`에 기록
4. `active.json.start_stage`를 인자 값으로 설정

예:

- `dalykit:kit new feature`
  - 이전 kit의 `eda/eda_results.json`, `eda/eda_report.md`, `clean/cleaned.csv`, `clean/clean_results.json`, `clean/clean_report.md`, `stat/stat_results.json`, `stat/stat_report.md`만 새 kit에 복사
  - 노트북(`*.ipynb`), 실행 스크립트(`*.py`), `figures/` 디렉토리는 기본 복사 대상이 아니다
  - 새 kit에서는 `feature`, `model`을 다시 생성

### `dalykit:kit switch k1`

1. 대상 kit 존재 여부 확인
2. 존재하면 `active.json.kit`만 변경
3. 현재 kit의 `manifest.json`과 실제 파일 존재 여부를 기준으로 `artifacts`를 재구성
4. 없으면 에러 메시지 후 종료
