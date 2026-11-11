-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Time Between First and Second Purchase

WITH Customer_Order_Ranking AS
(
    SELECT
        user_id,
        order_id,
        created_at,

        ROW_NUMBER() OVER
        (
            PARTITION BY user_id
            ORDER BY created_at, order_id
        ) AS Order_Rank

    FROM dbo.orders
),

Repeat_Order_Timing AS
(
    SELECT
        user_id,

        MAX(CASE
            WHEN Order_Rank = 1 THEN created_at
        END) AS First_Order_Date,

        MAX(CASE
            WHEN Order_Rank = 2 THEN created_at
        END) AS Second_Order_Date

    FROM Customer_Order_Ranking
    WHERE Order_Rank <= 2
    GROUP BY user_id
)

SELECT
    COUNT(*) AS Repeat_Customers,

    AVG(CAST(
        DATEDIFF(DAY, First_Order_Date, Second_Order_Date)
        AS DECIMAL(10,2)
    )) AS Average_Days_To_Second_Order,

    MIN(DATEDIFF(DAY, First_Order_Date, Second_Order_Date))
        AS Minimum_Days,

    MAX(DATEDIFF(DAY, First_Order_Date, Second_Order_Date))
        AS Maximum_Days

FROM Repeat_Order_Timing
WHERE Second_Order_Date IS NOT NULL;
