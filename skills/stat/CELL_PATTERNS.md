# Stat 파일 생성 패턴

`dalykit:stat`가 생성하는 파일 구조.

## 생성 파일

```text
dalykit/
└── kits/{kit}/stat/
    ├── stat_analysis.py
    ├── stat_analysis.ipynb
    ├── stat_results.json
    ├── stat_report.md
    └── figures/
```

## 워크플로우

```text
1. stat_analysis.py 생성
2. python 실행
3. stat_results.json 저장
4. stat_report.md 자동 생성
5. 필요 시 stat_analysis.ipynb 변환
```
