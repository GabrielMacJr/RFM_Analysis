/*Quickly inspecting the sales data*/
select top 100 * from [SalesRFMProject].[dbo].[salesdata] 

/*Inpecting dictinct (unique, nonrepetitive) values to better understand the data*/
select distinct ORDERNUMBER from [SalesRFMProject].[dbo].[salesdata]
select distinct QUANTITYORDERED from [SalesRFMProject].[dbo].[salesdata]
select distinct PRICEEACH from [SalesRFMProject].[dbo].[salesdata]
select distinct ORDERLINENUMBER from [SalesRFMProject].[dbo].[salesdata]
select distinct SALES from [SalesRFMProject].[dbo].[salesdata]
select distinct ORDERDATE from [SalesRFMProject].[dbo].[salesdata]
select distinct STATUS from [SalesRFMProject].[dbo].[salesdata]
select distinct QTR_ID from [SalesRFMProject].[dbo].[salesdata]
select distinct MONTH_ID from [SalesRFMProject].[dbo].[salesdata]
select distinct YEAR_ID from [SalesRFMProject].[dbo].[salesdata]
select distinct PRODUCTLINE from [SalesRFMProject].[dbo].[salesdata] 
select distinct MSRP from [SalesRFMProject].[dbo].[salesdata]
select distinct PRODUCTCODE from [SalesRFMProject].[dbo].[salesdata]
select distinct CUSTOMERNAME from [SalesRFMProject].[dbo].[salesdata]
select distinct PHONE from [SalesRFMProject].[dbo].[salesdata]
select distinct ADDRESSLINE1 from [SalesRFMProject].[dbo].[salesdata]
select distinct ADDRESSLINE2 from [SalesRFMProject].[dbo].[salesdata]
select distinct ADDRESSLINE2 from [SalesRFMProject].[dbo].[salesdata]
select distinct CITY from [SalesRFMProject].[dbo].[salesdata]
select distinct STATE from [SalesRFMProject].[dbo].[salesdata]
select distinct POSTALCODE from [SalesRFMProject].[dbo].[salesdata]
select distinct COUNTRY from [SalesRFMProject].[dbo].[salesdata]
select distinct TERRITORY from [SalesRFMProject].[dbo].[salesdata]
select distinct CONTACTLASTNAME from [SalesRFMProject].[dbo].[salesdata]
select distinct CONTACTFIRSTNAME from [SalesRFMProject].[dbo].[salesdata]
select distinct DEALSIZE from [SalesRFMProject].[dbo].[salesdata] 
/*By inspecting the columns for unique values, I noticed that there's
only 3 years of sales data (2003,2004,2005) . I will need to check if those three years
are complete; have 12 months. This is important because less months probably equates to less sales for that year
*/

/*Checking if all 3 years have 12 months*/
select distinct MONTH_ID from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2003
/*Year 2003 has data for the 12 months*/

select distinct MONTH_ID from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2004
/*Year 2004 has data for the 12 months*/

select distinct MONTH_ID from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2005
/*Year 2005 only has 5 months (Jan-May).*/

/*Checking the total sales for each year*/
select Year_ID, sum(SALES) Revenue
from [SalesRFMProject].[dbo].[salesdata]
group by Year_ID
order by Revenue Desc
/*Year 2004 had the highest revenue, followed by the revenue of 2003.
Year 2005 had the lowest revenue due to only having 5 months of sales data.
*/

/*What was the best month for sales in a specific year? How much was earned that month*/
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2004 --change year to see the rest
group by  MONTH_ID
order by 2 desc

select ORDERNUMBER, QUANTITYORDERED ,ORDERDATE, STATUS, SALES
from [SalesRFMProject].[dbo].[salesdata]
where CUSTOMERNAME = 'La Rochelle Gifts'



/*****Determining Recency*****/

/*What is recency? 
Recency: How recently a customer has made a purchase

To determine recency we need to take into account that the most recent order of the table was on 2005-05-31. 
Therefore, to find the most recent purchase of a customer, we will need to find how many days have
passed from the most recent purchase of a customer to the most recent order of the table (2005-05-31).
To accomplish this, the function DATEDIFF will be used and it will return the number of days that have passed.

Recency will have a lower value for the most recent purchase of a customer (Less days have passed)
Recency will have a higher value for the olders purchase of the customer (More days have passed)
*/

/**IMPORTANT**/
/*When ranking Recency on a scale of 1 through 5, it will be oraganized in a decesnding order, that way the most recent orders
will have a higher ranking.*/
select 
CUSTOMERNAME, 
min(ORDERDATE) Oldest_Order_of_Customer, 
max(ORDERDATE) Most_Recent_Order_of_Customer,
(select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata] max_order_date) Most_Recent_Order_of_Table, 
DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata])) Recency
from [SalesRFMProject].[dbo].[salesdata]
group by CUSTOMERNAME


/*****Determining Frequency*****/
/*What is frequency?
Frequency: How often a customer makes a purchase.
Frequency will be calculated by counting the number of orders.
*/

/**IMPORTANT**/
/*When ranking Frequency on a scale of 1 through 5, the higher the number of order, the higher the rank.
*/
select 
CUSTOMERNAME, 
count(ORDERNUMBER) Frequency
from [SalesRFMProject].[dbo].[salesdata]
group by CUSTOMERNAME

/*****Determining Monetary Value*****/
/*What is Monetary Value?
Monetary Value: How much money a customer spends on purchases.
Monetary Value will be calculated by the sum of sales*/
/**IMPORTANT**/
/*When ranking Monetary Value on a scale of 1 through 5, the higher the sum of sales, the higher the rank.
*/
select 
CUSTOMERNAME, 
sum(sales) MonetaryValue
from [SalesRFMProject].[dbo].[salesdata]
group by CUSTOMERNAME


DROP TABLE IF EXISTS #rfm
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata])) Recency
	from [SalesRFMProject].[dbo].[salesdata]
	group by CUSTOMERNAME
)
	select r.*,
		NTILE(5) OVER (order by Recency desc) rfm_recency,---Oraganized in a decesnding order, that way the most recent orders will have a higher rank---
		NTILE(5) OVER (order by Frequency) rfm_frequency,
		NTILE(5) OVER (order by MonetaryValue) rfm_monetary
	from rfm r


select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm

select 
CUSTOMERNAME, 
QUANTITYORDERED,
ORDERDATE, 
STATUS,DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata])) Recency
from [SalesRFMProject].[dbo].[salesdata]
where CUSTOMERNAME = 'La Rochelle Gifts'