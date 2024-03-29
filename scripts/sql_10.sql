with a as (
    select '02_day' as "AggregationCategory"
         , date("ValidDateTime") as "AggregationDatetime"
         , avg("AccountValueApiLoanStatus2")    as "AccountValueApiLoanStatus2"
         , avg("AccountValueApiBondora")        as "AccountValueApiBondora"
         , avg("Fraction2")        as "Fraction2"
         , avg("PrincipalRemainingLoanStatus2") as "PrincipalRemainingLoanStatus2"
         , avg("PrincipalRemaining")            as "PrincipalRemaining"
         , avg("MeanInterestLoanStatus2")       as "MeanInterestLoanStatus2"
         , avg("MeanInterestBondora")           as "MeanInterestBondora"
         , avg("ProjectedMonthlyIncomeLoanStatus2") as "ProjectedMonthlyIncomeLoanStatus2"
         , avg("ProjectedMonthlyIncomeBondora")       as "ProjectedMonthlyIncomeBondora"
         , avg("TotalAvailableFromApi")         as "TotalAvailableFromApi"
    from "AccountSummary"
    group by date("ValidDateTime")
),
b as (
    select '01_month' as "AggregationCategory"
         , date(DATE_TRUNC('month', "ValidDateTime"))  as "AggregationDatetime"
         , avg("AccountValueApiLoanStatus2")    as "AccountValueApiLoanStatus2"
         , avg("AccountValueApiBondora")        as "AccountValueApiBondora"
         , avg("Fraction2")        as "Fraction2"
         , avg("PrincipalRemainingLoanStatus2") as "PrincipalRemainingLoanStatus2"
         , avg("PrincipalRemaining")            as "PrincipalRemaining"
         , avg("MeanInterestLoanStatus2")       as "MeanInterestLoanStatus2"
         , avg("MeanInterestBondora")           as "MeanInterestBondora"
         , avg("ProjectedMonthlyIncomeLoanStatus2") as "ProjectedMonthlyIncomeLoanStatus2"
         , avg("ProjectedMonthlyIncomeBondora")       as "ProjectedMonthlyIncomeBondora"
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