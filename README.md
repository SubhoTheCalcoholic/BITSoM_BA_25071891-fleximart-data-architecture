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
