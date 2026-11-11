-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Product Refund Analysis

WITH Refund_Summary AS
(
    SELECT
        order_item_id,
        SUM(refund_amount_usd) AS Refund_Amount
    FROM dbo.order_item_refunds
    GROUP BY order_item_id
)

SELECT
    p.product_id,
    p.product_name,

    COUNT(DISTINCT oi.order_item_id) AS Total_Items_Sold,

    COUNT(DISTINCT r.order_item_id) AS Refunded_Items,

    CAST(
        COUNT(DISTINCT r.order_item_id) * 100.0 /
        NULLIF(COUNT(DISTINCT oi.order_item_id), 0)
        AS DECIMAL(10,2)
    ) AS Refund_Rate,

    CAST(
        COALESCE(SUM(r.Refund_Amount), 0)
        AS DECIMAL(18,2)
    ) AS Total_Refund_Amount

FROM dbo.order_items oi

INNER JOIN dbo.products p
    ON oi.product_id = p.product_id

LEFT JOIN Refund_Summary r
    ON oi.order_item_id = r.order_item_id

GROUP BY
    p.product_id,
    p.product_name

ORDER BY
    Refund_Rate DESC;
