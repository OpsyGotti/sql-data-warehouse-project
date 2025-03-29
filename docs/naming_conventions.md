# Data Catalog for Gold

## Overview

The Gold Layer represents business-level data, designed to support analytical and reporting use cases. It includes dimension tables and fact tables tailored to specific business metrics.

---

**1. gold.dim_customers**
- Purpose: Stores customers details enriched with demographic and geographic data.
- Columns:

| Column Name | Data Type | Description |
|--- | --- | --- |
| customers_key | INT | Surrogate key uniquely identifying each customer record in the dimension table.|
| customer_id | INT | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name | NVARCHAR(50) | The cumstomer's first name, as recorded in the system. |
| last_name | NVARCHAR(50) | The customer's last name or family name. |
| country | NVARCHAR(50) | The country of residence for the customer (e.g. 'Germany'). |
| marital_Status | NVARCHAR(50) | The marital status of the customer (e.g. 'Married', 'Single'). |
| gender | NVARCHAR(50) | The gender of the customer (e.g. 'Male', 'Female', 'n/a'). |
| birthdate | DATE | The date of birthe of the customer, formatted as YYYY-MM-DD (e.g. 1971-10-06). |
| create_date | DATE | The date and time when the customer record was created in the system. |


\\\\\\\||||||||








