---
name: eda
description: >
  탐색적 데이터 분석(EDA) 자동화. harnessda/data/에서 데이터를 읽고
  분석 스크립트를 생성하여 보고서까지 자동으로 작성한다.
  트리거: "harnessda:eda", "EDA 해줘", "데이터 탐색", "explore this data",
  "데이터 분석 시작", "what does this data look like".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

> .py 스크립트 생성 → 실행 → JSON → 보고서 자동 생성 (Heavy-Task-Offload).

## 사용법

```
harnessda:eda              ← data/에서 CSV 탐색 → 분석 → 보고서 자동
harnessda:eda update       ← 기존 py 재실행 → 보고서 갱신
harnessda:eda notebook     ← eda_analysis.py → ipynb 변환
```

## 사전 조건

- `harnessda/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`harnessda:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 데이터 | `harnessda/data/` |
| 도메인 설정 | `harnessda/config/domain.md` |
| 스크립트 | `harnessda/code/eda_analysis.py` |
| JSON 결과 | `harnessda/code/eda_results.json` |
| 보고서 | `harnessda/docs/eda_report.md` |
| 시각화 | `harnessda/figures/` |

## 워크플로우

### 1단계: 데이터 파악

- Glob으로 `harnessda/data/`의 CSV/Excel 파일 탐색
- 파일 1개 → 자동 선택, 여러 개 → 사용자에게 선택 요청
- `harnessda/config/domain.md`가 있으면 Read로 읽고 도메인 맥락 반영

### 2단계: .py 스크립트 생성 + 실행

> `CELL_PATTERNS.md`를 Read로 읽고 파일 구조를 따른다.

- Write 도구로 `harnessda/code/eda_analysis.py` 생성
- Bash 도구로 `python harnessda/code/eda_analysis.py` 실행 → `harnessda/code/eda_results.json` 생성

### 3단계: EDA 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

1. `harnessda/code/eda_results.json` 읽고 분석
2. EDA 보고서를 작성하여 `harnessda/docs/eda_report.md`에 저장
3. 보고서 구조와 작성 규칙은 **EDA_REPORT.md** 참조

## update 인자 처리

`harnessda:eda update` 호출 시:

1. `harnessda/code/eda_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: py 재실행 → JSON 갱신 → report 갱신 (py 생성 스킵)
3. **없으면**: "eda_analysis.py를 찾을 수 없습니다. `harnessda:eda`를 먼저 실행하세요." 안내 후 종료

## notebook 인자 처리

`harnessda:eda notebook` 호출 시:

1. `harnessda/code/eda_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `harnessda/code/eda_analysis.ipynb` 변환
3. **없으면**: "eda_analysis.py를 찾을 수 없습니다. `harnessda:eda`를 먼저 실행하세요." 안내 후 종료

변환 방법:
- py 파일을 Read로 읽는다
- `# %%` 로 시작하는 줄을 셀 경계로 인식
- `# %% [markdown]` 으로 시작하면 마크다운 셀
- 나머지는 코드 셀
- nbformat 4 형식의 JSON을 Write로 저장

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json) |
| `EDA_REPORT.md` | EDA 보고서 자동 생성 지침 |

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 모든 데이터 처리는 .py 스크립트에서 수행
2. **주석은 한국어**로 작성
3. **출력 제한**: `.head()`, `.describe()`, `.value_counts().head(10)` 등 요약만
4. **JSON 저장**: 모든 분석 결과를 `harnessda/code/eda_results.json`에 구조화하여 저장
5. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
6. **변수명**: 데이터프레임은 `df` 사용 (사용자가 다른 이름 지정 시 따름)
7. **이미지 저장**: `harnessda/figures/` 에 저장 (`plt.savefig()`)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
> 사용 가능한 차트: histogram, scatter, boxplot, heatmap, bar, line, stacked_bar, pairplot, subplot
