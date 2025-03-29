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
HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Check for unwanted Spaces
-- Expectation: No Results
    
SELECT 
	cst_firstname, 
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) and 
	  cst_firstname != TRIM(cst_firstname)


-- Data Standardization & Consistency
    
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

-- Data Standardization & Consistency
    
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

-- CLEANING TASKS PERFORMED
-- 1. Remove Unwanted spaces: Removes unnecesary spaces to ensure data consistency and uniformity across all records.
-- 2. Data Normalisation & Standardisation: Maps coded values to meaningful, user-friendly descriptions
-- 3. Ensure only one record per entity by identifying and retaining the most relevant row.
