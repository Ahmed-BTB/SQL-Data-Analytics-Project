/*
===============================================================================
-- 1 -- Database Exploration
===============================================================================
Objective:
    - Examine the database layout, focusing on available tables and their schemas.
    - Review column definitions and metadata for selected tables.

System Views Utilized:
    - information_schema.tables
    - information_schema.columns
===============================================================================
*/

-- Explore all objects in the database
select * from information_schema.tables


-- Explore all columns in the database
select * from information_schema.columns
where table_name = 'dim_customers'
