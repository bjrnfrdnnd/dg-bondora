with selection as (select iddb from "WhSecondMarketPublished" where "LoanStatusCode"=2 and "DebtManagmentEvents"=0 and "NextPaymentNr" > 6)
select "DesiredDiscountRate", "PrincipalRemaining", "Interest", "NextPaymentNr" from "WhSecondMarketPublished" where iddb in (select iddb from selection);
with selection as (select iddb from "WhSecondMarketPublished" where "LoanStatusCode"=2 and "DebtManagmentEvents"=0 and "NextPaymentNr" > 6)
select sum("PrincipalRemaining"), count(*) from "WhSecondMarketPublished" where iddb in (select iddb from selection);

WITH params AS (
    -- Parameters for down stream queries
    SELECT
       600 AS bucket_count,
       80 AS max_bars
),
numbers AS (
    -- Change this query to select real data.
    -- For now we make random set of numbers.
    SELECT EXTRACT('second' from (datetime_celery - "ListedOnDate"))*1000 as num from "WhSecondMarketPublished"

),
overall AS (
    SELECT
        MAX(num) max_num,
        count(num) as total_cnt
    FROM numbers
),
buckets AS (
    -- Build list of bucket ranges
    SELECT
        bucket,
        floor((max_num::numeric / bucket_count) * bucket)::int AS min_range,
        floor((max_num::numeric / bucket_count) * (bucket + 1) - 1)::int AS max_range
    FROM params,
         overall,
         generate_series(0, bucket_count - 1) AS t(bucket)
),
counts AS (
    -- Join numbers with buckets and count up how many fall between the ranges
    SELECT
        bucket,
        min_range,
        max_range,
        COUNT(num) AS count_num
    FROM numbers
    JOIN buckets ON numbers.num BETWEEN min_range AND max_range
    GROUP BY bucket, min_range, max_range
    ORDER BY bucket
),
count_ranges AS (
    -- Figure out the min/max counts for each range.
    -- This is use to normalize the width of the graph.
    SELECT
        MIN(count_num) min_count_num,
        MAX(count_num) max_count_num,
        SUM(count_num) sum_count_num
    FROM counts
),
percentages AS (
    -- Calculate how close count_num is to the max count for the entire graph.
    SELECT
        counts.*,
        count_num::numeric / max_count_num AS bar_pct,
        count_num::numeric / total_cnt::numeric AS pct
    FROM params, counts, count_ranges, overall
),
graph AS (
    -- Render the final chart
    SELECT
        bucket,
        min_range,
        max_range,
        count_num,
        pct * 100 as pct,
        repeat('0', (bar_pct * max_bars)::int) AS chart
    FROM params,
         percentages,
         overall
)
-- Select which part of the query to display by changing the `FROM` target
SELECT * FROM graph
;