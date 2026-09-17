-- 1. Główne KPI
SELECT
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- 2. AOV
SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- 3. Sprzedaż miesięczna
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY month;

-- 4. MoM growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
        2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;

-- 5. Top 10 kategorii wg przychodu
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY revenue DESC
LIMIT 10;

-- 6. Top 10 produktów wg przychodu
SELECT
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;

-- 7. Sprzedaż wg stanu klienta
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- 8. Top 10 klientów wg wydatków
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- 9. Powracający klienci
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE orders_count > 1) AS returning_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE orders_count > 1) / COUNT(*),
        2
    ) AS returning_customer_pct
FROM customer_orders;

-- 10. Rozkład liczby zamówień na klienta
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    orders_count,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY orders_count
ORDER BY orders_count;

-- 11. Top 10 sprzedawców wg przychodu
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;

-- 12. Średnia ocena
SELECT
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews;

-- 13. Ocena vs terminowość dostawy
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'on_time_or_early'
        ELSE 'late'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS reviews
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status
ORDER BY delivery_status;
