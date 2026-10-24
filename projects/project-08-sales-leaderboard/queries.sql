-- Project 8: Sales Leaderboard | queries.sql
-- The monthly sales review, built only with CTEs and window functions.

-- B1. Overall leaderboard with three kinds of rank.
WITH totals AS (
    SELECT r.name, r.region, SUM(d.amount) AS revenue, COUNT(*) AS deals
    FROM deals d JOIN reps r USING (rep_id) GROUP BY r.rep_id
)
SELECT RANK() OVER (ORDER BY revenue DESC) AS rnk, name, region, deals,
       printf('%,d', revenue) AS revenue,
       ROUND(100.0 * revenue / SUM(revenue) OVER (), 1) AS share_pct,
       NTILE(3) OVER (ORDER BY revenue DESC) AS tier
FROM totals ORDER BY rnk;

-- B2. Region champions: the top 2 per region (top-N per group).
WITH totals AS (
    SELECT r.region, r.name, SUM(d.amount) AS revenue
    FROM deals d JOIN reps r USING (rep_id) GROUP BY r.rep_id
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC) AS pos FROM totals
)
SELECT region, pos, name, revenue FROM ranked WHERE pos <= 2 ORDER BY region, pos;

-- B3. Monthly revenue, month-over-month growth and a 3-month moving average.
WITH monthly AS (
    SELECT strftime('%Y-%m', closed_on) AS month, SUM(amount) AS revenue FROM deals GROUP BY month
)
SELECT month, revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER w) / LAG(revenue) OVER w, 1) AS mom_growth_pct,
       ROUND(AVG(revenue) OVER (w ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS moving_avg_3m,
       SUM(revenue) OVER (w ROWS UNBOUNDED PRECEDING) AS year_to_date
FROM monthly WINDOW w AS (ORDER BY month) ORDER BY month;

-- B4. Rep of the month: the winner of each month.
WITH m AS (
    SELECT strftime('%Y-%m', d.closed_on) AS month, r.name, SUM(d.amount) AS revenue
    FROM deals d JOIN reps r USING (rep_id) GROUP BY month, r.rep_id
)
SELECT month, name AS rep_of_the_month, revenue
FROM (SELECT *, RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS rk FROM m)
WHERE rk = 1 ORDER BY month;

-- B5. Quota tracker: running total toward a Rs 15 lakh half-year quota, and the day it was hit.
WITH running AS (
    SELECT r.name, d.closed_on,
           SUM(d.amount) OVER (PARTITION BY d.rep_id ORDER BY d.closed_on, d.deal_id) AS cumulative
    FROM deals d JOIN reps r USING (rep_id)
), hit AS (
    SELECT name, MIN(closed_on) AS quota_hit_on FROM running WHERE cumulative >= 1500000 GROUP BY name
)
SELECT r.name, h.quota_hit_on FROM reps r LEFT JOIN hit h ON h.name = r.name
WHERE r.manager_id IN (2, 3) ORDER BY h.quota_hit_on IS NULL, h.quota_hit_on;

-- B6. Biggest jump between a rep's consecutive deals (LAG per rep).
WITH gaps AS (
    SELECT r.name, d.closed_on, d.amount, d.amount - LAG(d.amount) OVER (PARTITION BY d.rep_id ORDER BY d.closed_on, d.deal_id) AS jump
    FROM deals d JOIN reps r USING (rep_id)
)
SELECT name, closed_on, amount, jump FROM gaps WHERE jump IS NOT NULL ORDER BY jump DESC LIMIT 3;

-- B7. Team roll-up through the org chart (recursive CTE): each lead's whole team revenue.
WITH RECURSIVE team(lead_id, member_id) AS (
    SELECT rep_id, rep_id FROM reps
    UNION ALL
    SELECT t.lead_id, r.rep_id FROM reps r JOIN team t ON r.manager_id = t.member_id
)
SELECT l.name AS lead, COUNT(DISTINCT t.member_id) - 1 AS people_below, printf('%,d', SUM(d.amount)) AS team_revenue
FROM team t JOIN reps l ON l.rep_id = t.lead_id
LEFT JOIN deals d ON d.rep_id = t.member_id
WHERE l.rep_id IN (1, 2, 3)
GROUP BY t.lead_id ORDER BY t.lead_id;
