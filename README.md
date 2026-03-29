# Credit Risk Portfolio Analysis (R)

End-to-end credit risk portfolio analysis using **R**.  
This project demonstrates data cleaning, feature engineering, KPI development, and risk segmentation for a consumer lending portfolio.

The goal is to simulate a simplified **credit risk analysis workflow** similar to what a data analyst might perform in a financial institution.

---

## Project Structure

```
credit-risk-portfolio-analysis-r

data/
    Raw dataset used for analysis

scripts/
    R script containing the full analysis pipeline

figures/
    Folder where generated visualizations are saved when running the script

outputs/
    Folder where summary tables and KPIs are exported

README.md
    Project documentation

LICENSE
    MIT License
```


Note:  
`figures` and `outputs` are generated automatically when the script is executed.

---

## Dataset

Source: https://gist.github.com/eversonm/3d2b3cf0cd4b3c93f906377bba8f989c

Note: This dataset is publicly available and commonly used for educational purposes in credit risk modeling and data analysis projects.

The dataset contains borrower and loan characteristics, including:

- Borrower age
- Income
- Employment length
- Loan amount
- Interest rate
- Loan purpose
- Loan grade
- Historical default indicator

Target variable:

**loan_status**

1 = default
0 = non-default


---

## Analysis Pipeline

The project follows a structured workflow:

### 1. Reproducibility setup
Ensures consistent results by setting a seed and loading required packages.

### 2. Data loading
The dataset is loaded and column names are standardized.

### 3. Data quality checks
Missing values are identified and handled.

### 4. Feature engineering
New analytical variables are created:

- **Loan-to-Income Ratio**
- **Income Buckets**
- **Loan-to-Income Risk Buckets**

### 5. Portfolio KPIs
Key risk indicators are calculated:

- Total loans
- Portfolio default rate
- Default rate by income segment
- Default rate by debt burden

### 6. Risk segmentation
Borrowers are segmented based on income and debt levels to identify high-risk segments.

### 7. Visualization
Graphs are automatically generated to illustrate default patterns across segments.

### 8. Validation
Basic checks ensure that the analysis runs correctly and produces valid outputs.

---

## Example Insights

The analysis allows us to observe patterns such as:

- Higher **loan-to-income ratios** are associated with increased default risk
- Lower income segments tend to show **higher default rates**
- Portfolio segmentation can reveal borrower groups with elevated credit risk

These types of insights are commonly used in **credit portfolio monitoring and risk management**.

---

## How to Run the Project

1. Clone the repository


```
git clone https://github.com/sebastiansolanor1-alt/credit-risk-portfolio-analysis-r.git
```


2. Open the project in **RStudio**

3. Run the script:


```
scripts/credit_risk_analysis.R
```


4. The script will automatically generate:


```
figures/
    default_rate_by_income.png
    default_rate_by_lti.png

outputs/
    portfolio_kpi.csv
    kpi_default_by_income.csv
    kpi_default_by_lti.csv
    missing_values_summary.csv
```

---

## License

This project is licensed under the **MIT License**.

---

## Author

Sebastian Solano  

*Economist & Data Analyst* [LinkedIn](https://www.linkedin.com/in/sebastian-solanor1/) | [Portfolio](https://github.com/sebastian-solanor1)
