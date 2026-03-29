# 관계 — 산점도

## 기본 산점도

```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.scatterplot(data=df, x='변수1', y='변수2', color='0.3', ax=ax)
ax.set_title('변수1와(과) 변수2의 관계', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

## 그룹 비교

```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.scatterplot(data=df, x='변수1', y='변수2', hue='그룹변수',
                palette=['skyblue', 'orange'], ax=ax)
ax.set_title('변수1와(과) 변수2의 관계', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```

## 회귀직선 포함

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
