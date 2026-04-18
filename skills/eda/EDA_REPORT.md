# EDA 보고서 가이드

## 데이터 소스

- 입력: `dalykit/kits/{kit}/eda/eda_results.json`
- 출력: `dalykit/kits/{kit}/eda/eda_report.md`
- 이미지: `dalykit/kits/{kit}/eda/figures/`

## 필수 섹션

1. 요약
2. 데이터 개요
3. 결측값 분석
4. 수치형 변수 분석
5. 범주형 변수 분석
6. 변수 간 관계
7. 종합 판단 및 다음 단계

## 이미지 참조 규칙

- 보고서와 figures가 같은 stage 디렉토리 아래 있으므로 상대 경로는 `./figures/...`를 사용한다

예:

```markdown
![상관관계 히트맵](./figures/heatmap_corr.png)
```
