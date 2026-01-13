	--- 7 --- Change-Over-Time
-- Analyze how a measure evolves over time Helps
-- track trends and identify seasonality in your data
-- A high level overview that helps with strategic decision making

-- Analyze Sales Performance Over Time
-- By Year
select
year(order_date) as Order_Year,
sum(sales_amount) as Total_Sales,
count (distinct customer_key) as Total_Customers,
count(quantity) as Total_Quantity 
from gold.fact_sales
group by year(order_date)
order by Total_Sales desc

-- By Month
select
datetrunc(month,order_date) as Order_Month,
sum(sales_amount) as Total_Sales,
count (distinct customer_key) as Total_Customers,
count(quantity) as Total_Quantity 
from gold.fact_sales
group by datetrunc(month,order_date)
order by Total_Sales desc
