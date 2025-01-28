##### Tidy Data Workshop: Student Script
##### Professor Z. Garfield // FGSES // UM6P

# -----------------------------------------------------------------------------------
# 1. SETUP: Load Required Packages
# -----------------------------------------------------------------------------------

# Install required packages if they are not already installed
for (pkg in c("tidyverse", "haven", "labelled", "readxl")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}

# Load the libraries
library(tidyverse)
library(haven)
library(labelled)
library(readxl)

# -----------------------------------------------------------------------------------
# 2. LOAD EXAMPLE DATASETS (UNTIDY)
# -----------------------------------------------------------------------------------

# Example 1: Public Health Data (Untidy Format)
table2 <- tibble(
  country = c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China"),
  year = c(1999, 1999, 2000, 2000, 1999, 1999),
  type = c("cases", "population", "cases", "population", "cases", "population"),
  count = c(745, 19987071, 37737, 174504898, 212258, 1272915272)
)

# Example 2: Economic Data (Untidy Format)
table4b <- tibble(
  country = c("Afghanistan", "Brazil", "China"),
  `1999` = c(19987071, 172006362, 1272915272),
  `2000` = c(20595360, 174504898, 1280428583)
)

# Example 3: Financial Data (Wide Format)
morocco_debt <- read_excel("cleaned_MMF_debt_data.xlsx")

# Example 4: Car Dataset (Wide Format)
mtcars_data <- mtcars %>%
  rownames_to_column(var = "car_name")

# -----------------------------------------------------------------------------------
# 3. EXERCISE: IDENTIFY ISSUES IN THE DATASETS
# -----------------------------------------------------------------------------------

# TODO: Write a brief explanation of why each dataset is untidy.
# What is wrong with table2?
table2_issue <- "table2 is untidy because..."

# What is wrong with table4b?
table4b_issue <- "table4b is untidy because..."

# What is wrong with morocco_debt?
morocco_debt_issue <- "morocco_debt is untidy because..."

# What is wrong with mtcars_data?
mtcars_data_issue <- "mtcars_data is untidy because..."

# -----------------------------------------------------------------------------------
# 4. EXERCISE: TRANSFORM THESE DATASETS INTO A TIDY FORMAT
# -----------------------------------------------------------------------------------

# TODO: Use pivot_longer() or pivot_wider() to tidy each dataset.

# 1. Transform table2 into a tidy format
# table2_tidy <- ...

# 2. Transform table4b into a tidy format
# table4b_tidy <- ...

# 3. Transform morocco_debt into a tidy format
# morocco_debt_tidy <- ...

# 4. Transform mtcars_data into a tidy format
# mtcars_tidy <- ...

# -----------------------------------------------------------------------------------
# 5. ANALYSIS: DERIVE INSIGHTS FROM THE CLEAN DATA
# -----------------------------------------------------------------------------------

# TODO: Once your datasets are tidy, try summarizing or visualizing them.
# For example, calculate total cases per year from table2:
# summary_cases <- table2_tidy %>%
#   group_by(year) %>%
#   summarize(total_cases = sum(cases, na.rm = TRUE))

# TODO: Create a simple plot of debt trends over time
# ggplot(morocco_debt_tidy, aes(x = Year, y = Value, color = DebtType)) +
#   geom_line() +
#   labs(title = "Moroccan Debt Over Time", x = "Year", y = "Debt (Millions)")

# -----------------------------------------------------------------------------------
# 6. FINAL THOUGHTS
# -----------------------------------------------------------------------------------

# TODO: Reflect on what you learned.
final_reflection <- "The biggest challenge I faced was..."
