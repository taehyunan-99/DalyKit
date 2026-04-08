---
name: feature
description: >
  피처 엔지니어링. 전처리된 데이터에서 인코딩, 스케일링, 파생 변수 생성,
  피처 선택을 수행하는 노트북을 생성한다.
  트리거: "dalykit:feature", "피처 엔지니어링", "feature engineering",
  "인코딩", "스케일링", "파생 변수".
user_invocable: true
---

# Feature Engineering (피처 엔지니어링)

> ipynb 노트북 생성 → 사용자가 직접 실행 → `dalykit:feature report`로 보고서 생성.

## 사용법

```
dalykit:feature          ← cleaned 데이터 → feature_pipeline.ipynb 생성
dalykit:feature report   ← 실행된 노트북 결과 읽기 → dalykit/docs/feature_report.md 생성
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다 (Glob으로 확인)
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 경로 규칙

| 항목 | 경로 |
|------|------|
| 입력 데이터 | `dalykit/data/*_cleaned.csv` |
| 도메인 설정 | `dalykit/config/domain.md` |
| 노트북 | `dalykit/code/notebooks/feature_pipeline.ipynb` |
| JSON 결과 | `dalykit/code/results/feature_results.json` |
| 출력 데이터 | `dalykit/data/df_featured.csv` |
| 보고서 | `dalykit/docs/feature_report.md` |

## 워크플로우

### 1단계: 컨텍스트 수집 (2단계 참조)

1. **1차 — 요약만 Read (view_range)**:
  - `dalykit/docs/eda_report.md` → `## 요약` 섹션
  - `dalykit/docs/preprocessing_report.md` → `## 요약` 섹션
  - `dalykit/docs/stat_report.md` → `## 요약` 섹션
  - 보고서가 없으면 해당 항목 스킵
2. **2차 — 필요 시 상세 Read**:
  - 인코딩 대상 파악 시 → preprocessing_report.md "최종 컬럼 목록" 섹션
  - 유의미한 변수 파악 시 → stat_report.md "가설 통합 표" 또는 "요약 테이블" 섹션
3. `dalykit/config/domain.md` Read → 타겟 변수, 도메인 규칙 확인
4. `dalykit/data/` Glob → cleaned CSV 파일 탐색

### 2단계: ipynb 노트북 생성

> **출력 규칙**: 전략 제안이나 승인 요청 없이 바로 노트북을 생성한다. 전략은 노트북 셀 주석으로 확인 가능하다. 생성 완료 후 1-2줄 안내만 출력한다.

> `~/.claude/skills/feature/CELL_PATTERNS.md`를 Read로 읽고 셀 구조를 따른다.

- Write 도구로 `dalykit/code/notebooks/feature_pipeline.ipynb` 생성 (nbformat 4)
- 생성 완료 후 사용자에게 안내:
  ```
  feature_pipeline.ipynb 생성 완료.
  노트북을 열어 전체 셀을 실행한 뒤 `dalykit:feature report`를 실행하세요.
  피처 결과는 dalykit/data/df_featured.csv 에 저장됩니다.
  ```

### report 인자 워크플로우

> `dalykit:feature report` 호출 시 실행. 노트북을 사용자가 실행한 뒤 호출해야 한다.

1. `dalykit/code/results/feature_results.json` Read → 피처 변환 결과 데이터 확인
2. `dalykit/docs/feature_report.md` Write → 보고서 생성
3. JSON 미존재 시: "노트북을 먼저 실행한 뒤 다시 시도하세요." 안내 후 종료

## 참조 문서

| 파일 | 내용 |
|------|------|
| `CELL_PATTERNS.md` | ipynb 셀 구조 및 코드 패턴 |

## 코드 생성 규칙

1. **주석은 한국어**로 작성
2. **비파괴적**: `df_feat = df.copy()`로 원본 보존
3. **출력 제한**: `.head()`, `.describe()`, `.value_counts()` 등 요약만
4. **폰트 설정**: Windows `Malgun Gothic`, macOS `AppleGothic` — `platform.system()`으로 분기
5. **변수명**: 입력 데이터프레임은 `df`, 피처 결과는 `df_feat`
6. **저장**: 마지막 셀에서 `dalykit/data/df_featured.csv`로 저장
7. **이미지 저장**: `dalykit/figures/`에 저장 (`plt.savefig()`)

## 시각화 참조

> 색상 규칙, 폰트, 범례 설정은 `~/.claude/shared/viz/STYLE_GUIDE.md`를 Read로 읽고 따른다.
> 차트 코드 패턴은 `~/.claude/shared/viz/charts/` 하위에서 필요한 차트 파일만 Read로 읽고 따른다.
