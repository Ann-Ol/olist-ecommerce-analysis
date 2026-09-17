
-- 1. Liczba rekordów
SELECT 'customers' AS table_name, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
ORDER BY table_name;

-- 2. Unikalność order_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- 3. customer_id vs customer_unique_id
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_real_customers
FROM customers;

-- 4. Braki w kluczowych datach
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS missing_approved_at,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS missing_delivery_date
FROM orders;

-- 5. Statusy zamówień bez daty dostawy
SELECT
    order_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY orders_count DESC;

-- 6. Statusy zamówień bez daty zatwierdzenia
SELECT
    order_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_approved_at IS NULL
GROUP BY order_status
ORDER BY orders_count DESC;

-- 7. Delivered bez daty dostawy
SELECT *
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

-- 8. Delivered bez daty zatwierdzenia
SELECT *
FROM orders
WHERE order_status = 'delivered'
  AND order_approved_at IS NULL;

-- 9. Jakość danych w order_items
SELECT
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE freight_value IS NULL) AS null_freight,
    COUNT(*) FILTER (WHERE price <= 0) AS non_positive_price,
    COUNT(*) FILTER (WHERE freight_value < 0) AS negative_freight
FROM order_items;

-- 10. Braki w products
SELECT
    COUNT(*) AS total_products,
    COUNT(*) FILTER (WHERE product_category_name IS NULL) AS missing_category,
    COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS missing_weight,
    COUNT(*) FILTER (WHERE product_length_cm IS NULL) AS missing_length,
    COUNT(*) FILTER (WHERE product_height_cm IS NULL) AS missing_height,
    COUNT(*) FILTER (WHERE product_width_cm IS NULL) AS missing_width
FROM products;

-- 11. Osierocone order_items
SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 12. Brakujące produkty
SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 13. Brakujący sprzedawcy
SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- 14. Duplikaty w order_items
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- 15. Anomalie kolejności dat
SELECT
    COUNT(*) FILTER (
        WHERE order_approved_at < order_purchase_timestamp
    ) AS approval_before_purchase,
    COUNT(*) FILTER (
        WHERE order_delivered_carrier_date < order_approved_at
    ) AS carrier_before_approval,
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date < order_delivered_carrier_date
    ) AS customer_before_carrier
FROM orders;

-- 16. Przykładowe anomalie
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_approved_at < order_purchase_timestamp
   OR order_delivered_carrier_date < order_approved_at
   OR order_delivered_customer_date < order_delivered_carrier_date
LIMIT 20;

-- 17. Dostawa do klienta przed przekazaniem przewoźnikowi
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date
ORDER BY order_delivered_customer_date;

-- 18. Procent takich anomalii
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date < order_delivered_carrier_date
        ) / COUNT(*),
        4
    ) AS pct_customer_before_carrier
FROM orders;
