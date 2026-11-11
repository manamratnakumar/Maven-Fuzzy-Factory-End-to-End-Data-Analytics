-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Monthly Customer Cohort Retention

WITH Customer_First_Order AS
(
    SELECT
        user_id,
        MIN(created_at) AS First_Order_Date
    FROM dbo.orders
    GROUP BY user_id
),

Customer_Cohorts AS
(
    SELECT
        user_id,
        DATEFROMPARTS(
            YEAR(First_Order_Date),
            MONTH(First_Order_Date),
            1
        ) AS Cohort_Month
    FROM Customer_First_Order
),

Customer_Activity AS
(
    SELECT DISTINCT
        o.user_id,
        c.Cohort_Month,
        DATEFROMPARTS(
            YEAR(o.created_at),
            MONTH(o.created_at),
            1
        ) AS Activity_Month
    FROM dbo.orders o
    INNER JOIN Customer_Cohorts c
        ON o.user_id = c.user_id
),

Cohort_Retention AS
(
    SELECT
        Cohort_Month,
        DATEDIFF(
            MONTH,
            Cohort_Month,
            Activity_Month
        ) AS Cohort_Index,
        COUNT(DISTINCT user_id) AS Retained_Customers
    FROM Customer_Activity
    GROUP BY
        Cohort_Month,
        DATEDIFF(MONTH, Cohort_Month, Activity_Month)
),

Cohort_Size AS
(
    SELECT
        Cohort_Month,
        COUNT(DISTINCT user_id) AS Total_Customers
    FROM Customer_Cohorts
    GROUP BY Cohort_Month
)

SELECT
    r.Cohort_Month,
    r.Cohort_Index,
    s.Total_Customers,
    r.Retained_Customers,

    CAST(
        r.Retained_Customers * 100.0 /
        NULLIF(s.Total_Customers, 0)
        AS DECIMAL(10,2)
    ) AS Retention_Rate

FROM Cohort_Retention r
INNER JOIN Cohort_Size s
    ON r.Cohort_Month = s.Cohort_Month

ORDER BY
    r.Cohort_Month,
    r.Cohort_Index;
