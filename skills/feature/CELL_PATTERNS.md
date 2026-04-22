# Feature 노트북 셀 패턴

`dalykit:feature`가 생성하는 노트북은 아래 경로 계약을 따른다.

## 생성 파일

```text
dalykit/
└── kits/{kit}/feature/
    ├── feature_pipeline.ipynb
    ├── feature_results.json
    ├── featured.csv
    ├── feature_select.py
    ├── feature_select_results.json
    ├── selected_features.txt
    └── figures/
```

## 필수 코드 패턴

```python
import json
from pathlib import Path

BASE_DIR = Path("/absolute/path/to/dalykit")  # 생성 시 실제 dalykit 절대 경로로 치환
ACTIVE = json.loads((BASE_DIR / "config" / "active.json").read_text(encoding="utf-8"))
KIT = ACTIVE["kit"]

CLEAN_DIR = BASE_DIR / "kits" / KIT / "clean"
INPUT_PATH = CLEAN_DIR / "cleaned.csv"  # 사용자가 CSV를 직접 지정했으면 해당 경로로 치환

STAGE_DIR = BASE_DIR / "kits" / KIT / "feature"
FIGURES_DIR = STAGE_DIR / "figures"
RESULT_PATH = STAGE_DIR / "feature_results.json"
OUTPUT_PATH = STAGE_DIR / "featured.csv"

FIGURES_DIR.mkdir(parents=True, exist_ok=True)
```

```python
def save_results(payload):
    RESULT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
```

```python
# 최종 저장 셀
df_feat.to_csv(OUTPUT_PATH, index=False)
save_results(results)
```

## 셀 단위 저장 규칙

피처 엔지니어링 노트북도 마지막 셀에서만 저장하지 않는다. 인코딩, 스케일링, 파생 변수 생성, 피처 제거 같은 주요 셀마다 `results`를 갱신하고 `save_results(results)`를 호출한다.

```python
# 초기화 셀 — 설정 셀 직후에 위치
results = {
    "metadata": {"kit": KIT, "input": str(INPUT_PATH)},
    "steps": {},
    "created_features": [],
    "removed_features": [],
}
save_results(results)
```

```python
# 예: 인코딩 셀
results["steps"]["encoding"] = {"method": "label", "columns": [...]}
save_results(results)
```

```python
# 예: 스케일링 셀
results["steps"]["scaling"] = {"method": "standard", "columns": [...]}
save_results(results)
```

```python
# 예: 파생 변수 셀
results["created_features"].extend([...])
results["steps"]["derived"] = {"added": [...]}
save_results(results)
```

## `feature_select.py` 패턴

```python
SELECT_SCRIPT_PATH = STAGE_DIR / "feature_select.py"
SELECT_RESULT_PATH = STAGE_DIR / "feature_select_results.json"
SELECTED_FEATURES_PATH = STAGE_DIR / "selected_features.txt"

def select_cv_strategy(task_type, group_col=None, time_col=None, cv_strategy=None, cv_folds=5):
    if cv_strategy == "group" and group_col:
        return GroupKFold(n_splits=cv_folds), f"GroupKFold(group={group_col})"
    if cv_strategy == "timeseries" and time_col:
        return TimeSeriesSplit(n_splits=cv_folds), f"TimeSeriesSplit(time={time_col})"
    if group_col:
        return GroupKFold(n_splits=cv_folds), f"GroupKFold(group={group_col})"
    if time_col:
        return TimeSeriesSplit(n_splits=cv_folds), f"TimeSeriesSplit(time={time_col})"
    if task_type == "classification":
        return StratifiedKFold(n_splits=cv_folds, shuffle=True, random_state=42), "StratifiedKFold"
    return KFold(n_splits=cv_folds, shuffle=True, random_state=42), "KFold"

def select_candidates(X, y, model, max_candidates=30):
    model.fit(X, y)
    importance = pd.Series(model.feature_importances_, index=X.columns).sort_values(ascending=False)
    return importance.head(min(len(importance), max_candidates)).index.tolist(), importance

def greedy_forward_selection(X, y, candidates, model, scorer, splitter, groups=None):
    selected, history = [], []
    remaining = list(candidates)
    while remaining:
        step_scores = []
        for feature in remaining:
            cols = selected + [feature]
            scores = cross_val_score(model, X[cols], y, cv=splitter, scoring=scorer, groups=groups)
            step_scores.append((feature, scores.mean(), scores.std(), scores))
        best_feature, mean_score, std_score, fold_scores = max(step_scores, key=lambda item: item[1])
        history.append({"added_feature": best_feature, "features": selected + [best_feature], "mean_score": mean_score, "std_score": std_score, "fold_scores": fold_scores.tolist()})
        selected.append(best_feature)
        remaining.remove(best_feature)
        if len(history) >= 2 and history[-1]["mean_score"] - history[-2]["mean_score"] < 0.001:
            break
    return selected, history

def save_feature_select(payload, best_features):
    SELECT_RESULT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    SELECTED_FEATURES_PATH.write_text("\n".join(best_features), encoding="utf-8")
```

## 규칙

1. 결과 데이터 파일명은 항상 `featured.csv`
2. 결과 JSON은 `feature_results.json`
3. 시각화는 `feature/figures/`에 저장
4. `feature select`는 별도 결과 파일만 저장하고 `featured.csv`를 덮어쓰지 않는다
5. 주요 처리 셀 끝에서 `save_results(results)`를 호출한다
