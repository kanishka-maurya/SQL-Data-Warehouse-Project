/* 
===========================================================
Defining Tables within "bronze" Database using DDL.

Schema of a table must match the data definition of the source data to retain data 
without loss, truncation, or type mismatches during loading or migration processes.
===========================================================
*/

use bronze;

drop table if exists crm_cust_info;
create table crm_cust_info(
	cst_id int,
	cst_key varchar(50),
	cst_firstname varchar(50),
    cst_last_name varchar(50),
	cst_marital_status varchar(50),
	cst_gndr varchar(50),
	cst_create_date date
);

drop table if exists crm_prd_info;
create table crm_prd_info(
	prd_id int,
	prd_key varchar(50),
	prd_nm varchar(50),
    prd_cost int,
	prd_line varchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);

drop table if exists crm_sales_details;
create table crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key varchar(50),
	sls_cust_id int,
    sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
    sls_quantity int,
	sls_price int
);

drop table if exists erp_loc_a101;
create table erp_loc_a101(
	cid varchar(50),
	cntry varchar(50)
);

drop table if exists erp_cust_az12;
create table erp_cust_az12(
	cid varchar(50),
    bdate date,
	gen varchar(50)
);

drop table if exists erp_px_cat_g1v2;
create table erp_px_cat_g1v2(
	id varchar(50),
    cat varchar(50),
	subcat varchar(50),
    maintenance varchar(50)
);
