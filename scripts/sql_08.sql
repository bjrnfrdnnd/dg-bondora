select
       "UserName"
    , sum("PrincipalRemaining") as spr
from "MyInvestmentItem"
where "MyInvestmentItem"."PrincipalRemaining" > 0
group by "UserName"
order by sum("PrincipalRemaining") desc

