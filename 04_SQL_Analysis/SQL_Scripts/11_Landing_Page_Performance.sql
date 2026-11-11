-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Landing Page Performance

WITH First_Page AS
(
    SELECT
        website_session_id,
        pageview_url AS Landing_Page,

        ROW_NUMBER() OVER
        (
            PARTITION BY website_session_id
            ORDER BY created_at, website_pageview_id
        ) AS Page_Rank

    FROM dbo.website_pageviews
),

Landing_Page_Summary AS
(
    SELECT
        f.Landing_Page,

        COUNT(DISTINCT f.website_session_id) AS Total_Sessions,

        COUNT(DISTINCT o.order_id) AS Total_Orders,

        CAST(
            COUNT(DISTINCT o.order_id) * 100.0 /
            NULLIF(COUNT(DISTINCT f.website_session_id), 0)
            AS DECIMAL(10,2)
        ) AS Conversion_Rate,

        CAST(
            COALESCE(SUM(o.price_usd), 0)
            AS DECIMAL(18,2)
        ) AS Total_Revenue

    FROM First_Page f

    LEFT JOIN dbo.orders o
        ON f.website_session_id = o.website_session_id

    WHERE f.Page_Rank = 1

    GROUP BY f.Landing_Page
)

SELECT *
FROM Landing_Page_Summary
ORDER BY Total_Sessions DESC;
