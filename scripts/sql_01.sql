select "Id", "hash" from "WhScheduledPayment";
select "LoanPartId", count(iddb) from "InvestmentsListV2" group by "LoanPartId";
select "LoanPartId", count(iddb) from "MyInvestmentItem" group by "LoanPartId";