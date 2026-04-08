---
name: stat
description: >
  통계 분석 및 가설 검정. 변수 척도를 파악하고, 귀무가설을 설정한 뒤,
  적합한 통계 검정을 선택하여 scipy/statsmodels .py 스크립트를 생성, 결과를 해석한다.
  트리거: "dalykit:stat", "통계 분석", "가설 검정", "hypothesis test",
  "상관 분석", "정규성 검정", "t-test", "ANOVA", "회귀 분석".
user_invocable: true
---

# Stat Analysis (통계 분석)

> .py 스크립트 생성 → 실행 → JSON → 보고서 자동 생성 (Heavy-Task-Offload).

## 사용법

```
dalykit:stat             ← data/ 데이터 → 통계 검정 → 보고서
dalykit:stat notebook    ← stat_analysis.py → ipynb 변환
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 전처리 데이터 | `dalykit/data/` |
| 스크립트 | `dalykit/code/py/stat_analysis.py` |
| JSON 결과 | `dalykit/code/results/stat_results.json` |
| 보고서 | `dalykit/docs/stat_report.md` |
| 시각화 | `dalykit/figures/` |

## 보고서 요약 섹션
보고서 최상단에 `## 요약` 섹션 (5줄 이내) 필수 포함. REPORT_GUIDE.md 참조.

## 전체 흐름 (노션 워크플로우 기반)

```
0단계: 컨텍스트 수집 (인자 없이 호출 시)  → 아래 "전체 자동 분석" 참조
1단계: 척도 파악 + 연구 질문              → @TEST_SELECTION.md
  → 2단계: 귀무가설 설정                  → @HYPOTHESIS_GUIDE.md
  → 3단계: 가정 검정 + 본 검정 + 사후 분석 (단일 셀 통합)  → @CODE_PATTERNS.md
  → 4단계: 결과 해석
  → 5단계: 보고서 생성                    → @REPORT_GUIDE.md
```

## 참조 문서

| 파일 | 내용 |
|------|------|
| `~/.claude/skills/stat/TEST_SELECTION.md` | 척도 분류 + 의사결정 트리 + 사후 분석 매핑 |
| `~/.claude/skills/stat/HYPOTHESIS_GUIDE.md` | 귀무가설/대립가설 레퍼런스 테이블 |
| `~/.claude/skills/stat/CODE_PATTERNS.md` | 검정별 함수 패턴 (.py 스크립트용) |
| `~/.claude/skills/stat/CELL_PATTERNS.md` | 파일 생성 구조 (.py + .json + .ipynb) |
| `~/.claude/skills/stat/SCAN_LOGIC.md` | 변수 자동 스캔 알고리즘 + 분석 계획 출력 형식 |
| `~/.claude/skills/stat/REPORT_GUIDE.md` | 통계 보고서 자동 생성 지침 |

## 전체 자동 분석 (인자 없이 호출 시)

인자 없이 `dalykit:stat` 호출 시, 아래 순서로 전체 분석을 자동 수행한다.

### 0단계: 컨텍스트 수집

1. **보고서 읽기**:
   - `dalykit/docs/eda_report.md` → "다음 단계 추천" 섹션에서 통계 분석 추천 항목 추출
   - `dalykit/docs/preprocessing_report.md` → "최종 컬럼 목록" + "다음 단계 추천" 추출
   - 보고서가 없으면 → 데이터 파일을 직접 프로파일링 (dtypes, nunique, describe)
2. **타겟 변수 결정**: 보고서에서 종속변수로 반복 언급되는 변수 추론. 추론 불가 시 사용자에게 질문.
3. **데이터 경로 확인**: `dalykit/data/` 하위 파일 탐색 또는 전처리 보고서의 "저장 파일" 경로 참조.

### 1단계: 분석 계획 수립

> `~/.claude/skills/stat/SCAN_LOGIC.md`를 Read로 읽고 따른다.

- P1(보고서 추천) + P2(변수 자동 스캔) → 중복 제거 → 분석 계획 확정 → 바로 스크립트 생성 진행

### 2단계: .py 스크립트 생성 + 실행

> `~/.claude/skills/stat/CODE_PATTERNS.md`를 Read로 읽고 따른다.

- Write 도구로 `dalykit/code/py/stat_analysis.py` 생성 (분석 함수 + 실행 + JSON 저장)
- `dalykit/config/domain.md`의 "실행 환경" 섹션에 Python 경로가 있으면 해당 경로를 사용하여 실행. 없으면 `python3 ... 2>/dev/null || python ...` 폴백 패턴 사용.
- Bash 도구로 실행 시 반드시 `PYTHONIOENCODING=utf-8`을 앞에 붙인다: `PYTHONIOENCODING=utf-8 {python경로} dalykit/code/py/stat_analysis.py` → `dalykit/code/results/stat_results.json` 생성

### 3단계: 통계 보고서 자동 생성

스크립트 실행 완료 후 **자동으로** 이어서 실행한다.

- `dalykit/code/results/stat_results.json` 읽어 `dalykit/docs/stat_report.md` 생성
- 보고서 구조와 작성 규칙은 **`~/.claude/skills/stat/REPORT_GUIDE.md`** 참조
- 시각화 필요 시 → `~/.claude/shared/viz/STYLE_GUIDE.md` Read 후 `~/.claude/shared/viz/charts/` 하위에서 적합한 차트 파일을 Read로 읽고 패턴을 따른다

## notebook 인자 처리

`dalykit:stat notebook` 호출 시:

1. `dalykit/code/py/stat_analysis.py` 존재 여부 확인 (Glob)
2. **있으면**: `# %%` 구분자 기준으로 셀 분리 → `dalykit/code/notebooks/stat_analysis.ipynb` 변환
3. **없으면**: "stat_analysis.py를 찾을 수 없습니다. `dalykit:stat`을 먼저 실행하세요." 안내 후 종료

## 의사결정 트리

> `TEST_SELECTION.md`의 의사결정 트리 + 사후 분석 매핑 참조

## 코드 생성 규칙

1. **Heavy-Task-Offload**: 1000행 이상 → .py 스크립트로 분석, 결과 JSON 저장
2. **자동 분기**: 가정 검정 + 본 검정 + 사후 분석을 `if/else`로 통합
3. **정규성 분기**: n > 5000 → Jarque-Bera, n ≤ 5000 → Shapiro-Wilk
4. **사후 분석 자동 연결**: 3+ 그룹 유의 시 자동 실행
5. **효과 크기 포함**: Cohen's d / η² / r² / Cramér's V
6. **노트북은 결과 표시만**: JSON 로드 + 요약 테이블 + 시각화
7. **유의수준**: 기본 α = 0.05
8. **한국어 주석**
9. **라이브러리**: scipy, statsmodels, scikit_posthocs (사후 분석)
