with days as
         (
             select distinct dd
             from (
                      (
                          select distinct date("AdditionDateTime") as dd
                          from "Investments"
                      )
                      union all
                      (
                          select distinct date("EndDateTime") as dd
                          from "Investments"
                          where "EndDateTime" is not null
                      )
                      union all
                      (
                          select date("ListedOnDate")
                          from "WhSecondMarketPublished"
                      )
                      union all
                      (
                          select date("AdditionDateTime") as dd
                          from "Investments"
                      )
                  ) AS t0
         )
,
SMBuys as (
    select date("AdditionDateTime") as dd
           , sum("AdditionPrincipal") as "SMBuys"
           , sum("AdditionPrincipal") - sum("AdditionPrice") as "SMBuysProfit"
           , sum(greatest("AdditionPrincipal" - "AdditionPrice", 0)) as "SMBuysProfitPos"
    from "Investments"
    where "InvestmentOrigin" = 'SecondMarket'
    group by date("AdditionDateTime")
    )
,
SMSells as (
    select date("EndDateTime")                                               as dd
         , sum("SoldInResale_Principal")                                     as "SMSells"
         , sum("SoldInResale_Price") - sum("SoldInResale_Principal")         as "SMSellsProfit"
         , sum(greatest("SoldInResale_Price" - "SoldInResale_Principal", 0)) as "SMSellsProfitPos"
    from "Investments"
    where "InvestmentStatus" = 'Sold'
    group by date("EndDateTime")
    )
,
AuctionBuys as (
    select date("AdditionDateTime") as dd
    , sum("AdditionPrincipal") as "AuctionBuys"
    from "Investments"
    where "InvestmentOrigin" = 'Auction'
    group by date("AdditionDateTime")
    )
,
ApiBuys as (
    select distinct date("BidRequestedDate")  as dd,
                    sum("ActualBidAmount")    as "Actual",
                    sum("RequestedBidAmount") as "Requested"
    from "BidSummary"
    group by dd
    )
,
ges as (
    select d.dd
         , coalesce(sb."SMBuys", 0)                                                                   as "SMBuys"
         , coalesce(sb."SMBuysProfit", 0)                                                             as "SMBuysProfit"
         , coalesce(sb."SMBuysProfitPos", 0)                                                          as "SMBuysProfitPos"
         , coalesce(ss."SMSells", 0)                                                                  as "SMSells"
         , coalesce(ss."SMSellsProfit", 0)                                                            as "SMSellsProfit"
         , coalesce(ss."SMSellsProfitPos", 0)                                                         as "SMSellsProfitPos"
         , coalesce(ab."AuctionBuys", 0)                                                              as "AuctionBuys"
         , coalesce(apb."Actual", 0)                                                                  as "Actual"
         , coalesce(apb."Requested", 0)                                                               as "Requested"
         , coalesce(ab."AuctionBuys", 0) - coalesce(apb."Actual", 0)                                  as "PMAndPProBuys"
         , coalesce(sb."SMBuysProfit", 0) + coalesce(ss."SMSellsProfit", 0)                           as "SMProfit"
         , (coalesce(ss."SMSellsProfitPos", 0) + coalesce(sb."SMBuysProfitPos", 0)) * (0.25 * 1.0625) as "SMTaxPos"
    from days d
             left join SMBuys sb
                       on d.dd = sb.dd
             left join SMSells ss
                       on d.dd = ss.dd
             left join AuctionBuys ab
                       on d.dd = ab.dd
             left join ApiBuys apb
                       on d.dd = apb.dd
)
,
ges2 as (
    select
    *
    , "SMProfit" - "SMTaxPos"  as "SMP2"
    from ges
    )
,
ges3 as (
    select
    dd
    , round("SMBuys"::numeric, 4) as "SMBuys"
    , round("AuctionBuys"::numeric, 4) as "AuctionBuys"
    , round("PMAndPProBuys"::numeric, 4) as "PMAndPProBuys"
     , round("Actual"::numeric, 4) as "ApiActual"
    , round("SMSells"::numeric, 4) as "SMSells"
    , round("SMP2"::numeric, 4) as "SMP2"
    , round("SMTaxPos"::numeric, 4) as "SMTaxPos"
    , round("SMProfit"::numeric, 4) as "SMProfit"
    , round("SMBuysProfit"::numeric, 4) as "SMBuysProfit"
    , round("SMBuysProfitPos"::numeric, 4) as "SMBuysProfitPos"
    , round("SMSellsProfit"::numeric, 4) as "SMSellsProfit"
    , round("SMSellsProfitPos"::numeric, 4) as "SMSellsProfitPos"
    , round("Requested"::numeric, 4) as "ApiRequested"
    from
    ges2
)
,
ges4 as (
select
       '0_month' as mm_s,
       date(DATE_TRUNC('month',dd))   AS mm,
       sum("SMP2") as "SMP2",
       sum("SMTaxPos") as "SMTaxPos",
       sum("SMProfit") as "SMProfit",
       sum("SMBuys") + sum("AuctionBuys") as "TotalBuys",
       sum("SMSells") as "SMSells",
       sum("SMBuys") as "SMBuys",
       sum("AuctionBuys") as "AuctionBuys"
    from
    ges3
    group by DATE_TRUNC('month',dd)
)
,
ges5 as (
select
       '1_year' as mm_s,
       date(date_trunc('year', dd)) as mm,
       sum("SMP2") as "SMP2",
       sum("SMTaxPos") as "SMTaxPos",
       sum("SMProfit") as "SMProfit",
       sum("SMBuys") + sum("AuctionBuys") as "TotalBuys",
       sum("SMSells") as "SMSells",
       sum("SMBuys") as "SMBuys",
       sum("AuctionBuys") as "AuctionBuys"
    from
    ges3
    group by date_trunc('year', dd)
)
,
ges6 as (
select
       '2_all' as mm_s,
       date('9999-01-01') as mm,
       sum("SMP2") as "SMP2",
       sum("SMTaxPos") as "SMTaxPos",
       sum("SMProfit") as "SMProfit",
       sum("SMBuys") + sum("AuctionBuys") as "TotalBuys",
       sum("SMSells") as "SMSells",
       sum("SMBuys") as "SMBuys",
       sum("AuctionBuys") as "AuctionBuys"
    from
    ges3
)
select
*
from
--     ges3
-- order by dd
     ges4
union
 select * from ges5
union
 select * from ges6
order by mm_s, mm desc

;