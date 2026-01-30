# ============================================================
# Raw to Refined — Session 2 (Student Template)
# Topic: Missing data (NA), recoding with mutate/case_when,
#        basic string manipulation (stringr),
#        and joining datasets (left_join / inner_join).
#
# How to use this template:
# 1) Run top-to-bottom during lecture.
# 2) When you see "TODO", try it yourself before looking at hints.
# 3) Save your work frequently.
# ============================================================

# ----------------------------
# 0) Setup
# ----------------------------

# Install packages if needed (run once)
pkgs <- c("tidyverse", "readxl", "janitor", "countrycode")
to_install <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
if (length(to_install) > 0) install.packages(to_install)

# Load libraries
library(tidyverse)
library(readxl)
library(janitor)
library(countrycode)

# (Optional) make printed tibbles easier to read
options(tibble.width = Inf)

# ----------------------------
# 1) Project paths
# ----------------------------
# Your repo likely looks like:
# raw2refined/
#   data/
#   scripts/
#   session_docs/
# etc.

# If you're running this from the /scripts folder, this moves up one level.
# Adjust if needed.
proj_root <- ".."

data_dir   <- file.path(proj_root, "data")
images_dir <- file.path(proj_root, "images")

# Quick check
list.files(data_dir)

# ----------------------------
# 2) Load practice datasets
# ----------------------------

# (A) Built-in: starwars (good for strings + missing data)
starwars_df <- dplyr::starwars

# (B) Country metadata (CSV in your repo)
# NOTE: If you get "cannot open file", check your working directory.
country_meta <- readr::read_csv(file.path(data_dir, "country_metadata.csv"))

glimpse(country_meta)

# (C) Public debt Excel file (in your repo)
# If your file name differs, update it here:
debt_file <- file.path(data_dir, "public_debt.xls")

# Excel reading tip: list available sheets first
excel_sheets(debt_file)

# Pick a sheet name (update if needed)
debt_raw <- read_excel(debt_file, sheet = 1)

glimpse(debt_raw)
head(debt_raw)

# ----------------------------
# 3) Missing data: identifying and converting to NA
# ----------------------------

# Key idea:
# In R, missing values should be NA (not "N/A", "-", ".", "999", "")

# A simple toy example (you can run this quickly)
toy <- tibble(
  id = 1:6,
  value = c("10", "N/A", "15", "-", ".", "999")
)

toy

# Convert common missing encodings to NA
toy_clean <- toy %>%
  mutate(
    value = na_if(value, "N/A"),
    value = na_if(value, "-"),
    value = na_if(value, "."),
    value = na_if(value, "999"),
    value = as.numeric(value)
  )

toy_clean

# Identify missingness
is.na(toy_clean$value)
sum(is.na(toy_clean$value))

# Missingness in a whole dataframe
colSums(is.na(starwars_df)) %>% sort(decreasing = TRUE)

# ----------------------------
# 4) Handling missing data (overview)
# ----------------------------

# Option A: Omit rows with missing values in specific columns
# (Use cautiously; only if it makes sense analytically.)
starwars_complete <- starwars_df %>%
  filter(!is.na(height), !is.na(mass))

nrow(starwars_df)
nrow(starwars_complete)

# Option B: Mean substitution (simple, but can distort variance)
# Example: fill missing mass with mean mass
mass_mean <- mean(starwars_df$mass, na.rm = TRUE)

starwars_meanfill <- starwars_df %>%
  mutate(mass_filled = if_else(is.na(mass), mass_mean, mass))

summary(starwars_meanfill$mass_filled)

# Option C: Imputation (we're not doing the full details today)
# Note: more advanced approaches include regression, KNN, multiple imputation.

# ----------------------------
# 5) Recoding variables with mutate() + case_when()
# ----------------------------

# Example: create a "size_class" from height
# We'll define bins in cm:
# - Short: < 160
# - Medium: 160–190
# - Tall: > 190
starwars_recode <- starwars_df %>%
  mutate(
    size_class = case_when(
      is.na(height) ~ NA_character_,
      height < 160 ~ "short",
      height <= 190 ~ "medium",
      height > 190 ~ "tall"
    )
  )

starwars_recode %>%
  count(size_class, sort = TRUE)

# TODO: Make a new variable "mass_class" using mass:
# - light: < 60
# - medium: 60–100
# - heavy: > 100
# HINT: follow the structure above with case_when()

# ----------------------------
# 6) Basic string manipulation with stringr
# ----------------------------

# Common tasks:
# - lower/upper case
# - trim spaces
# - replace characters
# - detect patterns

# Example: clean species names (lowercase + trim)
starwars_strings <- starwars_df %>%
  mutate(
    species_clean = str_to_lower(species),
    species_clean = str_trim(species_clean)
  )

starwars_strings %>%
  count(species_clean, sort = TRUE) %>%
  slice_head(n = 10)

# Example: remove spaces entirely
# (This is useful when you're building IDs, filenames, or consistent labels.)
starwars_strings <- starwars_strings %>%
  mutate(
    name_nospaces = str_remove_all(name, "\\s+")
  )

starwars_strings %>%
  select(name, name_nospaces) %>%
  slice_head(n = 8)

# TODO: Create a variable "homeworld_clean" that:
# 1) converts to lower case
# 2) removes ALL spaces
# 3) turns empty strings "" into NA (if they exist)
# HINT: str_to_lower(), str_remove_all("\\s+"), na_if()

# ----------------------------
# 7) Joining data: left_join vs inner_join (and why you care)
# ----------------------------

# Real-world mental model:
# - One table has outcomes (e.g., debt data by country/year)
# - Another table has metadata (e.g., ISO codes, region)
# Joining combines them using a key (e.g., country code)

# First, ensure you have a reliable join key.
# In country_meta, see which columns look like ISO codes.
names(country_meta)

# Standardize column names to snake_case (helpful for joins)
country_meta_clean <- country_meta %>%
  clean_names()

names(country_meta_clean)

# Suppose your country metadata includes an iso3 code column.
# TODO: Identify the correct ISO column name below.
# Common possibilities: alpha_3, iso3, iso_a3, country_code, etc.

# For demonstration, we’ll create a small "debt" dataset that uses iso3 codes
debt_demo <- tibble(
  iso3 = c("MAR", "FRA", "USA", "ETH", "XXX"),
  year = c(2020, 2020, 2020, 2020, 2020),
  debt_pct_gdp = c(76.4, 115.0, 127.0, 55.1, 12.3)
)

debt_demo

# INNER JOIN: keeps only matches in BOTH tables
# (Good when you only want observations with valid metadata)
# TODO: Replace 'alpha_3' with the actual iso3 column name in your metadata
# inner_join(debt_demo, country_meta_clean, by = c("iso3" = "alpha_3"))

# LEFT JOIN: keeps ALL rows in the left table (debt_demo), and attaches metadata when available
# (Good when debt_demo is your "main" dataset and you don't want to drop rows)
# TODO: Replace 'alpha_3' with the actual iso3 column name in your metadata
# left_join(debt_demo, country_meta_clean, by = c("iso3" = "alpha_3"))

# To see what didn't match:
# anti_join(debt_demo, country_meta_clean, by = c("iso3" = "alpha_3"))

# ----------------------------
# 8) World Bank-style workflow (download → tidy → join)
# ----------------------------

# Many World Bank downloads arrive in a "wide" format:
# columns are years (e.g., 2010, 2011, 2012...) and rows are countries.
# We'll simulate a wide WB dataset here.

wb_wide <- tibble(
  country_name = c("Morocco", "France", "United States", "Ethiopia"),
  country_code = c("MAR", "FRA", "USA", "ETH"),
  `2018` = c(3.2, 2.3, 2.9, 6.8),
  `2019` = c(2.6, 1.8, 2.3, 9.0),
  `2020` = c(-6.3, -7.9, -3.4, 6.1)
)

wb_wide

# Pivot to long (tidy): one row per country-year
wb_long <- wb_wide %>%
  pivot_longer(
    cols = matches("^\\d{4}$"),
    names_to = "year",
    values_to = "gdp_growth"
  ) %>%
  mutate(year = as.integer(year))

wb_long

# Join WB-style data to metadata using the country code key
# TODO: Replace "alpha_3" with the right column name in metadata
# wb_long_joined <- wb_long %>%
#   left_join(country_meta_clean, by = c("country_code" = "alpha_3"))

# ----------------------------
# 9) Mini-checkpoints (what you should be able to do by the end)
# ----------------------------

# CHECKPOINT A:
# - Create a tibble with a column that includes "N/A", "-", ".", "999"
# - Convert to NA
# - Count missing values

# CHECKPOINT B:
# - Use mutate + case_when to create a recoded variable
# - Verify with count()

# CHECKPOINT C:
# - Use stringr to clean a messy text variable (lowercase + remove spaces)
# - Use str_detect() to flag values that contain a pattern (e.g., "a")

# CHECKPOINT D:
# - Do a left_join between a main table and a lookup table
# - Use anti_join() to find unmatched keys

# ----------------------------
# 10) (Optional) Export a clean dataset
# ----------------------------

# If you’ve created a cleaned dataset you want to save:
# write_csv(wb_long, file.path(data_dir, "wb_long_demo.csv"))

# ============================================================
# End of Session 2 template
# ============================================================
