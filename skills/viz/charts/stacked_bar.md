# 누적 비율 — 스택 바차트

```python
# 범주형 변수 간 상대도수 비교 (crosstab 기반 — 안정적)
ct = pd.crosstab(df['범주변수'], df['그룹변수'], normalize='index') * 100

# 색상: 그룹 수에 맞게 (2그룹: skyblue/orange, 3그룹: + #D9D9D9)
colors = ['skyblue', 'orange', '#D9D9D9'][:len(ct.columns)]

fig, ax = plt.subplots(figsize=(10, 6))
ct.plot(kind='bar', stacked=True, rot=0, color=colors, ax=ax)

# 각 구간에 비율 텍스트 표시
for i, (idx, row) in enumerate(ct.iterrows()):
    cumval = 0
    for col in ct.columns:
        val = row[col]
        ax.text(x=i, y=cumval + val/2, s=f'{val:.1f}%',
                ha='center', va='center', fontsize=8, fontweight='bold')
        cumval += val

ax.set_title('범주별 상대도수 비교', fontdict={'fontweight': 'bold'})
ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)
plt.tight_layout()
plt.show()
```
