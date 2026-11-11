-- Project: Maven Fuzzy Factory Analytics
-- Analysis: Monthly Website Traffic

SELECT
    YEAR(created_at) AS Session_Year,
    MONTH(created_at) AS Session_Month,
    COUNT(*) AS Total_Sessions
FROM dbo.website_sessions
GROUP BY
    YEAR(created_at),
    MONTH(created_at)
ORDER BY
    Session_Year,
    Session_Month;
