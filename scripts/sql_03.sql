select EXTRACT("second" from (datetime_celery- "ListedOnDate")) as timediff_total, EXTRACT("second" from (datetime_flask- "ListedOnDate")) as timediff_flask, EXTRACT("second" from (datetime_celery- datetime_flask)) as timediff_celery_flask, * from "WhSecondMarketPublished";

SELECT
    md5(CAST((array_agg(f.* order by iddb)) AS text)) /* id is a primary key of table (to avoid random sorting) */
FROM
    "WhSecondMarketPublished" AS f;

select "Id", count(distinct iddb) from "WhSecondMarketPublished" group by "Id" order by "Id";
select "AuctionId", count(distinct iddb) from "WhSecondMarketPublished" group by "AuctionId" order by "AuctionId";

explain analyse select "Id", count(distinct iddb), md5(cast(array_agg(("ScheduledDate", "PrincipalAmount", "PrincipalAmountLeft", "InterestAmount", "IntrestAmountCarriedOver", "PenaltyAmountCarriedOver","TotalAmount") order by "ScheduledDate") AS text)) from "WhScheduledPayment" group by "Id" order by "Id";

select "Id", count(distinct iddb), md5(cast(array_agg(("ScheduledDate", "PrincipalAmount", "PrincipalAmountLeft", "InterestAmount", "IntrestAmountCarriedOver", "PenaltyAmountCarriedOver","TotalAmount") order by "ScheduledDate") AS text)) from "WhScheduledPayment" group by "Id" order by "Id";

select "AuctionId", count(distinct "Id") from "WhScheduledPayment" group by "AuctionId";

select "AuctionId", count(distinct "Id") as "Id", count(distinct hash) as hash from (select "AuctionId", "Id",
       md5(cast(array_agg(("ScheduledDate", "PrincipalAmount", "PrincipalAmountLeft", "InterestAmount", "IntrestAmountCarriedOver", "PenaltyAmountCarriedOver","TotalAmount") order by "ScheduledDate") AS text)) as hash
    from "WhScheduledPayment" group by "AuctionId", "Id") as t group by "AuctionId" order by "AuctionId";

select "AuctionId", "Id",
       encode(digest(cast(array_agg(row("ScheduledDate",
                                     "PrincipalAmount",
                                     "PrincipalAmountLeft",
                                     "InterestAmount",
                                     "IntrestAmountCarriedOver",
                                     "PenaltyAmountCarriedOver",
                                     "TotalAmount") order by "ScheduledDate") AS text), 'sha256'), 'base64') as hash
    from "WhScheduledPayment"  group by "AuctionId", "Id";

select "AuctionId", "Id",
       array_agg(("ScheduledDate",
                                     "PrincipalAmount",
                                     "PrincipalAmountLeft",
                                     "InterestAmount",
                                     "IntrestAmountCarriedOver",
                                     "PenaltyAmountCarriedOver",
                                     "TotalAmount") order by "ScheduledDate") as aa,
              array_length(array_agg(("ScheduledDate",
                                     "PrincipalAmount",
                                     "PrincipalAmountLeft",
                                     "InterestAmount",
                                     "IntrestAmountCarriedOver",
                                     "PenaltyAmountCarriedOver",
                                     "TotalAmount") order by "ScheduledDate"), 1) as ab
    from "WhScheduledPayment"  group by "AuctionId", "Id";

select "AuctionId", "Id",
       md5(cast(array_agg(("ScheduledDate", "PrincipalAmount", "PrincipalAmountLeft", "InterestAmount", "IntrestAmountCarriedOver", "PenaltyAmountCarriedOver","TotalAmount") order by "ScheduledDate") AS text)) as hash
    from "WhScheduledPayment"  group by "AuctionId", "Id";

create extension if not exists pgcrypto;
SELECT sha256('hello world!');
select encode(digest('123456Adrian Wapcaplet', 'sha256'), 'base64');

select
       tt.*,
       tt."PR" - tt."PrincipalRemaining" as diff
    from ( select
                  "AuctionId",
                  "Id",
                  max("ListedOnDate") as  "ListedOnDate",
                  min("ScheduledDate") as "minS",
                  max("ScheduledDate") as "maxS",
                  sum("PR") as "PR",
                  max("PrincipalRemaining") as "PrincipalRemaining",
                  max("Amount") as "Amount"
    from (select
                 t2.*,
                 t1."PrincipalRemaining",
                 t1."ListedOnDate",
                 t1."Amount"
    from   (select * from "WhSecondMarketPublished" where "AuctionId"='032e46db-f1ac-447c-b889-a5e800f01051') as t1 left join (select
                                                            "AuctionId",
                                                            "Id",
                                                            "PrincipalAmount" as "PR" ,
                                                            "ScheduledDate" from "WhScheduledPayment") as t2  on t1."Id" = t2."Id") as t
    where t."ScheduledDate" >= '2000-01-01'
    group by  t."AuctionId", t."Id") as tt;

select * from "WhScheduledPayment" where "Id" = 'c8a32501-b8e6-4735-b370-ac64018931b7';
select "ScheduledDate", "PrincipalAmount", "PrincipalAmountLeft", "PrincipalAmountLeft" + "PrincipalAmount" from "WhScheduledPayment" where "Id" = 'c8a32501-b8e6-4735-b370-ac64018931b7';


with data as (
  select
    date_trunc('day', "ScheduledDate") as day,
    "PrincipalAmount",
    "PrincipalAmountLeft"
  from "WhScheduledPayment" where "Id" = 'c8a32501-b8e6-4735-b370-ac64018931b7'
)

select day, "PrincipalAmount", "PrCumSum", "PrincipalAmountLeft", "PrCumSum" + "PrincipalAmountLeft" as "check" from(
select
  day,
       "PrincipalAmount",
  sum("PrincipalAmount") over (order by day asc rows between unbounded preceding and current row) as "PrCumSum",
    "PrincipalAmountLeft"
from data) as t;

select "Id", count(distinct hash) from "WhSecondMarketPublished" group by "Id";
select "AuctionId", count(distinct "Id") "#Id", count(distinct "hash_sp") as "#hash" from "WhSecondMarketPublished" group by "AuctionId";
select count(distinct "Id") "#Id", count(distinct "hash_sp") as "#hash_sp", count(distinct "AuctionId") "#AuctionId" from "WhSecondMarketPublished";
select count(distinct "Id") "#Id", count(distinct "hash") as "#hash", count(distinct "AuctionId") "#AuctionId" from "WhScheduledPayment";
update "WhSecondMarketPublished" set hash=NULL;