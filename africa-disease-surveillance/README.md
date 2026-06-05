# Africa Disease Surveillance — Mpox & Measles

A fully reproducible R project tracking **mpox** (monkeypox) and **measles** across African countries using publicly available WHO and Our World in Data sources. Includes a complete data pipeline (download → clean → visualize), six publication-ready figures, and a rendered HTML report available via GitHub Pages.

---

## Live Report

> 📊 **[View the full report](https://YOUR-USERNAME.github.io/africa-disease-surveillance/)**  
> *(Update the link above after enabling GitHub Pages — see [Publishing](#publishing-to-github-pages) below)*

---

## Project Structure

```
africa-disease-surveillance/
├── R/
│   ├── 00_setup.R          # Install packages and create directories
│   ├── 01_download.R       # Download raw CSVs from public sources
│   ├── 02_clean.R          # Filter to Africa, standardize column names
│   ├── 03_visualize.R      # Generate and save all 6 figures
│   └── 04_run_all.R        # Master script: runs 00 → 01 → 02 → 03
├── data_clean/             # Africa-filtered CSVs (committed to git)
├── data_raw/               # Downloaded source files (gitignored — re-downloaded by script)
├── figures/                # Saved PNG figures (committed to git)
├── docs/                   # Rendered HTML report (for GitHub Pages)
├── africa_surveillance_report.qmd   # Full Quarto report with code explanations
├── africa_disease_surveillance.Rproj
├── .gitignore
└── README.md
```

---

## Quick Start

**Prerequisites:** R ≥ 4.2, internet access. [Quarto CLI](https://quarto.org/docs/get-started/) only needed for re-rendering the report.

```r
# 1. Open africa_disease_surveillance.Rproj in RStudio
#    (this sets the working directory to the project root)

# 2. Run the complete pipeline
source("R/04_run_all.R")

# 3. (Optional) Re-render the HTML report
quarto::quarto_render(
  "africa_surveillance_report.qmd",
  output_file = "index.html",
  quarto_args = c("--output-dir", "docs")
)
```

---

## Data Sources

| Dataset | Source | License |
|---------|--------|---------|
| Mpox confirmed cases & deaths (daily, by country) | [Our World in Data / WHO GitHub](https://github.com/owid/monkeypox) | CC BY 4.0 |
| Measles reported cases (annual) | [Our World in Data](https://ourworldindata.org/grapher/reported-cases-of-measles) | CC BY 4.0 |
| Measles MCV1 vaccination coverage (annual) | [Our World in Data](https://ourworldindata.org/grapher/share-of-children-vaccinated-against-measles) | CC BY 4.0 |

Raw data is **not committed** to this repository (gitignored). Running `source("R/04_run_all.R")` downloads the latest version from each source.

---

## Figures

| File | Description |
|------|-------------|
| `01_mpox_total_cases_by_country.png` | Cumulative mpox cases — top 15 African countries |
| `02_mpox_drc_cumulative.png` | DRC cumulative mpox cases over time |
| `03_mpox_ghana_smoothed.png` | Ghana mpox new cases (7-day smoothed) |
| `04_measles_ghana_historical.png` | Ghana measles cases 1974–present |
| `05_measles_multicountry_comparison.png` | Cases + MCV1 coverage for 6 countries |
| `06_measles_coverage_vs_cases_scatter.png` | MCV1 coverage vs. case burden (scatter) |

---

## Clean Data

| File | Rows | Countries | Coverage |
|------|------|-----------|----------|
| `mpox_africa_clean.csv` | ~23,000 | 36 | Daily, 2022–present |
| `measles_cases_africa.csv` | ~2,400 | 53 | Annual, 1974–present |
| `measles_vacc_cov_africa.csv` | ~2,200 | 53 | Annual, 1980–present |

Column names are standardized to snake_case across all files:
`entity` (country name), `code` (ISO3), `year` or `date`, and descriptive value columns.

---

## Publishing to GitHub Pages

1. Push the repository to GitHub (see below).
2. Go to **Settings → Pages** in your repository.
3. Source: `main` branch, folder: `/docs`.
4. Click **Save**. The report will be live at `https://<username>.github.io/africa-disease-surveillance/`.

---

## Git Setup (first time)

```bash
cd "C:\Users\sarpo\OneDrive\Documents\africa-disease-surveillance"

git init
git add .
git commit -m "Initial commit: Africa disease surveillance project"

# Option A — GitHub CLI
gh repo create africa-disease-surveillance \
  --public \
  --description "Mpox and measles surveillance in Africa using WHO and OWID data" \
  --source=. --remote=origin --push

# Option B — manual (paste your repo URL from github.com/new)
git remote add origin https://github.com/<your-username>/africa-disease-surveillance.git
git branch -M main
git push -u origin main
```

---

## Packages Used

| Package | Purpose |
|---------|---------|
| `tidyverse` | Data wrangling + ggplot2 |
| `lubridate` | Date parsing |
| `scales` | Axis formatting (comma, log scale) |
| `ggrepel` | Non-overlapping country labels |
| `quarto` | Rendering the report from R |

---

## License

Code: [MIT License](LICENSE)  
Data: Subject to the CC BY 4.0 license of the original data providers (OWID / WHO / UNICEF).  
Attribution required when using or reproducing data.

---

*Built with R, ggplot2, and Quarto.*
