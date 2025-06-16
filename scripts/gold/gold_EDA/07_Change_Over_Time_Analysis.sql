/*
===============================================================================
change over time analysis
===============================================================================
purpose:
    - to track trends, growth, and changes in key metrics over time.
    - for time-series analysis and identifying seasonality.
    - to measure growth or decline over specific periods.

sql functions used:
    - date functions: datepart(), datetrunc(), format()
    - aggregate functions: sum(), count(), avg()
===============================================================================
*/

-- analyse sales performance over time
-- quick date functions
select
    year(order_date) as order_year,
    month(order_date) as order_month,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date);

-- datetrunc()
select
    datetrunc(month, order_date) as order_date,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date);

-- format()
select
    format(order_date, 'yyyy-MMM') as order_date,
    sum(sales_amount) as total_sales,
    count(distinct customer_key) as total_customers,
    sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by format(order_date, 'yyyy-MMM')
order by format(order_date, 'yyyy-MMM');
