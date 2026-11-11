-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Conversion Funnel Drop-off Analysis

WITH Session_Journey AS
(
    SELECT
        website_session_id,

        MAX(CASE WHEN pageview_url = '/products'
            THEN 1 ELSE 0 END) AS Viewed_Product_List,

        MAX(CASE WHEN pageview_url LIKE '/the-%'
            THEN 1 ELSE 0 END) AS Viewed_Product_Detail,

        MAX(CASE WHEN pageview_url = '/cart'
            THEN 1 ELSE 0 END) AS Viewed_Cart,

        MAX(CASE WHEN pageview_url = '/shipping'
            THEN 1 ELSE 0 END) AS Viewed_Shipping,

        MAX(CASE WHEN pageview_url IN ('/billing', '/billing-2')
            THEN 1 ELSE 0 END) AS Viewed_Billing,

        MAX(CASE WHEN pageview_url = '/thank-you-for-your-order'
            THEN 1 ELSE 0 END) AS Completed_Purchase

    FROM dbo.website_pageviews
    GROUP BY website_session_id
),

Funnel_Counts AS
(
    SELECT
        (SELECT COUNT(*) FROM dbo.website_sessions) AS Total_Sessions,
        SUM(Viewed_Product_List) AS Product_List,
        SUM(Viewed_Product_Detail) AS Product_Detail,
        SUM(Viewed_Cart) AS Cart,
        SUM(Viewed_Shipping) AS Shipping,
        SUM(Viewed_Billing) AS Billing,
        SUM(Completed_Purchase) AS Purchase
    FROM Session_Journey
),

Funnel_Stages AS
(
    SELECT 0 AS Stage_Order, 'Total Sessions' AS Funnel_Stage,
           Total_Sessions AS Sessions FROM Funnel_Counts

    UNION ALL
    SELECT 1, 'Product Listing', Product_List FROM Funnel_Counts

    UNION ALL
    SELECT 2, 'Product Detail', Product_Detail FROM Funnel_Counts

    UNION ALL
    SELECT 3, 'Cart', Cart FROM Funnel_Counts

    UNION ALL
    SELECT 4, 'Shipping', Shipping FROM Funnel_Counts

    UNION ALL
    SELECT 5, 'Billing', Billing FROM Funnel_Counts

    UNION ALL
    SELECT 6, 'Completed Purchase', Purchase FROM Funnel_Counts
)

SELECT
    Funnel_Stage,
    Sessions,
    LAG(Sessions) OVER (ORDER BY Stage_Order) AS Previous_Stage_Sessions,

    CAST(
        Sessions * 100.0 /
        NULLIF(LAG(Sessions) OVER (ORDER BY Stage_Order), 0)
        AS DECIMAL(10,2)
    ) AS Stage_Conversion_Rate,

    CAST(
        100.0 - Sessions * 100.0 /
        NULLIF(LAG(Sessions) OVER (ORDER BY Stage_Order), 0)
        AS DECIMAL(10,2)
    ) AS Stage_Dropoff_Rate

FROM Funnel_Stages
ORDER BY Stage_Order;
