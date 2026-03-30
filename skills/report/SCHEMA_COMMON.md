# 공통 슬라이드 스키마

모든 도메인에서 사용하는 슬라이드 타입 스키마.
→ 도메인 특화: `SCHEMA_DOMAIN.md` / 포트폴리오 전용: `SCHEMA_PORTFOLIO.md`

---

### cover
```json
{
  "type": "cover",
  "title": "[분석 제목]",
  "subtitle": "[데이터 출처 또는 부제]",
  "insight": null
}
```

### problem
```json
{
  "type": "problem",
  "title": "[문제 정의]",
  "content": {
    "background": "[분석 배경 1-2문장]",
    "objective": "[분석 목적 1문장]",
    "questions": ["[연구 질문 1]", "[연구 질문 2]"]
  },
  "insight": null
}
```

### data_overview
```json
{
  "type": "data_overview",
  "title": "[데이터 개요]",
  "content": {
    "rows": 0000,
    "cols": 00,
    "types": { "numeric": 0, "categorical": 0 }
  },
  "chart": {
    "mode": "inline",
    "data": { "[컬럼명A]": 0.0, "[컬럼명B]": 0.0 }
  },
  "insight": "[데이터 규모 및 특성 요약 1문장]"
}
```

### data_quality
```json
{
  "type": "data_quality",
  "title": "[데이터 품질]",
  "content": {
    "missing_cols": 0,
    "duplicate_rows": 0,
    "treatment": "[결측값 처리 방법 요약]"
  },
  "chart": {
    "mode": "inline",
    "data": { "[컬럼명A]": 0.0, "[컬럼명B]": 0.0 }
  },
  "insight": "[품질 이슈 및 처리 결과 1문장]"
}
```

### distributions
```json
{
  "type": "distributions",
  "title": "[변수명] 분포",
  "chart": {
    "mode": "inline",
    "data": { "bins": [0, 0, 0], "counts": [0, 0, 0] }
  },
  "insight": "[분포 특성 요약 1문장]"
}
```
> 복잡한 분포는 PNG 폴백:
```json
"chart": { "mode": "image", "path": "figures/[차트파일명].png" }
```

### correlations
```json
{
  "type": "correlations",
  "title": "[상관관계 분석]",
  "chart": {
    "mode": "inline",
    "data": [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]],
    "labels": ["[변수A]", "[변수B]", "[변수C]"]
  },
  "insight": "[주요 상관관계 발견 1문장]"
}
```

### preprocessing
```json
{
  "type": "preprocessing",
  "title": "[전처리 과정]",
  "content": {
    "before": { "rows": 0000, "cols": 00, "missing": 0 },
    "after":  { "rows": 0000, "cols": 00, "missing": 0 },
    "steps": ["[처리 단계 1]", "[처리 단계 2]"]
  },
  "insight": "[전처리 결과 요약 1문장]"
}
```

### stat_results
```json
{
  "type": "stat_results",
  "title": "[통계 분석 결과]",
  "content": {
    "rows": [
      {
        "analysis": "[분석명]",
        "test": "[검정명]",
        "statistic": 0.00,
        "p_value": 0.000,
        "conclusion": "[귀무가설 기각 | 귀무가설 기각 불가]",
        "effect_size": 0.00
      }
    ]
  },
  "insight": "[통계 결과 종합 1문장]"
}
```

### key_findings
```json
{
  "type": "key_findings",
  "title": "[핵심 발견]",
  "findings": [
    { "label": "[지표명]", "value": "[수치 또는 텍스트]", "highlight": true },
    { "label": "[지표명]", "value": "[수치 또는 텍스트]", "highlight": false }
  ],
  "insight": "[핵심 발견 종합 1문장]"
}
```

### conclusion
```json
{
  "type": "conclusion",
  "title": "[결론 및 제언]",
  "summary": "[분석 결론 2-3문장]",
  "next_steps": ["[후속 분석 제안 1]", "[후속 분석 제안 2]"],
  "insight": null
}
```
