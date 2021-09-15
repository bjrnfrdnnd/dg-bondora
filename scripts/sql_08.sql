select
       "UserName"
    , sum("PrincipalRemaining") as spr
from "MyInvestmentItem"
group by "UserName"
 order by sum("PrincipalRemaining") desc