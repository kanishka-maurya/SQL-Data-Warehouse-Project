/* 
This Script:
    - Loads data from source CSV files into Bronze layer tables as part of the ETL process.
    - Captures total batch and individual table load durations for performance monitoring.
    - Includes structured TRY...CATCH error handling to ensure reliability.
    - Uses informative PRINT statements for real-time progress tracking.
    - Demonstrates key data engineering practices: automation, timing, and fault tolerance.
    - Ensures efficient, auditable, and resilient data ingestion.
    - Supports reliable downstream analytics by maintaining clean and traceable raw data.
    - Highlights the importance of engineering in scalable ETL pipeline design.
*/

create or alter procedure bronze.load_bronze
as
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
        print '>>>> truncating table: bronze.crm_cust_info'
        truncate table bronze.crm_cust_info
        print 'inserting data into: bronze.crm_cust_info'
        set @start_time = getdate()
        bulk insert bronze.crm_cust_info
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate()
        print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
        print '--------------------------------------------'


        print '--------------------------------------------'
        print '>>>> truncating table: bronze.crm_prd_info'
        truncate table bronze.crm_prd_info
        print 'inserting data into: bronze.crm_prd_info'
        set @start_time = getdate()
        bulk insert bronze.crm_prd_info
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate() 
        print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
        print '--------------------------------------------'


        print '--------------------------------------------'
        print '>>>> truncating table: bronze.crm_sales_details'
        truncate table bronze.crm_sales_details
        print 'inserting data into: bronze.crm_sales_details'
        set @start_time = getdate()
        bulk insert bronze.crm_sales_details
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate() 
        print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
        print '--------------------------------------------'


        print '-------------------------------------------------------'
        print 'loading erp tables....'
        print '-------------------------------------------------------'


        print '--------------------------------------------'
        print '>>>> truncating table: bronze.erp_cust_az12'
        truncate table bronze.erp_cust_az12
        print 'inserting data into: bronze.erp_cust_az12'
        set @start_time = getdate()
        bulk insert bronze.erp_cust_az12
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate()
        print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
        print '--------------------------------------------' 


        print '--------------------------------------------'
        print '>>>> truncating table: bronze.erp_loc_a101'
        truncate table bronze.erp_loc_a101
        print 'inserting data into: bronze.erp_loc_a101'
        set @start_time = getdate()
        bulk insert bronze.erp_loc_a101
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
        set @end_time = getdate()
        print 'loading duration: ' + cast(datediff(second, @start_time, @end_time) as varchar) + ' seconds'
        print '--------------------------------------------'


        print '--------------------------------------------'
        print '>>>> truncating table: bronze.erp_px_cat_g1v2'
        truncate table bronze.erp_px_cat_g1v2
        print 'inserting data into: bronze.erp_px_cat_g1v2'
        set @start_time = getdate()
        bulk insert bronze.erp_px_cat_g1v2
        from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );
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
        print 'error occurred during loading data in bronze layer....'
        print '======================================================='
        print 'error message: ' + error_message()
    end catch

end;
