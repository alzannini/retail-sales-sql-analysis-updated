# Retail Sales SQL Analysis

A portfolio SQL project analyzing retail sales data to identify revenue trends, customer behavior, product performance, and business opportunities.

## Project Overview

This project uses a fictional retail dataset containing:

- 1,000 customers
- 30 products
- 5,000 orders
- Order dates from 2024–2025
- Customer segments
- U.S. states
- Product categories
- Quantities, prices, and discounts
- Completed, returned, and cancelled orders

The analysis is designed to demonstrate practical SQL skills that are useful for Data Analyst, Reporting Analyst, Operations Analyst, and Business Intelligence roles.

## Business Questions

The analysis answers questions such as:

1. How much revenue did the business generate?
2. What are the top-performing products?
3. Which product categories generate the most sales?
4. Which states generate the most revenue?
5. Which customer segments are most valuable?
6. How do sales change month over month?
7. Who are the highest-value customers?
8. What percentage of orders are returned?
9. Which products rank highest within each category?
10. What business opportunities can be identified from the data?

## SQL Skills Demonstrated

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- COUNT
- SUM
- AVG
- CASE WHEN
- JOIN
- Common Table Expressions (CTEs)
- DATE_TRUNC
- EXTRACT
- LAG
- RANK
- Window functions
- NULLIF
- Business-oriented analysis

## Repository Structure

```text
retail-sales-sql-analysis/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
│
├── sql/
│   └── retail_sales_analysis.sql
│
└── README.md
```

## Dataset

The dataset is fictional and was created for portfolio and learning purposes.

### customers.csv

Contains customer-level information such as:

- Customer ID
- Customer name
- Segment
- State

### products.csv

Contains product information such as:

- Product ID
- Product name
- Category
- Unit price

### orders.csv

Contains transaction-level information such as:

- Order ID
- Order date
- Customer ID
- Product ID
- Quantity
- Discount
- Sales
- Order status

## Example SQL Analysis

### Total Completed Sales

```sql
SELECT
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
WHERE order_status = 'Completed';
```

### Top Products

```sql
SELECT
    p.product_name,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;
```

### Monthly Sales Trend

```sql
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
WHERE order_status = 'Completed'
GROUP BY month
ORDER BY month;
```

## Key Portfolio Takeaways

This project demonstrates the ability to move from raw transactional data to business-focused analysis.

The analysis focuses on:

- Revenue performance
- Product performance
- Customer value
- Geographic trends
- Sales trends
- Returns
- Ranking and segmentation

## Tools

- SQL
- PostgreSQL syntax
- CSV datasets
- GitHub

## Future Improvements

Potential next steps for this project include:

- Building a Power BI dashboard
- Adding customer retention analysis
- Calculating customer lifetime value
- Creating a monthly KPI dashboard
- Adding product profitability analysis
- Connecting the dataset to a cloud SQL database

## Author

Alex Zannini

This project was created as part of a data analytics portfolio to demonstrate practical SQL and business analysis skills.
