# HTML PPT 템플릿 설계 명세

`frontend-design` 플러그인이 `template.html` 제작 시 반드시 따라야 하는 설계 명세.

> **핵심 원칙**: AI는 `report_data.json`만 생성. `template.html`은 1회 제작 후 재사용.

---

## 아키텍처

```
report_data.json  ←  AI가 생성 (슬라이드 데이터 + Smart Insight)
      ↓
template.html     ←  frontend-design이 1회 제작, 이후 재사용
      ↓
JS가 JSON 로드 → slides 배열 순회 → 타입별 렌더 함수 호출 → 슬라이드 생성
```

---

## 1. 전체 크기 — CSS 변수 스케일 시스템

`:root`의 `--s` 하나로 전체 크기 일괄 조절. **모든 px 값에 `calc(Npx * var(--s))` 적용.**

```css
:root {
  --s: 1;  /* 0.8로 바꾸면 전체 80% 축소 */

  /* 폰트 — 발표용 기준 (포트폴리오는 --s 조절로 대응) */
  --fs-h1:    calc(36px * var(--s));
  --fs-h2:    calc(28px * var(--s));
  --fs-body:  calc(16px * var(--s));
  --fs-small: calc(12px * var(--s));
  --spacing:  calc(24px * var(--s));
}
```

**스케일 제외 대상** (고정값 유지):
- `border-width` (1px, 2px 등 얇은 선)
- `letter-spacing`, `opacity`, `z-index`
- `100%`, `100vw`, `100vh` 등 상대 단위
- `.nav-bar`, `.pdf-btn` 등 UI 컨트롤
- `@media print` 고정 치수

---

## 2. 슬라이드 캔버스 — 16:9 고정 + 중앙 정렬

```css
.slide {
  width: calc(960px * var(--s));
  height: calc(540px * var(--s));  /* 16:9 고정 */
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  overflow: hidden;                /* 콘텐츠 넘침 방지 */
  position: relative;
}

/* 브라우저 창 크기와 무관하게 슬라이드 비율 유지 */
#slide-viewport {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

---

## 3. 도메인 테마 — CSS 클래스 전환

`report_data.json`의 `domain` + `purpose` 값을 읽어 `<body>` 클래스 적용.

```html
<body class="finance presentation">
```

```css
/* 도메인별 색상 팔레트 */
.finance    { --primary: #1B2D5B; --accent: #C9A84C; --bg: #F5F6F8; --text: #1A1A2E; }
.healthcare { --primary: #2BA084; --accent: #2BA084; --bg: #F0FAF8; --text: #1C3A35; }
.manufacturing { --primary: #2C3E50; --accent: #E87722; --bg: #F4F5F7; --text: #1A1A1A; }
.ecommerce  { --primary: #1A0533; --accent: #C940D5; --bg: #0D0D1A; --text: #F0E6FF; }
.general    { --primary: #2D3E6B; --accent: #5B8DEF; --bg: #F7F8FC; --text: #2C2C3E; }

/* 용도별 정보 밀도 */
.presentation .slide-content { font-size: var(--fs-body); line-height: 1.8; }
.portfolio    .slide-content { font-size: var(--fs-small); line-height: 1.6; }
.presentation .slide { padding: calc(48px * var(--s)); }
.portfolio    .slide { padding: calc(32px * var(--s)); }
```

---

## 4. HTML 뼈대 구조

```
[네비게이션 바]  ← 슬라이드 번호 + 전/다음 버튼 + PDF 저장 버튼
[슬라이드 뷰포트]
  └─ [슬라이드 캔버스 .slide]
       ├─ [헤더 .slide-header]  ← 슬라이드 제목
       ├─ [콘텐츠 .slide-content]  ← 타입별 렌더 함수 결과
       └─ [푸터 .slide-footer]  ← 페이지 번호 + 프로젝트명
```

---

## 5. 슬라이드 타입 — 렌더 함수 정의

각 타입은 template.html 내부에 렌더 함수로 구현. **AI가 JSON에 올바른 타입만 지정하면 렌더링은 template.html이 담당.**

### 공통 슬라이드
| 타입 | 차트 | 설명 |
|------|------|------|
| `cover` | 없음 | 제목 + 부제목 + 날짜 |
| `problem` | 없음 | 배경/목적/질문 텍스트 카드 |
| `data_overview` | 막대차트 (인라인 SVG) | 컬럼 수, 행 수, 타입별 분포 |
| `data_quality` | 막대차트 (인라인 SVG) | 결측값 비율, 중복 수 |
| `key_findings` | 없음 | 수치 강조 카드 3~5개 |
| `conclusion` | 없음 | 요약 + 후속 분석 제안 |

### 도메인 특화 슬라이드
| 타입 | 도메인 | 차트 |
|------|--------|------|
| `risk_matrix` | finance | 히트맵 (인라인 SVG) |
| `portfolio_performance` | finance | 선형 차트 (인라인 SVG) |
| `fraud_pattern` | finance | 산점도 (인라인 SVG) |
| `clinical_significance` | healthcare | 박스플롯 (인라인 SVG) |
| `survival_analysis` | healthcare | 선형 차트 (인라인 SVG) |
| `defect_analysis` | manufacturing | 막대차트 (인라인 SVG) |
| `process_efficiency` | manufacturing | 선형 차트 (인라인 SVG) |
| `funnel_analysis` | ecommerce | 퍼널 차트 (인라인 SVG) |
| `cohort_retention` | ecommerce | 히트맵 (인라인 SVG) |
| `correlation` | 공통 | 히트맵 (인라인 SVG) |
| `distributions` | 공통 | 히스토그램 (inline) 또는 PNG 폴백 |

### 포트폴리오 전용 슬라이드
| 타입 | 설명 |
|------|------|
| `tech_stack` | 사용 라이브러리/기술 뱃지 |
| `troubleshooting` | 문제-해결 과정 타임라인 |
| `lessons_learned` | 배운 점 카드 목록 |

---

## 6. 차트 렌더링 방식

```javascript
// report_data.json의 chart.mode로 분기
const SLIDE_RENDERERS = {
  "correlation": (data) => renderHeatmapSVG(data.chart.data),
  "data_overview": (data) => renderBarSVG(data.chart.data),
  "key_findings": (data) => renderTextCards(data.findings),
  "distribution": (data) => {
    if (data.chart.mode === "image") return `<img src="${data.chart.path}">`;
    return renderHistogramSVG(data.chart.data);
  }
}
```

| 차트 종류 | 방식 |
|-----------|------|
| 막대/선/파이/히트맵 | 인라인 SVG (파일 의존성 없음) |
| pairplot 등 복잡한 분포 | PNG 폴백 (`figures/` 폴더) |

---

## 7. 필수 기능

| 기능 | 구현 |
|------|------|
| 키보드 네비게이션 | `←` `→` 키 이벤트 |
| 슬라이드 번호 | `현재 / 전체` 표시 |
| PDF 저장 | html2canvas + jsPDF CDN 동적 로드 |
| 폰트 보장 | `document.fonts.ready` 후 렌더링 |
| 한국어 폰트 | `Malgun Gothic`, `AppleGothic` |

---

## 8. 주의사항

- **CSS `zoom` 사용 금지** — html2canvas가 무시, PDF 렌더링 깨짐
- **CSS 애니메이션 제외** — PDF 캡처 호환성
- **`-webkit-text-fill-color: transparent` 금지** — html2canvas 미지원
- **외부 이미지 의존 최소화** — PNG는 base64 또는 상대경로만 사용
