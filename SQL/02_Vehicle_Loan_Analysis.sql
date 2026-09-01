-- ============================================================
-- VEHICLE LOAN DEFAULT ANALYSIS
-- ============================================================

USE vehicle_loan_risk;


-- ============================================================
-- 1. PORTFOLIO OVERVIEW
-- ============================================================

-- 1.1 Verify the analytical dataset

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT UniqueID) AS unique_customers
FROM loan_data;


-- 1.2 Overall Portfolio KPIs

SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT UniqueID) AS unique_customers,
    SUM(disbursed_amount) AS total_disbursed_amount,
    ROUND(AVG(disbursed_amount), 2) AS average_loan_amount,
    ROUND(AVG(ltv), 2) AS average_ltv,
    SUM(loan_default) AS total_defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data;


-- 1.3 Loan Default Distribution

SELECT
    loan_default,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY loan_default
ORDER BY loan_default;

-- ============================================================
-- 2. LOAN & LTV ANALYSIS
-- ============================================================

-- 2.1 Default Rate by Loan Amount Band

SELECT
    Loan_Amount_Band,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Loan_Amount_Band
ORDER BY default_rate DESC;


-- 2.2 Default Rate by LTV Band

SELECT
    LTV_Band,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY LTV_Band
ORDER BY default_rate DESC;


-- 2.3 Average Loan Amount and LTV by Default Status

SELECT
    loan_default,
    COUNT(*) AS total_loans,
    ROUND(AVG(disbursed_amount), 2) AS average_loan_amount,
    ROUND(AVG(ltv), 2) AS average_ltv
FROM loan_data
GROUP BY loan_default
ORDER BY loan_default;


-- 2.4 High LTV vs Lower LTV

SELECT
    CASE
        WHEN ltv >= 80 THEN 'High LTV (80%+)'
        ELSE 'Lower LTV (<80%)'
    END AS LTV_Risk_Group,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY LTV_Risk_Group
ORDER BY default_rate DESC;

-- ============================================================
-- 3. CUSTOMER CREDIT BEHAVIOUR ANALYSIS
-- ============================================================

-- 3.1 Default Rate by Previous Overdue History

SELECT
    Has_Previous_Overdue,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Has_Previous_Overdue
ORDER BY default_rate DESC;


-- 3.2 Default Rate by Recent Delinquency

SELECT
    Recent_Delinquency,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Recent_Delinquency
ORDER BY default_rate DESC;


-- 3.3 Default Rate by Credit History

SELECT
    Has_Credit_History,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Has_Credit_History
ORDER BY default_rate DESC;


-- 3.4 Default Rate by Number of Credit Inquiries

SELECT
    `NO.OF_INQUIRIES`,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY `NO.OF_INQUIRIES`
HAVING COUNT(*) >= 100
ORDER BY `NO.OF_INQUIRIES`;


-- 3.5 Default Rate by Number of Previous Accounts

SELECT
    `PRI.NO.OF.ACCTS`,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY `PRI.NO.OF.ACCTS`
HAVING COUNT(*) >= 500
ORDER BY `PRI.NO.OF.ACCTS`;

-- ============================================================
-- 04. GEOGRAPHICAL ANALYSIS
-- ============================================================

-- 4.1 Default Rate by State
SELECT
    State_ID,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY State_ID
ORDER BY default_rate DESC;

-- ============================================================
-- 05. OPERATIONAL ANALYSIS
-- ============================================================

-- 5.1 Branch-Level Risk
SELECT
    branch_id,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY branch_id
HAVING COUNT(*) >= 500
ORDER BY default_rate DESC;


-- 5.2 Supplier-Level Risk
SELECT
    supplier_id,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY supplier_id
HAVING COUNT(*) >= 500
ORDER BY default_rate DESC
LIMIT 15;


-- 5.3 Supplier Risk vs Overall Portfolio
SELECT
    supplier_id,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate,
    ROUND((AVG(loan_default) - 0.2171) * 100, 2) AS vs_portfolio_pp
FROM loan_data
GROUP BY supplier_id
HAVING COUNT(*) >= 500
ORDER BY default_rate DESC
LIMIT 15;


-- 5.4 Manufacturer-Level Risk
SELECT
    manufacturer_id,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY manufacturer_id
ORDER BY default_rate DESC;

-- ============================================================
-- 06. RISK SEGMENTATION
-- ============================================================

-- 6.1 Customer Risk Category
SELECT
    Risk_Category,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loan_data),
        2
    ) AS portfolio_share
FROM loan_data
GROUP BY Risk_Category
ORDER BY default_rate DESC;

-- ============================================================
-- 07. MONTHLY PORTFOLIO PERFORMANCE
-- ============================================================

-- 7.1 Monthly Default Rate
SELECT
    DATE_FORMAT(STR_TO_DATE(DisbursalDate, '%Y-%m-%d'), '%Y-%m') AS disbursal_month,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY disbursal_month
ORDER BY disbursal_month;


-- 7.2 Monthly Disbursed Amount
SELECT
    DATE_FORMAT(STR_TO_DATE(DisbursalDate, '%Y-%m-%d'), '%Y-%m') AS disbursal_month,
    SUM(disbursed_amount) AS total_disbursed,
    ROUND(AVG(disbursed_amount), 2) AS average_loan_amount
FROM loan_data
GROUP BY disbursal_month
ORDER BY disbursal_month;


-- 7.3 Monthly Default Count and Portfolio Share
SELECT
    DATE_FORMAT(STR_TO_DATE(DisbursalDate, '%Y-%m-%d'), '%Y-%m') AS disbursal_month,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loan_data),
        2
    ) AS portfolio_share,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY disbursal_month
ORDER BY disbursal_month;


-- 7.4 Monthly Loan Size vs Default
SELECT
    DATE_FORMAT(STR_TO_DATE(DisbursalDate, '%Y-%m-%d'), '%Y-%m') AS disbursal_month,
    loan_default,
    COUNT(*) AS total_loans,
    ROUND(AVG(disbursed_amount), 2) AS average_loan_amount,
    ROUND(AVG(ltv), 2) AS average_ltv
FROM loan_data
GROUP BY disbursal_month, loan_default
ORDER BY disbursal_month, loan_default;

-- ============================================================
-- 08. EMPLOYMENT ANALYSIS
-- ============================================================

-- ============================================================
-- 08. EMPLOYMENT ANALYSIS
-- ============================================================

-- 8.1 Employment Type vs Average Loan Amount
SELECT
    `Employment.Type`,
    COUNT(*) AS total_loans,
    ROUND(AVG(disbursed_amount), 2) AS average_loan_amount,
    ROUND(AVG(ltv), 2) AS average_ltv,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY `Employment.Type`
ORDER BY default_rate DESC;


-- 8.2 Employment Type vs LTV Risk
SELECT
    `Employment.Type`,
    LTV_Band,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY `Employment.Type`, LTV_Band
ORDER BY `Employment.Type`, default_rate DESC;

-- ============================================================
-- 09. CREDIT SCORE ANALYSIS
-- ============================================================

-- 9.1 Default Rate by Credit Score
SELECT
    `PERFORM_CNS.SCORE`,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY `PERFORM_CNS.SCORE`
HAVING COUNT(*) >= 500
ORDER BY default_rate DESC;


-- 9.2 Credit Score Band vs Default Rate
SELECT
    CASE
        WHEN `PERFORM_CNS.SCORE` = 0
            THEN 'No Credit History'
        WHEN `PERFORM_CNS.SCORE` < 500
            THEN 'Low Score (<500)'
        WHEN `PERFORM_CNS.SCORE` < 700
            THEN 'Medium Score (500-699)'
        ELSE 'High Score (700+)'
    END AS Credit_Score_Band,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Credit_Score_Band
ORDER BY default_rate DESC;



-- 9.3 Credit History vs Risk Category
SELECT
    Has_Credit_History,
    Risk_Category,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Has_Credit_History, Risk_Category
ORDER BY Has_Credit_History, default_rate DESC;

-- ============================================================
-- 10. ADVANCED RISK ANALYSIS
-- ============================================================

-- 10.1 LTV Risk vs Previous Overdue
SELECT
    LTV_Band,
    Has_Previous_Overdue,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY LTV_Band, Has_Previous_Overdue
ORDER BY default_rate DESC;


-- 10.2 LTV Risk vs Recent Delinquency
SELECT
    LTV_Band,
    Recent_Delinquency,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY LTV_Band, Recent_Delinquency
ORDER BY default_rate DESC;


-- 10.3 Loan Amount Band vs Previous Overdue
SELECT
    Loan_Amount_Band,
    Has_Previous_Overdue,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY Loan_Amount_Band, Has_Previous_Overdue
ORDER BY default_rate DESC;


-- 10.4 Risk Category × LTV Band

SELECT
    Risk_Category,
    LTV_Band,
    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate
FROM loan_data
GROUP BY
    Risk_Category,
    LTV_Band
HAVING COUNT(*) >= 500
ORDER BY
    Risk_Category,
    default_rate DESC;


-- ============================================================
-- 11. CUSTOMER RISK PROFILING & RANKING
-- ============================================================

-- 11.1 Default Rate by Number of Risk Indicators

SELECT
    (
        CASE WHEN ltv >= 80 THEN 1 ELSE 0 END +
        CASE WHEN Has_Previous_Overdue = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN Recent_Delinquency = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN `NO.OF_INQUIRIES` >= 2 THEN 1 ELSE 0 END
    ) AS risk_indicator_count,

    COUNT(*) AS total_loans,
    SUM(loan_default) AS defaults,
    ROUND(AVG(loan_default) * 100, 2) AS default_rate

FROM loan_data

GROUP BY risk_indicator_count

ORDER BY risk_indicator_count;


-- 11.2 Identify customers with multiple risk indicators
SELECT
    UniqueID,
    ltv,
    LTV_Band,
    Has_Previous_Overdue,
    Recent_Delinquency,
    `NO.OF_INQUIRIES`,
    Risk_Score,
    Risk_Category,
    loan_default,
    (
        CASE WHEN ltv >= 80 THEN 1 ELSE 0 END +
        CASE WHEN Has_Previous_Overdue = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN Recent_Delinquency = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN `NO.OF_INQUIRIES` >= 2 THEN 1 ELSE 0 END
    ) AS risk_indicator_count
FROM loan_data
ORDER BY risk_indicator_count DESC, Risk_Score DESC
LIMIT 100;


-- 11.3 High-risk customers who actually defaulted
SELECT
    UniqueID,
    disbursed_amount,
    ltv,
    LTV_Band,
    Has_Previous_Overdue,
    Recent_Delinquency,
    `NO.OF_INQUIRIES`,
    Risk_Score,
    Risk_Category,
    loan_default
FROM loan_data
WHERE Risk_Category IN ('High', 'Very High')
  AND loan_default = 1
ORDER BY Risk_Score DESC
LIMIT 100;


-- 11.4 High-risk customers with high LTV
SELECT
    UniqueID,
    disbursed_amount,
    asset_cost,
    ltv,
    LTV_Band,
    Risk_Score,
    Risk_Category,
    Has_Previous_Overdue,
    Recent_Delinquency,
    loan_default
FROM loan_data
WHERE ltv >= 80
  AND Risk_Category IN ('High', 'Very High')
ORDER BY Risk_Score DESC
LIMIT 100;