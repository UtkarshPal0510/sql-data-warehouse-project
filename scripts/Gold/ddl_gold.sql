/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    Creates the views for the Gold layer of the DataWarehouse (star schema).
    The Gold layer holds the final dimension and fact views, built by
    transforming and joining Silver layer tables.

    Views created:
        - gold.dim_customers
        - gold.dim_products
        - gold.fact_sales

    Each view is dropped first if it already exists, so the script is re-runnable.

Usage:
    Query these views directly for analytics and reporting.
===============================================================================
*/

USE DataWarehouse;
GO

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id              AS Customer_ID,
    ci.cst_key             AS Customer_Number,
    ci.cst_firstname       AS first_name,
    ci.cst_lastname        AS Customer_lastname,
    ci.cst_marital_status  AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr   -- CRM is the master for gender information
         ELSE COALESCE(ca.gen, 'n/a')
    END                    AS gender,
    ca.BDATE               AS Birthdate,
    la.CNTRY               AS country,
    ci.cst_create_date     AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 la
    ON ci.cst_key = la.CID;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS Product_key,
    pn.prd_id        AS Product_id,
    pn.prd_key       AS Product_number,
    pn.prd_nm        AS Product_Name,
    pn.cat_id        AS Category_id,
    pc.CAT           AS Category,
    pc.SUBCAT        AS Subcategory,
    pc.MAINTENANCE   AS maintainace,
    pn.prd_cost      AS cost,
    pn.prd_line      AS Product_Line,
    pn.prd_start_dt  AS product_start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_PX_CAT_G1V2 pc
    ON pn.cat_id = pc.ID
WHERE pn.prd_end_dt IS NULL;   -- Filter out all historical data
GO

-- =============================================================================
-- Create Fact: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num   AS Order_number,
    pr.Product_key   AS product_key,
    cu.customer_key  AS customer_key,
    sd.sls_order_dt  AS Order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS Sales,
    sd.sls_quantity  AS Quantity,
    sd.sls_price     AS sales_price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.Product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.Customer_ID;
GO
