# Data Catalog – Gold Layer

The gold layer is the business-ready layer of the `DataWarehouse` database. It is modelled as a star schema: one fact view surrounded by two dimension views. All objects are views in the `gold` schema, built on top of the `silver` layer.

## Overview

| Object | Type | Purpose | Grain |
|---|---|---|---|
| `gold.dim_customers` | Dimension | Customer master combining CRM and ERP data | One row per customer |
| `gold.dim_products` | Dimension | Current product catalog with category details | One row per active product |
| `gold.fact_sales` | Fact | Transaction-level sales data | One row per order line |

---

## 1. gold.dim_customers

**Purpose:** Customer master combining CRM and ERP data.

**Sources:** `silver.crm_cust_info`, `silver.erp_CUST_AZ12`, `silver.erp_LOC_A101`

**Joins:** `LEFT JOIN` on `cst_key = CID` for both ERP tables.

| Column | Description | Source / Logic |
|---|---|---|
| `customer_key` | Surrogate key | `ROW_NUMBER() OVER (ORDER BY cst_id)` |
| `Customer_ID` | Internal customer ID from CRM | `cst_id` |
| `Customer_Number` | Alphanumeric customer identifier, used to join ERP tables | `cst_key` |
| `first_name` | Customer's first name | `cst_firstname` |
| `Customer_lastname` | Customer's last name | `cst_lastname` |
| `marital_status` | Marital status | `cst_marital_status` |
| `gender` | Gender. CRM is the master source; falls back to ERP, otherwise `n/a` | `CASE WHEN cst_gndr != 'n/a' THEN cst_gndr ELSE COALESCE(ca.gen, 'n/a') END` |
| `Birthdate` | Date of birth | `erp_CUST_AZ12.BDATE` |
| `country` | Country of residence | `erp_LOC_A101.CNTRY` |
| `create_date` | Date the customer record was created in CRM | `cst_create_date` |

---

## 2. gold.dim_products

**Purpose:** Current product catalog with category details. Historical product versions are excluded.

**Sources:** `silver.crm_prd_info`, `silver.erp_PX_CAT_G1V2`

**Joins:** `LEFT JOIN` on `cat_id = ID`.

**Filter:** `WHERE prd_end_dt IS NULL`

| Column | Description | Source / Logic |
|---|---|---|
| `Product_key` | Surrogate key | `ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key)` |
| `Product_id` | Internal product ID from CRM | `prd_id` |
| `Product_number` | Product code, used to join the fact table | `prd_key` |
| `Product_Name` | Product name | `prd_nm` |
| `Category_id` | Category identifier | `cat_id` |
| `Category` | Product category | `erp_PX_CAT_G1V2.CAT` |
| `Subcategory` | Product subcategory | `erp_PX_CAT_G1V2.SUBCAT` |
| `maintainace` | Whether the product requires maintenance | `erp_PX_CAT_G1V2.MAINTENANCE` |
| `cost` | Product cost | `prd_cost` |
| `Product_Line` | Product line (e.g. Mountain, Road) | `prd_line` |
| `product_start_date` | Date the product became active | `prd_start_dt` |

> **Note:** the column alias `maintainace` is misspelled in the current view definition. Update this catalog if it is renamed to `maintenance`.

---

## 3. gold.fact_sales

**Purpose:** Transaction-level sales facts, connecting to the dimensions through surrogate keys.

**Sources:** `silver.crm_sales_details`, `gold.dim_products`, `gold.dim_customers`

**Joins:**
- `LEFT JOIN gold.dim_products ON sls_prd_key = product_number`
- `LEFT JOIN gold.dim_customers ON sls_cust_id = Customer_ID`

| Column | Description | Source / Logic | Key |
|---|---|---|---|
| `Order_number` | Sales order number | `sls_ord_num` | |
| `product_key` | Links to `gold.dim_products.Product_key` | `dim_products.product_key` | FK |
| `customer_key` | Links to `gold.dim_customers.customer_key` | `dim_customers.customer_key` | FK |
| `Order_date` | Date the order was placed | `sls_order_dt` | |
| `shipping_date` | Date the order was shipped | `sls_ship_dt` | |
| `due_date` | Payment due date | `sls_due_dt` | |
| `Sales` | Total sales amount for the line | `sls_sales` | |
| `Quantity` | Units ordered | `sls_quantity` | |
| `sales_price` | Price per unit | `sls_price` | |

---

## Relationships

| From | To | Cardinality |
|---|---|---|
| `gold.fact_sales.customer_key` | `gold.dim_customers.customer_key` | Many-to-one |
| `gold.fact_sales.product_key` | `gold.dim_products.Product_key` | Many-to-one |
