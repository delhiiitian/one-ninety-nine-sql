-- Project 3: Monthly Expense Tracker | queries.sql
-- A month-end money report built from functions, GROUP BY, HAVING and subqueries.

-- R1. Monthly totals (date functions + GROUP BY).
SELECT strftime('%Y-%m', spent_on) AS month,
       COUNT(*)                     AS entries,
       printf('%,.0f', SUM(amount)) AS total
FROM expenses GROUP BY month ORDER BY month;

-- R2. September by category, biggest first, with share of the month.
SELECT category,
       SUM(amount) AS spent,
       ROUND(100.0 * SUM(amount) / (SELECT SUM(amount) FROM expenses WHERE spent_on LIKE '2026-09-%'), 1) AS pct
FROM expenses
WHERE spent_on BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY category ORDER BY spent DESC;

-- R3. Budget check for September: which categories went over? (join to budgets via a subquery)
SELECT e.category, SUM(e.amount) AS spent,
       (SELECT monthly_limit FROM budgets b WHERE b.category = e.category) AS budget,
       SUM(e.amount) - (SELECT monthly_limit FROM budgets b WHERE b.category = e.category) AS over_by
FROM expenses e
WHERE strftime('%Y-%m', e.spent_on) = '2026-09'
GROUP BY e.category
HAVING SUM(e.amount) > (SELECT monthly_limit FROM budgets b WHERE b.category = e.category);

-- R4. Category x month pivot (conditional aggregation).
SELECT category,
       SUM(amount) FILTER (WHERE spent_on LIKE '2026-08-%') AS aug,
       SUM(amount) FILTER (WHERE spent_on LIKE '2026-09-%') AS sep,
       SUM(amount) FILTER (WHERE spent_on LIKE '2026-10-%') AS oct
FROM expenses GROUP BY category ORDER BY category;

-- R5. How do I pay? Share by method, excluding rent.
SELECT method, COUNT(*) AS payments, SUM(amount) AS total,
       ROUND(AVG(amount)) AS avg_payment
FROM expenses WHERE category <> 'Rent'
GROUP BY method ORDER BY total DESC;

-- R6. Biggest single non-rent expense each month (correlated subquery).
SELECT strftime('%Y-%m', e.spent_on) AS month, e.description, e.amount
FROM expenses e
WHERE e.category <> 'Rent'
  AND e.amount = (SELECT MAX(x.amount) FROM expenses x
                  WHERE x.category <> 'Rent' AND strftime('%Y-%m', x.spent_on) = strftime('%Y-%m', e.spent_on))
ORDER BY month;

-- R7. Weekend vs weekday spending (strftime('%w'): 0 = Sunday, 6 = Saturday).
SELECT CASE WHEN strftime('%w', spent_on) IN ('0', '6') THEN 'Weekend' ELSE 'Weekday' END AS day_type,
       COUNT(*) AS entries, SUM(amount) AS total
FROM expenses WHERE category <> 'Rent' GROUP BY day_type;

-- R8. Daily average so far in October and a simple month-end forecast.
SELECT ROUND(SUM(amount) / 20.0, 2) AS daily_avg_oct_1_to_20,
       ROUND(SUM(amount) / 20.0 * 31) AS forecast_for_october
FROM expenses
WHERE spent_on BETWEEN '2026-10-01' AND '2026-10-20' AND category <> 'Rent';

-- R9. Categories with no spending at all in October (NOT EXISTS).
SELECT b.category FROM budgets b
WHERE NOT EXISTS (SELECT 1 FROM expenses e WHERE e.category = b.category AND e.spent_on LIKE '2026-10-%');

-- R10. Descriptions tidied for a printed statement.
SELECT spent_on, UPPER(SUBSTR(category, 1, 3)) AS code, description, printf('%8.2f', amount) AS amount
FROM expenses WHERE spent_on >= '2026-10-01' ORDER BY spent_on;
