# **Data Warehouse and Analytics Project**
Welcome to the **Data Warehouse and Analytics** Project repository! 🚀


Building a modern datawarehouse with SQL Server, including ETL processes, data modeling and analytics.

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio projec
highlights industry best practices in data engineering and analytics.

---

# Data Architecture
The design of the data architecture of this is based on Medallion Architecture **Bronze, Silver, and Gold layers**:

![Data Architecture](https://github.com/OpsyGotti/sql-data-warehouse-project/blob/main/docs/images/Data_Architecture.drawio.png)

1. **Bronze Layer**: This will store the data in its raw form from the data sources. Data will be ingested from CSV files into the SQL Server Database.
2. **Silver Layer**: This layer performs data cleansing, standardization, and normalization to ensure data quality and consistency for accurate analysis
3. **Gold Layer**: Stores business-ready data structured in a star schema, optimized for reporting and analytics.

## Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- ** Data Sources **: Import data from two source systems (ERP and CRM) provided as CSV files.
- ** Data Quality **: Cleanse and resolve data quality issues prior to analysis.
- ** Integration **: Combine both sources into a single, user-friendly data model designed for analytical queries.
- ** Scope **: Focus on the latest dataset only; historization of data is not required.
- ** Documentation **: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analytics)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- ** Customer Behavior **
- ** Product Performance **
- ** Sales Trends **

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

##

License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## * About Me

Hi there! I'm ** Opeyemi Abolade ** , also known as ** Opsy Gotti **. state other fun facts and professional facts
