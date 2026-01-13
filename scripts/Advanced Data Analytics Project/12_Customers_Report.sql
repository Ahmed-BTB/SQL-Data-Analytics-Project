/* 
==================================================================================
Customer Report
==================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- Total orders
		- Total sales
		- Total quantity purchased
		- Total products
		- Lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==================================================================================		
*/
create view gold.report_customers as
with Base_Query as
(
/*--------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
--------------------------------------------------------------------------------*/
select 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	c.first_name + ' ' + c.last_name as Customer_Name,
	datediff(year, c.birthdate, getdate()) as Age
from gold.fact_sales f 
left join gold.dim_customers c
on c.customer_key = f.customer_key
where order_date is not null
), Customer_Aggregation as (
/*--------------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
--------------------------------------------------------------------------------*/
select
	customer_key,
	Customer_Number,
	Customer_Name,
	Age,
	count( distinct order_number) as Total_Orders,
	sum(sales_amount) as Total_Sales,
	sum(quantity) as Total_Quantity,
	count(distinct product_key) as Total_Products,
	max(order_date) as Last_Order_Date,
	datediff(month,min(order_date),max(order_date)) as Lifespan 
from Base_Query
group by
	customer_key,
	Customer_Number,
	Customer_Name,
	Age 
) 
select 
	customer_key,
	Customer_Number,
	Customer_Name,
	case when Age < 20 then 'Below 20 ' 
		 when Age between 20 and 29 then '20-29'
		 when Age between 30 and 39 then '30-39'
		 when Age between 40 and 49 then '40-49'
		 else '50 and above'
	end age_group,
	case when Total_Sales > 5000 and Lifespan > 12 then 'VIP'
		 when Total_Sales <= 5000 and Lifespan > 12 then 'Regular'
		 else 'New'
	end Customer_Segment,
	concat(datediff(month,Last_Order_Date,getdate()), ' Months') as Recency,
	Total_Orders,
	Total_Sales,
	Total_Quantity,
	Total_Products,
	Lifespan,
	-- compute average order value (AOV)
	case when total_sales = 0 then 0
		 else Total_Sales / Total_Orders
	end as Average_Order_Value,
	-- compute average monthly spend
	case when Lifespan = 0 then total_sales
		 else Total_Sales / Lifespan
	end as Average_Monthly_Spend
from Customer_Aggregation 
