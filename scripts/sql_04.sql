-- select "LoanPartId", count(distinct "ValidDateTime"), count (distinct "LoanStatusCode") from "MyInvestmentItem" group by "LoanPartId";
-- select "LoanPartId", count(distinct "ValidDateTime"), count (distinct "LoanStatusCode") as cnt_lsc from "MyInvestmentItem" WHERE "LoanStatusCode"=2 group by "LoanPartId" having count (distinct "LoanStatusCode")=1;
-- select "Id", count(distinct hash) from "WhSubtableScheduledPayments" group by "Id";
-- select "hash", count(distinct "Id") from "WhSubtableScheduledPayments" group by "hash";
-- select count(distinct "hash"), count(distinct "Id") from "WhSubtableScheduledPayments";
select count(*), count(distinct "Id") as "Id_sm", count(distinct "hash_sp") as "hash_sp", count(distinct "hash_lt") as "hash_lt", count(distinct "hash_dme") as "hash_dme"  from "WhSecondMarketPublished";

select "Id", count (distinct iddb) as iddb, count(distinct "hash_sp") as "hash_sp", count(distinct "hash_lt") as "hash_lt", count(distinct "hash_dme") as "hash_dme" from "WhSecondMarketPublished" group by "Id" ;
-- select hash_sp, count(distinct "hash_lt") from "WhSecondMarketPublished" group by hash_sp;
-- select "Id", count(distinct iddb) from "WhSecondMarketPublished" group by "Id"
--
-- select "LoanPartId", * from "MyInvestmentItem" where "LoanStatusCode"=4;
-- select * from "InvestmentsListReportLineV2" where "LoanPartId" in (select "LoanPartId" from "MyInvestmentItem" where "LoanStatusCode"=4)
-- select * from "RepaymentsReportLine" where "LoanPartId" in (select "LoanPartId" from "MyInvestmentItem" where "LoanStatusCode"=4)
-- select "LoanPartId", count(iddb) from "RepaymentsReportLine" where "LoanPartId" in (select "LoanPartId" from "MyInvestmentItem" where "LoanStatusCode"=4) group by "LoanPartId"
--
-- select "LoanPartId", "BoughtFromResale_Date", "SoldInResale_Date", count(distinct iddb) from "RlInvestmentsListReportLineV2" group by "LoanPartId", "BoughtFromResale_Date", "SoldInResale_Date"
select "LoanPartId", count(distinct iddb) from "RlInvestmentsListReportLineV2"  group by "LoanPartId";
select "LoanPartId", count(distinct iddb) from "MyInvestmentItem"  group by "LoanPartId";

SELECT EXTRACT("second" from (datetime_celery - "ListedOnDate"))*1000 as num from "WhSecondMarketPublished";

SELECT dd, sum("Amount") as sum_amt from (select "BiddingStartedOn", "LoanPartId","AuctionId", "Amount", date("BiddingStartedOn") as dd
from "RlInvestmentsListReportLineV2" where "BoughtFromResale_Date" is null) as t where dd <= '2020-11-30' and dd >= '2020-11-15'
group by dd;

SELECT avg(sum_amt) from  (select dd, sum("Amount") as sum_amt from (select "BiddingStartedOn", "LoanPartId","AuctionId", "Amount", date("BiddingStartedOn") as dd
from "RlInvestmentsListReportLineV2" where "BoughtFromResale_Date" is null) as t where dd <= '2020-11-30' and dd >= '2020-11-15'
group by dd) as tt;

SELECT dd, sum("Amount") as sum_amt from (select "BiddingStartedOn", "LoanPartId","AuctionId", "Amount", date("BiddingStartedOn") as dd
from "RlInvestmentsListReportLineV2" where "BoughtFromResale_Date" is null) as t where dd <= '2020-09-27' and dd >= '2020-09-19'
group by dd;

SELECT avg(sum_amt) from  (select dd, sum("Amount") as sum_amt from (select "BiddingStartedOn", "LoanPartId","AuctionId", "Amount", date("BiddingStartedOn") as dd
from "RlInvestmentsListReportLineV2" where "BoughtFromResale_Date" is null) as t where dd <= '2020-09-27' and dd >= '2020-09-19'
group by dd) as tt;

select "LoanPartId",
       "BoughtFromResale_Date",
       "SoldInResale_Date",
    count(distinct iddb),
       count(distinct "LoanPartId")
from "RlInvestmentsListReportLineV2" where "BoughtFromResale_Date" is not null and "SoldInResale_Date" is not null  and "BoughtFromResale_Date" > "SoldInResale_Date" group by "LoanPartId", "BoughtFromResale_Date", "SoldInResale_Date";

select date("ListedOnUTC") as dd, count(distinct "AuctionId") as "#Auction" , sum("AppliedAmount") as "AppliedAmount" from "WhAuctionPublished" group by date("ListedOnUTC") order by date("ListedOnUTC") desc;

select t1."LoanPartId" as "LPID_SMP", t2."LoanPartId" as "LPID_RL" from (select "LoanPartId" from "WhSecondMarketPublished" where date("ListedOnDate") = '2020-12-10' and "Success"=true) as t1
    full outer join
    (select "LoanPartId" from "RlInvestmentsListReportLineV2" where date("BoughtFromResale_Date") = '2020-12-10') as t2
    on t1."LoanPartId" = t2."LoanPartId";

select "LoanPartId",  CAST("AuctionNumber" AS text)||'-'||CAST("AuctionBidNumber" AS text) as "InvestmentNumber",  count(distinct "iddb") from "RlInvestmentsListReportLineV2" group by "LoanPartId", "AuctionNumber", "AuctionBidNumber";


select distinct "Status" from "RlInvestmentsListReportLineV2";

select t1."InvestmentNumber", t1."ListedOnDate", t2.* from "WhSecondMarketPublished" as t1 left join "Investments" as t2 on t1."InvestmentNumber"=t2."InvestmentNumber"  where t1."Success"=True order by t1."ListedOnDate" DESC

-- select t1.*, t2.* from "Investments" as t1 left join "RlRepaymentsReportLine" as t2 on t1."LoanPartId" = t2."LoanPartId" and t1."AdditionDateTime" <= t2."Date" and

select "LoanPartId", count(distinct iddb) from "Investments" group by "LoanPartId";

select "LoanPartId", COUNT(iddb) from "RlRepaymentsReportLine" group by "LoanPartId"

select "LoanPartId", COUNT("InvestmentStatus") from "Investments" group by "LoanPartId"

select sum("PrincipalRemaining") from "MyInvestmentItem" where "LoanStatusCode"=5;

SELECT "Investments"."LoanPartId" AS "LoanPartId", "Investments"."AdditionDateTime" AS "AdditionDateTime", "Investments"."AdditionDateTime" AS "DateTime", "Investments"."AdditionPrice" AS "Amount", "Investments"."InvestmentStatus" AS "InvestmentStatus"
FROM "Investments";

delete from "RlInvestmentsListReportLineV2" where "LoanPartId" not in ('bab7bf78-82ae-4c1a-9a09-ac6a010a7e41');
select "LoanPartId", "BoughtFromResale_Date" from "RlInvestmentsListReportLineV2";
select distinct "LoanStatusCode" from "MyInvestmentItem";

select datetime_celery - datetime_flask, datetime_flask, "ListedOnDate" from "WhSecondMarketPublished" order by datetime_flask desc;

select
       date("AdditionDateTime"),
       sum(greatest("SoldInResale_Price" - "SoldInResale_Principal", 0)) as "SMSellsProfitPos",
              sum(greatest("AdditionPrincipal" - "AdditionPrice", 0)) as "SMBuysProfitPos"
from "Investments"
        group by date("AdditionDateTime")