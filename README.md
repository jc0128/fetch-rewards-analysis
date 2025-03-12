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

![Fetch Rewards Data Model](https://github.com/user-attachments/assets/9ffb61b3-0c33-42c0-b58b-d0f18ff9199e){ width=500px }



