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
         , sum("PrincipalRemaining") as "total"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2) as "2"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5) as "5"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100) as "100"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4) as "4"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2)) / sum("PrincipalRemaining") as "2f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5)) / sum("PrincipalRemaining") as "5f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100)) / sum("PrincipalRemaining") as "100f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4)) / sum("PrincipalRemaining") as "4f"
    from e
            group by mm
)
,
h as (
    select
        date('9999-01-01') as mm
         , sum("PrincipalRemaining") as "total"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2) as "2"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5) as "5"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100) as "100"
        , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4) as "4"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2)) / sum("PrincipalRemaining") as "2f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5)) / sum("PrincipalRemaining") as "5f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100)) / sum("PrincipalRemaining") as "100f"
        , (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4)) / sum("PrincipalRemaining") as "4f"
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