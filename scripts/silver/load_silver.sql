create or alter procedure silver.load_silver as
begin
    declare @start_time datetime, @end_time datetime, @batch_start datetime, @batch_end datetime
        begin try 
            print '======================================================='
            print 'starting load procedure....'
            print '======================================================='


            print '-------------------------------------------------------'
            print 'loading crm tables....'
            print '-------------------------------------------------------'


            set @batch_start = getdate()
            print '--------------------------------------------'
            print '>>>>Truncating Table: silver.crm_cust_info';
            truncate table silver.crm_cust_info
            print '>>>> Inserting Data Into: silver.crm_cust_info';
            set @start_time = getdate()
            insert into silver.crm_cust_info(
                cst_id,
                cst_key,
                cst_firstname,
                cst_lastname,
                cst_marital_status,
                cst_gndr,
                cst_create_date
            )
            select 
            cst_id,
            cst_key,
            trim(cst_firstname) as cst_firstname,
            trim(cst_lastname) as cst_lastname,
            case
                when upper(trim(cst_marital_status)) = 'S' then 'Single'
                when upper(trim(cst_marital_status)) = 'M' then 'Married'
                else 'n/a'
            end cst_marital_status,
            case 
                when upper(trim(cst_gndr)) = 'F' then 'Female'
                when upper(trim(cst_gndr)) = 'M' then 'Male'
                else 'n/a'
            end cst_gndr, 
            cst_create_date
            from
            (select 
            *,
            row_number() over(partition by cst_id order by cst_create_date desc) as RecentDate
            from bronze.crm_cust_info) t
            where t.RecentDate = 1
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'


            print '--------------------------------------------'
            print '>>>> Truncating Table: silver.crm_prd_info';
            truncate table silver.crm_cust_info
            print '>>>> Inserting Data Into: silver.crm_prd_info';
            set @start_time = getdate()
            insert into silver.crm_prd_info(
                prd_id,
	            cat_id,
	            prd_key,
	            prd_nm,
                prd_cost,
	            prd_line,
	            prd_start_dt,
	            prd_end_dt
                )
            select 
            prd_id,
            replace(substring(prd_key, 1, 5),'-','_') as cat_id,
            substring(prd_key, 7, len(prd_key)) as prd_key,
            prd_nm,
            isnull(prd_cost,0) as prd_cost,
            case upper(trim(prd_line))
                when 'M' then 'Mountain'
                when 'R' then 'Road'
                when 'S' then 'Other Sales'
                when 'T' then 'Touring'
                else 'n/a'
            end prd_line,
            cast(prd_start_dt as date) as prd_start_dt,
            cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
            from bronze.crm_prd_info 
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'


            print '--------------------------------------------'
            print '>>>> Truncating Table: silver.crm_sales_details';
            truncate table silver.crm_cust_info
            print '>> Inserting Data Into: silver.crm_sales_details';
            set @start_time = getdate()
            insert into silver.crm_sales_details(
	            sls_ord_num,
	            sls_prd_key,
	            sls_cust_id,
                sls_order_dt,
	            sls_ship_dt,
	            sls_due_dt,
	            sls_sales,
                sls_quantity,
 	            sls_price
	            )
            select 
                sls_ord_num,
	            sls_prd_key,
	            sls_cust_id,
	            case
	                when sls_order_dt = 0 or len(sls_order_dt) != 8 then null 
		            else cast(cast(sls_order_dt as varchar) as date)
	            end as sls_order_dt,
	            case
	                when sls_order_dt = 0 or len(sls_ship_dt) != 8 then null 
		            else cast(cast(sls_ship_dt as varchar) as date)
	            end as sls_ship_dt,
	            case
	                when sls_due_dt = 0 or len(sls_due_dt) != 8 then null 
		            else cast(cast(sls_due_dt as varchar) as date)
	            end as sls_due_dt,
	            case 
	                when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) then sls_quantity*abs(sls_price) 
		            else sls_sales
                end as sls_sales,
                sls_quantity,
	            case 
	                when sls_price is null or sls_price <= 0
		            then sls_sales/nullif(sls_quantity,0)
	                else sls_price
	            end as sls_price
            from bronze.crm_sales_details
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'


            print '--------------------------------------------'
            print '>>>> Truncating Table: silver.erp_cust_az12';
            truncate table silver.crm_cust_info
            print '>>>> Inserting Data Into: silver.erp_cust_az12';
            set @start_time = getdate()
            insert into silver.erp_cust_az12 (cid, bdate, gen)
            select 
            case 
                when cid like 'NAS%' then substring(cid, 4,len(cid))
                else cid
            end as cid,
            case 
                when bdate > getdate() then null
                else bdate
            end as bdate,
            case 
                when upper(trim(gen)) in ('F','FEMALE') then 'Female'
                when upper(trim(gen)) in ('M','MALE') then 'Male' 
                else 'n/a'
            end as gen
            from bronze.erp_cust_az12
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'


            print '--------------------------------------------'
            print '>>>> Truncating Table: silver.erp_loc_a101';
            truncate table silver.crm_cust_info
            print '>>>> Inserting Data Into: silver.erp_loc_a101';
            set @start_time = getdate()
            insert into silver.erp_loc_a101
            (cid,cntry)
            select 
            replace(cid, '-', '') as cid,
            case 
                when trim(cntry) = 'DE' then 'Germany'
                when trim(cntry) in ('US','USA') then 'United States'
                when trim(cntry) = '' or cntry is null then 'n/a'
                else trim(cntry)
            end as cntry
            from bronze.erp_loc_a101
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'


            print '--------------------------------------------'
            print '>>>> Truncating Table: silver.erp_px_cat_g1v2';
            truncate table silver.crm_cust_info
            print '>>>> Inserting Data Into: silver.erp_px_cat_g1v2';
            set @start_time = getdate()
            insert into silver.erp_px_cat_g1v2
            (id, cat, subcat, maintenance)
            select * from bronze.erp_px_cat_g1v2
            set @end_time = getdate()
            print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
            print '--------------------------------------------'
            set @batch_end = getdate()


            print '-------------------------------------------------------'
            print 'loading ended....'
            print '-------------------------------------------------------'


            print '======================================================='
            print 'batch loading duration: ' + cast(datediff(second, @batch_start, @batch_end) as varchar) + ' seconds'
            print '======================================================='
        end try

        begin catch
            print '======================================================='
            print 'error occurred during loading data in silver layer....'
            print '======================================================='
            print 'error message: ' + error_message()
        end catch
              
end;
