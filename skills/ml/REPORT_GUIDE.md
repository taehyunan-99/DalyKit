# ML 보고서 가이드

## 데이터 소스

- 입력: `dalykit/kits/{kit}/model/model_results.json`
- 출력: `dalykit/kits/{kit}/model/model_report.md`
- 모델 파일: `dalykit/kits/{kit}/model/models/*.joblib`
- 이미지: `dalykit/kits/{kit}/model/figures/`

## 필수 섹션

1. 요약
2. 학습 개요
3. 타깃 변환 판단
4. 모델 비교
5. 피처 진단
6. 튜닝 이력
7. 최종 모델 상세
8. SHAP 해석
9. 한계점 및 추가 분석 추천

## 타깃 변환 기록 규칙

- 회귀 문제에서만 다룬다
- `identity`와 `log1p` 비교 여부를 기록한다
- `log1p` 사용 시 적용 이유와 역변환 방식을 적는다
- 성능 지표는 반드시 원본 스케일에서 계산했다고 명시한다
- `model_results.json`의 `target_transform` 필드를 요약한다

## 이미지 참조 규칙

- 보고서 안의 이미지 경로는 `./figures/...`
- 모델 파일 경로는 `./models/...`로 기록한다
