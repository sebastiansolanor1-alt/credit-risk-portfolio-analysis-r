#############################################
# CREDIT RISK PORTFOLIO ANALYSIS
# Author: Sebastian Solano
# Purpose: Exploratory credit risk analysis
#############################################

# =========================================
# 1. REPRODUCIBILITY SETUP
# =========================================

rm(list = ls())
set.seed(123)

# Required packages
required_packages <- c(
  "tidyverse",
  "janitor",
  "scales"
)

# Install missing packages automatically
installed <- required_packages %in% rownames(installed.packages())

if (any(installed == FALSE)) {
  install.packages(required_packages[!installed])
}

lapply(required_packages, library, character.only = TRUE)

# =========================================
# 2. PROJECT ROOT DETECTION
# =========================================

if (!require("here")) install.packages("here")
library(here)

data_path    <- here("data", "credit_risk_dataset.csv")
figures_path <- here("figures")
outputs_path <- here("outputs")

dir.create(figures_path, showWarnings = FALSE)
dir.create(outputs_path, showWarnings = FALSE)

# =========================================
# 3. LOAD DATA
# =========================================

if (!file.exists(data_path)) {
  stop("Dataset not found. Please place credit_risk_dataset.csv inside the data/ folder.")
}

credit <- read_csv(
  data_path,
  show_col_types = FALSE
) %>%
  clean_names()

glimpse(credit)

# =========================================
# 4. DATA QUALITY CHECKS
# =========================================

# Missing values summary
na_summary <- credit %>%
  summarise(across(everything(), ~sum(is.na(.))))

write_csv(
  na_summary,
  file.path(outputs_path, "missing_values_summary.csv")
)

# Replace missing employment length
# Keep numeric type (important for analysis)
credit <- credit %>%
  mutate(
    person_emp_length = replace_na(person_emp_length, -1)
  )

# =========================================
# 5. FEATURE ENGINEERING
# =========================================

# Loan-to-income ratio
credit <- credit %>%
  mutate(
    loan_to_income = loan_amnt / person_income,
    
    lti_bucket = case_when(
      loan_to_income < 0.10 ~ "<10%",
      loan_to_income < 0.20 ~ "10–20%",
      loan_to_income < 0.30 ~ "20–30%",
      TRUE ~ ">30%"
    ),
    
    lti_bucket = factor(
      lti_bucket,
      levels = c("<10%", "10–20%", "20–30%", ">30%")
    )
  )

# Income segmentation
credit <- credit %>%
  mutate(
    income_bucket = case_when(
      person_income < 30000 ~ "<30K",
      person_income < 60000 ~ "30K–60K",
      person_income < 100000 ~ "60K–100K",
      TRUE ~ ">100K"
    ),
    income_bucket = factor(
      income_bucket,
      levels = c("<30K", "30K–60K", "60K–100K", ">100K")
    )
  )

# =========================================
# 6. KPI CALCULATIONS
# =========================================

# Overall portfolio KPI
portfolio_kpi <- credit %>%
  summarise(
    total_loans = n(),
    default_rate = mean(loan_status == 1)
  )

write_csv(
  portfolio_kpi,
  file.path(outputs_path, "portfolio_kpi.csv")
)

# KPI by income
kpi_income <- credit %>%
  group_by(income_bucket) %>%
  summarise(
    total_loans = n(),
    default_rate = mean(loan_status == 1)
  )

write_csv(
  kpi_income,
  file.path(outputs_path, "kpi_default_by_income.csv")
)

# KPI by loan-to-income
kpi_lti <- credit %>%
  group_by(lti_bucket) %>%
  summarise(
    total_loans = n(),
    default_rate = mean(loan_status == 1)
  )

write_csv(
  kpi_lti,
  file.path(outputs_path, "kpi_default_by_lti.csv")
)

# =========================================
# 7. VISUALIZATIONS
# =========================================

# --- Default rate by income segment

p_income <- ggplot(
  kpi_income,
  aes(x = income_bucket, y = default_rate, fill = default_rate)
) +
  geom_col() +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_gradient(low = "lightblue", high = "red") +
  labs(
    title = "Default Rate by Income Segment",
    subtitle = "Lower income segments show higher default risk",
    x = "Annual Income",
    y = "Default Rate"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(
  filename = file.path(figures_path, "default_rate_by_income.png"),
  plot = p_income,
  width = 7,
  height = 5,
  dpi = 300
)

# --- Default rate by Loan-to-Income ratio

p_lti <- ggplot(
  kpi_lti,
  aes(x = lti_bucket, y = default_rate, fill = default_rate)
) +
  geom_col() +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_gradient(low = "lightblue", high = "red") +
  labs(
    title = "Default Rate by Loan-to-Income Ratio",
    subtitle = "Higher debt burden is associated with higher default risk",
    x = "Loan-to-Income Ratio",
    y = "Default Rate"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave(
  filename = file.path(figures_path, "default_rate_by_lti.png"),
  plot = p_lti,
  width = 7,
  height = 5,
  dpi = 300
)

# =========================================
# 8. FINAL VALIDATION
# =========================================

stopifnot(
  nrow(credit) > 0,
  all(!is.na(credit$loan_status))
)

cat("====================================\n")
cat("Credit Risk Analysis Completed\n")
cat("Figures saved in /figures\n")
cat("Tables saved in /outputs\n")
cat("====================================\n")

getwd()
ls()

