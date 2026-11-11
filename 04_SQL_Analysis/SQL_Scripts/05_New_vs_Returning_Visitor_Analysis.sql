-- Project: Maven Fuzzy Factory Analytics
-- Analysis: New vs Returning Customer Performance

SELECT
    CASE
        WHEN s.is_repeat_session = 1
            THEN 'Returning Visitors'
        ELSE 'New Visitors'
    END AS Visitor_Type,

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
    ) AS Total_Revenue

FROM dbo.vw_website_sessions_clean s

LEFT JOIN dbo.orders o
    ON s.website_session_id = o.website_session_id

GROUP BY
    s.is_repeat_session

ORDER BY
    Total_Revenue DESC;
