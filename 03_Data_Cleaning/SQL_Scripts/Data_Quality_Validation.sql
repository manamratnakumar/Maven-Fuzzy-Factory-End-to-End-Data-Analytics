/*
Project: Maven Fuzzy Factory Analytics
Purpose: Data Quality Validation
Database: MavenFuzzyFactory_Analytics
Tool: SQL Server
*/

-- ==========================================
-- 1. ROW COUNT VALIDATION
-- ==========================================

SELECT 'orders' AS Table_Name, COUNT(*) AS Total_Rows
FROM dbo.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM dbo.order_items

UNION ALL

SELECT 'order_item_refunds', COUNT(*)
FROM dbo.order_item_refunds

UNION ALL

SELECT 'products', COUNT(*)
FROM dbo.products

UNION ALL

SELECT 'website_pageviews', COUNT(*)
FROM dbo.website_pageviews

UNION ALL

SELECT 'website_sessions', COUNT(*)
FROM dbo.website_sessions;


-- ==========================================
-- 2. DUPLICATE PRIMARY KEY VALIDATION
-- ==========================================

SELECT 'orders' AS Table_Name,
       COUNT(*) - COUNT(DISTINCT order_id) AS Duplicate_IDs
FROM dbo.orders

UNION ALL

SELECT 'order_items',
       COUNT(*) - COUNT(DISTINCT order_item_id)
FROM dbo.order_items

UNION ALL

SELECT 'order_item_refunds',
       COUNT(*) - COUNT(DISTINCT order_item_refund_id)
FROM dbo.order_item_refunds

UNION ALL

SELECT 'products',
       COUNT(*) - COUNT(DISTINCT product_id)
FROM dbo.products

UNION ALL

SELECT 'website_pageviews',
       COUNT(*) - COUNT(DISTINCT website_pageview_id)
FROM dbo.website_pageviews

UNION ALL

SELECT 'website_sessions',
       COUNT(*) - COUNT(DISTINCT website_session_id)
FROM dbo.website_sessions;


-- ==========================================
-- 3. REFERENTIAL INTEGRITY VALIDATION
-- ==========================================

-- Orders to Website Sessions

SELECT COUNT(*) AS Unmatched_Order_Sessions
FROM dbo.orders o
LEFT JOIN dbo.website_sessions ws
    ON o.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;


-- Order Items to Orders

SELECT COUNT(*) AS Unmatched_Order_Items
FROM dbo.order_items oi
LEFT JOIN dbo.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Refunds to Order Items

SELECT COUNT(*) AS Unmatched_Refund_Items
FROM dbo.order_item_refunds r
LEFT JOIN dbo.order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;


-- Orders to Products

SELECT COUNT(*) AS Unmatched_Products
FROM dbo.orders o
LEFT JOIN dbo.products p
    ON o.primary_product_id = p.product_id
WHERE p.product_id IS NULL;


-- Pageviews to Website Sessions

SELECT COUNT(*) AS Unmatched_Pageview_Sessions
FROM dbo.website_pageviews pv
LEFT JOIN dbo.website_sessions ws
    ON pv.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;


-- ==========================================
-- 4. FINANCIAL VALIDATION
-- ==========================================

SELECT
    COUNT(*) AS Total_Order_Items,

    SUM(CASE WHEN price_usd <= 0
        THEN 1 ELSE 0 END) AS Invalid_Prices,

    SUM(CASE WHEN cogs_usd < 0
        THEN 1 ELSE 0 END) AS Negative_COGS,

    SUM(CASE WHEN cogs_usd > price_usd
        THEN 1 ELSE 0 END) AS COGS_Above_Price

FROM dbo.order_items;


-- ==========================================
-- 5. REFUND VALIDATION
-- ==========================================

SELECT
    COUNT(*) AS Total_Refunds,

    SUM(CASE WHEN refund_amount_usd <= 0
        THEN 1 ELSE 0 END) AS Invalid_Refunds

FROM dbo.order_item_refunds;
