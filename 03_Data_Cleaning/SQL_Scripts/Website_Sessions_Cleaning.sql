/*
Project: Maven Fuzzy Factory Analytics
Purpose: Standardize missing marketing values
Database: MavenFuzzyFactory_Analytics
*/

CREATE OR ALTER VIEW dbo.vw_website_sessions_clean AS

SELECT
    website_session_id,
    created_at,
    user_id,
    is_repeat_session,

    NULLIF(TRIM(utm_source), 'NULL') AS utm_source,
    NULLIF(TRIM(utm_campaign), 'NULL') AS utm_campaign,
    NULLIF(TRIM(utm_content), 'NULL') AS utm_content,

    device_type,

    NULLIF(TRIM(http_referer), 'NULL') AS http_referer

FROM dbo.website_sessions;

