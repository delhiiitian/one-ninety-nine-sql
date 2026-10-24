-- SQL 199 | 9.7 Reporting queries for dashboards
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-07-dashboard-reports.sql
-- Real world: a car dashboard. Hundreds of sensor readings become a few
-- clear numbers: speed, fuel, distance this trip.

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (order_id INTEGER PRIMARY KEY, ordered_at TEXT, channel TEXT, amount REAL, status TEXT);
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 600)
INSERT INTO orders (ordered_at, channel, amount, status)
SELECT datetime('2026-07-01', '+' || (i * 211 % 120) || ' days', '+' || (i * 53 % 24) || ' hours'),
       CASE i % 3 WHEN 0 THEN 'App' WHEN 1 THEN 'Web' ELSE 'Store' END,
       100 + (i * 97) % 900,
       CASE WHEN i % 17 = 0 THEN 'refunded' ELSE 'paid' END
FROM n;

-- KPI tiles: one row of headline numbers.
SELECT COUNT(*)                                        AS orders,
       ROUND(SUM(amount))                              AS revenue,
       ROUND(AVG(amount), 2)                           AS avg_order_value,
       ROUND(100.0 * SUM(status = 'refunded') / COUNT(*), 1) AS refund_rate_pct
FROM orders;

-- Line chart: revenue per month (date bucketing with strftime).
SELECT strftime('%Y-%m', ordered_at) AS month, ROUND(SUM(amount)) AS revenue, COUNT(*) AS orders
FROM orders WHERE status = 'paid'
GROUP BY month ORDER BY month;

-- Stacked bars: month x channel.
SELECT strftime('%Y-%m', ordered_at) AS month,
       ROUND(SUM(amount) FILTER (WHERE channel = 'App'))   AS app,
       ROUND(SUM(amount) FILTER (WHERE channel = 'Web'))   AS web,
       ROUND(SUM(amount) FILTER (WHERE channel = 'Store')) AS store
FROM orders WHERE status = 'paid' GROUP BY month ORDER BY month;

-- Heat map: busiest hours of the day.
SELECT strftime('%H', ordered_at) AS hour, COUNT(*) AS orders
FROM orders GROUP BY hour ORDER BY orders DESC LIMIT 5;

-- Month-over-month growth with LAG.
WITH m AS (SELECT strftime('%Y-%m', ordered_at) AS month, SUM(amount) AS revenue FROM orders WHERE status = 'paid' GROUP BY month)
SELECT month, ROUND(revenue) AS revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month), 1) AS growth_pct
FROM m;
