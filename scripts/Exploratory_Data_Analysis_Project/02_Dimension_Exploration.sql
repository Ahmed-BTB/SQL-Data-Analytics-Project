/*
===============================================================================
--- 2 --- Dimensions Exploration
===============================================================================
Objective:
    - Identify the unique values present in each dimension.
    - Understand how records can be grouped or segmented for analytical purposes.
    - Review the countries associated with customers.

SQL Functions Applied:
    - distinct
    - order by
===============================================================================
*/

select distinct country from gold.dim_customers

-- Explore All categories "The Major Devisions"
select distinct category,subcategory,product_name from gold.dim_products
order by 1,2,3
