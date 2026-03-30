# 포트폴리오 전용 슬라이드 스키마

`meta.purpose == "portfolio"` 일 때만 포함하는 슬라이드 타입 스키마.
→ 공통 슬라이드: `SCHEMA_COMMON.md` / 도메인 특화: `SCHEMA_DOMAIN.md`

---

### tech_stack
```json
{
  "type": "tech_stack",
  "title": "[기술 스택]",
  "items": ["[라이브러리/도구명]", "[라이브러리/도구명]"],
  "insight": null
}
```

### troubleshooting
```json
{
  "type": "troubleshooting",
  "title": "[문제 해결 과정]",
  "items": [
    { "problem": "[발생 문제]", "solution": "[해결 방법]" }
  ],
  "insight": null
}
```

### lessons_learned
```json
{
  "type": "lessons_learned",
  "title": "[배운 점]",
  "items": ["[배운 점 1]", "[배운 점 2]"],
  "insight": null
}
```
