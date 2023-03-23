-- '2022-04-01'
-- date(DATE_TRUNC('month', now()))
WITH
params0 AS (   -- Parameters for down stream queries
    SELECT
       80 AS max_bars
)
, _Investments AS (SELECT date("AdditionDateTime")                            as dd
                               , date(date_trunc('month', date("AdditionDateTime"))) as mm
                               , sum("SoldInResale_Principal")                       as principal
                               , sum("SoldInResale_Price")                           as price
                          from "Investments"
                          where date(date_trunc('month', date("EndDateTime"))) = date(DATE_TRUNC('month', now()))
                            and "InvestmentStatus" = 'Sold'
                          group by date("AdditionDateTime")
)
, numbers AS (
    -- Change this query to select real data.0
    -- For now we make random set of numbers.
    SELECT dd
    ,  mm
    , principal
    , price
    from _Investments
    where principal > 0 and price > 0
)
, overall AS (
    select t.*
    , EXTRACT(year FROM age(max_month, min_month))*12 + EXTRACT(month FROM age(max_month, min_month)) +  1 as cnt_months
           from (
                   select
                    min(mm) as min_month
                    , max(mm) as max_month
           , sum(principal) as total_sum_principal
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
        , (date_trunc('month', min_month) + interval '1 month' * bucket)::date AS bucket_month
    FROM params,
         overall,
         generate_series(0, bucket_count - 1) AS t(bucket)
)
, sums AS (
    -- Join numbers with buckets and sum up how much falls between the ranges
    SELECT
        bucket
        , bucket_month
        , sum(principal) AS sum_principal
        , sum(price) AS sum_price
    FROM numbers
    JOIN buckets ON numbers.mm = bucket_month
    GROUP BY bucket, bucket_month
    ORDER BY bucket
)
, sum_ranges AS (
    -- Figure out the min/max sums for each range.
    -- This is use to normalize the width of the graph.
    SELECT
        MIN(sum_principal) min_sum_num,
        MAX(sum_principal) max_sum_num,
        SUM(sum_principal) sum_sum_num
    FROM sums
)
, percentages AS (
    -- Calculate how close sum_num is to the max sum for the entire graph.
    SELECT
        sums.*,
        sum_principal::numeric / max_sum_num AS bar_pct,
        sum_principal::numeric / total_sum_principal::numeric AS pct
    FROM params, sums, sum_ranges, overall
)
, graph AS (
    -- Render the final chart
    SELECT
        bucket
        , bucket_month
        , round(sum_principal::numeric, 4) as sum_principal
        , round(sum_price::numeric, 4) as sum_price
         , round(((sum_price / sum_principal -1)*100)::numeric, 4) as p_gain
         , round((sum_price - sum_principal)::numeric, 4) as gain
        , round((pct * 100)::numeric, 4) as pct
        , repeat('0', (bar_pct * max_bars)::int) AS chart
    FROM params,
         percentages,
         overall
)
-- Select which part of the query to display by changing the `FROM` target
SELECT * FROM graph order by bucket_month desc
-- SELECT * FROM sums
-- SELECT * FROM overall
-- SELECT * FROM numbers
-- SELECT * FROM sum_ranges
-- SELECT * FROM percentages
;
