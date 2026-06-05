# =============================================================================
# 04_run_all.R — Master script: run the full pipeline from scratch
# =============================================================================
# Set your working directory to the project root before running this script.
# In RStudio: open africa_disease_surveillance.Rproj, then run this file.
#
# Steps:
#   00 → Install packages and verify directories
#   01 → Download raw CSVs from public sources
#   02 → Clean, rename, and filter to African countries
#   03 → Generate and save all 6 figures

message("=== Africa Disease Surveillance Pipeline ===")
message("Starting at ", Sys.time())

source("R/00_setup.R")
source("R/01_download.R")
source("R/02_clean.R")
source("R/03_visualize.R")

message("=== Pipeline complete at ", Sys.time(), " ===")
message("Outputs:")
message("  Clean data → data_clean/")
message("  Figures    → figures/")
message("  Render report: quarto::quarto_render('africa_surveillance_report.qmd')")
