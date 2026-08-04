/*
===============================================================================
Script Name : init_database.sql
Purpose     : Creates the 'DataWarehouse' database (if it does not already
              exist) and sets up the three schemas used by the Medallion
              Architecture: bronze, silver, and gold.

Layers:
    bronze  -> Raw, unprocessed data as ingested from source systems.
    silver  -> Cleaned, standardized, and validated data.
    gold    -> Business-ready, aggregated data modeled as a Star Schema.

WARNING:
    Running this script will DROP the existing 'DataWarehouse' database
    if it already exists. All data in that database will be permanently
    deleted. Make sure you have a backup before running this script.
===============================================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
