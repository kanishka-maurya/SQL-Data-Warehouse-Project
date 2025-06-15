/*
========================================================================
CUSTOMER REPORT
=========================================================================
Purpose:
    - This Report reflects key customer metrics and behaviors.

Key Points:
    1. Information such as names, gender, ages, and transaction details.
    2. Customer - level metrics aggregation:
        - total orders
        - total sales
        - total quantity purchased
        - lifespan (in months)
        - total products
    3. Customer Segmentation: (VIP, Regular, New) and age-groups.
    4. Variable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
=========================================================================
*/
-- ==========================
-- BASE TABLE PREPARATION
-- ==========================
if object_id('gold.report_customers', 'v') is not null
    drop view gold.report_customers;
go
create view gold.report_customers as 
with base_query as(
select 
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    concat(c.first_name,' ', c.last_name) as customer_name,
    c.birthdate,
    datediff(year, c.birthdate, getdate()) as age
from gold.fact_sales as f
left join gold.dim_customers c
on f.customer_key = c.customer_key
where order_date is not null)
, customer_segmentation as (
-- ====================================================================
-- CUSTOMER AGGREGATIONS: Summarizes key metrics at the customer level
-- ====================================================================
select 
customer_key,
customer_number,
customer_name,
age,
count(order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
datediff(month, min(order_date), max(order_date)) as lifespan,
count(product_key) as total_products,
max(order_date) as last_order_date
from base_query
group by 
        customer_key,
        customer_number,
        customer_name,
        age
)
select 
    customer_key,
    customer_number,
    customer_name,
    age,
    total_orders,
    total_sales,
    total_quantity,
    lifespan,
    total_products,
     case 
         when age < 20 then 'Under 20'
         when age between 20 and 29 then '20-29'
         when age between 30 and 39 then '30-39'
         when age between 40 and 49 then '40-49'
         else '50 and Above'
      end age_group,
      case 
         when lifespan > 12 and total_sales > 5000 then 'VIP'
         when lifespan >= 12 and total_sales <= 5000 then 'Regular'
         else 'New'
      end cust_segments,
      last_order_date,
      datediff(month, last_order_date, getdate()) as recency,
      -- average order value 
      case 
          when total_orders = 0 then 0
          else total_sales/total_orders 
      end avg_order_value,
      -- average monthly spend
      case 
          when lifespan = 0 then total_sales
          else total_sales/lifespan
      end as avg_monthly_spend
from customer_segmentation
