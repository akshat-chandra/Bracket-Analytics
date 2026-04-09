# BracketAnalytics

**Built with:** dbt · DuckDB · Streamlit · Python

📹 [Watch the demo](https://drive.google.com/file/d/1D_bk0s0XzGSi_I-ip7Deb0p96dw9UbqN/view?usp=drive_link)

A data pipeline and analytics dashboard analyzing 24 years of NCAA Tournament data (2002-2026).

## What It Does

Transforms raw tournament data through a dbt pipeline into analytics that answer:
- Which seeds historically make the deepest runs?
- Which conferences dominate the tournament?
- Which lower seeds pulled off the biggest upsets?

## Stack

- **dbt** - SQL transformation pipeline (staging to marts)
- **DuckDB** - local, serverless database (no account needed)
- **Streamlit** - interactive analytics dashboard
- **Python** - data loading and visualization

## Pipeline Architecture

```
data/raw/
  └── march_madness_raw.csv     <- Kaggle source data (2002-2026)
         |
         dbt seed
  DuckDB (march_madness_raw)
         |
         dbt run
  staging/
  └── stg_tournament            <- cleaned, typed, filtered
         |
  marts/
  ├── mart_seed_performance     <- Final Four % and championship rate by seed
  ├── mart_conference_performance <- tournament dominance by conference
  └── mart_upset_tracker        <- Cinderella teams categorized by upset magnitude
         |
  Streamlit Dashboard           <- 3-tab interactive analytics app
```

## Key Design Decisions

- **Coach data excluded** - source only contains current coaches, not historical ones per season. Including it would show the wrong coach for every historical game. Excluded to maintain data integrity.
- **DuckDB over cloud warehouse** - runs fully locally with zero setup. The dbt models are platform-agnostic and can be pointed at Snowflake, BigQuery, or Databricks by changing one line in `profiles.yml`.
- **Staging to marts pattern** - staging handles cleaning and type casting, marts handle business logic.

## Quick Start

```bash
# Install dependencies
pip install dbt-duckdb duckdb streamlit plotly pandas

# Load raw data and run transformations
cd bracket_analytics
dbt seed
dbt run

# Launch dashboard
cd ..
streamlit run streamlit/app.py
```

## Data Source

Kaggle - [March Madness Historical Dataset 2002-2026](https://www.kaggle.com/datasets/jonathanpilafas/2024-march-madness-statistical-analysis) by Jonathan Pilafas. Includes KenPom efficiency ratings, seeds, conference data, and tournament outcomes.

## Acknowledgments

Built with assistance from [Claude Code](https://claude.ai/code) by Anthropic.
