# Fetch Rewards Analysis
This is an repository contains my solutions on unstructured data to provide analysis on transactional receipt data, clean and validate multiple datasets and generate insights via Python and SQL. 

## Problem Statement
1. **Data Transformation:** Review unstructured json files (*brands.json*, *users.json*, *receipt.json*) and process/clean the datasets.
2. **Data Modeling:** Build a new structure relational data model and diagram.
3. **SQL Queries for Business Operations:** Answer related business questions from a business stakeholder via SQL.
4. **Data Quality Checks:** Explore and identify data quality issues and resolve inconsitencies if possible.
5. **Stakeholder Comunnication:** Generate insights from the data and address/ ask questions to the stakeholder.


## Data Transformation (Converting .json files to .csv)
Looking through the json files, there are nested fields within the tables that need to be unnested or cleaned and converted to a format that is readible into a database. 

I created a jupyter notebook python file: [to_csv.ipynb](./to_csv.ipynb) to clean and normalize these json files provided. I normalize the json files individually and export them to a .csv files. *(Note: you will need to comment out lines and put your file path to read in json files)*

I perform some normalization of the nested fields and addresssed any field naming issues like lowercasing and taking '$' out. 

After reviewing the unstructured json files, I discovered there is a nested table in the receipts.json file that can be extracted separately into another table by itself from the *rewards_receipt_item_list field*.

Here are the exported .csv files that are cleaned:
- [Brands.csv](./brands.csv)
- [Users.csv](./users.csv)
- [Receipts.csv](./receipts.csv)
- [Receipt Items List.csv](./receipt_items_list.csv)


## Data Modeling (Creating Relational Data Model Diagram)

After transforming the jsons into a readable format, I am able to create a relational diagram on the tables based on primary and forien keys I have identified:

1.**Brands:**
- Primary Key: *brand_id*
- Foreign Keys: *brand_code* (This could be used as a joinable key but, it is not advised).
2. **Users:**
- Primary Key: *user_id*
3. **Receipts:**
- Primary Key: *receipt_id*   Foreign Keys: *user_id*
4. **Receipt Items List:**
- Primary Key: *list_id* (This is a created SKEY to create a unique key)
- Foreign Keys: *receipt_id*


<img src="./Fetch_Rewards_Data_Model.png" alt="ER Diagram" width="800" height="auto">
Here is a link to the DBDiagram in more context: 

[Fetch Reward Data Model](https://dbdiagram.io/d/67d06dea75d75cc844b1f917)






