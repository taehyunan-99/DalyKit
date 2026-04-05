# 범주 — 바차트

```python
fig, ax = plt.subplots(figsize=(10, 6))
order = df['범주변수'].value_counts().index
colors = ['#D9D9D9'] * len(order)
colors[0] = 'skyblue'  # Top 1 강조
sns.countplot(data=df, x='범주변수', hue='범주변수', order=order, palette=colors, legend=False, ax=ax)
ax.set_title('범주별 빈도', fontdict={'fontweight': 'bold'})
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```
