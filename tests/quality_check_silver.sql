/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This scripts performs various quality checks for daa consistency, accuracy,
    and standardization accross the 'silver' schemas. It includes checks for:
    - Null or Duplicate primary keys.
    - Unwanted Spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading silver layer.
    - Investigate and resolve any discrepancies found during the checks.
================================================================================
*/

-- =============================================
-- Checking silver.crm_cust_info
-- =============================================

-- Checks for Nulls or Duplicates in Primary Key
-- Expectation: No result

SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 or cst_id IS NULL;


-- Check for unwanted spaces
-- Expectations: No results

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info


-- =============================================
-- Checking silver.crm_prd_info
-- =============================================

-- Checking for NULLs or Duplicates in Primary Key
-- Expectations: No Results

SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL;


-- Chinking for unwanted spaces
-- Expectations: No results
SELECT
	prd_nm
FROM
	silver.crm_prd_info
WHERE
	prd_nm != TRIM(prd_nm)

SELECT
	prd_cost
FROM
	silver.crm_prd_info
WHERE
	prd_cost < 0 or prd_cost IS NULL

-- Data Standardization and Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Checking for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT *
FROM silver.crm_prd_info



-- =============================================
-- Checking silver.crm_sales_detailso
-- =============================================


-- Check for unwanted spaces in sls_ord_num
-- Expectations: No results

SELECT 
	  sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price
  FROM silver.crm_sales_details
  WHERE sls_ord_num != TRIM(sls_ord_num)


-- Checks for columns available to connect with others tables
-- Expectation: No result

SELECT 
	  sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price
  FROM silver.crm_sales_details
  WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)



  SELECT 
	  sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_dt,
      sls_ship_dt,
      sls_due_dt,
      sls_sales,
      sls_quantity,
      sls_price
  FROM silver.crm_sales_details
  WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)




-- Checking for invalid Date Orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Checking Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, Zero, or Negative

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price



SELECT * FROM silver.crm_sales_details


-- =============================================
-- Checking silver.erp_cust_az12
-- =============================================

-- Identify Out-of-Range Dates

SELECT DISTINCT bdate
FROM silver.erp_cust_az12 
WHERE bdate < '1924-01-01' OR bdate > GETDATE()


-- Data Standardization

SELECT DISTINCT gen
FROM silver.erp_cust_az12


-- =============================================
-- Checking silver.erp_loc_a101
-- =============================================

-- Data Standardization

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry

-- =============================================
-- Checking silver.erp_px_cat_g1v2
-- =============================================

-- Checking Unwanted Spaces
-- Expectation:  No results
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization & Consistency
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2
