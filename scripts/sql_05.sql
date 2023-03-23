select date("ListedOnDate") as "dd"
       , count(iddb) as "#"
       , sum("Buy"::int)  as "#Buy"
       , sum(case when "Buy" and "Success" then 1 else 0 end)  as "#Success"
       , sum(case when "Buy" and not "Success" then 1 else 0 end) as "#Failure"
       , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%Not Found: Item is not on sale%') then 1 else 0 end) as "#ItemNotFound"
        , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%Conflict: Cannot buy your own item%') then 1 else 0 end)  as "#OwnItem"
        , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%Timeout occurred%') then 1 else 0 end)  as "#timeout"
        , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%An unhandled exception occurred%') then 1 else 0 end)  as "#unhandled"
        , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%Not enough funds%') then 1 else 0 end)  as "#NotEnoughFunds"
        , sum(case when "Buy" and not "Success"
                           and "FailureReason" like ('%the failure message failed to print%') then 1 else 0 end)  as "#unprintable"
       , round(sum(case when "Buy" then  "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRBuy"
       , round(sum(case when "Success" then "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRSuccess"
       from "WhSecondMarketPublished"
       group by date("ListedOnDate")  order by date("ListedOnDate") desc
;

select *
--        , count(iddb) as "#"
--        , sum("Buy"::int)  as "#Buy"
--        , sum(case when "Buy" and ("FailureReason" is null or "FailureReason" not in ('Not Found: Item is not on sale')) then 1 else 0 end)  as "#BuyExceptItemNotFound"
--        , sum(case when "Success" then 1 else 0 end)  as "#Success"
--        , round(sum(case when "Buy" then  "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRBuy"
--        , round(sum(case when "Buy" and ("FailureReason" is null or "FailureReason" not in ('Not Found: Item is not on sale')) then "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRBuyExceptItemNotFound"
--        , round(sum(case when "Success" then "PrincipalRemaining" else 0 end)::numeric, 4)  as "PRSuccess"
       from "WhSecondMarketPublished"
--        group by date("ListedOnDate")  order by date("ListedOnDate") desc
;
