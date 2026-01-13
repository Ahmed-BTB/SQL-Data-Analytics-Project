	--- 8 --- Cumilative Analysis
-- Aggregate the data progressively over time.
-- Helps to understand whether our buisiness is growing or declining

-- Over the years
select
year(order_date) as Order_Year,
Total_Sales,
sum( Total_sales) over (order by order_date asc) as Running_Total_Sales,
avg(avg_price) over (order by order_date ) as Moving_Average_Price
from
(
	select
	datetrunc(year,order_date) as Order_date,
	sum(sales_amount) as Total_Sales,
	count (distinct customer_key) as Total_Customers,
	count(quantity) as Total_Quantity,
	avg(price) as avg_price
	from gold.fact_sales
	group by datetrunc(year,order_date)
) t
  
-- Over the months of the same year
select
year(order_date) as Order_Year,
month(order_date) as Order_Month,
Total_Sales,
sum( Total_sales) over (partition by year(order_date) order by order_date asc) as Running_Total_Sales
from
(
	select
	datetrunc(month,order_date) as Order_date,
	sum(sales_amount) as Total_Sales,
	count (distinct customer_key) as Total_Customers,
	count(quantity) as Total_Quantity ,
	avg(price) as avg_price
	from gold.fact_sales
	group by datetrunc(month,order_date)
) t
