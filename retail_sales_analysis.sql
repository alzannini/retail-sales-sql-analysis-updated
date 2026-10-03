-- Retail Sales SQL Analysis
-- Portfolio project: retail-sales-sql-analysis
-- SQL dialect: PostgreSQL

-- ============================================================
-- 1. BASIC DATA EXPLORATION
-- ============================================================

SELECT *
FROM orders
LIMIT 10;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;


-- ============================================================
-- 2. TOTAL SALES
-- ============================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales
FROM orders;


-- ============================================================
-- 3. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(AVG(sales), 2) AS average_order_value
FROM orders
WHERE order_status = 'Completed';


-- ============================================================
-- 4. TOTAL QUANTITY SOLD
-- ============================================================

SELECT
    SUM(quantity) AS total_units_sold
FROM orders
WHERE order_status = 'Completed';


-- ============================================================
-- 5. SALES BY PRODUCT
-- ============================================================

SELECT
    p.product_name,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY total_sales DESC;


-- ============================================================
-- 6. TOP 10 PRODUCTS
-- ============================================================

SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 7. SALES BY CATEGORY
-- ============================================================

SELECT
    p.category,
    ROUND(SUM(o.sales), 2) AS total_sales,
    SUM(o.quantity) AS units_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY total_sales DESC;


-- ============================================================
-- 8. SALES BY STATE
-- ============================================================

SELECT
    c.state,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.state
ORDER BY total_sales DESC;


-- ============================================================
-- 9. SALES BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.segment
ORDER BY total_sales DESC;


-- ============================================================
-- 10. MONTHLY SALES TREND
-- ============================================================

SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
WHERE order_status = 'Completed'
GROUP BY month
ORDER BY month;


-- ============================================================
-- 11. SALES BY YEAR
-- ============================================================

SELECT
    EXTRACT(YEAR FROM order_date) AS sales_year,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
WHERE order_status = 'Completed'
GROUP BY sales_year
ORDER BY sales_year;


-- ============================================================
-- 12. CUSTOMER SPENDING
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    ROUND(SUM(o.sales), 2) AS total_spent
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_spent DESC;


-- ============================================================
-- 13. TOP 10 CUSTOMERS
-- ============================================================

SELECT
    c.customer_name,
    c.segment,
    ROUND(SUM(o.sales), 2) AS total_spent
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_name, c.segment
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================
-- 14. CUSTOMER VALUE SEGMENTS
-- ============================================================

WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.customer_name,
        ROUND(SUM(o.sales), 2) AS total_spent
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 2000 THEN 'High Value'
        WHEN total_spent >= 1000 THEN 'Medium Value'
        ELSE 'Lower Value'
    END AS customer_value_segment
FROM customer_spend
ORDER BY total_spent DESC;


-- ============================================================
-- 15. ORDERS PER CUSTOMER
-- ============================================================

SELECT
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY order_count DESC;


-- ============================================================
-- 16. RETURN RATE
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate_percent
FROM orders;


-- ============================================================
-- 17. SALES BY ORDER STATUS
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2) AS sales
FROM orders
GROUP BY order_status
ORDER BY sales DESC;


-- ============================================================
-- 18. MONTH-OVER-MONTH SALES CHANGE
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY month
)
SELECT
    month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        100.0 * (
            total_sales - LAG(total_sales) OVER (ORDER BY month)
        )
        / NULLIF(LAG(total_sales) OVER (ORDER BY month), 0),
        2
    ) AS mom_change_percent
FROM monthly_sales
ORDER BY month;


-- ============================================================
-- 19. PRODUCT RANKING
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_name,
        p.category,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.product_name, p.category
)
SELECT
    product_name,
    category,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS overall_rank
FROM product_sales
ORDER BY overall_rank;


-- ============================================================
-- 20. PRODUCT RANKING WITHIN CATEGORY
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_name,
        p.category,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.product_name, p.category
)
SELECT
    product_name,
    category,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_sales DESC
    ) AS category_rank
FROM product_sales
ORDER BY category, category_rank;


-- ============================================================
-- 21. FINAL BUSINESS SUMMARY
-- ============================================================

SELECT
    ROUND(SUM(sales), 2) AS total_completed_sales,
    COUNT(*) AS completed_orders,
    ROUND(AVG(sales), 2) AS average_order_value,
    SUM(quantity) AS units_sold
FROM orders
WHERE order_status = 'Completed';
