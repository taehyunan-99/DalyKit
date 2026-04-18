# DalyKit

### Data Analysis Kit

> A Claude Code plugin that manages end-to-end data analysis workflows as independent kits.

![version](https://img.shields.io/badge/version-0.2.0-blue?style=flat)
![license](https://img.shields.io/badge/license-MIT-green?style=flat)
![python](https://img.shields.io/badge/python-3.10%2B-yellow?style=flat&logo=python&logoColor=white)
![platform](https://img.shields.io/badge/platform-Claude%20Code-orange?style=flat)

English | [한국어](./README.md)

---

## What is DalyKit?

DalyKit is a Claude Code plugin for EDA, preprocessing, statistical analysis, feature engineering, and machine learning.

Its core design now uses `kits` as the unit of iteration. Instead of scattering stage outputs across global folders, each analysis cycle lives under its own `k1`, `k2`, ... directory.

---

## Installation

> **Requires** [Claude Code](https://claude.ai/code)

```text
/plugin marketplace add taehyunan-99/DalyKit
/plugin install dalykit@taehyunan
```

Start with `dalykit:init`.

---

## Quick Start

```text
1. dalykit:init
2. Place CSV files in dalykit/data/raw/
3. dalykit:next
```

From there, `dalykit:next` guides the next step one command at a time.

---

## Workflow

Basic flow:

```text
dalykit:init → dalykit:next (repeat)
```

Default sequence behind `dalykit:next`:

```text
domain → eda → clean → stat → feature → ml → ml report
```

Core concepts:

- Raw data lives in `dalykit/data/raw/`
- Each analysis cycle lives in `dalykit/kits/k1/`, `dalykit/kits/k2/`, ...
- The active kit is tracked by `dalykit/config/active.json`
- Overall status is summarized in `dalykit/config/progress.md`

---

## Project Structure

```text
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

Each stage directory contains its own outputs:

- `eda/`: `eda_analysis.ipynb`, `eda_results.json`, `eda_report.md`, `figures/`
- `clean/`: `clean_pipeline.ipynb`, `clean_results.json`, `clean_report.md`, `cleaned.csv`, `figures/`
- `stat/`: `stat_analysis.py`, `stat_analysis.ipynb`, `stat_results.json`, `stat_report.md`, `figures/`
- `feature/`: `feature_pipeline.ipynb`, `feature_results.json`, `feature_select.py`, `feature_select_results.json`, `selected_features.txt`, `feature_report.md`, `featured.csv`, `figures/`
- `model/`: `model_train.py`, `model_results.json`, `model_report.md`, `models/`, `figures/`

---

## Skills

### Basic

| Command | Description | Main Output |
|---------|-------------|-------------|
| `dalykit:init` | Initialize kit-based project structure | `dalykit/kits/k1/` |
| `dalykit:next` | Recommend the next step | — |
| `dalykit:eda` | Generate EDA notebook | `kits/{kit}/eda/eda_analysis.ipynb` |
| `dalykit:clean` | Generate preprocessing notebook | `kits/{kit}/clean/clean_pipeline.ipynb` |
| `dalykit:stat` | Generate/run statistical analysis + auto-report | `kits/{kit}/stat/` |
| `dalykit:feature` | Generate feature engineering notebook | `kits/{kit}/feature/feature_pipeline.ipynb` |
| `dalykit:ml` | Train and compare models | `kits/{kit}/model/` |
| `dalykit:ml report` | Generate model report + refresh progress | `kits/{kit}/model/model_report.md` |
| `dalykit:help` | Show help | — |

### Advanced

| Command | Description | Main Output |
|---------|-------------|-------------|
| `dalykit:doctor` | Check environment | Python / package status |
| `dalykit:doctor install` | Install dependencies | current Python/conda env |
| `dalykit:domain` | Structure domain information | `config/domain.md` |
| `dalykit:kit` | Show active kit | `config/active.json` |
| `dalykit:kit new` | Create a new kit | `kits/kN/` |
| `dalykit:kit list` | List kits | scan result of `kits/` |
| `dalykit:kit switch k1` | Switch active kit | `config/active.json` |
| `dalykit:progress` | Refresh progress document | `config/progress.md` |
| `dalykit:eda report` | Generate EDA report | `kits/{kit}/eda/eda_report.md` |
| `dalykit:clean report` | Generate preprocessing report | `kits/{kit}/clean/clean_report.md` |
| `dalykit:stat notebook` | Convert stat py → ipynb | `kits/{kit}/stat/stat_analysis.ipynb` |
| `dalykit:feature select` | Compare feature subsets with CV | `kits/{kit}/feature/feature_select_results.json` |
| `dalykit:feature report` | Generate feature report | `kits/{kit}/feature/feature_report.md` |
| `dalykit:ml LR,RF,XGB` | Compare only selected models | `kits/{kit}/model/` |
| `dalykit:ml ensemble` | Compare ensembles | `kits/{kit}/model/model_results.json` |

---

## Kit Management

`dalykit:kit` is the key management command in the new structure.

Example:

```text
dalykit:kit new feature
```

This creates a new kit, copies the prerequisite artifacts from the previous kit, and restarts from the feature stage.

Benefits:

- You can discard `k1` and continue independently with `k2`
- Reports, figures, models, and intermediate data stay grouped together
- Each iteration remains easier to inspect, compare, and clean up

---

## Contact

- GitHub: [taehyunan-99/DalyKit](https://github.com/taehyunan-99/DalyKit)
