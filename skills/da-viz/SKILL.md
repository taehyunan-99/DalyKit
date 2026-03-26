---
name: da-viz
description: >
  데이터 시각화. matplotlib/seaborn으로 차트 코드를 노트북 셀에 생성한다.
  최종 보고서 작성 시에는 visualize 플러그인에 위임하여 HTML 대시보드를 생성한다.
  트리거: "/da-viz", "시각화", "차트 그려줘", "plot this", "그래프",
  "분포 보여줘", "히트맵", "산점도".
user_invocable: true
---

# DA-Viz (데이터 시각화)

주피터 노트북(.ipynb)에 matplotlib/seaborn 시각화 코드 셀을 NotebookEdit로 작성한다.

## 사용법

```
/da-viz [차트 유형] [데이터/변수]
/da-viz                          ← 데이터에 맞는 차트 자동 추천
/da-viz 분포 age                 ← 특정 변수의 분포
/da-viz scatter x y              ← 산점도
/da-viz report                   ← 최종 보고서 (visualize 플러그인 위임)
```

## 워크플로우

### 1단계: 시각화 목적 파악
- 사용자가 차트 유형을 지정하면 해당 유형 생성
- 미지정 시 데이터 특성에 따라 추천:

| 데이터 특성 | 추천 차트 |
|-------------|-----------|
| 수치형 1개 | 히스토그램 + KDE |
| 수치형 2개 | 산점도 |
| 범주형 1개 | 바차트 / 파이차트 |
| 범주형 + 수치형 | 박스플롯 / 바이올린 |
| 수치형 다수 | 상관 히트맵 / 페어플롯 |
| 시계열 | 라인차트 |
| 범주형 2개 (비율 비교) | 누적 비율 바차트 |
| 그룹 비교 | 그룹별 박스플롯 |

### 2단계: 노트북 셀 생성 (NotebookEdit)

차트 유형별 참조 패턴:

**분포 — 히스토그램 + KDE**
```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.histplot(df['변수'], kde=True, color='#BDBDBD', ax=ax)
ax.set_title('변수 분포', fontdict={'fontweight': 'bold'})
ax.set_xlabel('값')
ax.set_ylabel('빈도')
plt.tight_layout()
plt.show()
```

**관계 — 산점도**
```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.scatterplot(data=df, x='변수1', y='변수2', color='0.3', ax=ax)
ax.set_title('변수1와(과) 변수2의 관계', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

**관계 — 산점도 (그룹 비교)**
```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.scatterplot(data=df, x='변수1', y='변수2', hue='그룹변수',
                palette=['skyblue', 'orange'], ax=ax)
ax.set_title('변수1와(과) 변수2의 관계', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

**관계 — 산점도 + 회귀직선**
```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.regplot(data=df, x='변수1', y='변수2', ci=None,
            scatter_kws={'facecolor': '0.3', 'edgecolor': '1',
                         's': 15, 'alpha': 0.2},
            line_kws={'color': 'red', 'linewidth': 1.5}, ax=ax)
ax.set_title('변수1와(과) 변수2의 관계', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

**비교 — 박스플롯**
```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.boxplot(data=df, x='범주변수', y='수치변수',
            color='#D9D9D9', ax=ax)
ax.set_title('그룹별 분포 비교', fontdict={'fontweight': 'bold'})
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

**상관 — 히트맵**
```python
num_cols = df.select_dtypes(include=np.number).columns
corr = df[num_cols].corr()
mask = np.triu(np.ones_like(corr, dtype=bool), k=1)

fig, ax = plt.subplots(figsize=(12, 10))
sns.heatmap(corr, mask=mask, cmap='RdYlBu', annot=True, fmt='.2f',
            annot_kws={'fontweight': 'bold', 'fontsize': 8},
            linewidth=1, ax=ax)
ax.set_title('상관관계 히트맵', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

**범주 — 바차트**
```python
fig, ax = plt.subplots(figsize=(10, 6))
order = df['범주변수'].value_counts().index
colors = ['#D9D9D9'] * len(order)
colors[0] = 'skyblue'  # Top 1 강조
sns.countplot(data=df, x='범주변수', order=order, palette=colors, ax=ax)
ax.set_title('범주별 빈도', fontdict={'fontweight': 'bold'})
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

**시계열 — 라인차트**
```python
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(df['날짜변수'], df['값변수'], color='#333333', linewidth=1.5)
ax.set_title('시계열 추이', fontdict={'fontweight': 'bold'})
ax.set_xlabel('날짜')
ax.set_ylabel('값')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

**다변량 — 페어플롯**
```python
# 변수가 많으면 주요 변수만 선택
selected_cols = ['변수1', '변수2', '변수3', '변수4']
sns.pairplot(df[selected_cols], diag_kind='kde')
plt.suptitle('변수 간 관계', y=1.02)
plt.tight_layout()
plt.show()
```

**누적 비율 — 스택 바차트**
```python
# 범주형 변수 간 상대도수 비교
pv = pd.pivot_table(data=df, index='범주변수', columns='그룹변수', aggfunc='count')
p = df['그룹변수'].unique().size
pv = pv.iloc[:, 0:p].sort_index()
pv.columns = pv.columns.droplevel(level=0)
pv.columns.name = None
pv = pv.reset_index()

cols = pv.columns[1:]
rowsum = pv[cols].apply(func=sum, axis=1)
pv[cols] = pv[cols].div(rowsum, 0) * 100
cumsum = pv[cols].cumsum(axis=1)

# 색상: 그룹 수에 맞게 (2그룹: skyblue/orange, 3그룹: + #D9D9D9)
colors = ['skyblue', 'orange', '#D9D9D9'][:len(cols)]

fig, ax = plt.subplots(figsize=(10, 6))
pv.plot(x='범주변수', kind='bar', stacked=True, rot=0,
        color=colors, legend='reverse', ax=ax)

# 각 구간에 비율 텍스트 표시
for col in cols:
    for i, (v1, v2) in enumerate(zip(cumsum[col], pv[col])):
        ax.text(x=i, y=v1 - v2/2, s=f'{v2:.1f}%',
                ha='center', va='center', fontsize=8, fontweight='bold')

ax.set_title('범주별 상대도수 비교', fontdict={'fontweight': 'bold'})
ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)
plt.tight_layout()
plt.show()
```

**서브플롯 — 여러 차트 한 번에**
```python
fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(14, 10))
# 각 서브플롯에 다른 차트 배치
sns.histplot(df['변수1'], ax=axes[0,0], kde=True)
axes[0,0].set_title('변수1 분포')
# ... 추가 서브플롯
plt.tight_layout()
plt.show()
```

### 3단계: 차트 저장 (선택)
사용자 요청 시 이미지 파일로 저장하는 코드 추가:
```python
fig.savefig('chart_name.png', dpi=150, bbox_inches='tight')
```

## 최종 보고서 모드 (`/da-viz report` 또는 `/da report`)

최종 보고서가 필요한 경우 visualize 플러그인에 위임:
1. 분석 결과를 요약한 데이터 준비
2. visualize 플러그인을 호출하여 HTML 대시보드 생성
3. 주요 차트, 통계 요약, 인사이트를 포함한 인터랙티브 보고서

## 색상 규칙 (필수)

- **기본 톤**: 무채색 베이스 (`#D9D9D9` 연회색, `#808080` 중회색, `#333333` 진회색)
- **포인트 컬러**: 강조할 데이터에만 색상 사용, **최대 3색 이내**
- **비교 시**: 대비되는 보색 쌍 사용 — `skyblue` vs `orange`, `steelblue` vs `coral` 등
- **단일 분포/단일 변수**: 무채색(`gray`, `#BDBDBD`) 또는 포인트 1색
- **히트맵**: 발산형 팔레트(`RdYlBu`) 허용 (상관계수 특성상 예외)
- **바차트**: 전체 `#D9D9D9`, 강조 항목만 포인트 컬러
- **그룹 비교**: 2그룹 → `skyblue` vs `orange` / 3그룹 → + `gray` 추가
- **불필요한 색 남발 금지**: 범주가 많아도 핵심 항목만 색상, 나머지는 회색

## 코드 생성 규칙

1. **한국어 주석**: 차트 제목, 축 레이블 한국어 가능 (Malgun Gothic 폰트 설정 필요)
2. **figsize**: 적절한 크기로 가독성 확보 (기본 10×6)
3. **tight_layout**: 항상 `plt.tight_layout()` 포함
4. **대용량**: 1000행 이상 산점도는 `.sample(1000)` 또는 `alpha=0.3` 적용
5. **폰트 설정**: 한국어 레이블 사용 시 첫 셀에 폰트 설정 포함 — Windows `Malgun Gothic`, macOS `AppleGothic` (`platform.system()`으로 분기)
6. **글로벌 폰트**: `plt.rcParams['font.size'] = 8`, `plt.rcParams['font.weight'] = 'bold'` — import 셀에서 설정
7. **범례 위치**: `plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)` — 차트 하단 중앙 배치

## Tableau 확장 (추후)
- Tableau 스킬은 별도로 추가 예정
- 현재는 matplotlib/seaborn + visualize 플러그인으로 커버
