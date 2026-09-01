# Indian Vehicle Loan Credit Risk Analytics

## 📌 Project Overview

This project analyzes vehicle loan portfolio data to identify **customer credit risk, loan risk factors, geographic risk, operational risk, and monthly portfolio trends**.

The analysis combines **MySQL, Python, and Power BI** to transform raw vehicle-loan data into actionable insights that can support credit-risk monitoring and portfolio decision-making.

The project focuses on identifying patterns associated with **first-EMI loan default** and segmenting customers based on multiple risk indicators.

---

## 🎯 Business Objective

The primary objectives of this analysis are to:

- Measure overall loan portfolio performance and default rate
- Identify loan characteristics associated with higher default risk
- Analyze the impact of **Loan-to-Value (LTV)** on defaults
- Evaluate customer credit behaviour such as previous overdue and delinquency
- Analyze credit-score and credit-inquiry patterns
- Identify geographic and operational risk across states, branches, suppliers, and manufacturers
- Analyze monthly loan volume and default trends
- Segment customers into different risk categories
- Identify customers exhibiting multiple risk indicators

---

## 📊 Dataset

The project uses the **LTFS Vehicle Loan Default Prediction** dataset containing approximately **233K loan records and 41 features**.

The dataset contains information related to:

- Loan and asset characteristics
- Loan-to-Value (LTV)
- Customer credit history
- Previous overdue accounts
- Recent delinquency
- Credit inquiries
- Employment type
- Branch and supplier information
- Manufacturer information
- Geographic information
- Loan default outcome

### Target Variable

`loan_default`

- `0` → No first-EMI default
- `1` → First-EMI default

> The original raw dataset (`train.csv`) is not included in this repository. It can be obtained from the original dataset source and placed in the `data/` directory.

The processed analytical dataset used for SQL analysis and Power BI is included in the repository.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** | Data exploration, cleaning, feature engineering and risk analysis |
| **MySQL** | Business-oriented SQL analysis and segmentation |
| **Power BI** | Interactive dashboard and visualization |
| **Jupyter Notebook** | Python analysis workflow |
| **Git & GitHub** | Version control and project documentation |

---

# 🔄 Analytical Workflow

```text
Raw Vehicle Loan Dataset
          ↓
   Python Exploration
          ↓
 Data Quality Checks
          ↓
 Data Cleaning
          ↓
 Feature Engineering
          ↓
 Risk Segmentation
          ↓
   Processed Dataset
          ↓
      MySQL Analysis
          ↓
     Power BI Dashboard
          ↓
 Business Risk Insights