# 파일 생성 패턴

`harnessda:stat` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 분석은 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 노트북은 생성하지 않는다.

## 생성 파일

```
프로젝트/                        ← 프로젝트 루트 (노트북과 같은 디렉토리)
├── stat_analysis.py             ← 분석 스크립트 (Write 도구로 생성)
├── stat_results.json            ← 스크립트 실행 결과 (Bash로 실행)
└── docs/
    └── stat_report.md           ← harnessda:stat report로 생성
```

## 워크플로우

```
1. Write 도구 → stat_analysis.py 생성
2. Bash 도구 → python stat_analysis.py 실행
3. 완료 → stat_results.json 저장됨
```

> 결과 활용: `harnessda:stat report` → JSON 읽어 `docs/stat_report.md` 생성
> 시각화: `viz/charts/` 하위에서 적합한 차트 파일을 Read로 읽고 패턴을 따른다

## stat_analysis.py 구조

> `CODE_PATTERNS.md`의 ".py 스크립트 전체 구조" 섹션 참조
