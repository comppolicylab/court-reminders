# Replication materials for *Automated Reminders Reduce Incarceration*, 2025

This repository contains replication materials for our paper, [Automated Reminders Reduce Incarceration for Missed Court Dates: Evidence from a Text Message Experiment](https://alexchohlaswood.com/assets/papers/court_reminders.pdf) (*Science Advances*, 2025).

If you are not viewing this README on GitHub, a more recently updated version may be available at our [online paper repository](https://github.com/comppolicylab/court-reminders/).

Users can set up the correct R environment by running `renv::restore()` in the root project directory. This will install the packages necessary to run the scripts in this repository.

## Data access
Before you begin, download the replication data from the [Harvard Dataverse](https://doi.org/10.7910/DVN/XFEQPO) and place the CSVs in the `data/` directory.

You have the option of either a) immediately downloading a public aggregate version of the data from our experiment or b) requesting access to the full set of de-identified restricted data required to replicate all analyses in the paper. Instructions for requesting access to the restricted data are described on [Dataverse](https://doi.org/10.7910/DVN/XFEQPO).

## Running the replication on public data
To replicate core findings using public aggregate data, download the public datasets from the [Dataverse](https://doi.org/10.7910/DVN/XFEQPO), place them in the `data/` folder, and run `src/public_data_analysis/evaluation.R`. 

## Running the replication on restricted data
To replicate all statistics and figures in the paper, you must request access to the restricted data from the [Dataverse](https://doi.org/10.7910/DVN/XFEQPO). After your access is approved, download the restricted datasets and place them in the `data/` folder.
Once the environment is restored and the restricted data are downloaded and placed in `data/`, run:
```R
source("make_restricted.R")
```
This will render a LaTeX file `output/stats.tex` from the R Markdown analysis in `src/calculate_stats.Rmd`. The LaTeX file contains all statistics reported in the paper.

## Repository contents

The main scripts are:
- `make_restricted.R` – Script to calculate all paper statistics and export figures and LaTeX macros to `output/` using restricted data.
- `src/public_data_analysis/evaluation.R` – Loads public aggregate data and fits regression models for replication of main findings.
- `src/restricted_data_analysis/calculate_stats.Rmd` – Primary R Markdown file generating descriptive stats, regression results, and LaTeX macros.
- `src/restricted_data_analysis/evaluation.R` – Loads data, fits regression models, and defines model objects used in the analysis.
- `src/restricted_data_analysis/utils.R` – Helper functions for factorization, summary statistics, formatting output, and LaTeX-friendly presentation.
