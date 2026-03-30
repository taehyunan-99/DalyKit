# 보고서 품질 보강 계획

> 기준: 제조 AI 실습 프로젝트 기획서 (4.1~4.9 수행 과업)
> 범위: 현재 EDA/전처리/통계/최종 보고서 구조 보강 (ML 파이프라인 제외)
> 원칙: 각 스킬 보고서 품질 향상 → 최종 보고서 자동 향상

---

## 현황 분석

### 기획서 vs HarnessDA 매핑

| 기획서 항목 | 담당 스킬 | 현재 상태 | 보강 필요 |
|-----------|----------|----------|----------|
| 4.1 문제 정의 | report (report_config.md) | 간단 기입만 가능 | ✅ 구조화 |
| 4.2 데이터 이해 및 진단 | eda | 대부분 충족 | ✅ 불균형/타겟 분석 추가 |
| 4.3 가설 수립 및 검증 | stat-analysis | H0 검정 있으나 형식 차이 | ✅ 가설 표 형식 보강 |
| 4.4 피처 엔지니어링 | (없음) | ML 확장 시 추가 | ❌ 이번 범위 외 |
| 4.5~4.6 ML 모델링/성능 | (없음) | ML 확장 시 추가 | ❌ 이번 범위 외 |
| 4.7 모델 해석 | (없음) | ML 확장 시 추가 | ❌ 이번 범위 외 |
| 4.8 적용 시나리오 | report | 없음 | ✅ 섹션 추가 |
| 4.9 한계 및 개선 | report (각 보고서 분산) | 종합 부재 | ✅ 구조화 |

---

## 수정 태스크

### Task 1: EDA 보고서 보강 (EDA_REPORT.md)

**파일**: `skills/eda/EDA_REPORT.md`

**추가/수정 항목**:

1. **§4 범주형 변수 분석 → 타겟 변수 불균형 분석 추가**
   - 타겟(종속변수)이 범주형일 때 클래스 비율 명시
   - 불균형 심각도 판단 기준 (90:10 이상 → 🔴)
   - 기획서 근거: "데이터 불균형 여부 확인 → 모델 영향 고려 필요"

2. **§3 수치형 변수 분석 → 타겟 변수 중심 분석 관점 추가**
   - 타겟이 수치형일 때 분포 특성 별도 강조 (정규성, 편향, 이상치)
   - 기획서 근거: "타깃 변수 분포 그래프" 필수

3. **§7 다음 단계 추천 → 가설 수립 연결 강화**
   - EDA에서 관찰한 패턴 → 가설 후보 목록 제안
   - 기획서 근거: "EDA 이후, 데이터에 대한 가설을 만들고 검증"

---

### Task 2: 통계 보고서 보강 (REPORT_GUIDE.md)

**파일**: `skills/stat-analysis/REPORT_GUIDE.md`

**추가/수정 항목**:

1. **§3 가설 검정 → "가설 수립 및 검증" 통합 표 추가**
   - 기존 H0/결론 형식 유지 + 기획서 형식 표 병행:

   ```
   | 가설 | 근거 (EDA 관찰) | 검증 방법 | 결과 | 채택 여부 |
   ```

   - 기획서 근거: "가설 내용, 근거, 검증 방법, 결과, 채택 여부" 표 형식

2. **§5 실질적 해석 → "현장 제어 가능성" 관점 추가**
   - 유의한 변수가 현장에서 제어 가능한지 판단
   - 기획서 근거: "가장 중요한 변수는 무엇인가? 현장에서 제어 가능한가?"

3. **§1 연구 개요 → EDA 가설 후보 참조 명시**
   - EDA 보고서의 가설 후보 → stat 분석 계획으로 이어지는 흐름 명시
   - 기획서 근거: 가설의 "근거" 컬럼 = EDA에서 관찰한 패턴

---

### Task 3: 최종 보고서 보강 (SLIDE_STRUCTURE.md + SKILL.md)

**파일**: `skills/report/SLIDE_STRUCTURE.md`, `skills/report/SKILL.md`

**추가/수정 항목**:

1. **`problem` 섹션 구조화**
   - 현재: 배경, 목적, 해결하려는 질문
   - 추가: **산업적 가치**, **기대 효과**, **왜 이 문제인지**
   - 기획서 근거: "문제 해결 시 산업적 가치 설명"

2. **`hypothesis` 섹션 신규 추가** (stat_report 존재 시)
   - 가설 수립 및 검증 요약 테이블
   - stat_report.md의 가설 통합 표에서 추출
   - 기획서 근거: "최소 3개 이상 가설 + 표 형식"

3. **`application` 섹션 신규 추가**
   - 분석 결과의 실제 적용 시나리오
   - 신규 데이터 적용 가능성
   - 기획서 근거: 4.8 "모델을 실제로 사용할 경우를 가정"

4. **`conclusion` 섹션 보강**
   - 현재: 문제에 대한 답, 한계점, 후속 제안
   - 추가: 한계점을 **데이터 한계 / 분석 한계 / 추가 데이터 필요성**으로 구분
   - 기획서 근거: 4.9 한계 및 개선 방향의 3분류

5. **분량 가이드라인 추가**
   - 최소 권장: 섹션 8개 이상, 표 5개 이상, 시각화 5개 이상
   - 기획서 근거: "최소 10페이지, 그래프 5개 이상, 표 5개 이상"

---

### Task 4: report_config 템플릿 보강

**파일**: `templates/REPORT_CONFIG_TEMPLATE.md`

**추가/수정 항목**:

1. **문제 정의 섹션 구조화**
   - 현재 있는 항목 확인 후 부족한 필드 추가:
     - 해결하려는 문제
     - 왜 이것이 문제인가 (산업적 맥락)
     - 해결 시 기대 효과
     - 적용 시나리오 (선택)

---

### Task 5: 시각화 조건부 저장 체계 구축

**문제**: `harnessda/figures/` 경로는 존재하지만, .py 스크립트에 `plt.savefig()` 패턴이 없어 시각화가 저장된 적 없음. 보고서에서 이미지를 참조할 수 없는 상태.

**원칙**: "인사이트가 있는 시각화"가 아니라 **"판단 근거가 되는 시각화"를 저장**한다.
- 유의한 결과 → 핵심 발견의 시각적 근거
- **유의하지 않은 결과 → "관계 없음"의 시각적 근거** (이것도 인사이트)
- 데이터 품질 이슈 → 문제 심각도의 시각적 근거

---

#### 5-1. 저장 기준 정의

**EDA 단계 (eda_analysis.py)**

| 조건 | 저장할 차트 | 파일명 패턴 | 판단 근거 |
|------|-----------|------------|----------|
| 타겟 변수 존재 | 타겟 분포 (히스토그램/바차트) | `dist_target_{변수명}.png` | 종속변수 현황 파악 — 보고서 핵심 |
| 타겟 범주형 + 불균형 (최소 클래스 < 20%) | 타겟 클래스 비율 바차트 | `imbalance_target_{변수명}.png` | 불균형 심각도 시각적 근거 |
| 결측률 > 5% 컬럼 1개 이상 | 결측값 히트맵 or 바차트 | `missing_overview.png` | 데이터 품질 이슈 근거 |
| 이상치 비율 > 5% 변수 1개 이상 | 해당 변수 박스플롯 | `outlier_{변수명}.png` | 이상치 심각도 근거 |
| 수치형 변수 2개 이상 | 상관 히트맵 | `heatmap_correlation.png` | 변수 관계 전체 조감도 |
| 강한 상관 \|r\| > 0.7 쌍 존재 | 해당 변수 쌍 산점도 | `scatter_{변수1}_vs_{변수2}.png` | 다중공선성/변수 제거 판단 근거 |

**통계 분석 단계 (stat_analysis.py)**

| 조건 | 저장할 차트 | 파일명 패턴 | 판단 근거 |
|------|-----------|------------|----------|
| 가설 검정 수행 (유의/비유의 무관) | 검정 관련 시각화 | `stat_{분석명}.png` | **가설 채택/기각의 시각적 근거** |
| 2그룹 비교 (t-test, Mann-Whitney) | 그룹별 박스플롯 또는 바이올린플롯 | `stat_compare_{X}_by_{Y}.png` | 차이 유무 시각적 확인 |
| 3+그룹 비교 (ANOVA, Kruskal-Wallis) | 그룹별 박스플롯 | `stat_compare_{X}_by_{Y}.png` | 그룹 간 차이 패턴 |
| 상관 검정 (Pearson, Spearman) | 산점도 + 추세선 | `stat_corr_{X}_vs_{Y}.png` | 관계 방향/강도 시각적 확인 |
| 사후 분석 유의 쌍 존재 | 사후 분석 히트맵 | `stat_posthoc_{분석명}.png` | 어떤 그룹 쌍이 다른지 근거 |

> **핵심**: 가설이 기각되지 않은(유의하지 않은) 결과도 반드시 저장한다.
> "상관이 없다"를 보여주는 산점도, "차이가 없다"를 보여주는 박스플롯이
> 보고서에서 "이 가설은 기각할 수 없다"의 시각적 근거가 된다.

---

#### 5-2. 저장 패턴 (CELL_PATTERNS.md에 추가)

**공통 savefig 패턴**:
```python
# 저장 유틸리티
def save_fig(fig, filename):
    """판단 근거가 되는 시각화를 figures/에 저장"""
    filepath = os.path.join(FIGURES_DIR, filename)
    fig.savefig(filepath, dpi=150, bbox_inches='tight', facecolor='white')
    plt.close(fig)
    return filepath

saved_figures = []  # 저장된 파일 목록 추적
```

**EDA 예시**:
```python
# %% 시각화: 타겟 분포 (항상 저장)
if TARGET_COL:
    fig, ax = plt.subplots(figsize=(8, 5))
    if df[TARGET_COL].dtype == 'object' or df[TARGET_COL].nunique() <= 10:
        df[TARGET_COL].value_counts().plot.bar(ax=ax)
    else:
        df[TARGET_COL].hist(ax=ax, bins=30)
    ax.set_title(f'타겟 변수 분포: {TARGET_COL}')
    path = save_fig(fig, f'dist_target_{TARGET_COL}.png')
    saved_figures.append({'type': 'target_dist', 'path': path})

# %% 시각화: 상관 히트맵 (수치형 2개 이상일 때)
if len(num_cols) >= 2:
    fig, ax = plt.subplots(figsize=(10, 8))
    sns.heatmap(df[num_cols].corr(), annot=True, fmt='.2f', ax=ax, cmap='RdBu_r')
    ax.set_title('변수 간 상관관계')
    path = save_fig(fig, 'heatmap_correlation.png')
    saved_figures.append({'type': 'correlation', 'path': path})

# %% 시각화: 이상치 박스플롯 (이상치 비율 > 5%인 변수만)
for col in num_cols:
    outlier_pct = results['outliers'].get(col, {}).get('pct', 0)
    if outlier_pct > 5:
        fig, ax = plt.subplots(figsize=(8, 5))
        df[col].plot.box(ax=ax)
        ax.set_title(f'이상치 분포: {col} ({outlier_pct:.1f}%)')
        path = save_fig(fig, f'outlier_{col}.png')
        saved_figures.append({'type': 'outlier', 'path': path})
```

**stat 예시**:
```python
# %% 시각화: 가설 검정 결과 (유의 여부 무관하게 모든 검정 저장)
for analysis in results['results']:
    name = analysis['name']
    p_value = analysis['p_value']
    conclusion = '유의' if p_value < 0.05 else '비유의'

    # 2그룹/다그룹 비교 → 박스플롯
    if analysis['type'] in ('t_test', 'mann_whitney', 'anova', 'kruskal'):
        fig, ax = plt.subplots(figsize=(8, 5))
        # 그룹별 박스플롯 생성
        ax.set_title(f'{name} (p={p_value:.4f}, {conclusion})')
        path = save_fig(fig, f'stat_{name}.png')
        saved_figures.append({'type': 'hypothesis', 'path': path, 'significant': p_value < 0.05})

    # 상관 검정 → 산점도
    elif analysis['type'] in ('pearson', 'spearman'):
        fig, ax = plt.subplots(figsize=(8, 5))
        # 산점도 + 추세선 생성
        ax.set_title(f'{name} (r={analysis["statistic"]:.3f}, p={p_value:.4f}, {conclusion})')
        path = save_fig(fig, f'stat_corr_{name}.png')
        saved_figures.append({'type': 'correlation_test', 'path': path, 'significant': p_value < 0.05})
```

---

#### 5-3. JSON에 저장 목록 포함

```python
# results JSON에 저장된 시각화 목록 추가
results['figures'] = saved_figures
```

→ 보고서 생성 시 `results['figures']`를 읽어 `![설명](../figures/파일명.png)` 자동 삽입

---

#### 5-4. 보고서에서 이미지 참조 패턴

**각 스킬 보고서 (eda_report.md, stat_report.md)**:
- JSON의 `figures` 목록에 있는 이미지만 보고서에 삽입
- 상대경로 사용: `![타겟 변수 분포](../figures/dist_target_quality.png)`
- 이미지 아래에 1줄 해석 추가

**최종 보고서 (report.md)**:
- 각 섹션에 맞는 이미지를 선별하여 참조
- `distributions` 섹션 → `dist_*`, `imbalance_*`
- `correlations` 섹션 → `heatmap_*`, `scatter_*`
- `stat_results` 섹션 → `stat_*`
- `data_quality` 섹션 → `missing_*`, `outlier_*`

---

#### 5-5. 수정 대상 파일

| 파일 | 수정 내용 |
|------|----------|
| `skills/eda/CELL_PATTERNS.md` | save_fig 유틸 + 조건부 저장 패턴 + saved_figures 추적 추가 |
| `skills/stat-analysis/CODE_PATTERNS.md` | 검정별 시각화 저장 패턴 추가 (유의/비유의 모두) |
| `skills/eda/EDA_REPORT.md` | figures 참조 패턴 + 이미지 삽입 가이드 추가 |
| `skills/stat-analysis/REPORT_GUIDE.md` | figures 참조 패턴 + 이미지 삽입 가이드 추가 |
| `skills/report/SLIDE_STRUCTURE.md` | 섹션별 이미지 매핑 규칙 갱신 (JSON figures 기반) |

---

## 수정하지 않는 항목

| 항목 | 이유 |
|------|------|
| 전처리 보고서 (PREPROCESSING_REPORT.md) | 현재 구조 충분히 충실 (WHY 필수, 대안 기록 등). 피처 엔지니어링 연결은 ML 확장 시 |
| 피처 엔지니어링 | ML 파이프라인 스킬로 별도 추가 예정 |
| 모델링/성능/해석 | ML 파이프라인 스킬로 별도 추가 예정 |

---

## 실행 순서

```
Task 1 (EDA_REPORT.md 보강)
  → Task 2 (REPORT_GUIDE.md 보강)
  → Task 3 (SLIDE_STRUCTURE.md + report SKILL.md 보강)
  → Task 4 (REPORT_CONFIG_TEMPLATE.md 보강)
  → Task 5 (시각화 조건부 저장 체계)
      5-1. eda/CELL_PATTERNS.md — save_fig 유틸 + EDA 조건부 저장
      5-2. stat-analysis/CODE_PATTERNS.md — 검정별 시각화 저장
      5-3. eda/EDA_REPORT.md — figures 참조 패턴 추가
      5-4. stat-analysis/REPORT_GUIDE.md — figures 참조 패턴 추가
      5-5. report/SLIDE_STRUCTURE.md — 섹션별 이미지 매핑 갱신
```

소스 보고서(1, 2) 보강 → 최종 보고서(3) 보강 → 템플릿(4) 갱신 → 시각화 체계(5) 구축

> Task 5는 Task 1~3에서 추가된 섹션(타겟 분포, 가설 검증 등)과 연동되므로 마지막에 수행
