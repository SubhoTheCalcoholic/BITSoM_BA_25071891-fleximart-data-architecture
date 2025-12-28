# Star Schema Design Documentation
## FlexiMart Data Warehouse

## Section 1: Schema Overview

### FACT TABLE: fact_sales
**Grain:** One row per product per order line item  
**Business Process:** Sales transactions analysis  
**Refresh Frequency:** Daily incremental load  

**Measures (Numeric Facts):**
- `quantity_sold`: Number of units sold (Integer, Not Null)
- `unit_price`: Price per unit at time of sale (Decimal(10,2), Not Null)
- `discount_amount`: Discount applied to line item (Decimal(10,2), Default: 0)
- `total_amount`: Final amount (quantity × unit_price - discount) (Decimal(10,2), Not Null)

**Foreign Keys:**
- `date_key` → `dim_date.date_key` (Integer, Not Null)
- `product_key` → `dim_product.product_key` (Integer, Not Null)
- `customer_key` → `dim_customer.customer_key` (Integer, Not Null)

**Surrogate Key:**
- `sale_key`: Primary key, auto-incrementing integer

**Degenerate Dimension:**
- `order_number`: Business order identifier (Optional, for traceability)

---

### DIMENSION TABLE: dim_date
**Purpose:** Date dimension for time-based analysis  
**Type:** Conformed dimension (shared across all fact tables)  
**Population:** Pre-populated for several years  
**Granularity:** Day level  

**Attributes:**
- `date_key` (PK): Surrogate key (integer, format: YYYYMMDD)
- `full_date`: Actual date (Date, Not Null)
- `day_of_week`: Monday, Tuesday, etc. (Varchar(10))
- `day_of_month`: 1-31 (Integer)
- `week_number`: 1-53 (Integer)
- `month`: 1-12 (Integer)
- `month_name`: January, February, etc. (Varchar(10))
- `quarter`: Q1, Q2, Q3, Q4 (Varchar(2))
- `year`: 2023, 2024, etc. (Integer)
- `is_weekend`: Boolean (True for Saturday/Sunday)
- `is_holiday`: Boolean (Flag for public holidays)
- `financial_quarter`: FYQ1, FYQ2, etc. (Financial year quarters)
- `financial_year`: 2023-24, 2024-25, etc. (Varchar(9))

---

### DIMENSION TABLE: dim_product
**Purpose:** Product dimension for product analysis  
**Type:** Slowly Changing Dimension Type 2 (for price changes)  
**Population:** From operational products table  

**Attributes:**
- `product_key` (PK): Surrogate key (Integer, Auto-increment)
- `product_id`: Natural key from source (Varchar(20))
- `product_name`: Name of product (Varchar(100))
- `category`: Main category (Electronics, Fashion, Groceries) (Varchar(50))
- `subcategory`: Sub-category (Smartphones, Laptops, etc.) (Varchar(50))
- `brand`: Product brand (Varchar(50))
- `unit_price`: Current price (Decimal(10,2))
- `is_active`: Boolean (True for active products)
- `valid_from`: Start date for this version (Date)
- `valid_to`: End date for this version (Date, Null for current)
- `current_flag`: Boolean (True for current version)

**SCD Type 2 Implementation:** 
- When product price changes, a new record is inserted with new valid_from date
- Previous record's valid_to is updated and current_flag set to False

---

### DIMENSION TABLE: dim_customer
**Purpose:** Customer dimension for customer analysis  
**Type:** Slowly Changing Dimension Type 1 (overwrite)  
**Population:** From operational customers table  

**Attributes:**
- `customer_key` (PK): Surrogate key (Integer, Auto-increment)
- `customer_id`: Natural key from source (Varchar(20))
- `customer_name`: Full name (Varchar(100))
- `city`: Customer city (Varchar(50))
- `state`: Customer state (Varchar(50))
- `country`: Country (Varchar(50), Default: 'India')
- `customer_segment`: High/Medium/Low value (Varchar(20))
- `registration_date`: Date of registration (Date)
- `loyalty_tier`: Bronze/Silver/Gold/Platinum (Varchar(20))
- `total_orders`: Number of orders placed (Integer, Derived)
- `total_spent`: Total amount spent (Decimal(10,2), Derived)

---

## Section 2: Design Decisions (150 words)

**Granularity Choice:** I chose transaction line-item level granularity because it provides maximum analytical flexibility. This allows drill-down to individual product sales while supporting roll-up to orders, customers, time periods, and categories. Business questions like "which specific products sold well on weekends?" require this detailed level.

**Surrogate Keys:** Surrogate keys were chosen over natural keys for several reasons: 1) Performance - integer joins are faster than string joins, 2) Stability - business keys can change (product codes may be reused), 3) Integration - different source systems may use different keys for same entities, 4) SCD support - essential for Type 2 dimensions.

**Drill-down/Roll-up Support:** The star schema naturally supports OLAP operations. Drill-down: Year → Quarter → Month → Day, or Category → Subcategory → Product. Roll-up: Product → Category → All Products. Dimension hierarchies (date hierarchy: Year-Quarter-Month-Day) enable intuitive navigation. Pre-aggregated columns in dimensions (total_orders in dim_customer) support rapid summarization without fact table scans.

**Denormalization:** Dimensions are deliberately denormalized to avoid joins during queries. All customer attributes are in one table, all product attributes in another. This trades storage efficiency for query performance - a classic data warehouse trade-off.

---

## Section 3: Sample Data Flow

**Source Transaction in Operational System:**


**ETL Process Steps:**

1. **Customer Lookup:** 
   - Query: `SELECT customer_key FROM dim_customer WHERE customer_id = 'C001'`
   - Result: customer_key = 12

2. **Product Lookup (with SCD Type 2):**
   - Query: `SELECT product_key FROM dim_product WHERE product_id = 'P001' AND current_flag = TRUE`
   - Result: product_key = 5

3. **Date Lookup:**
   - Query: `SELECT date_key FROM dim_date WHERE full_date = '2024-01-15'`
   - Result: date_key = 20240115

4. **Fact Table Insert:**
```sql
INSERT INTO fact_sales (date_key, product_key, customer_key, 
                       quantity_sold, unit_price, total_amount)
VALUES (20240115, 5, 12, 2, 45999.00, 91998.00);


##Resulting Star Schema Data:

fact_sales:
sale_key: 1001
date_key: 20240115
product_key: 5
customer_key: 12
quantity_sold: 2
unit_price: 45999.00
discount_amount: 0.00
total_amount: 91998.00

dim_date:
date_key: 20240115
full_date: '2024-01-15'
day_of_week: 'Monday'
day_of_month: 15
month: 1
month_name: 'January'
quarter: 'Q1'
year: 2024
is_weekend: FALSE

dim_product:
product_key: 5
product_id: 'P001'
product_name: 'Samsung Galaxy S21'
category: 'Electronics'
subcategory: 'Smartphones'
brand: 'Samsung'
unit_price: 45999.00
is_active: TRUE
valid_from: '2023-12-01'
valid_to: NULL
current_flag: TRUE

dim_customer:
customer_key: 12
customer_id: 'C001'
customer_name: 'John Doe'
city: 'Bangalore'
state: 'Karnataka'
customer_segment: 'High Value'
registration_date: '2023-01-15'
loyalty_tier: 'Gold'
total_orders: 15
total_spent: 245000.00

Analytical Query Example:
```sql
-- Monthly revenue by customer segment
SELECT 
    d.month_name,
    c.customer_segment,
    SUM(f.total_amount) as revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_customer c ON f.customer_key = c.customer_key
WHERE d.year = 2024
GROUP BY d.month_name, c.customer_segment
ORDER BY d.month, c.customer_segment;



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
