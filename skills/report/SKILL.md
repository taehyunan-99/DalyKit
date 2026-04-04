---
name: report
description: >
  최종 보고서 생성. EDA/전처리/통계 분석 결과를 종합하여
  마크다운 보고서를 생성한다.
  트리거: "dalykit:report", "보고서 만들어", "최종 보고서", "report".
user_invocable: true
---

# Report (최종 보고서)

EDA/전처리/통계 분석 보고서를 종합하여 최종 마크다운 보고서를 생성한다.

## 사용법

```
dalykit:report           ← 종합 마크다운 보고서 생성
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 보고서 설정 | `dalykit/config/report_config.md` |
| EDA 보고서 | `dalykit/docs/eda_report.md` |
| 전처리 보고서 | `dalykit/docs/preprocessing_report.md` |
| 통계 보고서 | `dalykit/docs/stat_report.md` |
| 시각화 | `dalykit/figures/` |
| 최종 보고서 | `dalykit/docs/report.md` |

## 참조 문서

| 파일 | 내용 |
|------|------|
| `REPORT_STRUCTURE.md` | 보고서 섹션 순서 + 콘텐츠 매핑 |

## 워크플로우

### 1단계: 설정 확인

1. `dalykit/config/report_config.md` 확인
   - **있으면**: Read로 읽고 프로젝트 정보 + 커스텀 순서 반영
   - **없으면**: REPORT_STRUCTURE.md 기본값 사용 (프로젝트 정보는 보고서에서 추론)

### 2단계: 수집

기존 보고서 + 차트 이미지를 Read/Glob으로 수집:

1. `dalykit/docs/eda_report.md` → 데이터 개요, 결측값, 분포, 상관관계
2. `dalykit/docs/preprocessing_report.md` → 전후 비교, 처리 요약
3. `dalykit/docs/stat_report.md` → 검정 결과 요약 테이블, 핵심 발견
4. `dalykit/figures/*.png` → 차트 이미지 목록

**보고서 누락 시**: 해당 섹션 스킵 + 사용자에게 경고 메시지 출력. 최소 1개 보고서는 필요.

### 3단계: 생성

> REPORT_STRUCTURE.md를 Read로 읽고, 섹션 순서를 따라 `dalykit/docs/report.md`에 Write.

보고서 구조는 REPORT_STRUCTURE.md의 순서를 따르되, 마크다운 형식으로 작성:
- 각 섹션 → 마크다운 제목 (`##`)
- 차트 이미지 → `![](../figures/chart.png)` 상대경로 참조
- 테이블 → 마크다운 테이블

## 마크다운 보고서 작성 규칙

1. **프로젝트 스토리라인** 유지: 문제 → 데이터 → 분석 → 발견 → 결론
2. `report_config.md`의 프로젝트 정보가 있으면 "문제 정의" 섹션에 반영
3. 없으면 보고서 내용에서 추론하여 간략히 서술
4. **차트 참조**: `dalykit/figures/` 이미지를 상대경로로 포함
5. **결론 섹션**: 문제 정의에서 제기한 질문에 직접 답변
6. **한계점 + 후속 분석**: 각 보고서의 추천사항을 종합
7. 한국어로 작성
