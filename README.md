# Replication materials for *Automated Reminders Reduce Incarceration*, 2025

This repository contains replication materials for our paper, [Automated Reminders Reduce Incarceration for Missed Court Dates: Evidence from a Text Message Experiment](https://alexchohlaswood.com/assets/papers/court_reminders.pdf) (*Science Advances*, 2025).

If you are not viewing this README on GitHub, a more recently updated version may be available at our [online paper repository](https://github.com/chohlasa/court-reminders/).

Users can set up the correct R environment by running `renv::restore()` in the root project directory. This will install the packages necessary to run the scripts in this repository.

## Data access
Before you begin, download the [replication data](https://doi.org/10.7910/DVN/XFEQPO) from the Harvard Dataverse and place the CSVs in the `data/` directory.

## Running the replication
Once the environment is restored and data are downloaded and placed in `data/`, run:
```R
source("make.R")
```
This will render the LaTeX file `output/stats.tex` from the R Markdown analysis in `src/calculate_stats.Rmd`.

## Repository contents

The main scripts are:
- `make.R` – Script to calculate all paper statistics and export figures and LaTeX macros to `output/`.
- `src/calculate_stats.Rmd` – Primary R Markdown file generating descriptive stats, regression results, and LaTeX macros.
- `src/evaluation.R` – Loads data, constructs regression models, and defines model objects used in the analysis.
- `src/utils.R` – Helper functions for factorization, summary statistics, formatting output, and LaTeX-friendly presentation.
