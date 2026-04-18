---
name: progress
description: >
  DalyKit 진행 현황 문서를 생성하거나 갱신한다.
  트리거: "dalykit:progress", "진행 현황", "progress.md".
user_invocable: true
---

# Progress (진행 현황)

> `active.json`, `kits/`, 각 단계 보고서를 읽어 `config/progress.md`를 갱신한다.

## 사용법

```text
dalykit:progress
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- `dalykit/kits/`가 있어야 한다
- 없으면 `dalykit:init`을 먼저 실행하라고 안내한다

## 워크플로우

1. `dalykit/config/active.json` 읽기
2. `dalykit/kits/`의 모든 `k*` 디렉토리를 스캔
3. 각 kit에서 아래를 수집
  - 완료 단계
  - 대표 보고서 요약
  - 주요 결과 지표
4. 활성 kit에 `feature/featured.csv` 또는 `feature_results.json`이 있으면 피처 목록 추출
5. 수집 결과를 `dalykit/config/progress.md`에 반영

## 출력 규칙

- 상단에 마지막 업데이트 시각
- 현재 활성 kit
- 사용 중인 원본 데이터와 현재 피처셋
- kit 이력 요약
- 통합 인사이트

## 자동 갱신 규칙

- `dalykit:ml report`가 끝나면 함께 갱신한다
- 그 외에는 `dalykit:progress`를 수동 호출한다
