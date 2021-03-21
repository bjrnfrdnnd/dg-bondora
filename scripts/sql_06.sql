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
    , DATE_TRUNC('month',"AdditionDateTime") AS mm
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
select
*
from f