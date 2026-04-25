# 시각화 스타일 가이드

모든 스킬(EDA, 통계 분석, 시각화)에서 차트 생성 시 이 규칙을 따른다.

---

## 색상 규칙

- **기본 톤**: 무채색 베이스 (`#D9D9D9` 연회색, `#808080` 중회색, `#333333` 진회색)
- **포인트 컬러**: 강조할 데이터에만 색상 사용, **최대 3색 이내**
- **비교 시**: 대비되는 보색 쌍 사용 — `skyblue` vs `orange`, `steelblue` vs `coral` 등
- **단일 분포/단일 변수**: 무채색(`gray`, `#BDBDBD`) 또는 포인트 1색
- **히트맵**: 발산형 팔레트(`RdYlBu`) 허용 (상관계수 특성상 예외)
- **바차트**: 전체 `#D9D9D9`, 강조 항목만 포인트 컬러
- **그룹 비교**: 2그룹 → `skyblue` vs `orange` / 3그룹 → + `gray` 추가
- **불필요한 색 남발 금지**: 범주가 많아도 핵심 항목만 색상, 나머지는 회색

## 폰트 설정

```python
import platform
if platform.system() == 'Darwin':
    plt.rcParams['font.family'] = 'AppleGothic'
else:
    plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['font.size'] = 8
plt.rcParams['font.weight'] = 'bold'
```

## 코드 생성 규칙

1. **한국어 주석**: 차트 제목, 축 레이블 한국어 가능
2. **figsize**: 적절한 크기로 가독성 확보 (기본 10×6)
3. **tight_layout**: 항상 `plt.tight_layout()` 포함
4. **대용량**: 1000행 이상 산점도는 `.sample(1000)` 또는 `alpha=0.3` 적용
5. **범례 위치**: 범례가 필요한 차트(그룹 비교, 누적 바차트 등)에서만 `ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=5)` — 차트 하단 중앙 배치. 단일 변수 차트에서는 범례 불필요.
6. **X축 라벨 회전 금지**: `plt.xticks(rotation=...)` 사용 금지. 라벨이 길어 겹치면 회전 대신 ① figsize 확대, ② 컬럼 분할(예: 상위 N개만, 그룹별 분리), ③ 가로 바차트(`barh`)로 해결한다. 회전된 라벨은 막대 위치와 시각적으로 어긋나 오독을 유발한다.
