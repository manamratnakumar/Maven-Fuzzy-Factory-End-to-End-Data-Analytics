-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Monthly Revenue and Orders Trend

SELECT
    YEAR(created_at) AS Order_Year,
    MONTH(created_at) AS Order_Month,
    COUNT(DISTINCT order_id) AS Total_Orders,
    SUM(price_usd) AS Total_Revenue,
    AVG(price_usd) AS Average_Order_Value
FROM dbo.orders
GROUP BY
    YEAR(created_at),
    MONTH(created_at)
ORDER BY
    Order_Year,
    Order_Month;
