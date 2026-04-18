---
name: doctor
description: >
  DalyKit 분석 환경 점검 및 의존성 설치.
  트리거: "dalykit:doctor", "dalykit:doctor install", "환경 점검", "의존성 설치".
user_invocable: true
---

# Doctor (환경 점검 · 의존성 부트스트랩)

> 프로젝트의 Python 실행 환경과 DalyKit 의존성을 점검하고, 필요 시 설치한다.

## 사용법

```
dalykit:doctor            ← 현재 분석 환경 점검
dalykit:doctor install    ← requirements.txt 기준 의존성 설치/업데이트
```

## 사전 조건

- `dalykit/` 폴더가 존재해야 한다
- `dalykit/config/domain.md`와 `dalykit/config/requirements.txt`가 있어야 한다
- 없으면: "`dalykit:init`을 먼저 실행하세요." 안내 후 종료

## 워크플로우

### 1단계: 실행 환경 확인

1. `dalykit/config/domain.md`를 읽어 `## 실행 환경`의 `가상환경 이름` 값을 확인한다
2. 가상환경 이름이 있으면 Python 실행 명령을 `conda run -n {env} --no-capture-output python`으로 설정한다
3. 비어 있으면 현재 세션 Python을 사용한다
   - 우선 `python3`
   - 없으면 `python`
4. 사용자가 `venv`를 활성화한 상태로 Claude Code를 실행했다면, 현재 세션 Python이 그 `venv` 인터프리터를 그대로 사용한다

### 2단계: 의존성 점검

1. `dalykit/config/requirements.txt`를 읽는다
2. 아래 검사를 수행한다
   - Python 버전 확인
   - `pip --version` 확인
   - 주요 패키지 import 검사: pandas, numpy, matplotlib, seaborn, scipy, statsmodels, sklearn, scikit_posthocs, xgboost, lightgbm, catboost, joblib
3. 결과를 표 형태로 요약한다
   - OK: import 성공
   - MISSING: import 실패
   - OPTIONAL: shap 미설치 등 선택 항목

### 3단계: install 인자 처리

`dalykit:doctor install` 호출 시:

1. 현재 사용 중인 Python 명령으로 아래를 실행한다

   ```bash
   python -m pip install -r dalykit/config/requirements.txt
   ```

2. conda 환경 이름이 있으면 아래 형태를 사용한다

   ```bash
   conda run -n {env} --no-capture-output python -m pip install -r dalykit/config/requirements.txt
   ```

3. 설치 완료 후 2단계 점검을 다시 실행해 누락 패키지를 재확인한다

## 출력 규칙

- 점검 시: 현재 Python 명령, Python 버전, 누락 패키지 목록을 먼저 요약한다
- 설치 시: 실제 실행한 설치 명령과 재점검 결과를 함께 요약한다
- 가상환경 이름이 비어 있으면:
  - "현재 세션 Python에 설치합니다. 프로젝트별 분리를 원하면 domain.md에 conda 환경 이름을 적으세요."를 출력한다
- 사용자가 `venv`를 활성화한 상태라면:
  - "현재 세션 Python이 활성 venv를 가리키므로 해당 환경에 설치/점검합니다."를 출력한다
