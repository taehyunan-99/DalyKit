# 상관 — 히트맵

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
