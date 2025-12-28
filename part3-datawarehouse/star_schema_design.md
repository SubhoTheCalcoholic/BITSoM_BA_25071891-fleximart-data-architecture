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
