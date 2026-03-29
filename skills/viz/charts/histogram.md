# 분포 — 히스토그램 + KDE

```python
fig, ax = plt.subplots(figsize=(10, 6))
sns.histplot(df['변수'], kde=True, color='#BDBDBD', ax=ax)
ax.set_title('변수 분포', fontdict={'fontweight': 'bold'})
ax.set_xlabel('값')
ax.set_ylabel('빈도')
plt.tight_layout()
plt.show()
```
