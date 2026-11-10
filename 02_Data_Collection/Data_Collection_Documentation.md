# Data Collection Documentation

## 1. Data Source

The project uses the Maven Fuzzy Factory e-commerce dataset provided for business analytics.

## 2. Data Collection Method

The datasets were downloaded in CSV format and imported into Microsoft SQL Server Management Studio (SSMS).

## 3. Database Information

**Database Name:** MavenFuzzyFactory_Analytics

**Total Tables:** 6

## 4. Dataset Overview

| Table Name | Records | Description |
|---|---:|---|
| orders | 32,313 | Order-level sales information |
| order_items | 40,025 | Individual products purchased |
| order_item_refunds | 1,731 | Refund transaction details |
| products | 4 | Product information |
| website_pageviews | 1,188,124 | Website pageview activity |
| website_sessions | 472,871 | Website session and marketing information |
| **Total** | **1,735,068** | |

## 5. Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Python
- Power BI

## 6. Data Preparation

All six CSV datasets were imported into SQL Server. Initial checks were performed to verify table structures, record counts, duplicate identifiers, missing values, and relationships between tables.

The detailed cleaning procedures are documented in the Data Cleaning section.

All six CSV datasets were imported into SQL Server. Initial checks were performed to verify table structures, record counts, duplicate identifiers, missing values, and relationships between tables.

The detailed cleaning procedures are documented in the Data Cleaning section.
