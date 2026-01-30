##### Raw to Refined (Session 1) — Student Follow-Along Script
##### From Raw to Refined: Tidy Data in R
##### Pr. Z. Garfield (student template updated)

# ------------------------------------------------------------------------------
# 0) Housekeeping
# ------------------------------------------------------------------------------

# Tip: Run your script top-to-bottom during lecture.
# When you see TODO blocks, pause and try to write the code yourself.
# You can always compare with the “Hints” section at the end.

# ------------------------------------------------------------------------------
# 1) Setup: install + load packages
# ------------------------------------------------------------------------------

# Install required packages if missing
pkgs <- c("tidyverse", "tidyr")
for (p in pkgs) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
}

library(tidyverse)
library(tidyr)

# Optional: keep printed tibbles from being too wide
options(tibble.width = Inf)

# ------------------------------------------------------------------------------
# 2) First contact: What do “tidy” example datasets look like?
# ------------------------------------------------------------------------------

# In tidyr, several example tables (table1, table2, ...) illustrate tidy vs untidy.
# You can view the package index:
# help(package = "tidyr")

table1
table2
table3
table4a
table4b
table5

# Quick structure check
str(table1)
glimpse(table2)

# ------------------------------------------------------------------------------
# 3) Core tidy-data principles (Wickham 2014)
# ------------------------------------------------------------------------------

# In a tidy dataset:
# 1) Each variable is a column
# 2) Each observation is a row
# 3) Each value is a cell
# 4) Each type of observational unit forms a table (often useful in “real” data)

# ------------------------------------------------------------------------------
# 4) Data structure vs data concepts (semantics)
# ------------------------------------------------------------------------------

# Two datasets can contain the same underlying information but be “shaped” differently.
# Example from lecture: treatments by person vs treatments as rows.

# Structure A: people are rows; treatments are columns
structure_a <- tibble(
  name       = c("Mohammed", "Fatima Ezzahra", "Jean-Baptiste"),
  treatmenta = c(NA, 16, 3),
  treatmentb = c(2, 11, 1)
)

# Structure B: treatments are rows; people are columns
structure_b <- tibble(
  treatment        = c("treatmenta", "treatmentb"),
  Mohammed         = c(NA, 2),
  Fatima_Ezzahra   = c(16, 11),
  Jean_Baptiste    = c(3, 1)
)

structure_a
structure_b

# TODO (in-class): What is the “unit of analysis” in structure_a? in structure_b?
# Write your answer as comments below.
# structure_a unit of analysis:
# structure_b unit of analysis:

# ------------------------------------------------------------------------------
# 5) A small messy example → tidy (pivot_wider)
# ------------------------------------------------------------------------------

table_messy <- tibble(
  country = c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China"),
  year    = c(1999, 1999, 2000, 2000, 1999, 1999),
  type    = c("cases", "population", "cases", "population", "cases", "population"),
  count   = c(745, 19987071, 37737, 174504898, 212258, 1272915272)
)

table_messy

# Diagnose: which tidy rules are violated?
# TODO: Identify (a) variables, (b) observations, (c) values.

# Make tidy: move type values into column names
table_tidy <- table_messy %>%
  pivot_wider(names_from = type, values_from = count)

table_tidy

# ------------------------------------------------------------------------------
# 6) Diagnosing “untidy” patterns in tidyr tables
# ------------------------------------------------------------------------------

# Pattern A: “values in a column name” (wide years) -> table4a / table4b
table4a
table4b

# Pattern B: “variables in a single column” -> table2
table2

# Pattern C: “multiple variables in one cell/column” -> table3 (rate is cases/pop)
table3

# Pattern D: “variables split across columns” -> table5 (century + year)
table5

# ------------------------------------------------------------------------------
# 7) Fixing common untidy patterns (hands-on)
# ------------------------------------------------------------------------------

# 7.1) table2 -> tidy with pivot_wider
table2_tidy <- table2 %>%
  pivot_wider(names_from = type, values_from = count)

table2_tidy

# Now computing a rate is easy:
table2_tidy %>%
  mutate(rate_per_10k = cases / population * 10000)

# 7.2) table4a + table4b -> tidy with pivot_longer and join
# table4a: cases by year columns; table4b: population by year columns

cases_long <- table4a %>%
  pivot_longer(
    cols      = -country,
    names_to  = "year",
    values_to = "cases"
  ) %>%
  mutate(year = as.integer(year))

pop_long <- table4b %>%
  pivot_longer(
    cols      = -country,
    names_to  = "year",
    values_to = "population"
  ) %>%
  mutate(year = as.integer(year))

cases_long
pop_long

# Join them into a single tidy table (country-year as observation)
table4_tidy <- cases_long %>%
  left_join(pop_long, by = c("country", "year"))

table4_tidy

# 7.3) table3 -> tidy using separate
# rate is stored as a character like "745/19987071"
table3_tidy <- table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

table3_tidy

# 7.4) table5 -> tidy by uniting century + year into a single year
# Here “19” + “99” should become 1999, etc.
table5_tidy <- table5 %>%
  unite("year_full", century, year, sep = "") %>%
  mutate(year_full = as.integer(year_full)) %>%
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

table5_tidy

# ------------------------------------------------------------------------------
# 8) Mini-exercises (do these during/after lecture)
# ------------------------------------------------------------------------------

# Exercise 1: Take structure_a and reshape it to a tidy “long” format with:
# columns: name, treatment, value
# Hint: pivot_longer() is your friend.

# TODO: write code here
# structure_a_long <- structure_a %>% ...
# structure_a_long

# Exercise 2: Starting from table4_tidy, compute:
# (a) rate per 10,000, (b) a log10(population) variable
# TODO: write code here
# table4_tidy %>% ...

# Exercise 3: In table2_tidy, filter to year == 2000 and arrange by cases (desc).
# TODO: write code here
# table2_tidy %>% ...

# ------------------------------------------------------------------------------
# 9) Hints (keep collapsed mentally; use only if stuck)
# ------------------------------------------------------------------------------

# Hint for Exercise 1:
# structure_a_long <- structure_a %>%
#   pivot_longer(cols = starts_with("treatment"),
#                names_to = "treatment",
#                values_to = "value")

