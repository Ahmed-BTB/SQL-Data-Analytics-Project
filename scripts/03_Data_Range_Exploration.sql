/*
===============================================================================
--- 3 --- Date Range Exploration
===============================================================================
Objective:
    - Identify the earliest and latest values for important date fields.
    - Gain insight into the span of historical records available.

SQL Functions Applied:
    - min()
    - max()
    - datediff()
===============================================================================
*/

-- find the date of the first and last order
select 
	min(order_date) as first_order,
	max(order_date) as last_order,
	datediff(month,min(order_date), max(order_date)) as order_range_in_months
from gold.fact_sales

-- find the youngest and oldest customers
select
	datediff(year,min(birthdate),getdate()) as oldest_customer,
	datediff(year,max(birthdate),getdate()) as youngest_customer
from gold.dim_customers
