-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Marketing Campaign Performance

SELECT
    COALESCE(s.utm_source, 'Unattributed / No UTM') AS Marketing_Source,
    COALESCE(s.utm_campaign, 'Unattributed') AS Marketing_Campaign,

    COUNT(DISTINCT s.website_session_id) AS Total_Sessions,

    COUNT(DISTINCT o.order_id) AS Total_Orders,

    CAST(
        COUNT(DISTINCT o.order_id) * 100.0 /
        NULLIF(COUNT(DISTINCT s.website_session_id), 0)
        AS DECIMAL(10,2)
    ) AS Conversion_Rate,

    CAST(
        COALESCE(SUM(o.price_usd), 0)
        AS DECIMAL(18,2)
    ) AS Total_Revenue,

    CAST(
        COALESCE(SUM(o.price_usd), 0) /
        NULLIF(COUNT(DISTINCT o.order_id), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value

FROM dbo.vw_website_sessions_clean s

LEFT JOIN dbo.orders o
    ON s.website_session_id = o.website_session_id

GROUP BY
    COALESCE(s.utm_source, 'Unattributed / No UTM'),
    COALESCE(s.utm_campaign, 'Unattributed')

ORDER BY
    Total_Revenue DESC;
