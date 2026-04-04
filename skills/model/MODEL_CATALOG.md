# 모델 카탈로그

모델별 기본 하이퍼파라미터 + 튜닝 그리드.

## 분류 모델

### LogisticRegression (LR)
```python
# 기본값
LogisticRegression(max_iter=1000, random_state=42)

# 튜닝 그리드
{
    'C': [0.01, 0.1, 1, 10],
    'penalty': ['l1', 'l2'],
    'solver': ['liblinear', 'saga']
}
```

### RandomForestClassifier (RF)
```python
# 기본값
RandomForestClassifier(n_estimators=100, random_state=42)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [5, 10, 20, None],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}
```

### XGBClassifier (XGB)
```python
# 기본값
XGBClassifier(n_estimators=100, random_state=42, eval_metric='logloss')

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7],
    'learning_rate': [0.01, 0.05, 0.1, 0.2],
    'subsample': [0.7, 0.8, 1.0],
    'colsample_bytree': [0.7, 0.8, 1.0]
}
```

### LGBMClassifier (LGBM)
```python
# 기본값
LGBMClassifier(n_estimators=100, random_state=42, verbose=-1)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7, -1],
    'learning_rate': [0.01, 0.05, 0.1],
    'num_leaves': [15, 31, 63],
    'subsample': [0.7, 0.8, 1.0]
}
```

### SVC (SVM)
```python
# 기본값
SVC(random_state=42, probability=True)

# 튜닝 그리드
{
    'C': [0.1, 1, 10],
    'kernel': ['rbf', 'linear'],
    'gamma': ['scale', 'auto']
}
```

### KNeighborsClassifier (KNN)
```python
# 기본값
KNeighborsClassifier()

# 튜닝 그리드
{
    'n_neighbors': [3, 5, 7, 11],
    'weights': ['uniform', 'distance'],
    'metric': ['euclidean', 'manhattan']
}
```

### DecisionTreeClassifier (DT)
```python
# 기본값
DecisionTreeClassifier(random_state=42)

# 튜닝 그리드
{
    'max_depth': [3, 5, 10, 20, None],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}
```

### GradientBoostingClassifier (GB)
```python
# 기본값
GradientBoostingClassifier(n_estimators=100, random_state=42)

# 튜닝 그리드
{
    'n_estimators': [100, 200, 500],
    'max_depth': [3, 5, 7],
    'learning_rate': [0.01, 0.05, 0.1],
    'subsample': [0.7, 0.8, 1.0]
}
```

---

## 회귀 모델

### LinearRegression (LR)
```python
# 기본값
LinearRegression()

# 튜닝: 없음 (하이퍼파라미터 없음)
# 대안: Ridge, Lasso, ElasticNet
{
    'alpha': [0.01, 0.1, 1, 10, 100]  # Ridge/Lasso용
}
```

### RandomForestRegressor (RF)
```python
# 기본값
RandomForestRegressor(n_estimators=100, random_state=42)

# 튜닝 그리드: 분류와 동일
```

### XGBRegressor (XGB)
```python
# 기본값
XGBRegressor(n_estimators=100, random_state=42)

# 튜닝 그리드: 분류와 동일 (eval_metric='rmse')
```

### LGBMRegressor (LGBM)
```python
# 기본값
LGBMRegressor(n_estimators=100, random_state=42, verbose=-1)

# 튜닝 그리드: 분류와 동일
```

### SVR (SVM)
```python
# 기본값
SVR()

# 튜닝 그리드: 분류와 동일 (probability 제외)
```

### KNeighborsRegressor (KNN)
```python
# 기본값
KNeighborsRegressor()

# 튜닝 그리드: 분류와 동일
```

### DecisionTreeRegressor (DT)
```python
# 기본값
DecisionTreeRegressor(random_state=42)

# 튜닝 그리드: 분류와 동일
```

### GradientBoostingRegressor (GB)
```python
# 기본값
GradientBoostingRegressor(n_estimators=100, random_state=42)

# 튜닝 그리드: 분류와 동일
```

---

## 자동 모델 선택 기본 후보

### 분류 (3-5개)
1. LogisticRegression — 베이스라인 (선형)
2. RandomForest — 앙상블 (비선형)
3. XGBoost — 부스팅
4. LightGBM — 부스팅 (대용량에 빠름)
5. SVC — 커널 기반

### 회귀 (3-5개)
1. LinearRegression — 베이스라인 (선형)
2. RandomForestRegressor — 앙상블
3. XGBRegressor — 부스팅
4. LGBMRegressor — 부스팅
5. SVR — 커널 기반

> 데이터 크기에 따라 후보 조정: n > 10,000이면 SVM 제외 (학습 느림)
