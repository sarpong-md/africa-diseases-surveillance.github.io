# =============================================================================
# 02_clean.R — Load, standardize, and filter raw data to African countries
# =============================================================================
# Reads each raw CSV, renames columns to a consistent snake_case convention,
# filters to the 53 African countries defined by their ISO 3166-1 alpha-3 codes,
# and writes cleaned CSVs to data_clean/.

library(tidyverse)

# -----------------------------------------------------------------------------
# Africa ISO3 country code reference vector (53 AU member states)
# ISO 3166-1 alpha-3 is the standard 3-letter country identifier used by WHO,
# OWID, and most international health databases — making it the right join key.
# -----------------------------------------------------------------------------
africa_iso3 <- c(
  "DZA","AGO","BEN","BWA","BFA","BDI","CMR","CPV","CAF","TCD","COM",
  "COG","CIV","COD","DJI","EGY","GNQ","ERI","SWZ","ETH","GAB","GMB",
  "GHA","GIN","GNB","KEN","LSO","LBR","LBY","MDG","MWI","MLI","MRT",
  "MUS","MAR","MOZ","NAM","NER","NGA","RWA","STP","SEN","SYC","SLE",
  "ZAF","SSD","SDN","TZA","TGO","TUN","UGA","ZMB","ZWE"
)

# -----------------------------------------------------------------------------
# 2a. Mpox (OWID/WHO) — daily country-level counts
# Original column names: iso_code, location, date, total_cases, new_cases, ...
# Rename to: code, entity — consistent with measles datasets.
# The OWID file also includes regional aggregates (e.g. iso_code = "OWID_AFR");
# filtering by africa_iso3 automatically excludes these non-standard codes.
# -----------------------------------------------------------------------------
mpox_africa <- read_csv(
  file.path("data_raw", "mpox_owid.csv"),
  show_col_types = FALSE
) |>
  rename(code = iso_code, entity = location) |>
  filter(code %in% africa_iso3) |>
  select(entity, code, date, total_cases, new_cases,
         total_deaths, new_deaths, new_cases_smoothed)

write_csv(mpox_africa, file.path("data_clean", "mpox_africa_clean.csv"))
message("mpox_africa_clean.csv: ", nrow(mpox_africa), " rows, ",
        n_distinct(mpox_africa$code), " countries")

# -----------------------------------------------------------------------------
# 2b. Measles reported cases (OWID) — annual, 1974–present
# Original OWID column names use title case: Entity, Code, Year, and a long
# descriptive column name for the value. We rename to snake_case and shorten
# the value column to `cases`.
# -----------------------------------------------------------------------------
measles_cases_africa <- read_csv(
  file.path("data_raw", "measles_reported_cases_owid.csv"),
  show_col_types = FALSE
) |>
  rename(
    entity = Entity,
    code   = Code,
    year   = Year,
    cases  = `Measles - number of reported cases`
  ) |>
  filter(code %in% africa_iso3)

write_csv(measles_cases_africa, file.path("data_clean", "measles_cases_africa.csv"))
message("measles_cases_africa.csv: ", nrow(measles_cases_africa), " rows, ",
        n_distinct(measles_cases_africa$code), " countries")

# -----------------------------------------------------------------------------
# 2c. Measles MCV1 vaccination coverage (OWID) — annual
# MCV1 = first dose of measles-containing vaccine administered to 1-year-olds.
# Value column renamed to `mcv1_pct` (percentage, 0–100 scale).
# -----------------------------------------------------------------------------
measles_cov_africa <- read_csv(
  file.path("data_raw", "measles_vaccination_coverage_owid.csv"),
  show_col_types = FALSE
) |>
  rename(
    entity   = Entity,
    code     = Code,
    year     = Year,
    mcv1_pct = `Measles, first dose (MCV1)`
  ) |>
  filter(code %in% africa_iso3)

write_csv(measles_cov_africa, file.path("data_clean", "measles_vacc_cov_africa.csv"))
message("measles_vacc_cov_africa.csv: ", nrow(measles_cov_africa), " rows, ",
        n_distinct(measles_cov_africa$code), " countries")

message("Cleaning complete. Clean data written to data_clean/")
