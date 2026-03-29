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
  harnessda:eda             탐색적 데이터 분석 (EDA)
  harnessda:clean           데이터 전처리
  harnessda:stat            통계 분석 · 가설 검정
  harnessda:report          최종 보고서 (마크다운)
  harnessda:report pptx     슬라이드형 HTML (발표용)
  harnessda:report config   보고서 설정 템플릿 생성
  harnessda:help            도움말
  harnessda:tracker         work-tracker 업데이트 (개발 전용)

에이전트:
  data-profiler             종합 프로파일링 (Agent 도구로 호출)

모든 스킬은 현재 디렉토리의 데이터/노트북을 자동 탐색합니다.
```

## 실행 패턴

| 패턴 | 스킬 | 방식 | 이유 |
|------|------|------|------|
| 노트북 직접 | eda, clean | NotebookEdit로 셀 생성 | 단순 연산, 인터랙티브 탐색 |
| 스크립트 오프로드 | stat | Write(.py) + Bash 실행 → JSON | 다수 검정 일괄 실행, 대용량 데이터 |
| 문서 생성 | report | Write(md) 또는 frontend-design(html) | 보고서 종합 |

## 워크플로우 순서

```
1. harnessda:eda        → docs/eda_report.md
2. harnessda:clean      → data/cleaned/*.csv + docs/preprocessing_report.md
3. harnessda:stat       → stat_results.json + docs/stat_report.md
4. harnessda:report     → docs/report.md (또는 report_ppt.html)
```
