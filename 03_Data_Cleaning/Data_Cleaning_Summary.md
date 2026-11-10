# Data Cleaning and Validation Summary

## 1. Overview

Data cleaning and validation were performed on six tables containing 1,735,068 records using Microsoft SQL Server.

The objective was to ensure data accuracy, consistency, completeness, and reliability before performing business analysis.

## 2. Dataset Validation

| Table | Total Records | Validation |
|---|---:|---|
| orders | 32,313 | Completed |
| order_items | 40,025 | Completed |
| order_item_refunds | 1,731 | Completed |
| products | 4 | Completed |
| website_pageviews | 1,188,124 | Completed |
| website_sessions | 472,871 | Completed |
| **Total** | **1,735,068** | |

## 3. Data Quality Checks

The following validation activities were performed:

- Checked duplicate primary identifiers across all six tables.
- Checked missing values in table columns.
- Validated primary and foreign key relationships.
- Inspected date ranges and timestamp consistency.
- Validated product prices and cost of goods sold.
- Checked refund amounts for invalid values.
- Inspected categorical values such as `is_primary_item`.
- Reviewed website page URLs and marketing attributes.

## 4. Issues Identified and Resolved

### Marketing Data Standardization

During website session validation, the `utm_campaign` and `utm_content` columns contained the literal text `'NULL'` in 83,328 records each.

These values were standardized using SQL Server's `NULLIF()` and `TRIM()` functions.

A reusable SQL view was created:

`dbo.vw_website_sessions_clean`

The original source table was preserved without modification.

### Refund Amount Precision

An initial comparison identified apparent refund amounts slightly above original item prices due to floating-point precision differences.

A tolerance of $0.01 was applied during validation.

Result: Zero refunds materially exceeded their original item prices.

## 5. Financial Validation Results

| Validation | Result |
|---|---:|
| Invalid order item prices | 0 |
| Negative item COGS | 0 |
| Item COGS above selling price | 0 |
| Zero or negative refund amounts | 0 |
| Refunds materially above item price | 0 |

## 6. Referential Integrity

The following relationships were validated:

- Orders → Website Sessions
- Order Items → Orders
- Order Item Refunds → Order Items
- Orders → Products
- Website Pageviews → Website Sessions

No unmatched records were found in the relationships checked.

## 7. Cleaning Approach

- Preserved original source tables.
- Used SQL queries for data validation.
- Created a cleaned SQL view for marketing fields.
- Avoided unnecessary deletion or modification of records.
- Documented validation results and cleaning decisions.

## 8. Outcome

The six datasets were reviewed and passed the key data-quality checks performed.

The cleaned website session view is ready for reuse in subsequent analytical queries.
