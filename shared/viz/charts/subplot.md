# 서브플롯 — 여러 차트 한 번에

```python
fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(14, 10))
# 각 서브플롯에 다른 차트 배치
sns.histplot(df['변수1'], ax=axes[0,0], kde=True)
axes[0,0].set_title('변수1 분포')
# ... 추가 서브플롯
plt.tight_layout()
plt.show()
```

## 차트 저장 (파일 출력 시)

```python
fig.savefig('docs/figures/chart_name.png', dpi=150, bbox_inches='tight')
```
