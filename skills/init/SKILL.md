---
name: init
description: >
  HarnessDA 프로젝트 구조 초기화. harnessda/ 폴더와 하위 디렉토리를 생성하고
  config 템플릿을 자동 배치한다.
  트리거: "harnessda:init", "프로젝트 초기화", "init", "시작".
user_invocable: true
---

# Init (프로젝트 초기화)

`harnessda/` 표준 프로젝트 구조를 생성한다.

## 사용법

```
harnessda:init              ← harnessda/ 폴더 + 하위 구조 + config 템플릿 생성
```

## 워크플로우

### 1단계: 존재 확인

- Glob으로 현재 디렉토리에 `harnessda/` 폴더 존재 여부 확인
- **있으면**: "이미 초기화되어 있습니다. (`harnessda/` 폴더가 존재합니다)" 출력 후 종료
- **없으면**: 2단계로 진행

### 2단계: 폴더 생성

Bash 도구로 디렉토리 생성:

```bash
mkdir -p harnessda/config harnessda/data/cleaned harnessda/code harnessda/docs harnessda/figures
```

### 3단계: config 템플릿 복사

플러그인의 `templates/` 디렉토리에서 템플릿을 복사한다.

1. `templates/DOMAIN_TEMPLATE.md`를 Read로 읽는다
2. 내용을 `harnessda/config/domain.md`에 Write로 저장
3. `templates/REPORT_CONFIG_TEMPLATE.md`를 Read로 읽는다
4. 내용을 `harnessda/config/report_config.md`에 Write로 저장

### 4단계: 완료 메시지

아래 내용을 출력한다:

```
✅ HarnessDA 프로젝트 초기화 완료

생성된 구조:
  harnessda/
  ├── config/          ← domain.md, report_config.md
  ├── data/            ← 여기에 CSV 파일을 넣으세요
  │   └── cleaned/
  ├── code/
  ├── docs/
  └── figures/

다음 단계:
  1. harnessda/data/ 에 분석할 CSV 파일을 넣으세요
  2. (선택) harnessda/config/domain.md 를 편집하세요
  3. harnessda:eda 를 실행하세요
```
