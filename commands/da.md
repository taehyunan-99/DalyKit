---
name: da
description: >
  HarnessDA 허브 명령어. 데이터 분석 스킬을 라우팅한다.
  "/da"로 스킬 목록, "/da eda"로 EDA 실행 등.
  트리거: "/da", "데이터 분석 도구", "DA 도구 목록".
user_invocable: true
---

# /da — HarnessDA 허브

데이터 분석 스킬 라우터. 인자에 따라 적절한 스킬로 라우팅한다.

## 라우팅 규칙

**인자 파싱**: `/da [서브명령] [인자...]`

| 서브명령 | 라우팅 대상 | 설명 |
|----------|-------------|------|
| (없음) | 아래 도움말 출력 | 사용 가능한 스킬 목록 |
| `eda` | `/eda` 스킬 호출 | 탐색적 데이터 분석 |
| `clean` | `/data-clean` 스킬 호출 | 데이터 전처리 |
| `stat` | `/stat-analysis` 스킬 호출 | 통계 분석 (대화형) |
| `stat-deep` | `stat-analyst` 에이전트 호출 | 통계 분석 (자동 — 보고서 기반 분석 계획 + 변수 스캔 + 전체 노트북 생성) |
| `viz` | `/da-viz` 스킬 호출 | 시각화 |
| `profile` | `data-profiler` 에이전트 호출 | 종합 프로파일링 |
| `report` | `visualize` 플러그인 위임 | 최종 HTML 보고서 |

## 인자 없이 호출 시 (`/da`)

아래 내용을 출력:

```
📊 HarnessDA — 데이터 분석 도구 모음

사용 가능한 명령어:
  /da eda [path]      탐색적 데이터 분석 (EDA)
  /da clean [path]    데이터 전처리
  /da stat [질문]     통계 분석 · 가설 검정 (대화형)
  /da stat-deep [질문] 통계 분석 (에이전트 — 자동 실행)
  /da viz [path]      데이터 시각화
  /da profile [path]  종합 프로파일링 (에이전트)
  /da report          최종 보고서 (HTML 대시보드)

개별 스킬 직접 호출도 가능:
  /eda, /data-clean, /stat-analysis, /da-viz
```

## 라우팅 동작

1. 서브명령을 파싱한다
2. 해당 스킬의 Skill 도구를 호출한다
3. 나머지 인자를 스킬에 전달한다

**`/da profile`의 경우:**
- Agent 도구로 `data-profiler` 서브에이전트를 호출한다
- 서브에이전트가 노트북에 프로파일링 셀을 생성한다

**`/da stat-deep`의 경우:**
- Agent 도구로 `stat-analyst` 서브에이전트를 호출한다
- 인자 없이 호출 시: EDA/전처리 보고서 기반 분석 계획 + 변수 자동 스캔 → 전체 노트북 생성
- 인자(연구 질문)와 함께 호출 시: 해당 질문에 대한 단일 분석 수행

**`/da report`의 경우:**
- 현재 분석 결과를 요약한다
- visualize 플러그인을 호출하여 HTML 대시보드를 생성한다
- 주요 차트, 통계 요약, 인사이트를 포함한다
