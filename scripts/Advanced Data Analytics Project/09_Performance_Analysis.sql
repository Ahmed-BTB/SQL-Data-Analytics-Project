	--- 9 --- Performance Analysis
-- Comparing the current value to a target value.
-- Helps measure success and compare performance

/*Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales*/
with yearly_product_sales as (
select
	year(f.order_date) as Order_Year,
	p.product_name,
	f.product_key,
	sum(f.sales_amount) as Current_Sales,
	sum(f.quantity) as Total_orders,
	avg(sales_amount) as Average_sales
from gold.fact_sales f left join gold.dim_products p on f.product_key = p.product_key
group by f.product_key, p.product_name, year(f.order_date)
) 
select 
Order_Year,
product_name,
Current_Sales,
avg(current_sales) over (partition by product_name) as Average_Sales,
Current_Sales - avg(current_sales) over (partition by product_name) as diff_Avg,
case when Current_Sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Avg'
	 when Current_Sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Avg'
	 else 'Avg'
end avg_change,
-- Year-Over-Year Analysis
Current_Sales -lag(current_sales) over(partition by product_name order by product_name, Order_Year) as Performance,
case when Current_Sales -lag(current_sales) over(partition by product_name order by product_name, Order_Year) > 0 then 'Increasing'
	 when Current_Sales -lag(current_sales) over(partition by product_name order by product_name, Order_Year) < 0 then 'Decreasing'
	 else 'No Change'
end py_change
from yearly_product_sales
order by product_name, Order_Year
