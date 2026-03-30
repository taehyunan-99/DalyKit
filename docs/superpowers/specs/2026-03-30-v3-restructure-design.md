# HarnessDA v3 구조 재설계 스펙

## 배경
- PPT(HTML 슬라이드) 기능 폐기: 퀄리티↔토큰 트레이드오프 해결 불가
- 마크다운 보고서 품질 향상에 집중
- `harnessda:init`으로 표준 프로젝트 구조 자동 생성
- 모든 출력물을 `harnessda/` 하위에 체계적 정리

## 프로젝트 구조 (init 생성물)

```
project/
└── harnessda/
    ├── config/
    │   ├── domain.md          ← 도메인 컨텍스트 템플릿
    │   └── report_config.md   ← 보고서 설정 템플릿
    ├── data/                  ← 원본 CSV
    │   └── cleaned/           ← 전처리 결과
    ├── code/                  ← .py 스크립트
    ├── docs/                  ← 보고서 (md)
    └── figures/               ← 시각화 이미지
```

## 스킬 스펙

### 1. harnessda:init
- 옵션 없음, 단순 실행
- 동작:
  1. 현재 디렉토리에 `harnessda/` 존재 확인
  2. 있으면 → "이미 초기화되어 있습니다" 안내 후 종료
  3. 없으면 → 폴더 생성 + config 템플릿 복사
  4. 완료 메시지 + 다음 단계 안내

### 2. harnessda:eda
```
harnessda:eda              ← data/에서 CSV 탐색 → 분석 → 보고서 자동
harnessda:eda update       ← 기존 py 재실행 → 보고서 갱신
harnessda:eda notebook     ← eda_analysis.py → ipynb 변환
```
- 데이터: `harnessda/data/`에서 자동 탐색
- 도메인: `harnessda/config/domain.md` 자동 참조 (있으면)
- 출력: `harnessda/code/eda_analysis.py`, `harnessda/docs/eda_report.md`, `harnessda/figures/`

### 3. harnessda:clean
```
harnessda:clean            ← data/ → 전처리 → cleaned/ 저장 + 보고서
harnessda:clean update     ← 기존 py 재실행 → 결과 갱신
harnessda:clean notebook   ← clean_pipeline.py → ipynb 변환
```
- 입력: `harnessda/data/`
- 출력: `harnessda/data/cleaned/`, `harnessda/code/clean_pipeline.py`, `harnessda/docs/preprocessing_report.md`

### 4. harnessda:stat
```
harnessda:stat             ← cleaned/ 데이터 → 통계 검정 → 보고서
harnessda:stat update      ← 기존 py 재실행 → 결과 갱신
harnessda:stat notebook    ← stat_analysis.py → ipynb 변환
```
- 입력: `harnessda/data/cleaned/`
- 출력: `harnessda/code/stat_analysis.py`, `harnessda/docs/stat_report.md`

### 5. harnessda:report
```
harnessda:report           ← docs/ 내 보고서 종합 → 최종 보고서
```
- 입력: `harnessda/docs/`의 eda_report.md, preprocessing_report.md, stat_report.md
- 출력: `harnessda/docs/report.md`
- 세부 구성은 별도 정의 예정

### 6. harnessda:help
```
harnessda:help             ← 스킬 목록 + 사용법 출력
```

## 공통 규칙

### 경로 자동 해석
- 모든 스킬은 실행 시 `harnessda/` 폴더 존재 여부 확인
- 없으면 → "harnessda:init을 먼저 실행하세요" 안내 후 종료

### 실행 패턴 (전 스킬 통일)
- Write(.py) → Bash 실행 → JSON 결과 → 보고서 자동 생성

### notebook 변환
- `# %%` 구분자 기준으로 셀 분리 → ipynb 변환
- eda, clean, stat 공통 적용

## 삭제 대상

### 파일 삭제
- `skills/report/HTML_TEMPLATE.md`
- `skills/report/JSON_SCHEMA.md`
- `skills/report/SCHEMA_COMMON.md`
- `skills/report/SCHEMA_DOMAIN.md`
- `skills/report/SCHEMA_PORTFOLIO.md`
- `skills/report/template.html`
- `skills/report/report_data.json`
- `skills/report/test_report_data.json`
- `skills/tracker/SKILL.md` (tracker 스킬 디렉토리 전체)

### 옵션 삭제
- `harnessda:report pptx`
- `harnessda:report config`
- `harnessda:eda domain`
- `harnessda:eda [데이터 경로]` (인자로 경로 지정)

## 수정 대상

### SKILL.md 수정 (전 스킬)
- 경로를 `harnessda/` 기준으로 변경
- init 존재 확인 로직 추가
- 삭제된 옵션 제거, notebook 옵션 추가

### 기타 문서 수정
- `CLAUDE.md` — 프로젝트 구조 + 스킬 목록 갱신
- `README.md` — 사용법 갱신
- `help/SKILL.md` — 스킬 목록 + 실행 패턴 갱신
- `scripts/install.ps1`, `install.sh` — tracker 제거, init 추가
- `scripts/uninstall.ps1`, `uninstall.sh` — tracker 제거, init 추가
- `agents/data-profiler.md` — 경로 참조 갱신
- `templates/` — init에서 직접 참조하므로 유지
- `docs/work-tracker.md` — 현재 상태 갱신
