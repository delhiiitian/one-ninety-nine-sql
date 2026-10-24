-- Project 6: Sales CSV Pipeline | step 3: report
SELECT store, COUNT(*) AS orders, SUM(qty) AS units, SUM(qty * unit_price) AS revenue
FROM sales GROUP BY store ORDER BY revenue DESC;

SELECT product, SUM(qty) AS units, SUM(qty * unit_price) AS revenue
FROM sales GROUP BY product ORDER BY revenue DESC;

SELECT 'Week ' || ((CAST(strftime('%d', order_date) AS INTEGER) - 1) / 7 + 1) AS week_of_sept,
       SUM(qty * unit_price) AS revenue
FROM sales GROUP BY week_of_sept;
