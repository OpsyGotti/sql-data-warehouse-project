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

- Naming Conventions: Use snake_case formatting - lowercase letters with underscores seperating words.
- Language: Only English language is allowed.
- Avoid Reserved Words: Refrain from using SQL reserved words as object names

# Table Naming Conventions

## Bronze Rules

- All names must start with the source system name, and table names must match their original names without renaming.
- `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Name of the source system (e.g., crm, erp).
  - `<entity>`: Exact table name from the source system.
  - Example: `crm_customer_info` → Customer information from the CRM system.
 
<'abc'>

`<category>_<entity>`
