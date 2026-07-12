-- Rank customers by lifetime value
WITH customer_revenue AS (
    SELECT c.customer_id, c.name, SUM(oi.quantity * oi.unit_price) AS ltv
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, name, ROUND(ltv, 2) AS ltv,
       RANK() OVER (ORDER BY ltv DESC) AS ltv_rank,
       DENSE_RANK() OVER (ORDER BY ltv DESC) AS ltv_dense_rank
FROM customer_revenue
ORDER BY ltv_rank;

-- Monthly revenue with running total and moving average
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
)
SELECT month, ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total,
       ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3mo
FROM monthly_revenue
ORDER BY month;

-- Monthly revenue growth rate using CTE
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
),
with_prev AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_revenue
)
SELECT month, ROUND(revenue, 2) AS revenue,
       ROUND(prev_revenue, 2) AS prev_revenue,
       ROUND((revenue - prev_revenue) * 100.0 / prev_revenue, 2) AS growth_rate_pct
FROM with_prev
ORDER BY month;
