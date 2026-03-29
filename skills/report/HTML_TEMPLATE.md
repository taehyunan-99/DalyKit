# HTML 보고서 템플릿

`frontend-design` 플러그인이 슬라이드형 HTML 생성 시 참조하는 패턴.

## 특징

- **단독 HTML 파일** — CDN/외부 리소스 없음, 오프라인 동작
- **CSS 변수 스케일 시스템** — `--s` 변수 하나로 전체 크기 조절
- **PDF 저장** — html2canvas + jsPDF로 화면 그대로 캡처
- **차트 임베드** — base64 인코딩으로 이미지 내장
- **한국어 폰트** — `Malgun Gothic`, `AppleGothic` 폰트 스택

## CSS 스케일 시스템

`:root`에 `--s` 변수를 선언하고, 모든 `px` 값에 `calc(원래값 * var(--s))`를 적용한다.

```css
:root {
  --s: 1;     /* 기본 크기 */
  /* --s: 1.4;  ← 40% 확대 */
}
h2 { font-size: calc(22px * var(--s)); }
.card { padding: calc(24px * var(--s)); border-radius: calc(10px * var(--s)); }
```

### 스케일 제외 대상
- `border-width` (1px, 2px 등 얇은 선)
- `letter-spacing`, `opacity`, `z-index`
- `max-width` (레이아웃 제약)
- `.save-toolbar`, `.nav-bar` 등 UI 컨트롤
- `@media print` 고정 치수
- `100%`, `100vw`, `100vh` 등 상대 단위

## 기본 HTML 구조

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{project_name} — 분석 보고서</title>
    <style>
        :root { --s: 1; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Malgun Gothic', 'AppleGothic', sans-serif;
            color: #333; line-height: 1.6; background: #f5f5f5;
        }
        .page {
            width: 960px;
            margin: calc(20px * var(--s)) auto;
            padding: calc(40px * var(--s)) calc(50px * var(--s));
            background: #fff; border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            page-break-after: always;
        }
        .page:last-child { page-break-after: auto; }
        /* 모든 px 값에 calc(Npx * var(--s)) 적용 */
        h1 { font-size: calc(28px * var(--s)); }
        h2 { font-size: calc(22px * var(--s)); color: #2C3E50; border-bottom: 2px solid #4A90D9; }
        th { background: #2C3E50; color: #fff; }
        .highlight { color: #4A90D9; font-weight: bold; }
        .alert { color: #E74C3C; font-weight: bold; }
        .callout { background: #f0f7ff; border-left: 4px solid #4A90D9; padding: calc(12px * var(--s)) calc(16px * var(--s)); }
        .save-toolbar { position: fixed; top: 16px; right: 16px; z-index: 200; }
        .save-btn { padding: 8px 16px; border-radius: 6px; border: 1px solid #4A90D9; background: rgba(255,255,255,0.95); color: #2C3E50; cursor: pointer; }
        .save-btn:hover { background: #4A90D9; color: #fff; }
        @media print { .save-toolbar { display: none; } }
    </style>
</head>
<body>
    <div class="save-toolbar">
        <button class="save-btn" onclick="savePDF()">PDF 저장</button>
    </div>
    {content}
    <script>
    async function savePDF() {
        const btn = document.querySelector('.save-btn');
        btn.textContent = '생성 중...'; btn.disabled = true;
        async function loadScript(src) {
            return new Promise((resolve, reject) => {
                if (document.querySelector(`script[src="${src}"]`)) { resolve(); return; }
                const s = document.createElement('script');
                s.src = src; s.onload = resolve; s.onerror = reject;
                document.head.appendChild(s);
            });
        }
        try {
            await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
            await loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
            const pages = document.querySelectorAll('.page');
            const { jsPDF } = window.jspdf;
            const scale = (window.devicePixelRatio || 1) * 2;
            const first = pages[0];
            const pw = first.offsetWidth * 0.264583;
            const ph = first.offsetHeight * 0.264583;
            const pdf = new jsPDF({ orientation: ph > pw ? 'portrait' : 'landscape', unit: 'mm', format: [pw, ph] });
            for (let i = 0; i < pages.length; i++) {
                btn.textContent = `${i+1}/${pages.length}...`;
                pages[i].scrollIntoView({ behavior: 'instant' });
                const canvas = await html2canvas(pages[i], {
                    scale, useCORS: true, allowTaint: true, backgroundColor: '#fff',
                    width: first.offsetWidth, height: first.offsetHeight
                });
                if (i > 0) pdf.addPage([pw, ph]);
                pdf.addImage(canvas.toDataURL('image/png'), 'PNG', 0, 0, pw, ph, '', 'FAST');
            }
            pages[0].scrollIntoView({ behavior: 'instant' });
            pdf.save(document.title.replace(/[^가-힣a-zA-Z0-9]/g, '_') + '.pdf');
        } catch(e) { alert('PDF 생성 실패: ' + e.message); }
        finally { btn.textContent = 'PDF 저장'; btn.disabled = false; }
    }
    </script>
</body>
</html>
```

## 섹션 패턴 요약

각 섹션은 `<div class="page">` 로 감싼다. 슬라이드형(`report_ppt.html`)에서는 `.page` 대신 `.slide`를 사용할 수 있다.

| 유형 | 핵심 요소 |
|------|----------|
| cover | `.page.cover` + `h1` + `.subtitle` |
| problem | `h2` + `h3`(배경/목적/질문) + `.highlight` |
| table | `<table>` + `th`(#2C3E50 배경) + 짝수행 배경 |
| chart | `<img class="chart" src="data:image/png;base64,...">` |
| callout | `.callout` + `<strong>` 제목 + 본문 |

## 주의사항

- **CSS `zoom` 사용 금지** — html2canvas가 무시하여 PDF 렌더링 깨짐
- **CSS 애니메이션 제외** — `opacity: 0` 상태를 캡처하여 빈 페이지 생성
- **`-webkit-text-fill-color: transparent` 금지** — html2canvas 미지원, 텍스트 안 보임
