############################################################
# Raw → Refined | Session 3
# Data Visualization with ggplot2
# Student Follow-Along Script
############################################################

# ==========================================================
# 0. Setup
# ==========================================================

# Install packages if needed (run once)
# install.packages("tidyverse")
# install.packages("palmerpenguins")

library(tidyverse)
library(palmerpenguins)

# Take a look at the data
glimpse(penguins)

# ==========================================================
# 1. What is ggplot?
# ==========================================================
# ggplot builds plots in layers:
# 1. data
# 2. aesthetics (aes)
# 3. geometry (geom)
# 4. optional: scales, facets, labels, themes

# Basic structure (does nothing yet):
ggplot(penguins)

# ==========================================================
# 2. First Plot: Scatter Plot
# ==========================================================

# Minimal scatter plot
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# TODO:
# Try changing x or y to a different numeric variable

# ==========================================================
# 3. Adding Aesthetics
# ==========================================================

# Color by species
ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g,
                     color = species)) +
  geom_point()

# Shape by island
ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g,
                     color = species,
                     shape = island)) +
  geom_point()

# TODO:
# Add alpha (transparency) inside geom_point()

# ==========================================================
# 4. Jitter and Overplotting
# ==========================================================

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_point()

# Add jitter to reduce overlap
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_jitter(width = 0.2, alpha = 0.6)

# ==========================================================
# 5. Adding a Regression Line
# ==========================================================

# Regression line for ALL data
ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE)

# TODO:
# What happens if you map color = species in aes()?

# ==========================================================
# 6. Faceting
# ==========================================================

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point() +
  facet_wrap(~ species)

# TODO:
# Try facetting by island instead

# ==========================================================
# 7. Histograms
# ==========================================================

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 30)

# Change fill and transparency
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 30,
                 fill = "steelblue",
                 alpha = 0.7)

# ==========================================================
# 8. Density Plots
# ==========================================================

ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# Density by species
ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.5)

# ==========================================================
# 9. Bar Plots
# ==========================================================

# Counts by species
ggplot(penguins, aes(x = species)) +
  geom_bar()

# Stacked bar chart
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar()

# ==========================================================
# 10. Box Plots
# ==========================================================

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# Add color
ggplot(penguins, aes(x = species,
                     y = body_mass_g,
                     fill = species)) +
  geom_boxplot(alpha = 0.7)

# ==========================================================
# 11. Violin Plots
# ==========================================================

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_violin()

# Combine violin + boxplot
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_violin(fill = "gray80") +
  geom_boxplot(width = 0.1)

# ==========================================================
# 12. Labels and Themes
# ==========================================================

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g,
                     color = species)) +
  geom_point(size = 2) +
  labs(
    title = "Penguin Body Mass vs Flipper Length",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  ) +
  theme_minimal()

# TODO:
# Try theme_classic() or theme_bw()

# ==========================================================
# 13. Tidy Data Reminder
# ==========================================================
# ggplot works best when:
# - each variable is a column
# - each observation is a row
# - aesthetics map cleanly to variables

# ==========================================================
# 14. Mini Challenge
# ==========================================================

# Challenge:
# Create a plot that shows:
# - x = bill_length_mm
# - y = bill_depth_mm
# - color = species
# - size = body_mass_g
# - nice labels
# - a regression line for all data

# Write your code below:

# ggplot( ... ) +
#   geom_point( ... ) +
#   geom_smooth( ... )

############################################################
# End of Session 3 Script
############################################################
