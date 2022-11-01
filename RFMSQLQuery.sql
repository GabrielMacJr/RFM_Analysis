/*Quickly inspecting the sales data*/
select top 100 * from [SalesRFMProject].[dbo].[salesdata] 

/*Inspecting distinct (unique, nonrepetitive) values to better understand the data*/
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
only 3 years of sales data (2003,2004,2005). I will need to check if those three years
are complete; have 12 months. This is important because less months probably equates to less sales for that year
*/

/*Checking if all 3 years have 12 months*/
select distinct MONTH_ID 
from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2003
/*Year 2003 has data for the 12 months*/

select distinct MONTH_ID 
from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2004
/*Year 2004 has data for the 12 months*/

select distinct MONTH_ID 
from [SalesRFMProject].[dbo].[salesdata]
where YEAR_ID = 2005
/*Year 2005 only has 5 months (Jan-May).*/

/*Checking the total sales for each year*/
select 
	Year_ID, 
	sum(SALES) Revenue
from [SalesRFMProject].[dbo].[salesdata]
group by Year_ID
order by Revenue Desc
/*Year 2004 had the highest revenue, followed by the revenue of 2003.
Year 2005 had the lowest revenue due to only having 5 months of sales data.
*/

/*****Determining Recency*****/
/*What is recency? 
Recency: How recently a customer has made a purchase

To determine recency, we need to take into account that the most recent order of the table was on 2005-05-31. 
Therefore, to find the most recent purchase of a customer, we will need to find how many days have
passed from the most recent purchase of a customer to the most recent order of the table (2005-05-31).
To accomplish this, the function DATEDIFF will be used, and it will return the number of days that have passed.

Recency will have a lower value for the most recent purchase of a customer (Less days have passed)
Recency will have a higher value for the oldest purchase of the customer (More days have passed)
*/

/**IMPORTANT**/
/*When ranking Recency on a scale of 1 through 5, it will be organized in a descending order, that way the most recent orders
will have a higher ranking.*/
select 
CUSTOMERNAME, 
min(ORDERDATE) Oldest_Order_of_Customer, 
max(ORDERDATE) Most_Recent_Order_Of_Customer,
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
/*When ranking Frequency on a scale of 1 through 5, the higher the number of orders, the higher the rank.
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


/**RFM Analysis**/
DROP TABLE IF EXISTS #rfm
;with rfm as 
(	
	select 
		CUSTOMERNAME, 
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [SalesRFMProject].[dbo].[salesdata])) Recency,
		count(ORDERNUMBER) Frequency,
		sum(sales) MonetaryValue
	from [SalesRFMProject].[dbo].[salesdata]
	group by CUSTOMERNAME
),
rfm_rank as
(
	select 
		rfm.*,
		NTILE(5) OVER (order by Recency desc) rfm_recency,/*Organized in a descending order, that way the most recent orders will have a higher rank*/
		NTILE(5) OVER (order by Frequency) rfm_frequency,
		NTILE(5) OVER (order by MonetaryValue) rfm_monetary
	from rfm 
)
select 
	rfm_rank.*,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar) rfm_string 
into #rfm /*Temporary table*/
from rfm_rank 

/*Switch case statement to assign ranking*/
select CUSTOMERNAME, rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_string in (155,144,133) then 'Lost big spender'
		when rfm_string in (111,112,132,132,112,122) then 'A lost customer'
		when rfm_string in (233,223,232,222,211,322,332,321,311) then 'Losing a customer'
		when rfm_string in (255,244,234,323,333,343,323) then 'A potential big spender'
        when rfm_string in (411,521,422,522,532,523,433,443,423,533,411) then 'New customer'
		when rfm_string in (454,444,344,345,335,355,445,455,545,544,534) then 'Big Spender'
		when rfm_string in (555) then 'Top Client'
	end segment 
from #rfm 
ORDER BY rfm_recency asc, rfm_frequency asc, rfm_monetary asc


