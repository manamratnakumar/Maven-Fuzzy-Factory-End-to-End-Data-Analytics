-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Website Conversion Funnel

WITH Session_Funnel AS
(
    SELECT
        website_session_id,

        MAX(CASE
            WHEN pageview_url = '/products'
            THEN 1 ELSE 0
        END) AS Viewed_Products,

        MAX(CASE
            WHEN pageview_url IN (
                '/the-original-mr-fuzzy',
                '/the-forever-love-bear',
                '/the-birthday-sugar-panda',
                '/the-hudson-river-mini-bear'
            )
            THEN 1 ELSE 0
        END) AS Viewed_Product_Detail,

        MAX(CASE
            WHEN pageview_url = '/cart'
            THEN 1 ELSE 0
        END) AS Viewed_Cart,

        MAX(CASE
            WHEN pageview_url = '/shipping'
            THEN 1 ELSE 0
        END) AS Viewed_Shipping,

        MAX(CASE
            WHEN pageview_url IN ('/billing', '/billing-2')
            THEN 1 ELSE 0
        END) AS Viewed_Billing,

        MAX(CASE
            WHEN pageview_url = '/thank-you-for-your-order'
            THEN 1 ELSE 0
        END) AS Completed_Purchase

    FROM dbo.website_pageviews
    GROUP BY website_session_id
)

SELECT
    COUNT(*) AS Total_Sessions,

    SUM(Viewed_Products) AS Product_List_Sessions,

    SUM(Viewed_Product_Detail) AS Product_Detail_Sessions,

    SUM(Viewed_Cart) AS Cart_Sessions,

    SUM(Viewed_Shipping) AS Shipping_Sessions,

    SUM(Viewed_Billing) AS Billing_Sessions,

    SUM(Completed_Purchase) AS Purchase_Sessions

FROM Session_Funnel;
