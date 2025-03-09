-- Create Database 'DataWarehouse'

/*
==================================================
Create Database and Schemas
==================================================
Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the scripts sets up three schemas within the database: 'Bronze', 'Silver', and 'Gold'

Warning:
  Returning this script will drop the entire 'DataWarehouse' database if its exists.
  All Data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running thid script.

*/

USE master;

GO

-- Drop and Create the 'DataWarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO

-- Create the 'DataWarehouse' Database

CREATE DATABASE DataWarehouse;

GO

USE DataWarehouse;

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
