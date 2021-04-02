-- '2021-04-01'
WITH
params0 AS (
    -- Parameters for down stream queries
    SELECT
       80 AS max_bars
)
, numbers AS (
    -- Change this query to select real data.
    -- For now we make random set of numbers.
    SELECT date("AdditionDateTime") as dd
    , sum("AdditionPrincipal") as ss
    from "Investments" where date("EndDateTime") between ? and ? and "InvestmentStatus" ='Sold'
    group by date("AdditionDateTime")
)
, overall AS (
    select t.*
    , extract(month from age(max_dd, min_dd)) + 1 as cnt_months
           from (
                   select
                          (date_trunc('month', min(dd)) )::date as min_dd
           , (date_trunc('month', now()) + interval '1 month -1 day' )::date as max_dd
           , sum(ss) as total_sum
    FROM numbers
                      ) t
)
, params AS (
    -- Parameters for down stream queries
    SELECT
       cnt_months::int AS bucket_count,
       80 AS max_bars
    from overall cross join params0
)
, buckets AS (
    -- Build list of bucket ranges
    SELECT
        bucket
        , (date_trunc('month', min_dd) + interval '1 month' * bucket)::date AS min_range
        , (date_trunc('month', min_dd) + interval '1 month' * bucket + interval '1 month -1 day'  )::date AS max_range

    FROM params,
         overall,
         generate_series(0, bucket_count - 1) AS t(bucket)
)
, sums AS (
    -- Join numbers with buckets and sum up how much falls between the ranges
    SELECT
        bucket,
        min_range,
        max_range,
        sum(ss) AS sum_ss
    FROM numbers
    JOIN buckets ON numbers.dd BETWEEN min_range AND max_range
    GROUP BY bucket, min_range, max_range
    ORDER BY bucket
)
, sum_ranges AS (
    -- Figure out the min/max sums for each range.
    -- This is use to normalize the width of the graph.
    SELECT
        MIN(sum_ss) min_sum_num,
        MAX(sum_ss) max_sum_num,
        SUM(sum_ss) sum_sum_num
    FROM sums
)
, percentages AS (
    -- Calculate how close sum_num is to the max sum for the entire graph.
    SELECT
        sums.*,
        sum_ss::numeric / max_sum_num AS bar_pct,
        sum_ss::numeric / total_sum::numeric AS pct
    FROM params, sums, sum_ranges, overall
)
, graph AS (
    -- Render the final chart
    SELECT
        bucket,
        min_range,
        max_range,
        sum_ss,
        pct * 100 as pct,
        repeat('0', (bar_pct * max_bars)::int) AS chart
    FROM params,
         percentages,
         overall
)
-- Select which part of the query to display by changing the `FROM` target
SELECT * FROM graph order by min_range desc
;