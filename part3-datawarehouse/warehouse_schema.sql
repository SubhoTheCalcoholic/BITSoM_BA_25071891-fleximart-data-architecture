
---

### **File: `part3-datawarehouse/warehouse_schema.sql`**
```sql
-- Data Warehouse Schema for FlexiMart Analytics
-- Database: fleximart_dw

CREATE DATABASE IF NOT EXISTS fleximart_dw;
USE fleximart_dw;

-- Dimension Table: Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10),
    day_of_month INT,
    week_number INT,
    month INT,
    month_name VARCHAR(10),
    quarter VARCHAR(2),
    year INT,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN DEFAULT FALSE,
    financial_quarter VARCHAR(4),
    financial_year VARCHAR(9),
    UNIQUE KEY idx_full_date (full_date),
    INDEX idx_year_month (year, month),
    INDEX idx_quarter (quarter, year)
);

-- Dimension Table: Product Dimension (SCD Type 2)
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY AUTO_INCREMENT,
    product_id VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    brand VARCHAR(50),
    unit_price DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    valid_from DATE NOT NULL,
    valid_to DATE,
    current_flag BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_product_id (product_id),
    INDEX idx_category (category),
    INDEX idx_current (current_flag),
    INDEX idx_valid_dates (valid_from, valid_to)
);

-- Dimension Table: Customer Dimension (SCD Type 1)
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    customer_segment VARCHAR(20),
    registration_date DATE,
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze',
    total_orders INT DEFAULT 0,
    total_spent DECIMAL(12,2) DEFAULT 0.00,
    last_order_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY idx_customer_id (customer_id),
    INDEX idx_city_state (city, state),
    INDEX idx_segment (customer_segment),
    INDEX idx_loyalty (loyalty_tier)
);

-- Fact Table: Sales Fact
CREATE TABLE fact_sales (
    sale_key INT PRIMARY KEY AUTO_INCREMENT,
    date_key INT NOT NULL,
    product_key INT NOT NULL,
    customer_key INT NOT NULL,
    quantity_sold INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL,
    order_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    INDEX idx_date (date_key),
    INDEX idx_product (product_key),
    INDEX idx_customer (customer_key),
    INDEX idx_order (order_number),
    INDEX idx_date_product (date_key, product_key),
    INDEX idx_customer_date (customer_key, date_key),
    CHECK (quantity_sold > 0),
    CHECK (unit_price >= 0),
    CHECK (total_amount >= 0)
);

-- Optional: Create a view for daily sales summary
CREATE VIEW vw_daily_sales AS
SELECT 
    d.full_date,
    d.day_of_week,
    d.month_name,
    d.quarter,
    d.year,
    COUNT(DISTINCT f.customer_key) as unique_customers,
    COUNT(DISTINCT f.product_key) as unique_products,
    SUM(f.quantity_sold) as total_quantity,
    SUM(f.total_amount) as total_revenue,
    AVG(f.unit_price) as avg_unit_price
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.full_date, d.day_of_week, d.month_name, d.quarter, d.year;

-- Optional: Create a view for product performance
CREATE VIEW vw_product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    COUNT(DISTINCT f.sale_key) as total_transactions,
    SUM(f.quantity_sold) as total_quantity_sold,
    SUM(f.total_amount) as total_revenue,
    AVG(f.unit_price) as avg_selling_price,
    p.unit_price as current_price
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
WHERE p.current_flag = TRUE
GROUP BY p.product_id, p.product_name, p.category, p.subcategory, p.brand, p.unit_price;
