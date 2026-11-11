-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Customer Purchasing and Repeat-Order Behavior

WITH Customer_Summary AS
(
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS Total_Orders,
        SUM(price_usd) AS Total_Revenue
    FROM dbo.orders
    GROUP BY user_id
),

Customer_Segments AS
(
    SELECT
        CASE
            WHEN Total_Orders = 1 THEN 'One-Time Customers'
            ELSE 'Repeat Customers'
        END AS Customer_Type,

        COUNT(*) AS Total_Customers,
        SUM(Total_Orders) AS Total_Orders,
        SUM(Total_Revenue) AS Total_Revenue
    FROM Customer_Summary
    GROUP BY
        CASE
            WHEN Total_Orders = 1 THEN 'One-Time Customers'
            ELSE 'Repeat Customers'
        END
)

SELECT
    Customer_Type,
    Total_Customers,
    Total_Orders,

    CAST(Total_Revenue AS DECIMAL(18,2)) AS Total_Revenue,

    CAST(
        Total_Revenue / NULLIF(Total_Customers, 0)
        AS DECIMAL(18,2)
    ) AS Revenue_Per_Customer,

    CAST(
        Total_Orders * 1.0 / NULLIF(Total_Customers, 0)
        AS DECIMAL(10,2)
    ) AS Orders_Per_Customer

FROM Customer_Segments
ORDER BY Total_Revenue DESC;
