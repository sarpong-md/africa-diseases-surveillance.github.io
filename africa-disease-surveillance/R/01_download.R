# =============================================================================
# 01_download.R — Download raw data from public sources
# =============================================================================
# Downloads three CSV files into data_raw/.
# Re-running this script overwrites previous downloads with the latest data.
#
# Sources:
#   - Mpox:            OWID/WHO (GitHub), updated hourly from WHO surveillance
#   - Measles cases:   Our World in Data (WHO reporting)
#   - Measles MCV1:    Our World in Data (UNICEF/WHO vaccination estimates)

# ---- Mpox: WHO confirmed cases and deaths, country-level daily data ----
mpox_url <- "https://raw.githubusercontent.com/owid/monkeypox/main/owid-monkeypox-data.csv"
mpox_raw_path <- file.path("data_raw", "mpox_owid.csv")
download.file(mpox_url, destfile = mpox_raw_path, mode = "wb")
message("Downloaded: ", mpox_raw_path)

# ---- Measles reported cases (annual, by country) ----
measles_cases_url <- paste0(
  "https://ourworldindata.org/grapher/reported-cases-of-measles.csv",
  "?v=1&csvType=full&useColumnShortNames=false"
)
measles_cases_path <- file.path("data_raw", "measles_reported_cases_owid.csv")
download.file(measles_cases_url, destfile = measles_cases_path, mode = "wb")
message("Downloaded: ", measles_cases_path)

# ---- Measles MCV1 vaccination coverage (annual, by country) ----
measles_cov_url <- paste0(
  "https://ourworldindata.org/grapher/share-of-children-vaccinated-against-measles.csv",
  "?v=1&csvType=full&useColumnShortNames=false"
)
measles_cov_path <- file.path("data_raw", "measles_vaccination_coverage_owid.csv")
download.file(measles_cov_url, destfile = measles_cov_path, mode = "wb")
message("Downloaded: ", measles_cov_path)

message("All raw data downloaded to data_raw/")
