
# Raw2Refined: A Mini-Course on Data Wrangling and Visualization in R

This hands-on mini-course introduces essential tools and workflows for transforming messy real-world datasets into analytically usable formats and for visualizing patterns using R. Students are guided through a three-session sequence, progressing from foundational concepts in data tidying to applied data manipulation and visualization with the tidyverse.

---

## 📁 Directory Structure

```
raw2refined/
│
├── data/               # Publicly available real-world datasets
│   ├── public_debt.xls
│   ├── country_metadata.csv
│   └── ...
│
├── images/             # Visualization outputs or assets
│
├── scripts/            # R scripts used in the sessions
│   └── r2r_session1_student_script.R
│
├── session_docs/       # RMarkdown and HTML lecture documents
│   ├── SCALE_RtR_Pt2.Rmd / .html
│   ├── SCALE_RtR_Pt3.Rmd / .html
│   └── ...
│
├── raw2refined.Rproj   # R Project file
└── README.md           # Course overview (this file)
```

---

## 📚 Course Overview

The course is organized into three sessions:

### **Session 1: Tidy Data Foundations**
- Understand the concept of "tidy data"
- Practice reshaping datasets using `pivot_longer()` and `pivot_wider()`
- Explore the problems with wide, inconsistent, or messy datasets

### **Session 2: Core Data Wrangling with dplyr and stringr**
- Handle missing data and recode variables
- Work with character strings
- Join datasets using `left_join()`, `inner_join()`, and others

### **Session 3: Data Visualization with ggplot2**
- Learn the grammar of graphics
- Build layered plots from the ground up
- Create scatter plots, histograms, boxplots, violin plots, bar charts, and more
- Map aesthetics such as color and size to variables
- Reinforce how tidy data structure enables effective visualizations

---

## 💻 Prerequisites

- Basic familiarity with R and RStudio
- `tidyverse` package (install using `install.packages("tidyverse")`)
- Optional: `readxl`, `janitor`, and `countrycode` packages

---

## 🚀 Getting Started

To run the course interactively:

1. Clone or download this repository.
2. Open `raw2refined.Rproj` in RStudio.
3. Open and run the R scripts or RMarkdown lecture files in the `session_docs/` directory.
4. Use datasets in `data/` for practice and exercises.

---

## 📜 License

This course is distributed for educational purposes. Feel free to remix or reuse for teaching or learning.

---

Created by Zachary Garfield, for AIRESSS-UM6P.
