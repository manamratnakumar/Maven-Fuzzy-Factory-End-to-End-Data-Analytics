-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Product Performance Analysis

SELECT
    p.product_id,
    p.product_name,

    COUNT(DISTINCT oi.order_id) AS Total_Orders,

    SUM(oi.is_primary_item) AS Primary_Items_Sold,

    CAST(SUM(oi.price_usd) AS DECIMAL(18,2))
        AS Total_Revenue,

    CAST(SUM(oi.cogs_usd) AS DECIMAL(18,2))
        AS Total_COGS,

    CAST(
        SUM(oi.price_usd) - SUM(oi.cogs_usd)
        AS DECIMAL(18,2)
    ) AS Total_Profit

FROM dbo.order_items oi

INNER JOIN dbo.products p
    ON oi.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    Total_Revenue DESC;
