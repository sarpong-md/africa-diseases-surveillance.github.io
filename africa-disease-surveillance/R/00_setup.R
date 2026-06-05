# =============================================================================
# 00_setup.R — Package installation and project initialization
# =============================================================================
# Run this script once before anything else.
# It installs any missing packages and creates the directory structure.

required_pkgs <- c("tidyverse", "lubridate", "scales", "ggrepel", "quarto")

installed_pkgs <- rownames(installed.packages())
to_install    <- setdiff(required_pkgs, installed_pkgs)

if (length(to_install) > 0) {
  message("Installing missing packages: ", paste(to_install, collapse = ", "))
  install.packages(to_install)
}

library(tidyverse)
library(lubridate)
library(scales)
library(ggrepel)

# Create directory structure (safe to re-run; showWarnings = FALSE suppresses
# "already exists" messages)
dirs <- c("data_raw", "data_clean", "figures", "docs", "R")
for (d in dirs) dir.create(d, showWarnings = FALSE, recursive = TRUE)

message("Setup complete. All packages loaded and directories verified.")
