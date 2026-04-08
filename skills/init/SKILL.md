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

### 3단계: config 템플릿 복사

`~/.claude/plugins/installed_plugins.json`에서 DalyKit 플러그인 설치 경로를 읽어 템플릿을 복사한다.

1. Bash로 installPath 추출:

    ```bash
    python3 -c "
    import json
    data = json.load(open('$HOME/.claude/plugins/installed_plugins.json'))
    entries = data['plugins'].get('dalykit@taehyunan', [])
    print(entries[-1]['installPath'] if entries else '')
    "
    ```

2. 추출된 `installPath`를 `INSTALL_PATH`로 저장

3. `{INSTALL_PATH}/templates/DOMAIN_TEMPLATE.md`를 Read로 읽는다

4. 읽은 내용을 `dalykit/config/domain.md`에 Write로 저장

### 4단계: Harness Hook 설치

DalyKit Guard hook을 현재 프로젝트에 설치한다. 도구 오용을 물리적으로 차단하는 안전장치다.

1. `.claude/hooks/` 폴더 생성:

    ```bash
    mkdir -p .claude/hooks
    ```

2. 3단계에서 추출한 `INSTALL_PATH`를 사용해 hook 스크립트를 복사:

    - `{INSTALL_PATH}/hooks/guard_write.py`를 Read로 읽어 `.claude/hooks/guard_write.py`에 Write
    - `{INSTALL_PATH}/hooks/guard_read.py`를 Read로 읽어 `.claude/hooks/guard_read.py`에 Write

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
  │   ├── py/          ← .py 스크립트 (stat, ml)
  │   ├── notebooks/   ← .ipynb 노트북 (eda, clean, feature)
  │   └── results/     ← .json 결과 (eda/clean/feature/stat/model_results.json)
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
