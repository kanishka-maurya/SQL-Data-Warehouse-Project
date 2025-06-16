/*
===============================================================================
database exploration
===============================================================================
purpose:
    - to explore the structure of the database, including the list of tables and their schemas.
    - to inspect the columns and metadata for specific tables.

table used:
    - information_schema.tables
    - information_schema.columns
===============================================================================
*/

-- retrieve a list of all tables in the database
select 
    table_catalog, 
    table_schema, 
    table_name, 
    table_type
from information_schema.tables;

-- retrieve all columns for a specific table (dim_customers)
select 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length
from information_schema.columns
where table_name = 'dim_customers';
