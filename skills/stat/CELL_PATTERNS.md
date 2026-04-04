# 파일 생성 패턴

`dalykit:stat` 스킬이 생성하는 파일 구조.

> **Heavy-Task-Offload**: 데이터 분석은 .py 스크립트에서 수행.
> 결과는 JSON으로 저장. 노트북은 `notebook` 인자로 별도 변환.

## 생성 파일

```
dalykit/
├── code/
│   ├── stat_analysis.py         ← 분석 스크립트 (Write 도구로 생성)
│   ├── stat_results.json        ← 스크립트 실행 결과 (Bash로 실행)
│   └── stat_analysis.ipynb      ← (notebook 인자 시) py → ipynb 변환
└── docs/
    └── stat_report.md           ← 보고서 자동 생성
```

## 워크플로우

```
1. Write 도구 → dalykit/code/stat_analysis.py 생성
2. Bash 도구 → python dalykit/code/stat_analysis.py 실행
3. 완료 → dalykit/code/stat_results.json 저장됨
4. 자동 → dalykit/docs/stat_report.md 보고서 생성
```

## stat_analysis.py 구조

> `CODE_PATTERNS.md`의 ".py 스크립트 전체 구조" 섹션 참조
