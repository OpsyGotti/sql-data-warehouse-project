# Naming Conventions

This document defines naming conventions for data warehouse objects, including schemas, tables, views, and columns

## Table of Contents

1. [General Principles](#General-Principles)
2. [Table Naming Conventions](#Table-Naming-Conventions)
     - [Bronze Rules](#Bronze-Rules)
     - [Silver Rules](#Silver-Rules)
     - [Gold Rules](#Gold-Rules)
3. [Column Naming Conventions](#Column-Naming-Conventions)
     - [Surrogate Keys](#Surrogate-Keys)
     - [Technical Columns](#Technical-Columns)
4. [Stored Procedure](#Stored-Procedure)

---

# General Principles 

- **Naming Conventions**: Use snake_case formatting - lowercase letters with underscores seperating words.
- **Language**: Only English language is allowed.
- **Avoid Reserved Words**: Refrain from using SQL reserved words as object names

---

# Table Naming Conventions

## Bronze Rules

- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the source system.
  - Example: `crm_customer_info` → Customer information from the CRM system.
 
## Silver Rules
- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**
   - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
   - `<entity>`: Exact table name from the source system.
   - Example: `crm_customer_info` → Customer information from the CRM system.

## Gold Rules
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**
   - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).
   - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).
   - Examples:
     - `dim_customers` → Dimension table for customer data.
     - `fact_sales` → Fact table containing sales transactions.

### Glossary of Category Patterns
| Pattern	| Meaning	| Example(s) |
|--- | --- | --- | 
| `dim_` | Dimension table |	`dim_customer`, `dim_product` |
| `fact_` | Fact table | `fact_sales` |
| `report_` | Report table | `report_customers`, `report_sales_monthly` |

---

# Column Naming Conventions

## Surrogate Keys
- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.
  - `_key`: A suffix indicating that this column is a surrogate key.
  - Example: `customer_key` → Surrogate key in the `dim_customers` table.
  - 
## Technical Columns
- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**
  - `dwh`: Prefix exclusively for system-generated metadata.
  - `<column_name>`: Descriptive name indicating the column's purpose.
  - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.

---

# Stored Procedure
- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example:
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
