---
name: stat
description: >
  통계 분석 및 가설 검정. 적합한 검정을 선택해 .py 스크립트를 생성하고 실행한다.
  트리거: "dalykit:stat", "통계 분석", "가설 검정".
user_invocable: true
---

# Stat (통계 분석)

> 활성 kit 기준으로 `stat/` 폴더에 스크립트, 결과 JSON, 보고서를 저장한다.

## 사용법

```text
dalykit:stat
dalykit:stat kits/k1/clean/cleaned.csv
dalykit:stat notebook
```

## 사전 조건

- `dalykit/config/active.json`이 있어야 한다
- 입력 데이터가 있어야 한다
  - 기본: `dalykit/kits/{kit}/clean/cleaned.csv`
  - fallback: raw 데이터
- 통계 패키지가 불명확하면 `dalykit:doctor install`을 먼저 안내한다

## 경로 규칙

| 항목 | 경로 |
|------|------|
| stage 디렉토리 | `dalykit/kits/{kit}/stat/` |
| 스크립트 | `dalykit/kits/{kit}/stat/stat_analysis.py` |
| 노트북 변환본 | `dalykit/kits/{kit}/stat/stat_analysis.ipynb` |
| 결과 JSON | `dalykit/kits/{kit}/stat/stat_results.json` |
| 보고서 | `dalykit/kits/{kit}/stat/stat_report.md` |
| 시각화 | `dalykit/kits/{kit}/stat/figures/` |

## 워크플로우

### `dalykit:stat`

1. 활성 kit 확인
2. 입력 데이터 결정
3. EDA와 clean 보고서가 있으면 함께 읽어 가설 후보와 컬럼 상태를 반영한다
4. [CODE_PATTERNS.md](CODE_PATTERNS.md)를 참조해 `stat_analysis.py` 생성
5. 스크립트를 실행해 `stat_results.json` 저장
6. [REPORT_GUIDE.md](REPORT_GUIDE.md)를 참조해 `stat_report.md` 자동 생성
7. `active.json.stages_completed`와 `artifacts`를 갱신한다

### `dalykit:stat notebook`

1. `stat_analysis.py` 존재 여부 확인
2. 있으면 `# %%` 구분자 기준으로 `stat_analysis.ipynb` 변환
3. 없으면 `dalykit:stat`을 먼저 실행하라고 안내한다

## 완료 기준

- `dalykit:stat`는 스크립트 실행과 보고서 생성을 한 번에 수행하므로, 명령 완료 시 `stat` 단계 완료로 본다

## 규칙

1. 결과와 보고서는 모두 `stat/` 폴더 내부에 저장한다
2. 시각화는 `stat/figures/`에 저장한다
3. 최신 별칭 개념은 사용하지 않는다
