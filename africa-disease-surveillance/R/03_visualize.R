# =============================================================================
# 03_visualize.R — Generate and save all project figures
# =============================================================================
# Produces 6 PNG figures, saved to figures/.
# Assumes 02_clean.R has already run and data_clean/ is populated.

library(tidyverse)
library(scales)
library(ggrepel)

# Load clean datasets
mpox_africa         <- read_csv(file.path("data_clean", "mpox_africa_clean.csv"),        show_col_types = FALSE)
measles_cases_africa <- read_csv(file.path("data_clean", "measles_cases_africa.csv"),     show_col_types = FALSE)
measles_cov_africa   <- read_csv(file.path("data_clean", "measles_vacc_cov_africa.csv"), show_col_types = FALSE)

# Helper: save figure and report path
save_fig <- function(plot, filename, width = 8, height = 5) {
  path <- file.path("figures", filename)
  ggsave(path, plot, width = width, height = height, dpi = 150)
  message("Saved: ", path)
}

# =============================================================================
# Plot 1 — Top 15 African countries by total confirmed mpox cases
# =============================================================================
p1 <- mpox_africa |>
  group_by(entity, code) |>
  summarise(total = max(total_cases, na.rm = TRUE), .groups = "drop") |>
  filter(!is.na(total), total > 0) |>
  slice_max(total, n = 15) |>
  mutate(entity = fct_reorder(entity, total)) |>
  ggplot(aes(x = total, y = entity)) +
  geom_col() +
  scale_x_continuous(labels = comma) +
  labs(
    title    = "Confirmed mpox cases by African country (cumulative to 2026)",
    subtitle = "Top 15 countries — Source: WHO via Our World in Data",
    x = "Total confirmed cases", y = NULL
  )

save_fig(p1, "01_mpox_total_cases_by_country.png", width = 8, height = 5)

# =============================================================================
# Plot 2 — DRC cumulative mpox cases over time
# The DRC is the epicenter of the ongoing clade 1b outbreak declared a PHEIC
# by WHO in August 2024.
# =============================================================================
p2 <- mpox_africa |>
  filter(code == "COD") |>
  ggplot(aes(x = date, y = total_cases)) +
  geom_line(color = "firebrick") +
  scale_y_continuous(labels = comma) +
  labs(
    title    = "Democratic Republic of Congo: cumulative confirmed mpox cases",
    subtitle = "Epicenter of the clade 1b outbreak — Source: WHO via OWID",
    x = "Date", y = "Total confirmed cases"
  )

save_fig(p2, "02_mpox_drc_cumulative.png", width = 8, height = 4.5)

# =============================================================================
# Plot 3 — Ghana: 7-day smoothed new mpox cases
# Smoothing averages out day-of-week reporting artifacts and makes trends
# easier to read.
# =============================================================================
p3 <- mpox_africa |>
  filter(code == "GHA") |>
  ggplot(aes(x = date, y = new_cases_smoothed)) +
  geom_line(color = "steelblue") +
  labs(
    title    = "Ghana: mpox new cases (7-day rolling average)",
    subtitle = "Source: WHO via Our World in Data",
    x = "Date", y = "New cases (7-day smoothed)"
  )

save_fig(p3, "03_mpox_ghana_smoothed.png", width = 8, height = 4.5)

# =============================================================================
# Plot 4 — Ghana: historical measles cases (1974–present)
# Long historical series shows the impact of vaccination programme scale-up.
# =============================================================================
p4 <- measles_cases_africa |>
  filter(code == "GHA") |>
  ggplot(aes(x = year, y = cases)) +
  geom_line(color = "firebrick") +
  scale_y_continuous(labels = comma) +
  labs(
    title    = "Ghana: reported measles cases (1974–present)",
    subtitle = "Source: WHO via Our World in Data",
    x = "Year", y = "Reported cases"
  )

save_fig(p4, "04_measles_ghana_historical.png", width = 8, height = 4.5)

# =============================================================================
# Plot 5 — Six African countries: measles cases + MCV1 coverage (two panels)
# Juxtaposing the two metrics in a shared facet lets the viewer see the
# inverse relationship between coverage gains and case reductions.
# =============================================================================
selected_countries <- c("NGA", "COD", "ETH", "GHA", "UGA", "CMR")

measles_joined <- measles_cases_africa |>
  inner_join(measles_cov_africa, by = c("entity", "code", "year")) |>
  filter(code %in% selected_countries) |>
  pivot_longer(
    cols      = c(cases, mcv1_pct),
    names_to  = "metric",
    values_to = "value"
  ) |>
  mutate(metric = recode(metric,
                         "cases"    = "Reported measles cases",
                         "mcv1_pct" = "MCV1 vaccination coverage (%)"))

p5 <- ggplot(measles_joined, aes(x = year, y = value, color = entity)) +
  geom_line() +
  facet_wrap(~ metric, scales = "free_y", nrow = 2) +
  labs(
    title    = "Measles cases and MCV1 coverage — selected African countries",
    subtitle = "Source: WHO / UNICEF via Our World in Data",
    x = "Year", y = NULL, color = NULL
  ) +
  theme(legend.position = "bottom")

save_fig(p5, "05_measles_multicountry_comparison.png", width = 9, height = 7)

# =============================================================================
# Plot 6 — Scatter: MCV1 coverage vs. log(measles cases), 5-year average
# Each point is a country; the log y-scale handles the wide range of case
# counts. Countries with near-complete coverage tend to cluster near zero cases.
# =============================================================================
scatter_data <- measles_cases_africa |>
  inner_join(measles_cov_africa, by = c("entity", "code", "year")) |>
  filter(year >= max(year) - 4) |>
  group_by(entity, code) |>
  summarise(
    avg_cases = mean(cases,    na.rm = TRUE),
    avg_mcv1  = mean(mcv1_pct, na.rm = TRUE),
    .groups   = "drop"
  ) |>
  filter(avg_cases > 0, !is.na(avg_mcv1))

p6 <- ggplot(scatter_data, aes(x = avg_mcv1, y = avg_cases)) +
  geom_point() +
  geom_text_repel(aes(label = code), size = 2.5, max.overlaps = 25) +
  scale_y_log10(labels = comma) +
  labs(
    title    = "MCV1 vaccination coverage vs. measles case burden (5-year average)",
    subtitle = "Higher coverage is broadly associated with fewer reported cases — Source: OWID",
    x = "MCV1 coverage (% of 1-year-olds vaccinated)",
    y = "Mean annual reported cases (log scale)"
  )

save_fig(p6, "06_measles_coverage_vs_cases_scatter.png", width = 8, height = 5.5)

message("All 6 figures saved to figures/")
