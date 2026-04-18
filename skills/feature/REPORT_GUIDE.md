# Feature 보고서 가이드

## 데이터 소스

- 입력: `dalykit/kits/{kit}/feature/feature_results.json`
- 선택 입력: `dalykit/kits/{kit}/feature/feature_select_results.json`
- 출력: `dalykit/kits/{kit}/feature/feature_report.md`
- 결과 데이터: `dalykit/kits/{kit}/feature/featured.csv`
- 이미지: `dalykit/kits/{kit}/feature/figures/`

## 필수 섹션

1. 요약
2. 피처 변경 내역
3. 최종 피처 상태
4. 모델링 관점 평가
5. 다음 단계 추천

## 선택 섹션

`feature_select_results.json`이 있을 때만 아래 섹션을 추가한다.

6. 피처 선택 결과

기록 항목:

- 사용한 CV 전략과 선택 이유
- 베이스 모델
- 선택 방법 (`greedy_forward`)
- 최적 step, 최적 피처 수, 최고 CV 점수
- 최종 추천 피처 목록
- 제외된 주요 피처 또는 개선 정체 구간

## 규칙

1. 결과 데이터 파일명은 `featured.csv`
2. 보고서와 이미지는 같은 stage 디렉토리 기준으로 `./figures/...` 상대 경로를 사용한다
3. `feature select` 결과는 요약만 포함하고 `featured.csv` 자동 변경으로 서술하지 않는다
