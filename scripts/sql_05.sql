select date("ListedOnDate") as "dd",
       count(iddb) as "#",
       sum("Buy"::int)  as "#Buy",
       sum(case when "Buy" and ("FailureReason" is null or "FailureReason" not in ('Not Found: Item is not on sale')) then 1 else 0 end)  as "#BuyExceptItemNotFound",
       sum(case when "Success" then 1 else 0 end)  as "#Success",
       round(sum(case when "Buy" then  "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRBuy",
       round(sum(case when "Buy" and ("FailureReason" is null or "FailureReason" not in ('Not Found: Item is not on sale')) then "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRBuyExceptItemNotFound",
       round(sum(case when "Success" then "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRSuccess"
       from "WhSecondMarketPublished" group by date("ListedOnDate")  order by date("ListedOnDate") desc;

select sum("PrincipalRemaining"), sum("PrincipalRemaining")*0.3 from "MyInvestmentItem" where "LoanStatusCode" in (5)

