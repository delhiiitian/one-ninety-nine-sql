-- Project 6: Sales CSV Pipeline | step 4: export
-- Writes exported-store-summary.csv and exported-sales.json to the repo root (ignored by git).
.headers on
.mode csv
.once exported-store-summary.csv
SELECT store, COUNT(*) AS orders, SUM(qty * unit_price) AS revenue FROM sales GROUP BY store ORDER BY revenue DESC;

.mode list
.headers off
.once exported-sales.json
SELECT json_group_array(json_object('ref', order_ref, 'date', order_date, 'store', store,
                                    'product', product, 'qty', qty, 'total', qty * unit_price))
FROM sales;

.mode box
.headers on
SELECT 'exported-store-summary.csv' AS file, length(readfile('exported-store-summary.csv')) AS bytes
UNION ALL
SELECT 'exported-sales.json', length(readfile('exported-sales.json'));
SELECT json_array_length(readfile('exported-sales.json')) AS orders_in_json;
