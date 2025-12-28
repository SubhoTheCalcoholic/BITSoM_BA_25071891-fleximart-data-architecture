# BITSoM_BA_25071891-fleximart-data-architecture
# FlexiMart Data Architecture Project

**Student Name:** Subhodip Pal  
**Student ID:** BITSoM_BA_25071891   
**Email:** palsubhodip17.me@gmail.com 
**Date:** 4-Jan-2026

## Project Overview

This project implements a complete data architecture solution for FlexiMart, an e-commerce company. The solution includes:
1. An ETL pipeline to process raw CSV data into a normalized relational database
2. NoSQL database analysis and implementation using MongoDB
3. A star schema data warehouse with analytical capabilities

The project demonstrates end-to-end data engineering skills, from data ingestion to analytical reporting.

## Repository Structure
studentID-fleximart-data-architecture/
├── README.md # This documentation
├── .gitignore # Git ignore file
├── data/ # Input data files
│ ├── customers_raw.csv # Raw customer data
│ ├── products_raw.csv # Raw product data
│ └── sales_raw.csv # Raw sales data
├── part1-database-etl/ # Part 1: Database & ETL
│ ├── README.md # Part 1 instructions
│ ├── etl_pipeline.py # Complete ETL implementation
│ ├── schema_documentation.md # Database schema documentation
│ ├── business_queries.sql # Business SQL queries
│ ├── data_quality_report.txt # Generated ETL report
│ └── requirements.txt # Python dependencies
├── part2-nosql/ # Part 2: NoSQL Analysis
│ ├── README.md # Part 2 instructions
│ ├── nosql_analysis.md # NoSQL justification report
│ ├── mongodb_operations.js # MongoDB operations
│ └── products_catalog.json # Sample product data
└── part3-datawarehouse/ # Part 3: Data Warehouse
├── README.md # Part 3 instructions
├── star_schema_design.md # Star schema documentation
├── warehouse_schema.sql # Data warehouse schema
├── warehouse_data.sql # Sample warehouse data
└── analytics_queries.sql # OLAP analytical queries


## Technologies Used

- **Python 3.8+**: For ETL pipeline development
- **Pandas**: Data manipulation and cleaning
- **MySQL 8.0**: Relational database for operational data
- **MongoDB 6.0**: NoSQL database for product catalog
- **SQL**: For analytical queries and data warehouse operations
- **Git**: Version control

## Setup Instructions

### Prerequisites
1. Install Python 3.8 or higher
2. Install MySQL 8.0 or higher
3. Install MongoDB 6.0 or higher
4. Install Git

### Step 1: Clone the Repository
```bash
git clone https://github.com/[username]/[studentID]-fleximart-data-architecture.git
cd [studentID]-fleximart-data-architecture
```

### Step 2: Set Up Python Environment
```bash
# Install Python dependencies for Part 1
cd part1-database-etl
pip install -r requirements.txt
cd ..
```

### Step 3: Database Setup
**MySQL Setup (for Parts 1 & 3):** 
```bash
# Install Python dependencies for Part 1
cd part1-database-etl
pip install -r requirements.txt
cd ..
```

**MongoDB Setup (for Part 2):** 
```bash
# Start MongoDB service (if not running)
sudo systemctl start mongod
```

### Step 4: Run Part 1 - ETL Pipeline
```bash
cd part1-database-etl

# Update database credentials in etl_pipeline.py if needed
# Then run the ETL pipeline
python etl_pipeline.py

# Execute business queries
mysql -u root -p fleximart < business_queries.sql
```

### Step 5: Run Part 2 - NoSQL Operations
```bash
cd part2-nosql

# Import data into MongoDB
mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray

# Run MongoDB operations
mongosh < mongodb_operations.js
```

### Step 6: Run Part 3 - Data Warehouse
```bash
cd part3-datawarehouse

# Create data warehouse schema
mysql -u root -p fleximart_dw < warehouse_schema.sql

# Load sample data
mysql -u root -p fleximart_dw < warehouse_data.sql

# Run analytical queries
mysql -u root -p fleximart_dw < analytics_queries.sql
```

### Key Features
**Part 1: ETL Pipeline**

    Data Extraction: Reads CSV files with various data quality issues

    Data Transformation:

        Handles missing values and duplicates

        Standardizes phone and date formats

        Cleans and normalizes data

    Data Loading: Inserts cleaned data into MySQL database

    Data Quality Report: Generates detailed report of ETL process

**Part 2: NoSQL Analysis**

    Theory: Analysis of RDBMS limitations and NoSQL benefits

    Practical: MongoDB operations including:

        Data import from JSON

        Basic and complex queries

        Aggregation pipelines

        Update operations

**Part 3: Data Warehouse**

    Star Schema Design: Complete dimensional modeling

    SCD Implementation: Type 2 slowly changing dimensions for products

    OLAP Queries: Advanced analytical queries including:

        Drill-down analysis

        Product performance ranking

        Customer segmentation

        RFM analysis

### Key Learnings

    Data Engineering Fundamentals: Building end-to-end data pipelines from raw data to insights

    Database Design: Understanding normalization, denormalization, and schema design

    ETL Best Practices: Handling data quality issues and ensuring data integrity

    NoSQL Applications: When and how to use document databases effectively

    Data Warehousing: Designing star schemas for analytical processing

    Analytical SQL: Writing complex queries for business intelligence

### Challenges Faced

    Data Quality Issues: Handling inconsistent formats, missing values, and duplicates in raw data

    Database Integration: Managing connections and transactions between Python and MySQL

    SCD Implementation: Designing Type 2 slowly changing dimensions for historical tracking

    Performance Optimization: Ensuring queries perform well with large datasets

    Documentation: Creating clear, comprehensive documentation for all components
