# DalyKit

### Data Analysis Kit

> Let DalyKit handle the repetitive analysis code. You focus on the insights.  
> Streamline your data analysis workflow with a Claude Code plugin.

![version](https://img.shields.io/badge/version-0.2.0-blue?style=flat)
![license](https://img.shields.io/badge/license-MIT-green?style=flat)
![python](https://img.shields.io/badge/python-3.10%2B-yellow?style=flat&logo=python&logoColor=white)
![platform](https://img.shields.io/badge/platform-Claude%20Code-orange?style=flat)

English | [한국어](./README.md)

---

## Table of Contents

- [What is DalyKit?](#what-is-dalykit)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Workflow](#workflow)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Skills](#skills)
- [Kit Management](#kit-management)
- [Contact](#contact)

---

## What is DalyKit?

Data analysis is repetitive. You write the same EDA code, apply the same preprocessing patterns, and run models the same way every time.

DalyKit eliminates the repetition.

A single command generates analysis code, summarizes results into reports, and automatically runs model tuning loops. Analysts can focus entirely on insights.

### Key Features

- **Step-by-step workflow** — Run the full pipeline (init → eda → clean → stat → feature → ml) one skill at a time
- **Kit-based cycle management** — Each analysis attempt lives in its own `kits/k1/`, `kits/k2/` folder, keeping iterations independent
- **Context-efficient design** — Datasets over 1,000 rows are processed via separate `.py` scripts to prevent context window pollution
- **Standardized output** — All artifacts are saved under `dalykit/` in a consistent structure

<div align="right"><a href="#dalykit">Top</a></div>

---

## Installation

> **Requires** [Claude Code](https://claude.ai/code)

```
/plugin marketplace add taehyunan-99/DalyKit
/plugin install dalykit@taehyunan
```

After installation, get started with `dalykit:init`.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Quick Start

```
# 1. Initialize the project
dalykit:init

# 2. Place your CSV file in dalykit/data/raw/

# 3. Check the next step
dalykit:next
```

From there, `dalykit:next` guides you one step at a time.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Workflow

```
dalykit:init
│
├── dalykit:next          Auto-recommend the next step based on current state
│
├── dalykit:domain        Define domain information (optional)
│
├── dalykit:eda           Exploratory data analysis
│
├── dalykit:clean         Data preprocessing
│
├── dalykit:stat          Statistical analysis & hypothesis testing
│
├── dalykit:feature       Feature engineering
│
└── dalykit:ml            Model training & auto-tuning
```

Each skill can be called independently. Run the full pipeline in order, or use only the steps you need.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Project Structure

Folder structure created after running `dalykit:init`.

```
dalykit/
├── config/
│   ├── domain.md
│   ├── requirements.txt
│   ├── active.json      ← pointer to the current active kit
│   └── progress.md
├── data/
│   └── raw/             ← raw CSV files
└── kits/
    └── k1/
        ├── manifest.json
        ├── eda/
        ├── clean/
        ├── stat/
        ├── feature/
        └── model/
```

Each stage directory contains its own outputs:

- `eda/`: `eda_analysis.ipynb`, `eda_results.json`, `eda_report.md`, `figures/`
- `clean/`: `clean_pipeline.ipynb`, `clean_results.json`, `clean_report.md`, `cleaned.csv`, `figures/`
- `stat/`: `stat_analysis.py`, `stat_analysis.ipynb`, `stat_results.json`, `stat_report.md`, `figures/`
- `feature/`: `feature_pipeline.ipynb`, `feature_results.json`, `feature_select.py`, `feature_select_results.json`, `selected_features.txt`, `feature_report.md`, `featured.csv`, `figures/`
- `model/`: `model_train.py`, `model_results.json`, `model_report.md`, `models/`, `figures/`

<div align="right"><a href="#dalykit">Top</a></div>

---

## Tech Stack

| Purpose | Library |
|---------|---------|
| Data processing | pandas 2.x, numpy 2.x |
| Visualization | matplotlib 3.x, seaborn 0.13.x |
| Statistical analysis | scipy 1.x, statsmodels 0.14.x, scikit-posthocs 0.x |
| Machine learning | scikit-learn 1.x, xgboost 3.x, lightgbm 4.x, catboost 1.x, joblib 1.x |
| Model interpretation | shap (optional) |

<div align="right"><a href="#dalykit">Top</a></div>

---

## Skills

| Command | Description | Output |
|---------|-------------|--------|
| `dalykit:init` | Initialize project structure | `dalykit/kits/k1/` |
| `dalykit:next` | Recommend the next step based on current state | — |
| `dalykit:domain` | Structure domain info (free-form → domain.md) | `config/domain.md` |
| `dalykit:eda` | Exploratory data analysis | `kits/{kit}/eda/eda_analysis.ipynb` |
| `dalykit:eda report` | Generate EDA report from executed notebook | `kits/{kit}/eda/eda_report.md` |
| `dalykit:clean` | Data preprocessing | `kits/{kit}/clean/clean_pipeline.ipynb` |
| `dalykit:clean report` | Generate preprocessing report from executed notebook | `kits/{kit}/clean/clean_report.md` |
| `dalykit:stat` | Statistical analysis & hypothesis testing | `kits/{kit}/stat/stat_report.md` |
| `dalykit:stat notebook` | Convert py → ipynb | `kits/{kit}/stat/stat_analysis.ipynb` |
| `dalykit:feature` | Feature engineering — encoding, scaling, derived variables | `kits/{kit}/feature/feature_pipeline.ipynb` |
| `dalykit:feature select` | Greedy Forward Selection + CV-based feature subset comparison | `kits/{kit}/feature/feature_select_results.json` |
| `dalykit:feature report` | Generate feature report from executed notebook | `kits/{kit}/feature/feature_report.md` |
| `dalykit:ml` | Auto model selection (3–5 models) + tuning | `kits/{kit}/model/` |
| `dalykit:ml LR,RF,XGB` | Compare specified models + tuning | `kits/{kit}/model/` |
| `dalykit:ml ensemble` | Compare Voting + Stacking ensemble with top baseline models | `kits/{kit}/model/model_results.json` |
| `dalykit:ml report` | Generate report + visualizations from results JSON + refresh progress | `kits/{kit}/model/model_report.md` |
| `dalykit:doctor` | Check environment | Python / package status |
| `dalykit:doctor install` | Install dependencies | current Python/conda env |
| `dalykit:kit` | Show active kit | `config/active.json` |
| `dalykit:kit new` | Create a new kit | `kits/kN/` |
| `dalykit:kit list` | List kits | scan result of `kits/` |
| `dalykit:kit switch k1` | Switch active kit | `config/active.json` |
| `dalykit:progress` | Refresh progress document | `config/progress.md` |
| `dalykit:help` | Show help | — |

<div align="right"><a href="#dalykit">Top</a></div>

---

### Skills in Detail

### `dalykit:init` — Project Initialization

The first skill to run before starting any analysis. Creates the `dalykit/` folder and its kit-based structure in one step, and copies the necessary configuration files.

**How it works**

1. Exits if `dalykit/` already exists to prevent duplicate initialization
2. Creates `config`, `data/raw`, `kits/k1/{eda,clean,stat,feature,model}` folders
3. Copies `domain.md`, `requirements.txt`, `active.json`, `progress.md` from the plugin bundle
4. Creates `kits/k1/manifest.json`

**Output**
```
dalykit/
├── config/
│   ├── domain.md
│   ├── requirements.txt
│   ├── active.json
│   └── progress.md
├── data/
│   └── raw/
└── kits/
    └── k1/
        ├── manifest.json
        ├── eda/
        ├── clean/
        ├── stat/
        ├── feature/
        └── model/
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:next` — Next Step Recommendation

Reads the current state and automatically recommends the one next command to run. Use it anytime you're unsure where to start.

**Decision order**

1. Check initialization (`dalykit/config/active.json` existence)
2. Check raw data (`data/raw/` has CSV/Excel files)
3. Check domain structuring
4. Check split report stages (if result files exist but report not yet generated, prioritize report command)
5. Recommend based on pipeline order (`eda → clean → stat → feature → ml`)
6. Guide post-completion branching

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:domain` — Domain Information Structuring

A skill for organizing data and business context before analysis. Claude reads your free-form notes and converts them into a structured format that subsequent skills can reference.

**How it works**

1. Read the free-form input section of `dalykit/config/domain.md`
2. Explore CSV files in `dalykit/data/raw/` to understand column names, types, and distributions
3. Combine free-form input + CSV info to structure: industry, target variable, column descriptions, domain rules, etc.
4. Overwrite only the structured section of `domain.md` (free-form input is preserved)

You can run this even without any free-form input — CSV column info alone is enough to generate structure. However, items like domain rules and business constraints that can't be inferred from data are best entered manually.

This file is referenced by every subsequent skill from `dalykit:eda` through `dalykit:ml`.

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:eda` — Exploratory Data Analysis

Automatically generates a Jupyter notebook to analyze your data's structure, distributions, missing values, and correlations.

**How it works**

1. Explore CSV files in `dalykit/data/raw/`
2. If `domain.md` is present, incorporates domain context into the notebook structure
3. Generate `kits/{kit}/eda/eda_analysis.ipynb` (the final cell auto-saves analysis results to `eda_results.json`)
4. User runs the notebook manually, then calls `dalykit:eda report` to generate the report

**Execution flow**
```
dalykit:eda           → generates eda_analysis.ipynb
  ↓ user runs notebook (→ eda_results.json auto-saved)
dalykit:eda report    → reads eda_results.json → generates eda_report.md
```

You run the notebook yourself — this lets you check and adjust results cell by cell for better analysis quality.

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:clean` — Data Preprocessing

Generates a preprocessing pipeline notebook to handle missing values, duplicates, outliers, and type conversions. If an EDA report exists, it automatically incorporates the findings into the preprocessing strategy.

**How it works**

1. If `eda_report.md` exists, extract missing value / outlier / type issues; otherwise profile the data directly
2. Generate `kits/{kit}/clean/clean_pipeline.ipynb` (the final cell auto-saves preprocessing results to `clean_results.json`)
3. User runs the notebook manually, then calls `dalykit:clean report` to generate the report
4. Preprocessing result is saved as `kits/{kit}/clean/cleaned.csv`

**Missing value strategy** (auto-selected by missing ratio)

| Missing ratio | Strategy |
|---------------|----------|
| > 50% | Recommend column removal (user confirmation) |
| 5 ~ 50% | Group median imputation → fallback: simple median |
| < 5% | Simple median / mode imputation |
| Complex pattern | IterativeImputer cell provided separately (optional) |

**Outlier handling workflow**

Outliers are not removed automatically. Only detection results are printed; treatment options (IQR removal / clipping) are provided as commented-out cells.

```
dalykit:clean            → generates clean_pipeline.ipynb
  ↓ run notebook (review outlier detection results, → clean_results.json auto-saved)
dalykit:clean report     → reads clean_results.json → review report
  ↓ uncomment outlier treatment cell in notebook, re-run
dalykit:clean report     → updated report
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:stat` — Statistical Analysis & Hypothesis Testing

Identifies variable measurement scales and automatically selects appropriate statistical tests. Incorporates recommendations from EDA/preprocessing reports if available.

**How it works**

1. Extract analysis recommendations from EDA/preprocessing reports; otherwise profile data directly
2. Identify variable scales (nominal / ordinal / interval / ratio) → auto-select appropriate tests
3. Generate `kits/{kit}/stat/stat_analysis.py` and run it automatically
4. Save results as JSON and auto-generate `stat_report.md`

Unlike eda/clean, no manual notebook execution is required — the pipeline runs end-to-end from script execution to report generation. Use `dalykit:stat notebook` if you want to review results in a notebook.

**Execution flow**
```
dalykit:stat          → generates + runs stat_analysis.py → auto-generates stat_report.md
dalykit:stat notebook → converts to stat_analysis.ipynb
```

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:feature` — Feature Engineering

Generates a notebook to perform encoding, scaling, derived variable creation, and feature selection on preprocessed data. Automatically configures strategy by referencing summary sections from EDA, preprocessing, and statistical reports.

**How it works**

1. Reference summary sections of previous reports (eda, clean, stat) → identify encoding targets and significant variables
2. Read `domain.md` for target variable and domain rules
3. Generate `kits/{kit}/feature/feature_pipeline.ipynb` (the final cell auto-saves feature transformation results to `feature_results.json`)
4. User runs the notebook manually, then calls `dalykit:feature report` to generate the report
5. Feature result saved as `kits/{kit}/feature/featured.csv` (input for the ml skill)

**Execution flow**
```
dalykit:feature           → generates feature_pipeline.ipynb
  ↓ user runs notebook (→ feature_results.json auto-saved)
dalykit:feature select    → Greedy Forward Selection + CV comparison on featured.csv (optional)
dalykit:feature report    → reads feature_results.json → generates feature_report.md
```

**`dalykit:feature select` — Feature Subset Comparison**

An optional auxiliary step to find the optimal feature subset from `featured.csv`. Returns recommendations only — does not modify `featured.csv`.

- Auto CV strategy selection: GroupKFold → TimeSeriesSplit → StratifiedKFold → KFold (based on data characteristics)
- Lightweight base model (LGBM/RF) for relative performance comparison (not final model performance)
- Output: `feature_select_results.json`, `selected_features.txt`, `figures/feature_select_*.png`

<div align="right"><a href="#dalykit">Top</a></div>

---

### `dalykit:ml` — Model Training & Auto-Tuning

Trains machine learning models on feature-engineered data and tunes them automatically. Auto-detects classification vs. regression, compares 3–5 candidate models, selects the best-performing ones, and runs a tuning loop.

**How it works**

1. Reference summary sections of previous reports + read `domain.md` for target variable and performance goal
2. Determine strategy by data size (small n≤10k: full comparison / medium n≤100k: exclude SVM / large n>100k: sample → select → retrain)
3. Generate `kits/{kit}/model/model_train.py` and run it automatically in background
4. After the first round, perform feature diagnostics (importance convergence, multicollinearity, overfitting, overall underperformance)
5. If no issues, select top 1–2 models → run tuning loop (max 5 rounds)
6. For regression: auto-judge target log transform (identity vs log1p); `y.min() >= 0` required, metrics evaluated on original scale after inverse transform
7. Save results to `model_results.json` + `models/{model_name}.joblib`

**Tuning stop conditions**

| Condition | Action |
|-----------|--------|
| Target performance reached | Stop |
| Improvement ≤ 0.5% vs. previous or performance drop | Convergence stop |
| Max 5 rounds reached | Force stop |

**Execution flow**
```
dalykit:ml              → auto model selection + tuning loop
dalykit:ml LR,RF,XGB   → compare specified models + tuning
dalykit:ml ensemble     → compare Voting + Stacking ensemble with top baseline models
dalykit:ml report       → model_results.json → model_report.md + refresh progress
```

**Feature diagnostic signals**

If any of the following signals are detected after the first round, the process stops early and provides feature improvement feedback.

| Signal | Threshold |
|--------|-----------|
| Feature importance near zero | >50% of features have importance < 0.01 |
| Multicollinearity | VIF > 10 for any feature pair |
| Overfitting | Train-test performance gap > 10% |
| Overall underperformance | All models below baseline |

If feature revision is required, return to `dalykit:feature`, update and re-run the notebook, then re-run `dalykit:ml`.

<div align="right"><a href="#dalykit">Top</a></div>

---

## Kit Management

`dalykit:kit` is the key command for managing independent analysis cycles.

Example:

```
dalykit:kit new feature
```

This creates a new kit, copies the prerequisite artifacts from the previous kit, and restarts from the feature stage.

Benefits:

- You can discard `k1` and continue independently with `k2`
- Even if you abandon a previous kit, the new kit has its own input files to remain self-contained
- Reports, figures, and model files all stay grouped under the same kit for easy tracking

| Command | Description |
|---------|-------------|
| `dalykit:kit` | Show current active kit |
| `dalykit:kit new` | Create a new kit (auto-assigns next number) |
| `dalykit:kit new feature` | Create a new kit starting from the feature stage |
| `dalykit:kit list` | List all kits with completed stages summary |
| `dalykit:kit switch k2` | Switch active kit |

<div align="right"><a href="#dalykit">Top</a></div>

---

## Contact

[![Email](https://img.shields.io/badge/Email-withblua%40gmail.com-D14836?style=flat&logo=gmail&logoColor=white)](mailto:withblua@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-taehyun--an-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/taehyun-an-8b07993a5)
[![Velog](https://img.shields.io/badge/Velog-taehyunan817-20C997?style=flat&logo=velog&logoColor=white)](https://velog.io/@taehyunan817/posts)

<div align="right"><a href="#dalykit">Top</a></div>
