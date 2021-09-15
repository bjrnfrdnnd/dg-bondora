with a as (
    select "LoanPartId"
    , "PrincipalRemaining"
    , "LoanStatusCode"
    from "MyInvestmentItem"
)
,
b as (
    select
    "LoanPartId"
    , "AdditionDateTime"
    from "Investments"
     )
,
c as (
    select
    a.*
    , b."AdditionDateTime"
    from
         a
    left join
        b
    on a."LoanPartId"=b."LoanPartId"
)
,
d as (
    select
    *
    , Date(DATE_TRUNC('month',"AdditionDateTime")) AS mm
    from c
)
,
e as (
    select
    mm
    , "LoanStatusCode"
    , sum("PrincipalRemaining") as "PrincipalRemaining"
    from d
    group by "LoanStatusCode", mm
    order by mm desc, "LoanStatusCode"
)
,
f as (
    select
    "LoanStatusCode"
    , sum("PrincipalRemaining")
    from e
    group by "LoanStatusCode"
    order by "LoanStatusCode"
)
,
g as (
    select
        mm as mm
         , round(sum("PrincipalRemaining")::numeric, 4) as "total"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2))::numeric, 4) as "2"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100))::numeric, 4) as "100"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5))::numeric, 4) as "5"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0))::numeric, 4) as "0"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3))::numeric, 4) as "3"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4))::numeric, 4) as "4"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8))::numeric, 4) as "8"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2)) / sum("PrincipalRemaining"))::numeric, 4) as "2f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100)) / sum("PrincipalRemaining"))::numeric, 4) as "100f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5)) / sum("PrincipalRemaining"))::numeric, 4) as "5f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0)) / sum("PrincipalRemaining"))::numeric, 4) as "0f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3)) / sum("PrincipalRemaining"))::numeric, 4) as "3f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4)) / sum("PrincipalRemaining"))::numeric, 4) as "4f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8)) / sum("PrincipalRemaining"))::numeric, 4) as "8f"
    from e
            group by mm
)
,
h as (
    select
        date('9999-01-01') as mm
         , round(sum("PrincipalRemaining")::numeric, 4) as "total"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2))::numeric, 4) as "2"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100))::numeric, 4) as "100"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5))::numeric, 4) as "5"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0))::numeric, 4) as "0"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3))::numeric, 4) as "3"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4))::numeric, 4) as "4"
         , round((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8))::numeric, 4) as "8"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2)) / sum("PrincipalRemaining"))::numeric, 4) as "2f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100)) / sum("PrincipalRemaining"))::numeric, 4) as "100f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5)) / sum("PrincipalRemaining"))::numeric, 4) as "5f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0)) / sum("PrincipalRemaining"))::numeric, 4) as "0f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3)) / sum("PrincipalRemaining"))::numeric, 4) as "3f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4)) / sum("PrincipalRemaining"))::numeric, 4) as "4f"
         , round(((sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8)) / sum("PrincipalRemaining"))::numeric, 4) as "8f"
    from e
)
,
i as (
    select
    *
    from g
    union all
    select
    *
    from h
    order by mm desc
)
select
*
from i