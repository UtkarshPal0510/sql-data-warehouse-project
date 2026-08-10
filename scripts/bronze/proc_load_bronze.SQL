/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV 
    files. It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the BULK INSERT command to load data from CSV files to bronze tables.    
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME
  BEGIN TRY
  SET @batch_start_time=GETDATE()
PRINT'========================================================';
PRINT'LOADING BRONZE LAYER';
PRINT'========================================================';

PRINT'--------------------------------------------------------';
PRINT'LOADING CRM TABLES';
PRINT'--------------------------------------------------------';
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.crm_cust_info'
TRUNCATE TABLE bronze.crm_cust_info 
PRINT'Inserting Data Into bronze.crm_cust_info' 
BULK INSERT bronze.crm_cust_info 
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
WITH (
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT'----------'
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.crm_sales_details'
TRUNCATE TABLE bronze.crm_sales_details
PRINT'>> Inserting Data Into: bronze.crm_sales_details';
BULK INSERT bronze.crm_sales_details 
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
WITH (
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT '--------------'
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.crm_prd_info '
TRUNCATE TABLE bronze.crm_prd_info 
PRINT'>>Inserting Data Into: bronze.crm_prd_info' 
BULK INSERT bronze.crm_prd_info 
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
WITH (
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT'--------------'
PRINT'--------------------------------------------------------';
PRINT'LOADING ERP TABLES';
PRINT'--------------------------------------------------------';
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.erp_CUST_AZ12'
TRUNCATE TABLE bronze.erp_CUST_AZ12 
PRINT'>> Inserting Data Into:bronze.erp_CUST_AZ12';
BULK INSERT bronze.erp_CUST_AZ12 
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
WITH (
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT '-------------'
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.erp_LOC_a101'
TRUNCATE TABLE bronze.erp_LOC_a101
PRINT'>> Inserting Data Into:bronze.erp_LOC_a101'
BULK INSERT bronze.erp_LOC_a101 
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
WITH (
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      TABLOCK
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT '-------------'
SET @start_time=GETDATE();
PRINT '>> TRUNCATING THE TABLE:bronze.erp_PX_CAT_G1V2'
TRUNCATE TABLE bronze.erp_PX_CAT_G1V2
PRINT'>> Inserting Data Into:bronze.erp_PX_CAT_G1V2'
BULK INSERT bronze.erp_PX_CAT_G1V2
FROM 'C:\Data Warehouse Project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    TABLOCK,
    CODEPAGE = '65001'
);
SET @end_time=GETDATE();
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @start_time, @end_time) AS NVARCHAR)+ 'second'
PRINT '-------------'
SET @batch_end_time=GETDATE();
PRINT'=========================='
PRINT'Loading Bronze Layer is Completed'
PRINT'>> LOAD DURATION: ' +CAST(DATEDIFF(second , @batch_start_time, @batch_end_time) AS NVARCHAR)+ 'second'
PRINT '=========================='
  END TRY
  BEGIN CATCH 
  END CATCH
  PRINT'================================================='
  PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
  PRINT 'ERROR MESSAGE'+ERROR_MESSAGE();
  PRINT 'ERROR NUMBER'+CAST(ERROR_NUMBER()AS NVARCHAR) ;
  PRINT 'ERROR NUMBER'+CAST(ERROR_STATE() AS NVARCHAR);
  PRINT '================================================'
  END
  


GO 
EXEC bronze.load_bronze







