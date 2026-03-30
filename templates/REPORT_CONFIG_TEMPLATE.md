# 프로젝트 보고서 설정

<!-- harnessda:report config 실행 시 현재 디렉토리에 report_config.md로 복사됩니다 -->
<!-- 항목을 채우면 보고서/슬라이드에 반영됩니다 -->
<!-- 빈 항목은 AI가 데이터/보고서에서 추론합니다 -->

## 프로젝트 정보

- 프로젝트명:
  <!-- 예: "UniversalBank 고객 대출 분석" -->
- 분석 목적:
  <!-- 예: "고객 이탈 원인 파악 및 대응 전략 수립" -->
- 배경:
  <!-- 예: "최근 3개월 이탈률 15% 증가, 경영진 요청" -->
- 핵심 질문:
  <!-- 예: "어떤 고객군이 이탈 위험이 높은가?" -->
- 데이터 출처:
  <!-- 예: "사내 CRM 시스템, 2024년 1월~12월" -->

## 발표 정보

- 발표자:
- 발표일:
  <!-- 미입력 시 오늘 날짜 사용 -->
- 청중:
  <!-- 예: "마케팅팀 팀장 보고" / "데이터팀 내부 공유" / "채용 포트폴리오" -->

## 출력 설정

- 목적:
  <!-- report: 발표/보고용 (기본) -->
  <!-- portfolio: 포트폴리오용 (기술 깊이 + 특화 슬라이드 추가) -->
- 도메인:
  <!-- finance / healthcare / manufacturing / ecommerce / general -->
  <!-- 미지정 시 domain.md 또는 데이터에서 AI가 자동 추론 -->
- 테마:
  <!-- 미지정 시 도메인에 따라 자동 선택 -->

## 슬라이드 구성 (선택)

<!-- 포함하지 않을 슬라이드는 삭제하세요. 순서 변경 가능. -->
<!-- 이 섹션을 비워두면 도메인에 맞는 기본 순서로 자동 생성됩니다 -->

### 공통 슬라이드
1. cover
2. problem
3. data_overview
4. data_quality
5. key_findings
6. conclusion

### 도메인 특화 슬라이드 (도메인에 따라 자동 선택)
<!-- 아래는 AI가 도메인에 맞게 자동 구성합니다 -->
<!-- 수동으로 추가/제거하려면 주석 해제 후 편집하세요 -->

<!-- finance: feature_engineering, risk_analysis, correlations -->
<!-- healthcare: cohort, preprocessing, outcome_analysis, variable_importance -->
<!-- manufacturing: preprocessing, root_cause, prediction -->
<!-- ecommerce: funnel_analysis, segmentation, experiment, kpi_dashboard -->
<!-- general: distributions, correlations -->

### 포트폴리오 전용 슬라이드 (purpose: portfolio 시 자동 추가)
<!-- 포함하지 않을 항목은 삭제하세요 -->

<!-- tech_stack: 사용 기술 스택, 본인 역할, 기여도 -->
<!-- troubleshooting: 분석 중 기술적 문제와 해결 과정 -->
<!-- lessons_learned: 새롭게 배운 점, 개선하고 싶은 부분 -->
