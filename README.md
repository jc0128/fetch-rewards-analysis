# Fetch Rewards Analysis
This is an repository contains my solutions on unstructured data to provide analysis on transactional receipt data, clean and validate multiple datasets and generate insights via Python and SQL. 

## Problem Statement
1. **Data Transformation:** Review unstructured json files (*brands.json*, *users.json*, *receipt.json*) and process/clean the datasets.
2. **Data Modeling:** Build a new structure relational data model and diagram.
3. **SQL Queries for Business Operations:** Answer related business questions from a business stakeholder via SQL.
4. **Data Quality Checks:** Explore and identify data quality issues and resolve inconsitencies if possible.
5. **Stakeholder Comunnication:** Generate insights from the data and address/ ask questions to the stakeholder.


## Data Transformation (Converting .json files to .csv)
Looking through the json files, there are nested fields within the tables that need to be unnested or cleaned and converted to a format that is readible into a database. I created a jupyter notebook python file [View the SQL Queries](./to_csv.ipynb) to clean and normalize these json files provided. 

