#!/bin/bash

# Create root directory
mkdir -p BITSoM_BA_25071891-fleximart-data-architecture
cd BITSoM_BA_25071891-fleximart-data-architecture || exit

# Root files
touch README.md .gitignore

# Data folder
mkdir -p data
touch data/customers_raw.csv data/products_raw.csv data/sales_raw.csv

# Part 1: Database ETL
mkdir -p part1-database-etl
touch part1-database-etl/README.md \
      part1-database-etl/etl_pipeline.py \
      part1-database-etl/schema_documentation.md \
      part1-database-etl/business_queries.sql \
      part1-database-etl/data_quality_report.txt \
      part1-database-etl/requirements.txt

# Part 2: NoSQL
mkdir -p part2-nosql
touch part2-nosql/README.md \
      part2-nosql/nosql_analysis.md \
      part2-nosql/mongodb_operations.js \
      part2-nosql/products_catalog.json

# Part 3: Data Warehouse
mkdir -p part3-datawarehouse
touch part3-datawarehouse/README.md \
      part3-datawarehouse/star_schema_design.md \
      part3-datawarehouse/warehouse_schema.sql \
      part3-datawarehouse/warehouse_data.sql \
      part3-datawarehouse/analytics_queries.sql

echo "✅ Project structure created successfully!"
