---
name: eda
description: >
  탐색적 데이터 분석 자동화. raw 데이터를 읽고 EDA 노트북과 결과 파일을 생성한다.
  트리거: "dalykit:eda", "EDA 해줘", "데이터 탐색".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

> raw 데이터 기준으로 `kits/{active_kit}/eda/` 아래에 노트북, 결과 JSON, 보고서를 만든다.

## 사용법

```text
dalykit:eda
dalykit:eda bank_customers.csv
dalykit:eda report
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- `dalykit/data/raw/`에 CSV 또는 Excel 파일이 있어야 한다
- 없으면 `dalykit:init` 또는 데이터 배치를 먼저 안내한다

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 원본 데이터 | `dalykit/data/raw/` |
| 활성 kit | `dalykit/config/active.json`의 `kit` |
| stage 디렉토리 | `dalykit/kits/{kit}/eda/` |
| 노트북 | `dalykit/kits/{kit}/eda/eda_analysis.ipynb` |
| 결과 JSON | `dalykit/kits/{kit}/eda/eda_results.json` |
| 보고서 | `dalykit/kits/{kit}/eda/eda_report.md` |
| 시각화 | `dalykit/kits/{kit}/eda/figures/` |

## 워크플로우

### `dalykit:eda`

1. 활성 kit 확인
2. 인자 없으면 `active.json.raw_data`를 우선 사용하고, 비어 있으면 `data/raw/`에서 파일을 선택
3. 인자 있으면 해당 파일을 원본 데이터로 사용하고 `active.json.raw_data`를 갱신
4. [CELL_PATTERNS.md](CELL_PATTERNS.md)를 참조해 노트북 생성
5. 첫 코드 셀에 한글 폰트 설정을 포함한다
6. 노트북은 각 분석 셀 끝에서 `eda_results.json`을 중간 저장하도록 구성한다 (`figures/` 포함)
7. 데이터 로드 직후 기초통계 셀을 고정 포함해 `info()`와 `describe(include="all")`를 생략 없이 출력한다
8. 상관관계 히트맵은 CELL_PATTERNS의 고정 코드맵을 사용해 `heatmap_corr.png`로 저장한다

### `dalykit:eda report`

1. `dalykit/kits/{kit}/eda/eda_results.json`을 읽는다
2. [EDA_REPORT.md](EDA_REPORT.md)를 읽어 보고서를 생성한다
3. `dalykit/kits/{kit}/eda/eda_report.md`에 저장한다
4. `active.json.stages_completed`와 `artifacts.eda_results`를 갱신한다

## 완료 기준

- `dalykit:eda`는 노트북 생성만 수행하므로 완료 단계로 기록하지 않는다
- `dalykit:eda report`까지 생성되어야 `eda` 단계 완료로 본다

## 규칙

1. 원본 데이터는 절대 수정하지 않는다
2. 결과는 활성 kit 내부에만 저장한다
3. 이미지 저장 경로는 항상 `eda/figures/`이다
4. 보고서 생성 전 결과 JSON이 없으면 노트북을 먼저 실행하라고 안내한다
5. 그래프 한글 깨짐 방지를 위해 CELL_PATTERNS의 폰트 설정을 생략하지 않는다
6. EDA 결과는 마지막 셀에서만 저장하지 말고 셀 단위로 누적 저장한다
7. 기초통계와 상관관계 히트맵 고정 셀을 임의로 생략하거나 대체하지 않는다
