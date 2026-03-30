---
name: eda
description: >
  탐색적 데이터 분석(EDA) 자동화. 노트북에 EDA 코드 셀을 생성하여
  데이터의 구조, 품질, 분포, 상관관계를 파악한다.
  트리거: "harnessda:eda", "EDA 해줘", "데이터 탐색", "explore this data",
  "데이터 분석 시작", "what does this data look like".
user_invocable: true
---

# EDA (탐색적 데이터 분석)

> 이 스킬은 NotebookEdit 대신 .py 스크립트를 생성한다 (Heavy-Task-Offload).

## 사용법

```
harnessda:eda [데이터 경로]
harnessda:eda                    ← 현재 디렉토리의 CSV 자동 탐색
harnessda:eda data.csv           ← 특정 파일 지정
harnessda:eda update             ← 기존 eda_analysis.py 재실행 + JSON + report 갱신
harnessda:eda domain             ← 현재 디렉토리에 domain.md 템플릿 생성
```

## 도메인 컨텍스트 (`domain.md`)

- `harnessda:eda domain` 실행 시: `templates/DOMAIN_TEMPLATE.md`를 현재 작업 디렉토리에 `domain.md`로 복사 생성
- EDA 실행 시: 현재 디렉토리에 `domain.md`가 있으면 자동으로 읽고 도메인 맥락을 반영하여 분석
- `domain.md`가 없으면: 일반적인 통계 기준으로 분석

## 워크플로우

### 1단계: 데이터 파악

- 사용자가 경로를 제공하면 해당 파일 사용
- 경로 미제공 시: Glob으로 현재 디렉토리의 CSV/Excel 파일 탐색 → 사용자에게 선택 요청
- 현재 디렉토리에 `domain.md`가 있으면 읽고, 이후 모든 분석·판단·보고서에 도메인 맥락 반영

### 2단계: .py 스크립트 생성 + 실행

> `CELL_PATTERNS.md`를 Read로 읽고 파일 구조를 따른다.

- Write 도구로 `eda_analysis.py` 생성
- Bash 도구로 `python eda_analysis.py` 실행 → `eda_results.json` 생성

### 3단계: EDA 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

1. `eda_results.json` 읽고 분석
2. EDA 보고서를 작성하여 `docs/eda_report.md`에 저장
3. 보고서 구조와 작성 규칙은 **EDA_REPORT.md** 참조

## update 인자 처리

`harnessda:eda update` 호출 시:

1. `eda_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: py 재실행 → JSON 갱신 → report 갱신 (py 생성 스킵)
3. **없으면**: "eda_analysis.py를 찾을 수 없습니다. `harnessda:eda`를 먼저 실행하세요." 안내 후 종료

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json) |
| `EDA_REPORT.md` | EDA 보고서 자동 생성 지침 |
| `templates/DOMAIN_TEMPLATE.md` | domain.md 템플릿 |

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 모든 데이터 처리는 .py 스크립트에서 수행
2. **주석은 한국어**로 작성
3. **출력 제한**: `.head()`, `.describe()`, `.value_counts().head(10)` 등 요약만
4. **JSON 저장**: 모든 분석 결과를 `eda_results.json`에 구조화하여 저장
5. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
6. **변수명**: 데이터프레임은 `df` 사용 (사용자가 다른 이름 지정 시 따름)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
> 사용 가능한 차트: histogram, scatter, boxplot, heatmap, bar, line, stacked_bar, pairplot, subplot
