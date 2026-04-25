# 시계열 — 라인차트

```python
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(df['날짜변수'], df['값변수'], color='#333333', linewidth=1.5)
ax.set_title('시계열 추이', fontdict={'fontweight': 'bold'})
ax.set_xlabel('날짜')
ax.set_ylabel('값')
plt.tight_layout()
plt.show()
```
