# Database Schema Documentation
## FlexiMart E-commerce System

## Entity-Relationship Description

### ENTITY: customers
**Purpose:** Stores customer information and registration details

**Attributes:**
- `customer_id`: Unique identifier for each customer (Primary Key, Auto-increment)
- `first_name`: Customer's first name (Required)
- `last_name`: Customer's last name (Required)
- `email`: Customer's email address (Unique, Required)
- `phone`: Customer's phone number (Optional, formatted)
- `city`: Customer's city of residence (Optional)
- `registration_date`: Date when customer registered (Date format)

**Relationships:**
- One customer can place MANY orders (1:M relationship with orders table)

### ENTITY: products
**Purpose:** Stores product catalog information

**Attributes:**
- `product_id`: Unique identifier for each product (Primary Key, Auto-increment)
- `product_name`: Name of the product (Required)
- `category`: Product category (Electronics, Fashion, Groceries)
- `price`: Product price in decimal format (Required)
- `stock_quantity`: Available quantity in stock (Default: 0)

**Relationships:**
- One product can appear in MANY order_items (1:M relationship with order_items table)

### ENTITY: orders
**Purpose:** Stores order header information

**Attributes:**
- `order_id`: Unique identifier for each order (Primary Key, Auto-increment)
- `customer_id`: Reference to customer who placed the order (Foreign Key)
- `order_date`: Date when order was placed (Required)
- `total_amount`: Total amount of the order (Required)
- `status`: Order status (Pending, Completed, Cancelled) (Default: 'Pending')

**Relationships:**
- One order belongs to ONE customer (M:1 relationship with customers table)
- One order contains MANY order_items (1:M relationship with order_items table)

### ENTITY: order_items
**Purpose:** Stores line items for each order

**Attributes:**
- `order_item_id`: Unique identifier for each order item (Primary Key, Auto-increment)
- `order_id`: Reference to the order (Foreign Key)
- `product_id`: Reference to the product (Foreign Key)
- `quantity`: Quantity ordered (Required)
- `unit_price`: Price per unit at time of order (Required)
- `subtotal`: Calculated as quantity × unit_price (Required)

**Relationships:**
- One order_item belongs to ONE order (M:1 relationship with orders table)
- One order_item references ONE product (M:1 relationship with products table)

## Normalization Explanation

This database design is in **Third Normal Form (3NF)**. Here's the justification:

### 1. **First Normal Form (1NF)** - Atomic Values
- All attributes contain atomic values (no repeating groups)
- Each table has a primary key
- All values are of the same domain
- Example: Customer name is split into first_name and last_name

### 2. **Second Normal Form (2NF)** - No Partial Dependencies
- All tables already satisfy 2NF as they have single-column primary keys
- All non-key attributes are fully dependent on the entire primary key
- Example: In order_items, all attributes depend on the complete primary key (order_item_id)

### 3. **Third Normal Form (3NF)** - No Transitive Dependencies
- All non-key attributes are non-transitively dependent on the primary key
- No attribute depends on another non-key attribute

**Functional Dependencies:**
1. **Customers table:**
   - customer_id → {first_name, last_name, email, phone, city, registration_date}
   - email → customer_id (since email is unique)

2. **Products table:**
   - product_id → {product_name, category, price, stock_quantity}

3. **Orders table:**
   - order_id → {customer_id, order_date, total_amount, status}
   - customer_id → {customer details} (but this is handled through foreign key)

4. **Order_items table:**
   - order_item_id → {order_id, product_id, quantity, unit_price, subtotal}
   - (order_id, product_id) → {quantity, unit_price, subtotal}

### Anomalies Avoided:

**1. Update Anomalies:**
- Customer information is stored only once in the customers table
- Changing a customer's email only needs update in one place
- No duplication of customer data across orders

**2. Insertion Anomalies:**
- Can add a new customer without needing to create an order
- Can add a new product without any sales records
- Independent entity creation is possible

**3. Deletion Anomalies:**
- Deleting an order doesn't delete customer information
- Removing a product from catalog doesn't affect historical sales data
- Preserves referential integrity through foreign keys

### Additional Benefits:
- **Referential Integrity:** Foreign keys ensure data consistency
- **Data Consistency:** Normalized structure prevents data redundancy
- **Query Efficiency:** Proper indexing on foreign keys improves JOIN performance
- **Scalability:** Structure supports business growth and additional features

The design achieves a balance between normalization for data integrity and practical considerations for query performance.

## Sample Data Representation

### Customers Table
| customer_id | first_name | last_name | email | phone | city | registration_date |
|-------------|------------|-----------|-------|-------|------|-------------------|
| 1 | Rahul | Sharma | rahul.sharma@gmail.com | +91-9876543210 | Bangalore | 2023-01-15 |
| 2 | Priya | Patel | priya.patel@yahoo.com | +91-9988776655 | Mumbai | 2023-02-20 |
| 3 | Amit | Kumar | amit.kumar@fleximart.com | +91-9765432109 | Delhi | 2023-03-10 |

### Products Table
| product_id | product_name | category | price | stock_quantity |
|------------|--------------|----------|-------|----------------|
| 1 | Samsung Galaxy S21 | Electronics | 45999.00 | 150 |
| 2 | Nike Running Shoes | Fashion | 3499.00 | 80 |
| 3 | Apple MacBook Pro | Electronics | 84999.00 | 45 |

### Orders Table
| order_id | customer_id | order_date | total_amount | status |
|----------|-------------|------------|--------------|--------|
| 101 | 1 | 2024-01-15 | 45999.00 | Completed |
| 102 | 2 | 2024-01-16 | 5998.00 | Completed |
| 103 | 3 | 2024-01-20 | 1950.00 | Completed |

### Order_Items Table
| order_item_id | order_id | product_id | quantity | unit_price | subtotal |
|---------------|----------|------------|----------|------------|----------|
| 1001 | 101 | 1 | 1 | 45999.00 | 45999.00 |
| 1002 | 102 | 2 | 2 | 2999.00 | 5998.00 |
| 1003 | 103 | 3 | 3 | 650.00 | 1950.00 |
