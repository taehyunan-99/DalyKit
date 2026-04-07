---
name: init
description: >
    DalyKit 프로젝트 구조 초기화. dalykit/ 폴더와 하위 디렉토리를 생성하고
    config 템플릿을 자동 배치한다.
    트리거: "dalykit:init", "프로젝트 초기화", "init", "시작".
user_invocable: true
---

# Init (프로젝트 초기화)

`dalykit/` 표준 프로젝트 구조를 생성한다.

## 사용법

```
dalykit:init              ← dalykit/ 폴더 + 하위 구조 + config 템플릿 생성
```

## 워크플로우

### 1단계: 존재 확인

- Glob으로 현재 디렉토리에 `dalykit/` 폴더 존재 여부 확인
- **있으면**: "이미 초기화되어 있습니다. (`dalykit/` 폴더가 존재합니다)" 출력 후 종료
- **없으면**: 2단계로 진행

### 2단계: 폴더 생성

생성할 하위 디렉토리 목록: `config`, `data`, `code/py`, `code/notebooks`, `code/results`, `models`, `docs`, `figures`

```bash
mkdir -p dalykit/config dalykit/data dalykit/code/py dalykit/code/notebooks dalykit/code/results dalykit/models dalykit/docs dalykit/figures
```

### 3단계: config 템플릿 생성

아래 내용을 `dalykit/config/domain.md`에 Write로 저장한다.

```markdown
# 자유 입력
<!-- 데이터/도메인에 대해 아는 것을 자유롭게 작성하세요. 형식 무관. -->
<!-- 예: "은행 고객 데이터, Personal Loan이 타겟, Experience 음수는 정상" -->
<!-- 작성 후 dalykit:domain 을 실행하면 아래 구조화 정보가 자동 생성됩니다 -->


## 실행 환경
<!-- conda 가상환경 이름만 입력하세요 (예: myenv) -->
<!-- 미입력 시 dalykit:init이 자동 감지합니다 -->
- 가상환경 이름:

---

# 구조화 정보
<!-- dalykit:domain이 자동 생성. 직접 수정하지 마세요. -->
<!-- dalykit:domain 실행 전까지 아래 항목을 직접 채워도 됩니다 -->
<!-- 빈 항목은 AI가 데이터에서 추론합니다 -->

## 업종
<!-- 아래에서 선택하거나 직접 입력하세요 -->
<!-- finance / healthcare / manufacturing / ecommerce / (직접 입력) -->
<!-- 미지정 시 AI가 컬럼명·데이터 특성에서 자동 추론합니다 -->
- 업종:

## 데이터 설명
<!-- 데이터의 출처와 수집 방법을 적어주세요 -->
<!-- 예: "KB부동산 실거래가 데이터, 2020~2024년, 서울 아파트" -->
<!-- 예: "UniversalBank 고객 데이터, 5000명, 인구통계+금융상품 가입 정보" -->
- 설명:

## 핵심 타겟 변수
<!-- 예측/분석하려는 종속변수를 적어주세요 -->
<!-- 예: "거래금액" / "이탈 여부(Churn)" / "불량 여부(Defect)" / "Personal Loan" -->
- 타겟:

## 주요 피처
<!-- 타겟에 영향을 줄 것으로 예상되는 변수들 -->
<!-- 예: "전용면적, 층, 시군구" / "Income, Age, Education" -->
- 피처:

## 컬럼 설명
<!-- 변수명이 약어·불명확한 경우 설명을 추가하세요 -->
<!-- AI가 이상치 판단, 가설 수립, 현장 제어 가능성 판단, 보고서 서술에 활용합니다 -->
<!-- 제어 가능 여부: ✅ 현장에서 직접 조정 가능 / ❌ 외부 환경·고객 속성 등 불가 -->
| 컬럼명 | 설명 | 단위 | 제어 가능 여부 |
|--------|------|------|--------------|
|        |      |      |              |

## 도메인 규칙
<!-- 값 처리 기준 — 전문가만 아는 이상치·대체 규칙 (AI가 전처리 판단에 활용) -->
<!-- 예: "층 음수는 반지하 → 정상 데이터, 제거 금지" -->
<!-- 예: "Experience 음수는 신입 → 정상, 0으로 대체" -->
-

## 비즈니스 제약
<!-- 분석 시 반드시 고려해야 할 제약 조건 -->
<!-- 예: "고객 개인정보 컬럼(ID, 이름)은 분석에서 제외" -->
<!-- 예: "재건축 충족 아파트는 시세 괴리 큼 → 별도 분석 필요" -->
-

## 특이사항
<!-- 데이터의 알려진 한계, 주의점 등 -->
<!-- 예: "2020년 이전 데이터는 수집 기준 변경으로 비교 시 주의" -->
-

## ML 목표 (선택)
<!-- 머신러닝 모델 학습 시 참조합니다. 미입력 시 자동 감지합니다 -->
- 타겟 변수:
- 문제 유형: (분류 / 회귀)
- 목표 성능: (예: accuracy ≥ 0.85)
```

### 3.5단계: 가상환경 자동 감지

`dalykit/config/domain.md`의 `- 가상환경 이름:`이 비어 있으면 자동 감지를 시도한다.

1. Bash로 현재 활성 conda 환경 이름 확인:
   ```bash
   conda info --envs 2>/dev/null | grep '\*' | awk '{print $1}' || echo "NO_CONDA"
   ```

2. 결과 해석:
   - conda 활성 환경 감지됨 (예: myenv) → `- 가상환경 이름: myenv` 기입
   - conda 없음 → 공백 유지, 완료 메시지에 "가상환경 미감지 — 필요 시 직접 입력하세요" 안내

3. `dalykit/config/domain.md`의 `- 가상환경 이름:` 라인을 Edit 도구로 수정하여 감지 결과 기입

4. 완료 메시지에 감지 결과 포함:
   ```
   가상환경 자동 감지: myenv
   변경이 필요하면 dalykit/config/domain.md 를 편집하세요.
   ```

### 4단계: Harness Hook 설치

DalyKit Guard hook을 현재 프로젝트에 설치한다. 도구 오용을 물리적으로 차단하는 안전장치다.

1. `.claude/hooks/` 폴더 생성:

    ```bash
    mkdir -p .claude/hooks
    ```

2. hook 스크립트 복사:

    ```bash
    cp ~/.claude/hooks/guard_write.py .claude/hooks/guard_write.py
    cp ~/.claude/hooks/guard_read.py .claude/hooks/guard_read.py
    ```

3. `.claude/settings.json` 생성 또는 업데이트:
    - 파일이 없으면 아래 내용으로 Write로 생성
    - 파일이 있으면 Read로 읽은 뒤 `hooks` 키를 병합하여 Write로 저장

    ```json
    {
        "hooks": {
            "PreToolUse": [
                {
                    "matcher": "Write|Edit",
                    "hooks": [
                        {
                            "type": "command",
                            "command": "python3 .claude/hooks/guard_write.py 2>/dev/null || python .claude/hooks/guard_write.py"
                        }
                    ]
                },
                {
                    "matcher": "Read",
                    "hooks": [
                        {
                            "type": "command",
                            "command": "python3 .claude/hooks/guard_read.py 2>/dev/null || python .claude/hooks/guard_read.py"
                        }
                    ]
                }
            ]
        }
    }
    ```

### 5단계: 완료 메시지

```
✅ DalyKit 프로젝트 초기화 완료

생성된 구조:
  dalykit/
  ├── config/          ← domain.md
  ├── data/            ← 원본 CSV + 전처리 + 피처 결과
  ├── code/
  │   ├── py/          ← .py 스크립트
  │   ├── notebooks/   ← .ipynb 노트북
  │   └── results/     ← .json 결과
  ├── models/          ← .joblib 모델 파일
  ├── docs/
  └── figures/

  .claude/
  ├── hooks/           ← DalyKit Guard (도구 오용 차단)
  └── settings.json    ← hook 설정

다음 단계:
  1. dalykit/data/ 에 분석할 CSV 파일을 넣으세요
  2. (선택) dalykit/config/domain.md 를 편집하세요
  3. dalykit:eda 를 실행하세요
```
