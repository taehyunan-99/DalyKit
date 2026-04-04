---
name: eda
description: >
  탐색적 데이터 분석(EDA) 자동화. dalykit/data/에서 데이터를 읽고
  분석 노트북을 생성한다.
  트리거: "dalykit:eda", "EDA 해줘", "데이터 탐색", "explore this data",
  "데이터 분석 시작", "what does this data look like".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

> ipynb 노트북 생성 → 사용자가 직접 실행 → `dalykit:eda report`로 보고서 생성.

## 사용법

```
dalykit:eda              ← data/에서 CSV 탐색 → eda_analysis.ipynb 생성
dalykit:eda report       ← 실행된 노트북 결과 읽기 → dalykit/docs/eda_report.md 생성
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 데이터 | `dalykit/data/` |
| 도메인 설정 | `dalykit/config/domain.md` |
| 노트북 | `dalykit/code/eda_analysis.ipynb` |
| 시각화 | `dalykit/figures/` |

## 워크플로우

### 1단계: 데이터 파악

- Glob으로 `dalykit/data/`의 CSV/Excel 파일 탐색
- 파일 1개 → 자동 선택, 여러 개 → 사용자에게 선택 요청
- `dalykit/config/domain.md`가 있으면 Read로 읽고 도메인 맥락 반영

### 2단계: ipynb 노트북 생성

> `~/.claude/skills/eda/CELL_PATTERNS.md`를 Read로 읽고 셀 구조를 따른다.

- Write 도구로 `dalykit/code/eda_analysis.ipynb` 생성 (nbformat 4)
- 생성 완료 후 사용자에게 안내:
  ```
  eda_analysis.ipynb 생성 완료.
  노트북을 열어 전체 셀을 실행한 뒤 `dalykit:eda report`를 실행하세요.
  ```

### report 인자 워크플로우

> `dalykit:eda report` 호출 시 실행. 노트북을 사용자가 실행한 뒤 호출해야 한다.

1. `dalykit/code/eda_analysis.ipynb` Read → 셀 출력(outputs) 분석
2. `~/.claude/skills/eda/EDA_REPORT.md` Read → 보고서 작성 지침 확인
3. `dalykit/docs/eda_report.md` Write → 보고서 생성
4. ipynb 미존재 또는 outputs가 비어 있으면: "노트북을 먼저 실행한 뒤 다시 시도하세요." 안내 후 종료

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |
| `EDA_REPORT.md` | (report 스킬용) EDA 보고서 작성 지침 |

## 코드 생성 규칙

1. **주석은 한국어**로 작성
2. **출력 제한**: `.head()`, `.describe()`, `.value_counts().head(10)` 등 요약만
3. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
4. **변수명**: 데이터프레임은 `df` 사용 (사용자가 다른 이름 지정 시 따름)
5. **이미지 저장**: `dalykit/figures/` 에 저장 (`plt.savefig()`)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `~/.claude/shared/viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
> 사용 가능한 차트: histogram, scatter, boxplot, heatmap, bar, line, stacked_bar, pairplot, subplot
