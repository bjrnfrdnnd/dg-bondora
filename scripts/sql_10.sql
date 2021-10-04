with a as (
    select '01_day' as "AggregationCategory"
         , date("ValidDateTime") as "AggregationDatetime"
         , avg("AccountValueApiLoanStatus2")    as "AccountValueApiLoanStatus2"
         , avg("AccountValueApiBondora")        as "AccountValueApiBondora"
         , avg("PrincipalRemainingLoanStatus2") as "PrincipalRemainingLoanStatus2"
         , avg("PrincipalRemaining")            as "PrincipalRemaining"
         , avg("MeanInterestLoanStatus2")       as "MeanInterestLoanStatus2"
         , avg("MeanInterestBondora")           as "MeanInterestBondora"
         , avg("ProjecteMonthlyIncomeLoanStatus2") as "ProjectedMonthlyIncomeLoanStatus2"
         , avg("ProjecteMonthlyIncomeBondora")       as "ProjecteMonthlyIncomeBondora"
         , avg("TotalAvailableFromApi")         as "TotalAvailableFromApi"
    from "AccountSummary"
    group by date("ValidDateTime")
),
b as (
    select '02_month' as "AggregationCategory"
         , date(DATE_TRUNC('month', "ValidDateTime"))  as "AggregationDatetime"
         , avg("AccountValueApiLoanStatus2")    as "AccountValueApiLoanStatus2"
         , avg("AccountValueApiBondora")        as "AccountValueApiBondora"
         , avg("PrincipalRemainingLoanStatus2") as "PrincipalRemainingLoanStatus2"
         , avg("PrincipalRemaining")            as "PrincipalRemaining"
         , avg("MeanInterestLoanStatus2")       as "MeanInterestLoanStatus2"
         , avg("MeanInterestBondora")           as "MeanInterestBondora"
         , avg("ProjecteMonthlyIncomeLoanStatus2") as "ProjectedMonthlyIncomeLoanStatus2"
         , avg("ProjecteMonthlyIncomeBondora")       as "ProjecteMonthlyIncomeBondora"
         , avg("TotalAvailableFromApi")         as "TotalAvailableFromApi"
    from "AccountSummary"
    group by date(DATE_TRUNC('month', "ValidDateTime"))
)
select
       *
from a
union all
select
    *
from b
order by "AggregationCategory", "AggregationDatetime" desc ;