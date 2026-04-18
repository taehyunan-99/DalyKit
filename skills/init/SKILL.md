---
name: init
description: >
  DalyKit 프로젝트 구조 초기화. dalykit/ 폴더와 kit 기반 하위 디렉토리를 생성하고
  번들된 템플릿을 프로젝트에 복사한다.
  트리거: "dalykit:init", "프로젝트 초기화".
user_invocable: true
---

# Init (프로젝트 초기화)

`dalykit/` 표준 프로젝트 구조를 `kits/k1` 기준으로 생성한다.

## 사용법

```text
dalykit:init
```

## 핵심 원칙

- DalyKit은 Claude Code 플러그인 번들 내부 파일만 참조한다
- 절대 경로나 marketplace 내부 캐시 경로를 전제하지 않는다
- 최신 별칭 대신 `config/active.json`과 `kits/k1/` 구조를 기준으로 동작한다

## 번들 리소스

- 도메인 템플릿: [DOMAIN_TEMPLATE.md](../../templates/DOMAIN_TEMPLATE.md)
- requirements 템플릿: [REQUIREMENTS_TEMPLATE.txt](../../templates/REQUIREMENTS_TEMPLATE.txt)
- active 템플릿: [ACTIVE_TEMPLATE.json](../../templates/ACTIVE_TEMPLATE.json)
- progress 템플릿: [PROGRESS_TEMPLATE.md](../../templates/PROGRESS_TEMPLATE.md)

## 워크플로우

### 1단계: 존재 확인

- 현재 디렉토리에 `dalykit/` 폴더가 있는지 확인한다
- 있으면: "이미 초기화되어 있습니다. (`dalykit/` 폴더가 존재합니다)" 출력 후 종료

### 2단계: 폴더 생성

생성할 디렉토리:

- `dalykit/config`
- `dalykit/data/raw`
- `dalykit/kits/k1/eda/figures`
- `dalykit/kits/k1/clean/figures`
- `dalykit/kits/k1/stat/figures`
- `dalykit/kits/k1/feature/figures`
- `dalykit/kits/k1/model/models`
- `dalykit/kits/k1/model/figures`

```bash
mkdir -p dalykit/config dalykit/data/raw dalykit/kits/k1/eda/figures dalykit/kits/k1/clean/figures dalykit/kits/k1/stat/figures dalykit/kits/k1/feature/figures dalykit/kits/k1/model/models dalykit/kits/k1/model/figures
```

### 3단계: 템플릿 복사

1. [DOMAIN_TEMPLATE.md](../../templates/DOMAIN_TEMPLATE.md)를 `dalykit/config/domain.md`로 복사한다
2. [REQUIREMENTS_TEMPLATE.txt](../../templates/REQUIREMENTS_TEMPLATE.txt)를 `dalykit/config/requirements.txt`로 복사한다
3. [ACTIVE_TEMPLATE.json](../../templates/ACTIVE_TEMPLATE.json)을 `dalykit/config/active.json`으로 복사한다
4. [PROGRESS_TEMPLATE.md](../../templates/PROGRESS_TEMPLATE.md)를 `dalykit/config/progress.md`로 복사한다
5. `dalykit/kits/k1/manifest.json`을 아래 구조로 생성한다

```json
{
  "kit": "k1",
  "based_on": null,
  "start_stage": "eda",
  "copied_inputs": {},
  "notes": ""
}
```

### 4단계: 완료 메시지

```text
✅ DalyKit 프로젝트 초기화 완료

생성된 구조:
  dalykit/
  ├── config/
  │   ├── domain.md
  │   ├── requirements.txt
  │   ├── active.json
  │   └── progress.md
  ├── data/
  │   └── raw/
  └── kits/
      └── k1/
          ├── manifest.json
          ├── eda/
          ├── clean/
          ├── stat/
          ├── feature/
          └── model/

다음 단계:
  1. dalykit/data/raw/ 에 분석할 CSV 파일을 넣으세요
  2. dalykit:next 를 실행하세요
```
