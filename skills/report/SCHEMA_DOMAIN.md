# 도메인 특화 슬라이드 스키마

`meta.domain` 값과 일치할 때만 포함하는 슬라이드 타입 스키마.
→ 공통 슬라이드: `SCHEMA_COMMON.md` / 포트폴리오 전용: `SCHEMA_PORTFOLIO.md`

---

## Finance

### risk_matrix
```json
{
  "type": "risk_matrix",
  "title": "[리스크 매트릭스]",
  "chart": {
    "mode": "inline",
    "data": [[0.0, 0.0], [0.0, 0.0]],
    "labels": { "x": ["[그룹A]", "[그룹B]"], "y": ["[지표1]", "[지표2]"] }
  },
  "insight": "[리스크 분포 특성 1문장]"
}
```

### portfolio_performance
```json
{
  "type": "portfolio_performance",
  "title": "[포트폴리오 성과]",
  "chart": {
    "mode": "inline",
    "data": { "x": ["[기간1]", "[기간2]"], "y": [0.0, 0.0] }
  },
  "insight": "[성과 추이 요약 1문장]"
}
```

### fraud_pattern
```json
{
  "type": "fraud_pattern",
  "title": "[이상 거래 패턴]",
  "chart": {
    "mode": "inline",
    "data": { "x": [0.0, 0.0], "y": [0.0, 0.0], "label": ["[정상]", "[이상]"] }
  },
  "insight": "[이상 거래 특성 1문장]"
}
```

---

## Healthcare

### clinical_significance
```json
{
  "type": "clinical_significance",
  "title": "[임상적 유의성]",
  "content": {
    "test": "[검정명 예: t-test]",
    "p_value": 0.000,
    "effect_size": 0.00,
    "interpretation": "[유의성 해석 1문장]"
  },
  "insight": "[임상적 의미 1문장]"
}
```

### survival_analysis
```json
{
  "type": "survival_analysis",
  "title": "[생존 분석]",
  "chart": {
    "mode": "inline",
    "data": { "x": [0, 0, 0], "y": [1.0, 0.0, 0.0] }
  },
  "insight": "[생존율 패턴 요약 1문장]"
}
```

---

## Manufacturing

### defect_analysis
```json
{
  "type": "defect_analysis",
  "title": "[불량 분석]",
  "chart": {
    "mode": "inline",
    "data": { "[공정A]": 0.0, "[공정B]": 0.0 }
  },
  "insight": "[불량 집중 구간 및 원인 1문장]"
}
```

### process_efficiency
```json
{
  "type": "process_efficiency",
  "title": "[공정 효율]",
  "chart": {
    "mode": "inline",
    "data": { "x": ["[기간1]", "[기간2]"], "y": [0.0, 0.0] }
  },
  "insight": "[효율 개선 추이 1문장]"
}
```

---

## Ecommerce

### funnel_analysis
```json
{
  "type": "funnel_analysis",
  "title": "[전환 퍼널]",
  "chart": {
    "mode": "inline",
    "data": [
      { "stage": "[단계명]", "count": 0, "rate": 0.0 }
    ]
  },
  "insight": "[이탈 집중 구간 1문장]"
}
```

### cohort_retention
```json
{
  "type": "cohort_retention",
  "title": "[코호트 리텐션]",
  "chart": {
    "mode": "inline",
    "data": [[0.0, 0.0], [0.0, 0.0]],
    "labels": { "x": ["[월차1]", "[월차2]"], "y": ["[코호트1]", "[코호트2]"] }
  },
  "insight": "[리텐션 패턴 요약 1문장]"
}
```
