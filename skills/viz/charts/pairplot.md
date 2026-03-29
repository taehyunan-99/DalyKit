# 다변량 — 페어플롯

```python
# 변수가 많으면 주요 변수만 선택
selected_cols = ['변수1', '변수2', '변수3', '변수4']
sns.pairplot(df[selected_cols], diag_kind='kde')
plt.suptitle('변수 간 관계', y=1.02)
plt.tight_layout()
plt.show()
```
