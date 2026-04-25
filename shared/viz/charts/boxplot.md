# 비교 — 박스플롯

```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.boxplot(data=df, x='범주변수', y='수치변수',
            color='#D9D9D9', ax=ax)
ax.set_title('그룹별 분포 비교', fontdict={'fontweight': 'bold'})
plt.tight_layout()
plt.show()
```
