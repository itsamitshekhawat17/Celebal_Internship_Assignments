-- Total revenue per customer
SELECT c.customer_id, c.name, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY revenue DESC;

-- Total revenue per category
SELECT p.category, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Total revenue per month
SELECT strftime('%Y-%m', o.order_date) AS month, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Top products by quantity sold and revenue
SELECT p.product_name, SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- Average order value by customer segment
SELECT c.segment, ROUND(AVG(order_total), 2) AS avg_order_value
FROM customers c
JOIN (
    SELECT o.order_id, o.customer_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t ON c.customer_id = t.customer_id
GROUP BY c.segment;
