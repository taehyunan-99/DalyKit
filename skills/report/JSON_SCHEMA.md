# report_data.json 스키마

AI가 `harnessda:report pptx` 호출 시 생성하는 JSON 구조 명세.
`template.html`의 JS가 이 파일을 로드하여 슬라이드를 렌더링한다.

---

## 전체 구조

```json
{
  "meta": {
    "project_name": "[프로젝트명]",
    "author": "[작성자명]",
    "date": "[YYYY-MM-DD]",
    "domain": "[finance|healthcare|manufacturing|ecommerce|general]",
    "purpose": "[presentation|portfolio]"
  },
  "slides": [ ... ]
}
```

- `meta.domain` → CSS 테마 클래스 결정 (`<body class="finance presentation">`)
- `meta.purpose` → 정보 밀도 결정 (폰트 크기, 여백)
- `slides` → 배열 순서대로 슬라이드 생성

---

## 슬라이드 타입 참조

| 분류 | 파일 | 포함 타입 |
|------|------|-----------|
| 공통 | `SCHEMA_COMMON.md` | cover, problem, data_overview, data_quality, distributions, correlations, preprocessing, stat_results, key_findings, conclusion |
| 도메인 특화 | `SCHEMA_DOMAIN.md` | risk_matrix, portfolio_performance, fraud_pattern (finance) / clinical_significance, survival_analysis (healthcare) / defect_analysis, process_efficiency (manufacturing) / funnel_analysis, cohort_retention (ecommerce) |
| 포트폴리오 전용 | `SCHEMA_PORTFOLIO.md` | tech_stack, troubleshooting, lessons_learned |

---

## 슬라이드 조건부 포함 규칙

AI가 `slides` 배열 구성 시 아래 조건에 따라 포함 여부 결정.

| 슬라이드 타입 | 포함 조건 |
|--------------|-----------|
| `cover` | 항상 포함 |
| `problem` | 항상 포함 (`report_config.md` 없으면 보고서에서 추론) |
| `data_overview` | `docs/eda_report.md` 존재 시 |
| `data_quality` | `docs/eda_report.md` 존재 시 |
| `distributions` | `docs/eda_report.md` 존재 시 |
| `correlations` | `docs/eda_report.md` 존재 시 |
| `preprocessing` | `docs/preprocessing_report.md` 존재 시 |
| `stat_results` | `docs/stat_report.md` 존재 시 |
| `key_findings` | `docs/stat_report.md` 존재 시 |
| 도메인 특화 슬라이드 | eda/stat 보고서 존재 + `meta.domain` 일치 시 |
| `tech_stack` | `meta.purpose == "portfolio"` 시 |
| `troubleshooting` | `meta.purpose == "portfolio"` 시 |
| `lessons_learned` | `meta.purpose == "portfolio"` 시 |
| `conclusion` | 항상 포함 |

### 기본 슬라이드 순서

보고서가 모두 존재할 때의 기본 순서 (포트폴리오 기준):

```
cover → problem → data_overview → data_quality → distributions → correlations
→ preprocessing → stat_results → key_findings → [도메인 특화]
→ tech_stack → troubleshooting → lessons_learned → conclusion
```

발표용은 `tech_stack`, `troubleshooting`, `lessons_learned` 제외.
`report_config.md`의 슬라이드 순서가 있으면 이를 우선 적용.

---

## meta.domain × meta.purpose 조합표

| domain | purpose | CSS 클래스 | 폰트 크기 | 정보 밀도 |
|--------|---------|-----------|-----------|-----------|
| finance | presentation | `finance presentation` | 36px+ | 낮음 |
| finance | portfolio | `finance portfolio` | 28px+ | 높음 |
| healthcare | presentation | `healthcare presentation` | 36px+ | 낮음 |
| healthcare | portfolio | `healthcare portfolio` | 28px+ | 높음 |
| manufacturing | presentation | `manufacturing presentation` | 36px+ | 낮음 |
| manufacturing | portfolio | `manufacturing portfolio` | 28px+ | 높음 |
| ecommerce | presentation | `ecommerce presentation` | 36px+ | 낮음 |
| ecommerce | portfolio | `ecommerce portfolio` | 28px+ | 높음 |
| general | presentation | `general presentation` | 36px+ | 낮음 |
| general | portfolio | `general portfolio` | 28px+ | 높음 |
