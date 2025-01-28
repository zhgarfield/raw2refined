---
title: "From Raw to Refined: Tidy Data in R"
subtitle:  "Session 1: Principles and Practices of Tidy Data"
author:
  - name: Pr. Zachary H. Garfield
    orcid: 0000-0002-1547-1492
    email: zachary.garfield@um6p.ma
    affiliations:
      - name: Africa Institute for Research in Economics and Social Sciences, University Mohammed VI Polytechnic
        address:
        city: Rabat
        state: Morocco
date:
urlcolor: blue
output: 
  html_document:
    toc: false
    number_sections: false
    fig_caption: true
    highlight: default
    theme: default 
    df_print: tibble #options: default, tibble, paged
    keep_md: true 
editor_options: 
  markdown: 
    wrap: 72
---

```{=html}
<style>
  body {
    font-size: 19px; /* Increase the font size here */
  }
  
  img {
    max-width: 100%;
    height: auto;
    margin: 0 auto;
    display: block;
  }
  
  .figure {
    text-align: center;
    margin: 1em auto;
    max-width: 100%;
  }
  .caption {
    font-style: italic;
    font-size: 0.9em;
    margin-top: 0.5em;
  }
</style>
```

# Introduction

Have you ever struggled to clean messy data before an analysis? Tidy
data principles will help you streamline your workflow and save time.

In this session, we will explore the principles of tidy data, how to
identify untidy datasets, and the tools to transform data into tidy
formats using R. This lecture draws on content from [Tidyverse Skills
for Data Science](https://jhudatascience.org/tidyversecourse/intro.html)
by Carrie Wright, Shannon E. Ellis, Stephanie C. Hicks and Roger D.
Peng, as well as the [Data Management and Manipulation Using
R](https://ozanj.github.io/rclass/resources/) course at UCLA.

## Logistics

### Libraries we will use today

You must run this chunk of R code. The first line will install the
`tidyverse` package if it is not installed on your machine/directory.

``` r
# Command to conditionally install packages
for (pkg in c("tidyverse", "haven", "labelled")) if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)

# Loack packages
library(tidyverse)

── Attaching core tidyverse packages ──────────────────────────────────────────────────────────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.5
✔ forcats   1.0.0     ✔ stringr   1.5.1
✔ ggplot2   3.5.1     ✔ tibble    3.2.1
✔ lubridate 1.9.4     ✔ tidyr     1.3.1
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()

library(haven)
library(labelled)
```

### Key strokes we will use

You will need to be able to access these key strokes on your computer

-   The back tick `` ` ``
-   The dollar sign `$`
-   The tilde `~`
-   The assignment operator `<-`
-   The pipe operator `%>%`
    -   `ctrl + shift + m` or `command + shift + m`

### Script file

Go to the [GitHub repository](https://github.com/zhgarfield/raw2refined)
for the workshop (search "zhgarfield" "raw2refined"). Click on
"scripts". Right click on "r2r_session1_student_script.R" and save scrit
file.

Pro tip: Or you can clone the repository in R Studio ?!?

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/raw2refined/refs/heads/main/images/r2r_script_location.png" alt="Location of script file for this session" width="100%"/>

<p class="caption">

Location of script file for this session

</p>
:::

<br>

### Other resources

[R Cheatsheets](https://rstudio.github.io/cheatsheets/) hosted by Posit.

```         
* See in particular the [tidyr::Cheatsheet](https://rstudio.github.io/cheatsheets/html/tidyr.html) and the [dplyr::Cheatsheet](https://rstudio.github.io/cheatsheets/html/data-transformation.html).
```

[R for Data Science (2e)](https://r4ds.hadley.nz/)

## Lecture overview

### Why Does Tidy Data Matter?

Tidy data is the foundation of effective data analysis. Imagine you’re
handed a messy dataset with inconsistent formats, missing values, or
multiple variables crammed into a single column. Tasks like
visualization or modeling become unnecessarily complex. Tidy data
principles solve this problem by providing a standard structure that
ensures consistency, compatibility, and clarity.

For example:

-   With tidy data, functions from the tidyverse (e.g., dplyr, ggplot2,
    tidyr) work seamlessly, saving you time and effort.

-   It promotes reproducibility and collaboration, as a clean dataset is
    easier to share and understand.

By learning how to tidy data, you’ll reduce frustration and create a
strong foundation for analysis, visualization, and reporting.

### Goals of Tidying Data

By the end of this session, you will:

-   Understand the principles of tidy data.

-   Diagnose untidy datasets and identify specific issues.

-   Transform untidy data into tidy formats using tools from the
    tidyverse.

-   Recognize the benefits of tidy data in the context of real-world
    analysis.

### How Will We Achieve This?

1.  Defining Tidy Data:

    -   What makes a dataset tidy?

    -   Core principles: Variables as columns, observations as rows, and
        values as individual cells.

2.  Diagnosing Untidy Data:

    -   How to recognize untidy datasets.

    -   Examples of common violations of tidy principles.

3.  Hands-on Practice:

    -   Exploring datasets (`table1`, `table2`, etc.).

    -   Diagnosing issues and transforming them into tidy formats using
        `pivot_longer()` and `pivot_wider()`.

4.  Real-World Relevance:

    -   How tidy data simplifies analysis and visualization in R.

    -   Discussion of tidy data’s role in reproducible research and
        collaboration.

# Get tidy :)) or cry tryin T_T

Creating analysis datasets often require **changing the organizational
structure** of data.

Examples:

-   You want your analysis dataset to have *one obs per student*, but
    your data has *one obs per student-course*
-   You want your analysis dataset to have *one obs per institution*,
    but enrollment data has *one obs per institution-enrollment level*
-   You want your analysis dataset to have *one obs per country*, but
    GDP data has *one obs per country-year level*

## Example for Context

Let’s say you’re analyzing public health data from three countries over
two years. The dataset might look like this:

``` r
# Untidy Example
table_messy <- tibble(
  country = c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China"),
  year = c(1999, 1999, 2000, 2000, 1999, 1999),
  type = c("cases", "population", "cases", "population", "cases", "population"),
  count = c(745, 19987071, 37737, 174504898, 212258, 1272915272)
)

print(table_messy)
# A tibble: 6 × 4
#   country      year type            count
#   <chr>       <dbl> <chr>           <dbl>
# 1 Afghanistan  1999 cases             745
# 2 Afghanistan  1999 population   19987071
# 3 Brazil       2000 cases           37737
# 4 Brazil       2000 population  174504898
# 5 China        1999 cases          212258
# 6 China        1999 population 1272915272
```

> ***NOTE:*** `tibble` builds a tibble (a type of table) from individual
> columns; Tibbles are `data.frames` that don’t change variable names or
> types, and don’t do partial matching which forces you to confront
> problems earlier, typically leading to cleaner, more expressive code.
> See the [tibbles chapter](https://r4ds.had.co.nz/tibbles.html) in *R
> for data science*.

This dataset is untidy because:

-   The type column stores two variables: cases and population.

-   Each country-year observation spans two rows instead of one.

Using tidy data principles, we can transform this into:

``` r
# Tidy Example
table_tidy <- table_messy %>%
  pivot_wider(names_from = type, values_from = count)

print(table_tidy)
# A tibble: 3 × 4
#   country      year  cases population
#   <chr>       <dbl>  <dbl>      <dbl>
# 1 Afghanistan  1999    745   19987071
# 2 Brazil       2000  37737  174504898
# 3 China        1999 212258 1272915272
```

> ***NOTE:*** `pivot_wider` is a function for "reshaping data" discussed
> more below.

Now:

-   Each variable has its own column (cases, population).

-   Each observation is stored in one row.

Two common ways to change organizational structure of data:

1.  Use `group_by` to perform calculations separately within groups and
    then use `summarise` to create an object with one observation per
    group. Examples:
    -   Creating objects containing summary statistics that are basis
        for tables and graphs
    -   Creating student-transcript level GPA variable from
        student-transcript-course level data
2.  **Reshape** your data--called **tidying** in the R tidyverse
    world--by transforming columns (variables) into rows (observations)
    and vice-versa
    -   Our topic for today

This lecture is about changing the organizational structure of your data
by transforming **untidy** data into **tidy** data.

-   Working with tidy data has many benefits, one of them is that all
    the packages in the tidyverse are designed to work with tidy data.
-   We will perform data **tidying** using functions from the `tidyr`
    package, which is a package within `tidyverse`.

Show index and example datasets in `tidyr` package

``` r
help(package="tidyr")

# note that example datasets table1, table2, etc. are listed in the index alongside functions
table1
tidyr::table1 # same same
# A tibble: 6 × 4
#   country      year  cases population
#   <chr>       <dbl>  <dbl>      <dbl>
# 1 Afghanistan  1999    745   19987071
# 2 Afghanistan  2000   2666   20595360
# 3 Brazil       1999  37737  172006362
# 4 Brazil       2000  80488  174504898
# 5 China        1999 212258 1272915272
# 6 China        2000 213766 1280428583

df1 <- table1 # create an object from the "function" table1
str(df1)
# tibble [6 × 4] (S3: tbl_df/tbl/data.frame)
#  $ country   : chr [1:6] "Afghanistan" "Afghanistan" "Brazil" "Brazil" ...
#  $ year      : num [1:6] 1999 2000 1999 2000 1999 ...
#  $ cases     : num [1:6] 745 2666 37737 80488 212258 ...
#  $ population: num [1:6] 2.00e+07 2.06e+07 1.72e+08 1.75e+08 1.27e+09 ...

table2
# A tibble: 12 × 4
#    country      year type            count
#    <chr>       <dbl> <chr>           <dbl>
#  1 Afghanistan  1999 cases             745
#  2 Afghanistan  1999 population   19987071
#  3 Afghanistan  2000 cases            2666
#  4 Afghanistan  2000 population   20595360
#  5 Brazil       1999 cases           37737
#  6 Brazil       1999 population  172006362
#  7 Brazil       2000 cases           80488
#  8 Brazil       2000 population  174504898
#  9 China        1999 cases          212258
# 10 China        1999 population 1272915272
# 11 China        2000 cases          213766
# 12 China        2000 population 1280428583

table3
# A tibble: 6 × 3
#   country      year rate             
#   <chr>       <dbl> <chr>            
# 1 Afghanistan  1999 745/19987071     
# 2 Afghanistan  2000 2666/20595360    
# 3 Brazil       1999 37737/172006362  
# 4 Brazil       2000 80488/174504898  
# 5 China        1999 212258/1272915272
# 6 China        2000 213766/1280428583
```

## Why Tidy Data Matters

Adopting a uniform tidy data structure enables the creation of tools
that function effectively within this context, thereby streamlining the
processes of data manipulation, visualization, and analysis. Initiating
a project with data in a tidy format, or dedicating time early on to
organize data tidily, simplifies subsequent stages of your data science
endeavor.

What is tidy data? **Tidy data is a structured way of organizing data
that makes analysis, visualization, and modeling more intuitive and
efficient.**

In a tidy dataset:

-   Each *variable* is stored in its own *column*.
-   Each *observation* is stored in its own *row*.
-   Each *value* has its own unique *cell*.

This consistent structure ensures that datasets are easy to understand
and manipulate, enabling seamless use of tools like `ggplot2`, `dplyr`,
and other \`tidyverse\`\`\` packages.

<br>

> "Happy families are all alike; every unhappy family is unhappy in its
> own way" - Leo Tolstoy

<br>

> "Tidy datasets are all alike but every messy dataset is messy in its
> own way." - Hadley Wickam

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/raw2refined/refs/heads/main/images/Hadley-wickham2016-02-04.jpg" alt="Hadley Wickham" width="30%"/>

<p class="caption">

Hadley Wickham

</p>
:::

<br>

## Why Tidy Data is Essential

Messy data can slow down analysis, lead to errors, and frustrate
collaboration. Tidy data solves these problems by:

-   *Streamlining Analysis*: Clean, structured data allows you to focus
    on the insights rather than data cleaning.
-   *Tool Compatibility*: Most functions in the tidyverse are designed
    to work with tidy data, saving time and effort.
-   *Collaboration & Reproducibility*: A tidy dataset is easy to share
    and ensures that others can understand and replicate your work.
-   *Simplifying Visualization*: Tools like \`ggplot2\`\`\` rely on tidy
    data to create clear, meaningful visualizations.

> ***Key Takeaway*** Tidy data isn’t just a best practice—it’s the
> backbone of efficient and error-free data workflows. Whether you’re
> exploring trends, building models, or creating visualizations,
> starting with tidy data simplifies the entire process.

Now that we’ve explored why tidy data matters, let’s break down the
principles that define a tidy dataset and how these principles apply to
real-world data scenarios.

# Data "structure" vs data "concepts"

Before we define "tidy data", we will spend significant time defining
and discussing some core terms/concepts about datasets.

This discussion draws from the 2014 article [Tidy
Data](https://www.jstatsoft.org/article/view/v059i10) by Hadley Wickham.

-   Wickham (2014) distinguishes between "**data structure**" and
    "**data concepts**"
    -   (Wickham actually uses the term "data semantics")

## Dataset structure

Before we get deeper into tidy data, it's important to understand the
distinction between *data structure* and *data concepts*. These are the
building blocks of any dataset and form the foundation for diagnosing
and tidying messy data.

### Dataset Structure: The Physical Layout

*Dataset structure* refers to the *physical arrangement* of data in
*rows* and *columns*. Most datasets are represented as rectangular
tables, where:

-   Columns represent variables or attributes (e.g., height, GDP).
-   Rows represent observations or individual data points (e.g.,
    participants, countries).

There are many alternative data structures to present the same
underlying data. For example, consider the two datasets below,
`structure_a` and `structure_b`, which represent the same information
but in different layouts.

``` r
#create structure a: treatment as columns, names as rows
structure_a <- tibble( # The `tibble` function creates a data frame
  name   = c("Mohammed","Fatima Ezzahra","Jean-Baptiste"),
  treatmenta    = c(NA, 16, 3),
  treatmentb = c(2, 11, 1)
)

#create structure b: treatment as rows, names as columns
structure_b <- tibble(
  treatment   = c("treatmenta","treatmentb"),
  Mohammed    = c(NA, 2),
  Fatima_Ezzahra = c(16,11),
  Jean_Baptiste = c(3,1)
)

structure_a
#> # A tibble: 3 × 3
#>   name           treatmenta treatmentb
#>   <chr>               <dbl>      <dbl>
#> 1 Mohammed               NA          2
#> 2 Fatima Ezzahra         16         11
#> 3 Jean-Baptiste           3          1
structure_b
#> # A tibble: 2 × 4
#>   treatment  Mohammed Fatima_Ezzahra Jean_Baptiste
#>   <chr>         <dbl>          <dbl>         <dbl>
#> 1 treatmenta       NA             16             3
#> 2 treatmentb        2             11             1
```

> ***Key Takeaway*** Both tables contain the same underlying data but
> differ in their physical structure. Deciding which structure is most
> useful depends on the analysis task.

## Data Concepts: The Meaning Behind the Data

*Data concepts* refer to how the data is interpreted—what the rows,
columns, and cells represent in terms of meaning and analysis. These
concepts help us identify the appropriate structure for a dataset.

Key Terms: \* *Dataset*: A collection of data values organized into rows
and columns. \* *Variables*: Columns that represent the attributes being
measured or recorded (e.g., name, treatment type). \* *Observations*:
Rows that represent individual data points or units of analysis. \*
*Values*: The actual measurements stored in cells (e.g., 16, 35.32, or
"Fatima").

### Dataset {.unnumbered}

A *dataset* is a collection of values. These are often numbers and
strings, and are stored in a variety of ways. However, every value in a
dataset belongs to a variable and an observation.

### Variables {.unnumbered}

*Variables* in a dataset are the different categories of data that will
be collected. They are the different pieces of information that can be
collected or measured on each observation. Here, we see there are 7
different variables: ID, LastName, FirstName, Sex, City, State, and
Occupation. The names for variables are put in the first row of the
spreadsheet.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/001.png" alt="Variables" width="100%"/>

<p class="caption">

Variables

</p>
:::

### Observations

The measurements taken from a person for each variable are called
observations. Observations in a tidy dataset are stored in a single row,
with each observation being put in the appropriate column for each
variable.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/002.png" alt="Observations" width="100%"/>

<p class="caption">

Observations

</p>
:::

### Types

Often, data are collected for the same individuals from multiple
sources. For example, when you go to the doctor’s office, you fill out a
survey about yourself. That would count as one type of data. The
measurements a doctor collects at your visit, however, would be a
different type of data.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/003.png" alt="Types" width="100%"/>

<p class="caption">

Types

</p>
:::

Here’s an example of how these concepts apply to a dataset:

``` r
example_data <- tibble(
  ID = 1:3,
  Name = c("Mohammed", "Fatima", "Jean-Baptiste"),
  Age = c(34, 29, 42),
  Treatment = c("A", "B", "A")
)

example_data
# A tibble: 3 × 4
#      ID Name            Age Treatment
#   <int> <chr>         <dbl> <chr>    
# 1     1 Mohammed         34 A        
# 2     2 Fatima           29 B        
# 3     3 Jean-Baptiste    42 A    
```

In this dataset:

-   *Variables*: `ID`, `Name`, `Age`, `Treatment`.
-   *Observations*: Each row represents a person (Mohammed, Fatima, or
    Jean-Baptiste).
-   *Values*: Specific data points, such as `34` for Mohammed's age or
    \`A\`\`\` for his treatment.

### Why This Matters

Understanding data structure and concepts helps us:

1.  Determine the *unit of analysis*: What does each row represent? For
    example:

    -   In `structure_a`, each row represents a person.

    -   In `structure_b`, each row represents a treatment type.

2.  Identify *variables* vs. *values*: This distinction is critical for
    diagnosing untidy data.

3.  Recognize structural issues: Is information scattered across
    multiple rows or columns? Are variables combined into a single
    column?

### Unit of analysis

What each row represents in a dataset (referring to physical layout of
dataset).

Examples of different units of analysis:

-   if each row represents a student, you have student level data
-   if each row represents a student-course, you have student-course
    level data
-   if each row represents an organization-year, you have
    organization-year level data
-   if each row represents a player on the Morocco National Football
    Team, you have player-level data
-   if each row represents each time a player on the Morocco National
    Football Team took a penalty kick, you have penelty kick
    attempt-level data

**Questions**:

-   What does each row represent in the data frame object `structure_a`?
    What is the unit of analysis?

``` r
structure_a
#> # A tibble: 3 × 3
#>   name           treatmenta treatmentb
#>   <chr>               <dbl>      <dbl>
#> 1 Mohammed               NA          2
#> 2 Fatima Ezzahra         16         11
#> 3 Jean-Baptiste           3          1
```

-   What does each row represent in the data frame object `structure_b`?
    What is the unit of analysis?

``` r
structure_b
#> # A tibble: 2 × 4
#>   treatment  Mohammed Fatima_Ezzahra Jean_Baptiste
#>   <chr>         <dbl>          <dbl>         <dbl>
#> 1 treatmenta       NA             16             3
#> 2 treatmentb        2             11             1
```

### Practical Exercise: Identify Structure and Concepts

Use the `table2` dataset from the `tidyr` package to practice
identifying structure and concepts.

``` r
library(tidyr)

# Example dataset
table2

# Output
# A tibble: 12 × 4
#    country      year type            count
#    <chr>       <dbl> <chr>           <dbl>
#  1 Afghanistan  1999 cases             745
#  2 Afghanistan  1999 population   19987071
#  3 Afghanistan  2000 cases            2666
#  4 Afghanistan  2000 population   20595360
#  5 Brazil       1999 cases           37737
#  6 Brazil       1999 population  172006362
#  7 Brazil       2000 cases           80488
#  8 Brazil       2000 population  174504898
#  9 China        1999 cases          212258
# 10 China        1999 population 1272915272
# 11 China        2000 cases          213766
# 12 China        2000 population 1280428583
```

Questions:

1.  What does each row represent in this dataset?

    <details>

    <summary>Answer</summary>

    <p>A country-year-type combination</p>

    </details>

2.  What are the variables?

    <details>

    <summary>Answer</summary>

    <p>country, year, cases, population</p>

    </details>

3.  How could this dataset be tidied?

    <details>

    <summary>Answer</summary>

    <p>Hint: Use `pivot_wider()` to reshape.</p>

    </details>

# Principles of Tidy Data

Hadley Wickham’s 2014 paper [“Tidy
Data”](https://www.jstatsoft.org/article/view/v059i10) lays out three
key principles of tidy data. These principles ensure datasets are
structured for optimal analysis, modeling, and visualization:

-   *Each variable forms a column*: A single column contains all values
    for a specific variable (e.g., all `cases` or `population` values
    are grouped together).
-   *Each observation forms a row*: Each row corresponds to one complete
    observation (e.g., `country-year` data in a single row).
-   *Each value forms a cell*: Every cell contains one and only one
    value.

When these principles are followed, datasets are easier to manipulate
and analyze. Here's an example of a tidy dataset:

Example: Tidy Dataset (`table1`)

``` r
# Example of tidy data
table1
#> # A tibble: 6 × 4
#>   country      year  cases population
#>   <chr>       <dbl>  <dbl>      <dbl>
#> 1 Afghanistan  1999    745   19987071
#> 2 Afghanistan  2000   2666   20595360
#> 3 Brazil       1999  37737  172006362
#> 4 Brazil       2000  80488  174504898
#> 5 China        1999 212258 1272915272
#> 6 China        2000 213766 1280428583
```

Each *variable* (e.g., `cases`, `population`) is a column. Each
*observation* (e.g., `country-year`) is a row. Each *value* (e.g., `745`
or `19987071`) occupies its own cell.

> Tidy datasets are easy to manipulate, model and visualize, and have a
> specific structure: each variable is a column, each observation is a
> row, and each type of observational unit is a table.

Here, we’ll break down each one to ensure that we are all on the same
page.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/004.png" alt="Principle #1 of Tidy Data" width="100%"/>

<p class="caption">

Principle #1 of Tidy Data

</p>
:::

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/005.png" alt="Principle #2 of Tidy Data" width="100%"/>

<p class="caption">

Principle #2 of Tidy Data

</p>
:::

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/006.png" alt="Principle #3 of Tidy Data" width="100%"/>

<p class="caption">

Principle #3 of Tidy Data

</p>
:::

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/007.png" alt="Principle #3 of Tidy Data" width="100%"/>

<p class="caption">

Principle #3 of Tidy Data

</p>
:::

> ***Key Takeaway*** When it comes to thinking about tidy data, remember
> that tidy data are rectangular data. The data should be a rectangle
> with each variable in a separate column and each entry in a different
> row. All cells should contain some text, so that the spreadsheet looks
> like a rectangle with something in every cell.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/008.png" alt="Tidy Data = rectangular data" width="100%"/>

<p class="caption">

Tidy Data = rectangular data

</p>
:::

So, if you’re working with a dataset and attempting to tidy it, if you
don’t have a nice rectangle at the end of the process, you likely have
more work to do before it’s truly in a tidy data format.

## Summary of the Rules of tidy data (defining tidy data)

Wickham chapter 12: "There are three interrelated rules which make a
dataset tidy:

1.  Each **variable** must have its own **column**
2.  Each **observation** must have its own **row**
3.  Each **value** must have its own "**cell**"
4.  Additional rule from Wickham (2014): Each type of **observational
    unit** forms a **table**

> These three rules are interrelated because it’s impossible to only
> satisfy two of the three (Wickham chapter 12)

<br> **Visual representation of the three rules of tidy data**:

![](http://r4ds.had.co.nz/images/tidy-1.png) Here is an example of tidy
data:

``` r
#help(package="tidyr")
table1
#> # A tibble: 6 × 4
#>   country      year  cases population
#>   <chr>       <dbl>  <dbl>      <dbl>
#> 1 Afghanistan  1999    745   19987071
#> 2 Afghanistan  2000   2666   20595360
#> 3 Brazil       1999  37737  172006362
#> 4 Brazil       2000  80488  174504898
#> 5 China        1999 212258 1272915272
#> 6 China        2000 213766 1280428583
```

# Untidy data

While all tidy datasets follow the same principles, untidy datasets can
vary significantly in how they are disorganized. Diagnosing and fixing
these issues is a critical step in data preparation.

<br> *Example 1:* Table with Mixed Variables in Rows Consider the
dataset `table2`. It does not conform to tidy data principles because it
combines multiple variables (cases and population) in a single column
(type), with their values stored in the count column. This organization
makes it challenging to perform computations or analysis.

``` r
# Untidy Data: table2
table2
#> # A tibble: 12 × 4
#>    country      year type          count
#>    <chr>       <dbl> <chr>         <dbl>
#>  1 Afghanistan  1999 cases           745
#>  2 Afghanistan  1999 population 19987071
#>  3 Afghanistan  2000 cases          2666
#>  4 Afghanistan  2000 population 20595360
#>  5 Brazil       1999 cases         37737
#>  6 Brazil       1999 population 172006362
#>  7 Brazil       2000 cases         80488
#>  8 Brazil       2000 population 174504898
#>  9 China        1999 cases        212258
#> 10 China        1999 population 1272915272
```

Why is `table2` untidy?

-   Does each variable have its own column?

    <details>

    <summary>Answer</summary>

    <p>No. The type column contains two variables: cases and population.
    These should instead be stored as two separate columns: one for
    cases and one for population.</p>

    </details>

-   Does each observation have its own row?

    <details>

    <summary>Answer</summary>

    <p>No. Observations (country-year) are split across multiple rows
    because the type column separates the attributes.Each country-year
    should occupy a single row.</p>

    </details>

-   Does each value have its own cell?

    <details>

    <summary>Answer</summary>

    <p>Yes. The values (745, 19987071, etc.) are stored properly in
    individual cells.</p>

    </details>

*Example 2*: Embedded Variables in a Single Column In `table3`, the
`rate` column combines two variables (`cases` and `population`) into a
single string. This violates the principle of storing each variable in
its own column.

``` r
# Untidy Data: table3
table3
#> # A tibble: 6 × 3
#>   country      year rate             
#>   <chr>       <dbl> <chr>            
#> 1 Afghanistan  1999 745/19987071     
#> 2 Afghanistan  2000 2666/20595360    
#> 3 Brazil       1999 37737/172006362  
#> 4 Brazil       2000 80488/174504898  
```

How can we tidy this dataset?

<details>

<summary>Answer</summary>

<p>To tidy this dataset, we would need to split the rate column into two
separate columns: one for cases and one for population.</p>

</details>

*Example 3*: Values Spread Across Columns In `table4a` and `table4b`,
values for a single variable (`cases` or `population`) are spread across
multiple columns, with `years` (`1999`, `2000`) as column names. This
violates the rule that each variable should have its own column.

``` r
# Untidy Data: table4a
table4a
#> # A tibble: 3 × 3
#>   country     `1999` `2000`
#>   <chr>        <dbl>  <dbl>
#> 1 Afghanistan    745   2666
#> 2 Brazil       37737  80488
#> 3 China       212258 213766

# Untidy Data: table4b
table4b
#> # A tibble: 3 × 3
#>   country         `1999`     `2000`
#>   <chr>            <dbl>      <dbl>
#> 1 Afghanistan   19987071   20595360
#> 2 Brazil       172006362  174504898
#> 3 China       1272915272 1280428583
```

How can we tidy this dataset?

<details>

summary\>Answer

</summary>

<p>To tidy this dataset, the `year` columns (`1999`, `2000`) should be
gathered into a single column, with their corresponding values moved
into a separate column.</p>

</details>

## Diagnosing untidy data

To transform untidy data into tidy data, you first need to diagnose the
problems. Revisit the three principles of tidy data: Recall the three
principles of tidy data:

1.  Each variable must have its own column.

    -   If not, identify the variables hidden in rows or concatenated in
        a single column.

2.  Each observation must have its own row.

    -   If not, identify the unit of observation and ensure all its
        attributes are represented in one row.

3.  Each value must have its own cell.

    -   If not, split concatenated values into separate cells.

### Practical Exercise: Diagnosing `table2`

Let’s analyze `table2` step by step:

``` r
table2
#> # A tibble: 12 × 4
#>    country      year type            count
#>    <chr>       <dbl> <chr>           <dbl>
#>  1 Afghanistan  1999 cases             745
#>  2 Afghanistan  1999 population   19987071
#>  3 Afghanistan  2000 cases            2666
#>  4 Afghanistan  2000 population   20595360
#>  5 Brazil       1999 cases           37737
#>  6 Brazil       1999 population  172006362
#>  7 Brazil       2000 cases           80488
#>  8 Brazil       2000 population  174504898
#>  9 China        1999 cases          212258
#> 10 China        1999 population 1272915272
#> 11 China        2000 cases          213766
#> 12 China        2000 population 1280428583
```

Answers to these questions:

1.  Does each variable have its own column?

    <details>

    <summary>Answer</summary>

    <p>No. The type column combines two variables: `cases` and
    `population`.</p>

    </details>

2.  Does each observation have its own row?

    <details>

    <summary>Answer</summary>

    <p>No. Each `country-year` observation is split across two rows.</p>

    </details>

3.  Does each value have its own cell?

    <details>

    <summary>Answer</summary>

    <p>Yes. Individual values (`745`, `19987071`, etc.) are stored
    correctly.</p>

    </details>

### A real world example: Cross-societal data on punishment systems

In real-world data, issues such as missing values, inconsistent formats,
or poorly named variables often compound untidy structures.

::: {.figure style="text-align: center"}
<img src="https://zhgarfield.github.io/files/untidydata.jpg" alt="Data not tidy!" width="100%"/>

<p class="caption">

Data not tidy!

</p>
:::

Raw data developed by researchers used in [Garfield et al.
(2023)](https://zhgarfield.github.io/files/garfield_et_al_2023_EHS.pdf)
"Norm violations and punishments across human societies," *Evolutionary
Human Sciences* (after much Tidying!)

Tidy(er) data now available on
[GitHub](https://github.com/zhgarfield/violationsandpunishmentsdata):

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/zhgarfield.github.io/refs/heads/master/files/git_pun_data.jpeg" alt="GitHub ftw" width="100%"/>

<p class="caption">

GitHub ftw

</p>
:::

### Anoter real world example: Moroccan Ministry of Economics and Finance, Public External Debt and Central Government Debt (2023)

Download the data:
<https://www.finances.gov.ma/en/Pages/Economic-and-Financial-Statistics.aspx>

(Google "Morocco ministry data") and click: "Economic and Financial
Statistics - The Ministry of Economy and Finance ..."

<br>

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/zhgarfield.github.io/refs/heads/master/files/MMF.jpeg" alt="Economics and Vital statistics, www.finances.gov.ma" width="100%"/>

<p class="caption">

Economics and Vital statistics, www.finances.gov.ma

</p>
:::

<br>

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/zhgarfield.github.io/refs/heads/master/files/MMF_debt_data_raw.jpeg" alt="Public External Debt and Central Government Debt (Update: 03/31/2023)" width="100%"/>

<p class="caption">

Public External Debt and Central Government Debt (Update: 03/31/2023)

</p>
:::

#### How can we make these data tidy?

<details>

<summary>Click to view</summary>

::: {.figure style="text-align: center"}
<img src="https://raw.githubusercontent.com/zhgarfield/zhgarfield.github.io/refs/heads/master/files/clean_mmf.jpeg" alt="Cleaning up the spreadsheet" width="100%"/>

<p class="caption">

Cleaning up the spreadsheet

</p>
:::

</details>

<br>

*1. Load the data*

Ensure that your dataset is properly loaded into R. Since this is a
structured table, it's best to use `readxl` if it's an Excel file.

``` r
library(tidyverse)
library(readxl)

# Load the dataset
cleaned_MMF_debt_data <- read_excel("cleaned_MMF_debt_data.xlsx")

> head(cleaned_MMF_debt_data)
# A tibble: 6 × 27
#   DebtVariable       DebtType  `1998`  `1999`  `2000`  `2001`  `2002`  `2003`  `2004`  `2005`  `2006`  `2007`  `2008`  `2009`  `2010`  `2011`  `2012`  `2013`  `2014`  `2015`  `2016`
#   <chr>              <chr>      <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
# 1 Public External D… PublicE… 1.93e+4 1.75e+4 1.61e+4 1.41e+4 1.40e+4 1.44e+4 1.40e+4 1.25e+4 1.37e+4 1.58e+4 1.65e+4 1.94e+4 2.08e+4 2.20e+4 2.52e+4 2.88e+4 3.08e+4 3.04e+4 3.09e+4
# 2 Public External D… PublicE… 1.79e+5 1.78e+5 1.71e+5 1.63e+5 1.42e+5 1.26e+5 1.15e+5 1.16e+5 1.16e+5 1.22e+5 1.34e+5 1.52e+5 1.74e+5 1.89e+5 2.13e+5 2.35e+5 2.78e+5 3.01e+5 3.12e+5
# 3 In % of GDP        PublicE… 4.47e-1 4.35e-1 4.34e-1 3.66e-1 3.06e-1 2.53e-1 2.18e-1 2.1 e-1 1.92e-1 1.88e-1 1.86e-1 2.03e-1 2.22e-1 2.31e-1 2.51e-1 2.61e-1 2.78e-1 2.79e-1 2.86e-1
# 4 Total Debt Servic… PublicE… 3.01e+3 2.96e+3 2.52e+3 2.49e+3 2.57e+3 3.10e+3 2.57e+3 2.38e+3 2.11e+3 2.45e+3 2.35e+3 1.75e+3 1.82e+3 2.16e+3 2.31e+3 2.59e+3 2.68e+3 2.52e+3 2.96e+3
# 5 Total Debt Servic… PublicE… 2.89e+4 2.90e+4 2.68e+4 2.83e+4 2.84e+4 2.98e+4 2.28e+4 2.12e+4 1.86e+4 2.01e+4 1.83e+4 1.42e+4 1.54e+4 1.75e+4 2.00e+4 2.18e+4 2.26e+4 2.47e+4 2.91e+4
# 6 In % Current Rece… PublicE… 2.39e-1 2.26e-1 1.89e-1 1.65e-1 1.61e-1 1.65e-1 1.16e-1 9.3 e-2 7.1 e-2 6.8 e-2 5.4 e-2 5.4 e-2 5.1 e-2 5.3 e-2 5.7 e-2 6   e-2 5.7 e-2 6   e-2 6.8 e-2
# ℹ 6 more variables: `2017` <dbl>, `2018` <dbl>, `2019` <dbl>, `2020` <dbl>, `2021` <dbl>, `2022` <dbl>
```

*2. Identify problems*

The dataset has wide-format issues:

-   The first two columns (`DebtVariable` and `DebtType`) are
    categorical descriptors.
-   The remaining columns are *years*, meaning each row contains
    multiple observations instead of one observation per row.
-   There are percentage values mixed with numerical values, which may
    need standardization.

*3. Convert to Tidy Format*

We need to pivot the dataset from wide to long format using
`pivot_longer()`.

``` r
tidy_MMF_debt_data <- cleaned_MMF_debt_data %>%
  pivot_longer(
    cols = -c(DebtVariable, DebtType), # Keep category columns fixed
    names_to = "Year",
    values_to = "Value"
  ) %>%
  mutate(Year = as.integer(Year))  # Convert year from character to numeric if needed

> head(tidy_MMF_debt_data)
# A tibble: 6 × 4
#   DebtVariable                                    DebtType            Year Value
#   <chr>                                           <chr>              <int> <dbl>
# 1 Public External Debt Outstanding  ($US million) PublicExternalDebt  1998 19324
# 2 Public External Debt Outstanding  ($US million) PublicExternalDebt  1999 17548
# 3 Public External Debt Outstanding  ($US million) PublicExternalDebt  2000 16094
# 4 Public External Debt Outstanding  ($US million) PublicExternalDebt  2001 14110
# 5 Public External Debt Outstanding  ($US million) PublicExternalDebt  2002 13998
# 6 Public External Debt Outstanding  ($US million) PublicExternalDebt  2003 14360
```

*4. Separate Data Types*

Some rows represent monetary values, while others are percentages. If
necessary, we can split them into separate columns.

``` r
tidy_MMF_debt_data <- tidy_MMF_debt_data %>%
  mutate(ValueType = case_when(
    str_detect(DebtVariable, "%") ~ "Percentage",
    TRUE ~ "Amount"
  ))
  
head(tidy_MMF_debt_data)
# A tibble: 6 × 5
#   DebtVariable                                    DebtType            Year Value ValueType
#   <chr>                                           <chr>              <int> <dbl> <chr>    
# 1 Public External Debt Outstanding  ($US million) PublicExternalDebt  1998 19324 Amount   
# 2 Public External Debt Outstanding  ($US million) PublicExternalDebt  1999 17548 Amount   
# 3 Public External Debt Outstanding  ($US million) PublicExternalDebt  2000 16094 Amount   
# 4 Public External Debt Outstanding  ($US million) PublicExternalDebt  2001 14110 Amount   
# 5 Public External Debt Outstanding  ($US million) PublicExternalDebt  2002 13998 Amount   
# 6 Public External Debt Outstanding  ($US million) PublicExternalDebt  2003 14360 Amount   
```

These transformations ensures that:

-   Each row is now an observation (i.e., a specific `DebtVariable` in a
    `Year`).
-   The dataset is tidy with clear variables (`DebtVariable`,
    `DebtType`, `Year`, `Value`, and `ValueType`).
-   It is ready for analysis and visualization in R.

Plots, to be continued...

# Why tidy data

Why should you structure your datasets tidily before conducting
analyses?

1.  A consistent structure simplifies analysis

    -   Tidy data ensures that each column represents a variable, each
        row represents an observation, and each value has its own cell.
    -   This uniform structure makes it easier to apply transformations,
        summaries, and visualizations.

2.  Tidy datasets work optimally with R

    -   R’s base functions and the tidyverse ecosystem are designed to
        work seamlessly with tidy data, treating each column as a vector
        of values.
    -   Operations like filtering, grouping, and summarizing become
        straightforward and efficient.

*Example: Understanding Tidy Data Structure*

Consider the following tidy dataset (table1), which stores country-level
health data:

``` r
str(table1)
#> tibble [6 × 4] (S3: tbl_df/tbl/data.frame)
#>  $ country   : chr [1:6] "Afghanistan" "Afghanistan" "Brazil" "Brazil" ...
#>  $ year      : num [1:6] 1999 2000 1999 2000 1999 ...
#>  $ cases     : num [1:6] 745 2666 37737 80488 212258 ...
#>  $ population: num [1:6] 2.00e+07 2.06e+07 1.72e+08 1.75e+08 1.27e+09 ...
```

Each column represents a distinct variable (`country`, `year`, `cases`,
`population`). This allows R to treat them as vectors:

``` r
str(table1$country)
#>  chr [1:6] "Afghanistan" "Afghanistan" "Brazil" "Brazil" "China" "China"

str(table1$cases)
#>  num [1:6] 745 2666 37737 80488 212258 ...
```

Since each variable has its own column, we can easily calculate new
variables.

## Tidy vs. Untidy Data in Practice

Let’s compute infection rate per 10,000 people in a tidy dataset:

``` r
table1 %>% 
  mutate(rate = cases / population * 10000)
  
# A tibble: 6 × 5
#   country      year  cases population  rate
#   <chr>       <dbl>  <dbl>      <dbl> <dbl>
# 1 Afghanistan  1999    745   19987071 0.373
# 2 Afghanistan  2000   2666   20595360 1.29 
# 3 Brazil       1999  37737  172006362 2.19 
# 4 Brazil       2000  80488  174504898 4.61 
# 5 China        1999 212258 1272915272 1.67 
# 6 China        2000 213766 1280428583 1.67 
```

Why is `table2` Harder to Work With? Now, look at `table2`, which is
untidy:

``` r
#> # A tibble: 12 × 4
#>    country      year type            count
#>    <chr>       <dbl> <chr>           <dbl>
#>  1 Afghanistan  1999 cases             745
#>  2 Afghanistan  1999 population   19987071
#>  3 Afghanistan  2000 cases            2666
#>  4 Afghanistan  2000 population   20595360
#>  5 Brazil       1999 cases           37737
#>  6 Brazil       1999 population  172006362
#>  7 Brazil       2000 cases           80488
#>  8 Brazil       2000 population  174504898
#>  9 China        1999 cases          212258
#> 10 China        1999 population 1272915272
#> 11 China        2000 cases          213766
#> 12 China        2000 population 1280428583
```

*Problems in `table2`:*

-   The `type` column mixes two variables (`cases` and `population`),
    violating the one variable per column principle.
-   Each `country-year` spans multiple rows, making calculations
    difficult.
-   To compute the infection rate, we’d need to *pivot the data* before
    performing calculations.

> ***Key Takeaway*** Tidy data simplifies analysis. Each column should
> represent a single variable, and each row should represent a single
> observation. Tidy datasets integrate seamlessly with R functions,
> making calculations, visualizations, and modeling more intuitive.
> Untidy data increases complexity by requiring additional
> transformations before it can be analyzed.

By structuring data tidily from the outset, you’ll streamline your
workflow and avoid unnecessary complications in analysis.

### Caveat: But tidy data not always best

Datasets are often stored in an untidy structure rather than a tidy
structure when the untidy structure has a smaller file size than the
tidy structure

-   smaller file-size leads to faster processing time, which is very
    important for web applications (e.g., social media integration) and
    data visualizations (e.g., interactive maps)

# A Bit More Tidy Data Philosophy

## Rules for Storing Tidy Data

In addition to the core tidy data principles, there are several best
practices to follow when storing, entering, or restructuring data. These
rules will save time, reduce errors, and make data analysis more
efficient.

These principles were outlined in [“Data organization in
spreadsheets”](https://peerj.com/preprints/3183/) by Karl Broman and
Kara Woo, and they provide essential guidance for working with
structured data.

*Best Practices for Data Organization:*

✔ Be consistent ✔ Choose good names for things ✔ Write dates as
YYYY-MM-DD ✔ No empty cells ✔ Put just one thing in a cell ✔ Don’t use
font color or highlighting as data ✔ Save the data as plain text files

We’ll go through each of these in detail.

### Be consistent

Consistency in data entry minimizes errors and simplifies analysis.

-   Use the same coding scheme for categorical variables. For example:
    ✅ "male", "female" (consistent) ❌ "M", "Female", "fem"
    (inconsistent)
-   Maintain uniform variable names across datasets. If one dataset uses
    "ID", do not switch to "id" or "identifier" in another.
-   Avoid extra spaces, inconsistent abbreviations, or multiple ways of
    recording the same value.

*Example:*

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/009.png" alt="Be Consistent!" width="100%"/>

<p class="caption">

Be Consistent!

</p>
:::

### Choose Clear and Descriptive Names

Good variable names should be:

-   Short but meaningful (birth_year instead of date_of_birth)

-   Consistent (stick to snake_case or camelCase)

-   Free of spaces or special characters (first_name instead of "First
    Name")

*Example:*

✅ "doctor_visit_v1" (clear, consistent, versioned) ❌ "Doctor Visit 1"
(contains spaces)

div class="figure" style="text-align: center"\>
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/010.png" alt="Be Consistent!" width="100%"/>

<p class="caption">

Be Consistent!

</p>

</div>

#### underscore_naming_system vs. CamelCase

*CamelCase* is a method of writing compound words or phrases without
spaces, where each word starts with a capital letter. This formatting
style is widely used in programming, web URLs, and naming conventions in
computing. The term "CamelCase" comes from the resemblance of
capitalized letters to the humps of a camel’s back.

Use either underscores to separate words or CamelCase. *Never spaces!*

### Format Dates as YYYY-MM-DD

Dates should always follow the ISO 8601 format:

✅ 2025-01-28 (YYYY-MM-DD) ❌ 01/28/25 (ambiguous) ❌ 28-01-2025
(regional variation)

Why?

-   This format avoids confusion between regional date conventions
    (MM/DD/YYYY vs. DD/MM/YYYY).
-   Prevents spreadsheet software from misinterpreting dates as numbers
    or text.

*Example:*

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/011.png" alt="YYYY-MM-DD" width="100%"/>

<p class="caption">

YYYY-MM-DD

</p>
:::

### No empty cells

Every cell should contain data or an explicit `NA` for missing values.

-   Empty cells create ambiguity. Is the data missing? Should it be
    inferred from above?
-   If a date or category applies to multiple rows, repeat it instead of
    leaving blank spaces.

*Example:*

✅

ID Date Score 001 2024-01-15 90 002 2024-01-16 NA

❌

ID Date Score 001 2024-01-15 90 002

This spreadsheet does not follow the rules for tidy data. There is not a
single variable per column with a single entry per row. These data would
have to be reformatted before they could be used in analysis.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/012.png" alt="No empty cells" width="100%"/>

<p class="caption">

No empty cells

</p>
:::

### Put Just One Thing in a Cell

Each cell should contain one piece of data—never mix numbers with text.

-   Bad practice: "60 kg" (weight and unit combined)
-   Good practice: 60 (numeric column) + kg (separate column for units)

*Example:*

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/013.png" alt="One thing per cell" width="100%"/>

<p class="caption">

One thing per cell

</p>
:::

### Don’t Use Font Color or Highlighting as Data

Spreadsheet formatting (e.g., red text for errors) is not readable by R.
Instead:

-   Create a new column to flag issues (e.g., `outlier` = TRUE/FALSE).
-   Avoid manual formatting—-always store metadata explicitly.

*Example:*

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/014.png" alt="No highlighting or font color" width="100%"/>

<p class="caption">

No highlighting or font color

</p>
:::

### Save Data as Plain Text Files

The best file formats for long-term storage are:

✔ CSV (.csv) – widely supported, stores structured tabular data. ✔ TXT
(.txt) – simple text, readable by all systems. ✔ RDS (.rds) – ideal for
R-specific data storage.

Avoid proprietary formats: ❌ .xlsx, .xls (Excel formats) ❌ .sav, .dta
(SPSS, Stata formats)

⚠ Once data entry is complete, *NEVER manually edit the file*!

Perform all cleaning, transformations, and renaming in R using scripts.
This ensures reproducibility and prevents accidental data corruption.

### Summary

The data entry guidelines discussed in and a few additional rules have
been summarized below and are [available online for
reference](https://doi.org/10.7287/peerj.preprints.3139v5).

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/015.png" alt="Naming Guidelines" width="100%"/>

<p class="caption">

Naming Guidelines

</p>
:::

## Long vs. Wide Data: Choosing the Right Format

The structure of your dataset significantly affects how you manipulate,
analyze, and visualize data. Two commonly used formats are wide and
long, each suited for different tasks.

### Wide Format

In the wide format, multiple variables are spread across columns, often
with separate columns for different conditions, time points, or
categories.

*When to Use Wide Format:*

-   Easier for human readability, especially in spreadsheets.
-   Useful when each column represents a distinct measurement rather
    than repeated observations.
-   Preferred for reports or static summaries.

### Long Format

In the long format, each row represents a single observation with
separate columns for the variable name and its corresponding value.

When to Use Long Format

-   Preferred for data analysis and visualization in R, especially when
    using tidyverse packages.
-   Essential when working with repeated measures, time-series data, or
    grouped observations.
-   More flexible for functions that rely on structured relationships
    between variables.

#### Example Using R and Tidyverse

To illustrate these concepts, let's use a dataset included in R,
`mtcars`. This dataset is inherently in a wide format, where each row
represents a car, and the columns represent different attributes of
these cars, like `mpg` (miles per gallon), `cyl` (number of cylinders),
and so on.

First, we'll load the tidyverse package and then show how to pivot this
dataset between wide and long formats.

``` r
# Load the tidyverse package
library(tidyverse)

# View the first few rows of the mtcars dataset to understand its structure
head(mtcars)
#> # A tibble: 6 × 11
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
#> 2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
#> 3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
#> 4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
#> 5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
#> 6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

*Example: Reshaping Data in R*

To illustrate, we use the built-in `mtcars` dataset. By default,
`mtcars` is in a wide format, where each row represents a car, and
columns store different attributes like `mpg` (miles per gallon) and
`cyl` (cylinder count).

``` r
# View first few rows of the dataset
head(mtcars)
#                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
# Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
# Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

*Converting from Wide to Long Format*

We use `pivot_longer()` to gather multiple columns into two:

1.  `attribute`: The variable name (e.g., `mpg`, `cyl`, `disp`).
2.  `value`: The corresponding measurement for each car.

``` r
# Convert wide format to long format
mtcars_long <- mtcars %>%
  rownames_to_column(var = "car_name") %>%
  pivot_longer(cols = -car_name, names_to = "attribute", values_to = "value")

# View transformed data
head(mtcars_long)

# A tibble: 6 × 3
#   car_name  attribute  value
#   <chr>     <chr>      <dbl>
# 1 Mazda RX4 mpg        21   
# 2 Mazda RX4 cyl         6   
# 3 Mazda RX4 disp      160   
# 4 Mazda RX4 hp        110   
# 5 Mazda RX4 drat        3.9 
# 6 Mazda RX4 wt          2.62
```

Why is this useful?

-   Each row now represents a single observation (car-attribute pair).
-   This format makes it easier to group, filter, and analyze specific
    attributes.

*Converting from Long to Wide Format*

Conversely, `pivot_wider()` spreads a key-value pair across multiple
columns, restoring the original structure.

``` r
# Convert long format back to wide
mtcars_wide <- mtcars_long %>%
  pivot_wider(names_from = attribute, values_from = value)

# View restructured data
head(mtcars_wide)
# A tibble: 6 × 12
#   car_name            mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#   <chr>             <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1 Mazda RX4          21       6   160   110  3.9   2.62  16.5     0     1     4     4
# 2 Mazda RX4 Wag      21       6   160   110  3.9   2.88  17.0     0     1     4     4
# 3 Datsun 710         22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
# 4 Hornet 4 Drive     21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
# 5 Hornet Sportabout  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
# 6 Valiant            18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

> ***Key Takeaways***: *Wide format* is intuitive for human
> interpretation but less flexible for analysis. *Long format* aligns
> better with `tidyverse` functions and facilitates grouping, filtering,
> and plotting. Use `pivot_longer()` to reshape wide data into long
> format. Use `pivot_wider()` to restructure long data back into wide
> format.

By mastering these transformations, you ensure that your datasets are
structured optimally for both analysis and visualization.

### Conclusion

The structure of your dataset plays a fundamental role in data analysis,
influencing how easily you can manipulate, visualize, and extract
insights. The `tidyr` package in R's tidyverse provides intuitive and
efficient tools like `pivot_longer()` and `pivot_wider()` to reshape
data as needed. By mastering these transformations, you can ensure your
datasets are consistently formatted, making analysis more
straightforward, reproducible, and scalable.

# The Process of Tidying Data

## The Data Science Life Cycle

Now that we have a clear understanding of tidy data, it's essential to
situate it within the broader data science life cycle. As we touched on
earlier, this process begins with a question and progresses through
various stages to derive meaningful insights from data. This course
focuses on mastering the critical steps between formulating a question
and arriving at an answer.

Several models illustrate these intermediate steps, with one of the most
well-known being the version from [R for Data
Science](https://r4ds.had.co.nz/). This framework emphasizes the
importance of data import and tidying as foundational components of the
analysis pipeline. It also reflects the iterative nature of
visualization, transformation, and modeling—steps that often require
refining and revisiting before reaching a final conclusion.

::: {.figure style="text-align: center"}
<img src="https://jhudatascience.org/tidyversecourse/images/gslides/021.png" alt="Naming Guidelines" width="100%"/>

<p class="caption">

Naming Guidelines

</p>
:::

## Steps in tidying untidy data:

The process of tidying an untidy dataset follows a structured workflow:

1.  Diagnose the Problem

    -   Identify which principles of tidy data are violated.
    -   etermine the correct unit of analysis and what the variables and
        observations should be.

2.  Sketch the Expected Tidy Structure

    -   Before coding, outline what the cleaned dataset should look
        like. A simple diagram or table sketch can help.

3.  Transform the Data

    -   Use `tidyr` functions such as `pivot_longer()`, `pivot_wider()`,
        `separate()`, and `unite()` to convert the dataset into a tidy
        format.

## Common Causes of Untidy Data

Tidy datasets have a consistent structure, but untidy datasets can take
on various disorganized forms. Below are the most frequent issues
encountered when working with untidy data:

1.  Column Names Contain Data Values Instead of Variables

This occurs when a single variable is spread across multiple columns
rather than being stored in a single column.

*Example:*

``` r
table4b
#> # A tibble: 3 × 3
#>   country         `1999`     `2000`
#>   <chr>            <dbl>      <dbl>
#> 1 Afghanistan   19987071   20595360
#> 2 Brazil       172006362  174504898
#> 3 China       1272915272 1280428583
```

In this case, the years `1999` and `2000` should be a single column
(`year`), and population should be a separate variable.

2.  Observations Scattered Across Multiple Rows

Instead of each row representing a single observation, different
attributes are stored across multiple rows, making it difficult to
analyze.

*Example:*

``` r
table2
#> # A tibble: 12 × 4
#>    country      year type            count
#>    <chr>       <dbl> <chr>           <dbl>
#>  1 Afghanistan  1999 cases             745
#>  2 Afghanistan  1999 population   19987071
#>  3 Afghanistan  2000 cases            2666
#>  4 Afghanistan  2000 population   20595360
```

The variable `type` contains multiple attributes (`cases`, `population`)
rather than storing them as separate columns.

3.  Multiple Variables Stored in a Single Column

Sometimes, a column contains a combination of two variables instead of
separating them into distinct columns.

*Example:*

``` r
table3
#> # A tibble: 6 × 3
#>   country      year rate             
#>   <chr>       <dbl> <chr>            
#> 1 Afghanistan  1999 745/19987071     
#> 2 Afghanistan  2000 2666/20595360    
#> 3 Brazil       1999 37737/172006362  
#> 4 Brazil       2000 80488/174504898  
#> 5 China        1999 212258/1272915272
#> 6 China        2000 213766/1280428583
```

Here, `rate` is actually a combination of `cases` and popu\`lation,
which should be stored in separate columns.

4.  Variables Split into Multiple Columns

When a single variable is divided into multiple columns, it makes the
data harder to manipulate.

*Example:*

``` r
table5
#> # A tibble: 6 × 4
#>   country     century year  rate             
#>   <chr>       <chr>   <chr> <chr>            
#> 1 Afghanistan 19      99    745/19987071     
#> 2 Afghanistan 20      00    2666/20595360    
#> 3 Brazil      19      99    37737/172006362  
#> 4 Brazil      20      00    80488/174504898  
#> 5 China       19      99    212258/1272915272
#> 6 China       20      00    213766/1280428583
```

The `year` variable is split into two separate columns: `century` and
`year`, making it more cumbersome to work with.

# Final Thoughts

Tidying data is a critical skill for any data analyst or scientist.
Recognizing common patterns of untidy data and knowing how to
restructure them ensures smoother workflows, better analyses, and more
effective visualizations. Using tools from the `tidyverse`, particularly
`tidyr`, allows for seamless transformation of messy datasets into
structured, meaningful formats.

# Homework Assignment: Tidying and Transforming Data with Tidyverse

**Objective**: Apply the concepts of tidy data to transform and clean
datasets. This assignment will help you practice diagnosing untidy data,
reshaping datasets, and preparing data for analysis using the tidyverse
package in R.

**Instructions**

Setup: Make sure you have installed and loaded the `tidyverse`, `haven`,
and `labelled` packages. You might need to install the development
version of `tidyr` as described in the lecture.

**Dataset Selection**: Choose one of the following datasets for your
assignment. These datasets are available in R and are commonly used for
practice and teaching purposes:

`gapminder`: An excerpt of the Gapminder dataset, containing information
about global health and population trends. `storms`: Data on Atlantic
hurricanes and tropical storms.

## Task 1: Data Exploration

Load your selected dataset and use `glimpse()` to explore its structure.

Identify if the dataset is in a wide or long format and justify your
reasoning based on the principles of tidy data.

## Task 2: Identifying Untidiness

Highlight any aspects of the dataset that do not conform to the
principles of tidy data. This may involve variables stored in both rows
and columns, multiple variables stored in one column, or multiple types
of observational units in a single table.

## Task 3: Tidying the Data

Depending on the issues identified, use `pivot_longer()`,
`pivot_wider()`, `separate()`, or `unite()` functions from the `tidyr`
package to tidy the dataset.

Provide a brief explanation of your process and why it was necessary to
make these transformations.

## Task 4: Data Transformation and Summarization

Use `dplyr` functions such as `filter()`, `summarise()`, `group_by()`,
and `mutate()` to explore and summarize your tidied dataset.

Create at least one new variable that could be useful for analysis. For
example, calculate the mean GDP per capita for each continent in the
`gapminder` dataset, or average miles per gallon by cylinder type in the
`mpg` dataset.
