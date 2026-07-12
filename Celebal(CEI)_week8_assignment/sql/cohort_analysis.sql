-- Assign each customer to a cohort based on first purchase month
WITH first_purchase AS (
    SELECT customer_id, MIN(strftime('%Y-%m', order_date)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
orders_with_cohort AS (
    SELECT o.customer_id, fp.cohort_month, strftime('%Y-%m', o.order_date) AS order_month
    FROM orders o
    JOIN first_purchase fp ON o.customer_id = fp.customer_id
)
SELECT cohort_month, order_month, COUNT(DISTINCT customer_id) AS active_customers
FROM orders_with_cohort
GROUP BY cohort_month, order_month
ORDER BY cohort_month, order_month;

-- Churned vs repeat customers (repeat = more than 1 order)
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS n_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE WHEN n_orders > 1 THEN 'repeat' ELSE 'one_time' END AS customer_type,
    COUNT(*) AS n_customers
FROM order_counts
GROUP BY customer_type;
