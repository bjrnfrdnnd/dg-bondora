select * from "Investments";

with a as (select *
                , date(date_trunc('month', date("AdditionDateTime"))) as mm
    from "Cashflows"
),
     b as (select a.*
     , case when a."Amount" >= 0 then a."Amount" else 0. end as "Amount_pos"
          , case when a."Amount" < 0 then -a."Amount" else 0. end as "Amount_neg"
         from a)
, c as (
    select b.mm
           , sum(b."Amount") as "Amount"
            , sum(b."Amount_pos") as "Amount_pos"
            , sum(b."Amount_neg") as "Amount_neg"
    from b
    group by
    b.mm)

select
*
from c
order by c.mm desc