/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- ============================================================================
Checking 'silver.crm_cust_info'
-- ============================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT
	cst_id,
	COUNT (*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT 
	cst_firstname, 
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) and 
	  cst_firstname != TRIM(cst_firstname);


-- Data Standardization & Consistency
    
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Data Standardization & Consistency
    
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

-- CLEANING TASKS PERFORMED
-- 1. Remove Unwanted spaces: Removes unnecesary spaces to ensure data consistency and uniformity across all records.
-- 2. Data Normalisation & Standardisation: Maps coded values to meaningful, user-friendly descriptions
-- 3. Ensure only one record per entity by identifying and retaining the most relevant row.

-- ============================================================================
Checking 'silver.crm_prd_info'
-- ============================================================================

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Results

SELECT
	prd_id,
	COUNT (*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT (*) > 1 OR prd_id IS NULL;

-- CHECK FOR UNWANTED SPACES
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- CHECK NULL or Negative Numbers
-- Expectation: No Results

SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardisation & Consistency

SELECT DISTINCT 
	prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
-- End date must no be earlier than the start date

SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--TASKED ACHIEVED.

--1. Derive Columns: Create new columns based on calculations or transformation of existing ones
--2. Standardisation and Normalisation
--3. Handles null values
--4. Data Enrichment: Add new, relevant data to enhance the dataset for analysis (example: CAST(
--	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
--	AS DATE
--) AS prd_end_dt_test -- Calculate end date as one day before the next start date
	
-- ============================================================================
Checking 'silver.crm_sales_details'
-- ============================================================================

-- Check for Invalid Dates

SELECT * FROM silver.crm_sales_details;

SELECT
	NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 --produces zero values, therefore change to Null
	OR LEN(sls_order_dt) != 8
	OR sls_order_dt > 20500101 -- used to search for presence of outliers
	OR sls_order_Dt < 19000101;

SELECT
	sls_due_dt,
	NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 --produces zero values, therefore change to Null
	OR LEN(sls_due_dt) != 8
	OR sls_due_dt > 20500101 -- used to search for presence of outliers
	OR sls_due_dt < 19000101;
	
-- check for invalid date orders
SELECT 
	* 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
	OR sls_order_dt > sls_due_dt;

--Check for Data Consistency: Between Sales, Qantity and Price
-->> Sales = Quantity * Pric
--.. Values must not NULL, zero or negative

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL 
	OR sls_quantity IS NULL 
	OR sls_price IS NULL
	OR sls_sales <= 0 
	OR sls_quantity <= 0 
	OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- Identify out of range dates
-- Results: birthdates between 1924-01-01 and Today

SELECT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
	or bdate > GETDATE()

SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

--Data Standardization & Consistency

SELECT DISTINCT
cntry
FROM silver.erp_loc_a101
ORDER BY cntry

SELECT * FROM silver.erp_loc_a101

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- CHECK FOR unwanted spaces
-- Result: Nil

SELECT
*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(CAT) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

--Data Standardization & Consistency

SELECT DISTINCT
cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT
subcat
FROM silver. erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM silver. erp_px_cat_g1v2
