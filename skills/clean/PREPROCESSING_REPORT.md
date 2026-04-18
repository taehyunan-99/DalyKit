# Clean 보고서 가이드

## 데이터 소스

- 입력: `dalykit/kits/{kit}/clean/clean_results.json`
- 출력: `dalykit/kits/{kit}/clean/clean_report.md`
- 결과 데이터: `dalykit/kits/{kit}/clean/cleaned.csv`
- 이미지: `dalykit/kits/{kit}/clean/figures/`

## 필수 섹션

1. 요약
2. 전처리 개요
3. 처리 내역
4. 전처리 후 데이터 상태
5. 다음 단계 추천

## 규칙

1. 보고서 파일명은 `clean_report.md`
2. 결과 데이터 파일명은 `cleaned.csv`
3. EDA를 참조할 경우 현재 kit의 `eda_report.md`를 읽는다
