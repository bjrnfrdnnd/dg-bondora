with a as (
    select "LoanPartId"
    , "PrincipalRemaining"
    , "LoanStatusCode"
    , "Interest"
    from "MyInvestmentItem"
)
,
b as (
    select
    "LoanPartId"
    , "AdditionDateTime"
    , "Interest"
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
    , sum(coalesce("PrincipalRemaining", 0)) as "PrincipalRemaining"
    , case when sum(coalesce("PrincipalRemaining", 0)) > 0 then sum("Interest" * "PrincipalRemaining") / sum(coalesce("PrincipalRemaining", 0)) else Null end as "MeanInterest"
    from d
    group by "LoanStatusCode", mm
    order by mm desc, "LoanStatusCode"
)
,
f as (
    select
        mm as mm
         , sum("PrincipalRemaining") as "total"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2) as "2"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100) as "100"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5) as "5"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0) as "0"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3) as "3"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4) as "4"
         , sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8) as "8"
         , coalesce(sum("MeanInterest" * "PrincipalRemaining") / sum("PrincipalRemaining"), null) as "totalMI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=2)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=2)), null) as "2MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=100)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=100)), null) as "100MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=5)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=5)), null) as "5MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=0)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=0)), null) as "0MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=3)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=3)), null) as "3MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=4)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=4)), null) as "4MI"
         , coalesce((sum("MeanInterest" * "PrincipalRemaining") FILTER (where "LoanStatusCode"=8)) / (sum("PrincipalRemaining") FILTER (where "LoanStatusCode"=8)), null) as "8MI"
    from e
            group by mm
)
,
g as (
    select
        case when mm is not null then mm else null end as mm
         , round(sum("total")::numeric, 4) as "total"
         , round(sum("2")::numeric, 4) as "2"
         , round(sum("100")::numeric, 4) as "100"
         , round(sum("5")::numeric, 4) as "5"
         , round(sum("0")::numeric, 4) as "0"
         , round(sum("3")::numeric, 4) as "3"
         , round(sum("4")::numeric, 4) as "4"
         , round(sum("8")::numeric, 4) as "8"
         , round((sum("2")/sum("total"))::numeric, 4) as "2f"
         , round((sum("100")/sum("total"))::numeric, 4) as "100f"
         , round((sum("5")/sum("total"))::numeric, 4) as "5f"
         , round((sum("0")/sum("total"))::numeric, 4) as "0f"
         , round((sum("3")/sum("total"))::numeric, 4) as "3f"
         , round((sum("4")/sum("total"))::numeric, 4) as "4f"
         , round((sum("8")/sum("total"))::numeric, 4) as "8f"
         , case when sum("total") > 0 then round((sum("totalMI" * "total") / sum("total"))::numeric, 4)  end as "totalMI"
         , case when sum("2") > 0 then round((sum("2MI" * "2") / sum("2"))::numeric, 4)  end as "2MI"
         , case when sum("100") > 0 then round((sum("100MI" * "100") / sum("100"))::numeric, 4)  end as "100MI"
         , case when sum("5") > 0 then round((sum("5MI" * "5") / sum("5"))::numeric, 4)  end as "5MI"
         , case when sum("0") > 0 then round((sum("0MI" * "0") / sum("0"))::numeric, 4)  end as "0MI"
         , case when sum("3") > 0 then round((sum("3MI" * "3") / sum("3"))::numeric, 4)  end as "3MI"
         , case when sum("4") > 0 then round((sum("4MI" * "4") / sum("4"))::numeric, 4)  end as "4MI"
         , case when sum("8") > 0 then round((sum("8MI" * "8") / sum("8"))::numeric, 4)  end as "8MI"
    from f
            group by case when mm is not null then mm else null end
)
,
h as (
    select
        date('9999-01-01') as mm
         , round(sum("total")::numeric, 4) as "total"
         , round(sum("2")::numeric, 4) as "2"
         , round(sum("100")::numeric, 4) as "100"
         , round(sum("5")::numeric, 4) as "5"
         , round(sum("0")::numeric, 4) as "0"
         , round(sum("3")::numeric, 4) as "3"
         , round(sum("4")::numeric, 4) as "4"
         , round(sum("8")::numeric, 4) as "8"
         , round((sum("2")/sum("total"))::numeric, 4) as "2f"
         , round((sum("100")/sum("total"))::numeric, 4) as "100f"
         , round((sum("5")/sum("total"))::numeric, 4) as "5f"
         , round((sum("0")/sum("total"))::numeric, 4) as "0f"
         , round((sum("3")/sum("total"))::numeric, 4) as "3f"
         , round((sum("4")/sum("total"))::numeric, 4) as "4f"
         , round((sum("8")/sum("total"))::numeric, 4) as "8f"
         , case when sum("total") > 0 then round((sum("totalMI" * "total") / sum("total"))::numeric, 4)  end as "totalMI"
         , case when sum("2") > 0 then round((sum("2MI" * "2") / sum("2"))::numeric, 4)  end as "2MI"
         , case when sum("100") > 0 then round((sum("100MI" * "100") / sum("100"))::numeric, 4)  end as "100MI"
         , case when sum("5") > 0 then round((sum("5MI" * "5") / sum("5"))::numeric, 4)  end as "5MI"
         , case when sum("0") > 0 then round((sum("0MI" * "0") / sum("0"))::numeric, 4)  end as "0MI"
         , case when sum("3") > 0 then round((sum("3MI" * "3") / sum("3"))::numeric, 4)  end as "3MI"
         , case when sum("4") > 0 then round((sum("4MI" * "4") / sum("4"))::numeric, 4)  end as "4MI"
         , case when sum("8") > 0 then round((sum("8MI" * "8") / sum("8"))::numeric, 4)  end as "8MI"
    from f
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