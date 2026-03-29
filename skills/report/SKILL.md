---
name: report
description: >
  최종 보고서 생성. EDA/전처리/통계 분석 결과를 종합하여
  마크다운 보고서 또는 슬라이드형 HTML을 생성한다.
  트리거: "harnessda:report", "보고서 만들어", "최종 보고서",
  "PPT 만들어", "발표 자료", "report".
user_invocable: true
---

# Report (최종 보고서)

EDA/전처리/통계 분석 보고서를 종합하여 최종 보고서를 생성한다.

## 사용법

```
harnessda:report              ← 종합 마크다운 보고서 (기본)
harnessda:report pptx         ← 슬라이드형 HTML (frontend-design 플러그인)
harnessda:report config       ← report_config.md 템플릿 생성
```

## 참조 문서

| 파일 | 내용 |
|------|------|
| `SLIDE_STRUCTURE.md` | 슬라이드 기본 순서 + 콘텐츠 매핑 |
| `HTML_TEMPLATE.md` | HTML 템플릿 (CSS 스케일, PDF 저장, html2canvas 주의사항) |
| `REPORT_CONFIG_TEMPLATE.md` | 사용자 커스텀 설정 템플릿 |

## 출력 형식 분기

| 인자 | 출력 | 방법 |
|------|------|------|
| (없음) | `docs/report.md` | 직접 Write (마크다운 종합 보고서) |
| `pptx` | `docs/report_ppt.html` | `frontend-design` 플러그인으로 슬라이드형 HTML 생성 |
| `config` | `report_config.md` | REPORT_CONFIG_TEMPLATE.md 복사 |

## 워크플로우

### 1단계: 설정 확인

1. 현재 디렉토리에 `report_config.md` 확인
   - **있으면**: Read로 읽고 프로젝트 정보 + 커스텀 슬라이드 순서 반영
   - **없으면**: SLIDE_STRUCTURE.md 기본값 사용 (프로젝트 정보는 보고서에서 추론)
2. `harnessda:report config` 호출 시: REPORT_CONFIG_TEMPLATE.md를 현재 디렉토리에 `report_config.md`로 복사 → 종료

### 2단계: 수집

기존 보고서 + 차트 이미지를 Read/Glob으로 수집:

1. `docs/eda_report.md` → 데이터 개요, 결측값, 분포, 상관관계
2. `docs/preprocessing_report.md` → 전후 비교, 처리 요약
3. `docs/stat_report.md` → 검정 결과 요약 테이블, 핵심 발견
4. `docs/figures/*.png` → 차트 이미지 목록

**보고서 누락 시**: 해당 섹션 스킵 + 사용자에게 경고 메시지 출력. 최소 1개 보고서는 필요.

### 3단계: 생성

#### 기본 (마크다운 — 인자 없이 호출)

> SLIDE_STRUCTURE.md를 Read로 읽고, 슬라이드 순서를 **보고서 섹션 순서**로 변환하여 `docs/report.md`에 Write.

보고서 구조는 SLIDE_STRUCTURE.md의 슬라이드 순서를 따르되, 마크다운 형식으로 작성:
- 각 슬라이드 → 마크다운 섹션 (`##`)
- 차트 이미지 → `![](figures/chart.png)` 상대경로 참조
- 테이블 → 마크다운 테이블

#### PPTX (슬라이드형 HTML — `pptx` 인자)

> `frontend-design` 플러그인을 호출하여 슬라이드형 HTML을 생성한다.

1. 2단계에서 수집한 보고서 내용을 바탕으로 **슬라이드별 데이터** 정리
2. `frontend-design` 플러그인에 아래 정보를 전달:
   - 슬라이드 구성 (SLIDE_STRUCTURE.md 순서)
   - 각 슬라이드의 콘텐츠 (표, 수치, 해석)
   - 톤&무드: `report_config.md`에 지정되어 있으면 그대로 사용, 없으면 데이터 키워드에서 자동 추론
3. 결과: `docs/report_ppt.html` (슬라이드 네비게이션 + PDF 저장 포함)

**슬라이드형 HTML 필수 요소:**
- 화살표 키/스크롤 네비게이션
- PDF 저장: html2canvas + jsPDF (CDN 동적 로드)
- CSS 스케일 시스템: `:root { --s: 1; }` — 전체 크기 일괄 조절
- 애니메이션 제외 (PDF 캡처 호환성)
- 인라인 차트/시각화 (CSS/SVG 기반)
- 한국어 폰트: `Malgun Gothic` / `Apple SD Gothic Neo`

## 마크다운 보고서 작성 규칙

1. **프로젝트 스토리라인** 유지: 문제 → 데이터 → 분석 → 발견 → 결론
2. `report_config.md`의 프로젝트 정보가 있으면 "문제 정의" 섹션에 반영
3. 없으면 보고서 내용에서 추론하여 간략히 서술
4. **차트 참조**: `docs/figures/` 이미지를 상대경로로 포함
5. **결론 섹션**: 문제 정의에서 제기한 질문에 직접 답변
6. **한계점 + 후속 분석**: 각 보고서의 추천사항을 종합
7. 한국어로 작성
