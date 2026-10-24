-- Project 6: Sales CSV Pipeline | step 1: import
-- Load the raw file exactly as it is into a staging table (every column TEXT).
DROP TABLE IF EXISTS staging_sales;
.import --csv projects/project-06-sales-csv-pipeline/data/sales_raw.csv staging_sales
SELECT COUNT(*) AS raw_rows FROM staging_sales;
