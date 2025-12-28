-- Data Warehouse Sample Data
-- Database: fleximart_dw

USE fleximart_dw;

-- Insert Date Dimension Data (January-February 2024)
INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, week_number, month, month_name, quarter, year, is_weekend, financial_quarter, financial_year) VALUES
-- January 2024
(20240101, '2024-01-01', 'Monday', 1, 1, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240102, '2024-01-02', 'Tuesday', 2, 1, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240103, '2024-01-03', 'Wednesday', 3, 1, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240104, '2024-01-04', 'Thursday', 4, 1, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240105, '2024-01-05', 'Friday', 5, 1, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240106, '2024-01-06', 'Saturday', 6, 1, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240107, '2024-01-07', 'Sunday', 7, 1, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240108, '2024-01-08', 'Monday', 8, 2, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240109, '2024-01-09', 'Tuesday', 9, 2, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240110, '2024-01-10', 'Wednesday', 10, 2, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240111, '2024-01-11', 'Thursday', 11, 2, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240112, '2024-01-12', 'Friday', 12, 2, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240113, '2024-01-13', 'Saturday', 13, 2, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240114, '2024-01-14', 'Sunday', 14, 2, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240115, '2024-01-15', 'Monday', 15, 3, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240116, '2024-01-16', 'Tuesday', 16, 3, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240117, '2024-01-17', 'Wednesday', 17, 3, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240118, '2024-01-18', 'Thursday', 18, 3, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240119, '2024-01-19', 'Friday', 19, 3, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240120, '2024-01-20', 'Saturday', 20, 3, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240121, '2024-01-21', 'Sunday', 21, 3, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240122, '2024-01-22', 'Monday', 22, 4, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240123, '2024-01-23', 'Tuesday', 23, 4, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240124, '2024-01-24', 'Wednesday', 24, 4, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240125, '2024-01-25', 'Thursday', 25, 4, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240126, '2024-01-26', 'Friday', 26, 4, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240127, '2024-01-27', 'Saturday', 27, 4, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240128, '2024-01-28', 'Sunday', 28, 4, 1, 'January', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240129, '2024-01-29', 'Monday', 29, 5, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240130, '2024-01-30', 'Tuesday', 30, 5, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240131, '2024-01-31', 'Wednesday', 31, 5, 1, 'January', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
-- February 2024
(20240201, '2024-02-01', 'Thursday', 1, 5, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240202, '2024-02-02', 'Friday', 2, 5, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240203, '2024-02-03', 'Saturday', 3, 5, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240204, '2024-02-04', 'Sunday', 4, 5, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240205, '2024-02-05', 'Monday', 5, 6, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240206, '2024-02-06', 'Tuesday', 6, 6, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240207, '2024-02-07', 'Wednesday', 7, 6, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240208, '2024-02-08', 'Thursday', 8, 6, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240209, '2024-02-09', 'Friday', 9, 6, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240210, '2024-02-10', 'Saturday', 10, 6, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240211, '2024-02-11', 'Sunday', 11, 6, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240212, '2024-02-12', 'Monday', 12, 7, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240213, '2024-02-13', 'Tuesday', 13, 7, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240214, '2024-02-14', 'Wednesday', 14, 7, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240215, '2024-02-15', 'Thursday', 15, 7, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240216, '2024-02-16', 'Friday', 16, 7, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240217, '2024-02-17', 'Saturday', 17, 7, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240218, '2024-02-18', 'Sunday', 18, 7, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240219, '2024-02-19', 'Monday', 19, 8, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240220, '2024-02-20', 'Tuesday', 20, 8, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240221, '2024-02-21', 'Wednesday', 21, 8, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240222, '2024-02-22', 'Thursday', 22, 8, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240223, '2024-02-23', 'Friday', 23, 8, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240224, '2024-02-24', 'Saturday', 24, 8, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240225, '2024-02-25', 'Sunday', 25, 8, 2, 'February', 'Q1', 2024, TRUE, 'FYQ3', '2023-24'),
(20240226, '2024-02-26', 'Monday', 26, 9, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240227, '2024-02-27', 'Tuesday', 27, 9, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240228, '2024-02-28', 'Wednesday', 28, 9, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24'),
(20240229, '2024-02-29', 'Thursday', 29, 9, 2, 'February', 'Q1', 2024, FALSE, 'FYQ3', '2023-24');

-- Insert Product Dimension Data (15+ products across 3 categories)
INSERT INTO dim_product (product_id, product_name, category, subcategory, brand, unit_price, is_active, valid_from, valid_to, current_flag) VALUES
-- Electronics Category
('ELEC001', 'Samsung Galaxy S21', 'Electronics', 'Smartphones', 'Samsung', 45999.00, TRUE, '2023-01-01', NULL, TRUE),
('ELEC002', 'Apple iPhone 13', 'Electronics', 'Smartphones', 'Apple', 69999.00, TRUE, '2023-02-01', NULL, TRUE),
('ELEC003', 'Dell XPS 13 Laptop', 'Electronics', 'Laptops', 'Dell', 89999.00, TRUE, '2023-03-01', NULL, TRUE),
('ELEC004', 'Sony WH-1000XM4', 'Electronics', 'Headphones', 'Sony', 24999.00, TRUE, '2023-04-01', NULL, TRUE),
('ELEC005', 'Apple MacBook Air', 'Electronics', 'Laptops', 'Apple', 99999.00, TRUE, '2023-05-01', NULL, TRUE),
('ELEC006', 'OnePlus Nord 2', 'Electronics', 'Smartphones', 'OnePlus', 29999.00, TRUE, '2023-06-01', NULL, TRUE),
('ELEC007', 'Boat Rockerz 450', 'Electronics', 'Headphones', 'Boat', 1999.00, TRUE, '2023-07-01', NULL, TRUE),
('ELEC008', 'HP Pavilion Laptop', 'Electronics', 'Laptops', 'HP', 54999.00, TRUE, '2023-08-01', NULL, TRUE),
-- Fashion Category
('FASH001', 'Levis 501 Jeans', 'Fashion', 'Clothing', 'Levis', 3999.00, TRUE, '2023-01-01', NULL, TRUE),
('FASH002', 'Nike Air Max', 'Fashion', 'Footwear', 'Nike', 10999.00, TRUE, '2023-02-01', NULL, TRUE),
('FASH003', 'Adidas T-Shirt', 'Fashion', 'Clothing', 'Adidas', 1499.00, TRUE, '2023-03-01', NULL, TRUE),
('FASH004', 'Puma Running Shoes', 'Fashion', 'Footwear', 'Puma', 5999.00, TRUE, '2023-04-01', NULL, TRUE),
('FASH005', 'H&M Formal Shirt', 'Fashion', 'Clothing', 'H&M', 1999.00, TRUE, '2023-05-01', NULL, TRUE),
-- Groceries Category
('GROC001', 'Basmati Rice 5kg', 'Groceries', 'Food Grains', 'India Gate', 650.00, TRUE, '2023-01-01', NULL, TRUE),
('GROC002', 'Fortune Oil 1L', 'Groceries', 'Cooking Oil', 'Fortune', 210.00, TRUE, '2023-02-01', NULL, TRUE),
('GROC003', 'Tata Salt 1kg', 'Groceries', 'Spices', 'Tata', 25.00, TRUE, '2023-03-01', NULL, TRUE),
('GROC004', 'Amul Butter 500g', 'Groceries', 'Dairy', 'Amul', 275.00, TRUE, '2023-04-01', NULL, TRUE),
('GROC005', 'Nescafe Classic', 'Groceries', 'Beverages', 'Nescafe', 450.00, TRUE, '2023-05-01', NULL, TRUE);

-- Insert Customer Dimension Data (12+ customers across 4 cities)
INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment, registration_date, loyalty_tier, total_orders, total_spent) VALUES
('C001', 'Rahul Sharma', 'Bangalore', 'Karnataka', 'High Value', '2023-01-15', 'Platinum', 15, 245000.00),
('C002', 'Priya Patel', 'Mumbai', 'Maharashtra', 'Medium Value', '2023-02-20', 'Gold', 8, 85000.00),
('C003', 'Amit Kumar', 'Delhi', 'Delhi', 'Low Value', '2023-03-10', 'Silver', 3, 15000.00),
('C004', 'Sneha Reddy', 'Hyderabad', 'Telangana', 'Medium Value', '2023-04-15', 'Gold', 6, 65000.00),
('C005', 'Vikram Singh', 'Chennai', 'Tamil Nadu', 'High Value', '2023-05-22', 'Platinum', 12, 180000.00),
('C006', 'Anjali Mehta', 'Bangalore', 'Karnataka', 'Medium Value', '2023-06-18', 'Gold', 7, 72000.00),
('C007', 'Ravi Verma', 'Mumbai', 'Maharashtra', 'Low Value', '2023-07-25', 'Silver', 4, 22000.00),
('C008', 'Pooja Iyer', 'Bangalore', 'Karnataka', 'High Value', '2023-08-15', 'Platinum', 10, 160000.00),
('C009', 'Karthik Nair', 'Kochi', 'Kerala', 'Medium Value', '2023-09-30', 'Gold', 5, 45000.00),
('C010', 'Deepa Gupta', 'Delhi', 'Delhi', 'Low Value', '2023-10-12', 'Silver', 2, 8000.00),
('C011', 'Arjun Rao', 'Hyderabad', 'Telangana', 'High Value', '2023-11-05', 'Platinum', 14, 210000.00),
('C012', 'Lakshmi Krishnan', 'Chennai', 'Tamil Nadu', 'Medium Value', '2023-12-01', 'Gold', 9, 95000.00),
('C013', 'Neha Shah', 'Ahmedabad', 'Gujarat', 'Low Value', '2024-01-15', 'Bronze', 1, 5000.00),
('C014', 'Manish Joshi', 'Jaipur', 'Rajasthan', 'Medium Value', '2024-01-20', 'Silver', 4, 35000.00);

-- Insert Sales Fact Data (40+ sales transactions)
INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount, order_number) VALUES
-- January 2024 Sales (Higher sales on weekends)
-- Weekday sales
(20240115, 1, 1, 1, 45999.00, 0.00, 45999.00, 'ORD-20240115-001'),
(20240115, 9, 2, 2, 3999.00, 500.00, 7498.00, 'ORD-20240115-002'),
(20240116, 3, 3, 1, 89999.00, 0.00, 89999.00, 'ORD-20240116-001'),
(20240117, 14, 4, 5, 650.00, 0.00, 3250.00, 'ORD-20240117-001'),
(20240118, 2, 5, 1, 69999.00, 2000.00, 67999.00, 'ORD-20240118-001'),
(20240119, 10, 6, 1, 10999.00, 0.00, 10999.00, 'ORD-20240119-001'),
-- Weekend sales (higher quantities)
(20240120, 7, 7, 3, 1999.00, 0.00, 5997.00, 'ORD-20240120-001'),
(20240120, 15, 8, 10, 450.00, 200.00, 4300.00, 'ORD-20240120-002'),
(20240121, 1, 9, 2, 45999.00, 3000.00, 88998.00, 'ORD-20240121-001'),
(20240121, 11, 10, 1, 1499.00, 0.00, 1499.00, 'ORD-20240121-002'),
-- More January sales
(20240122, 4, 11, 1, 24999.00, 0.00, 24999.00, 'ORD-20240122-001'),
(20240123, 13, 12, 3, 210.00, 0.00, 630.00, 'ORD-20240123-001'),
(20240124, 5, 1, 1, 99999.00, 5000.00, 94999.00, 'ORD-20240124-001'),
(20240125, 8, 2, 1, 54999.00, 0.00, 54999.00, 'ORD-20240125-001'),
(20240126, 12, 3, 2, 5999.00, 500.00, 11498.00, 'ORD-20240126-001'),
-- Weekend sales
(20240127, 6, 4, 1, 29999.00, 0.00, 29999.00, 'ORD-20240127-001'),
(20240127, 16, 5, 4, 275.00, 0.00, 1100.00, 'ORD-20240127-002'),
(20240128, 1, 6, 1, 45999.00, 0.00, 45999.00, 'ORD-20240128-001'),
(20240128, 9, 7, 1, 3999.00, 0.00, 3999.00, 'ORD-20240128-002'),
-- February 2024 Sales
(20240201, 2, 8, 1, 69999.00, 0.00, 69999.00, 'ORD-20240201-001'),
(20240202, 10, 9, 2, 10999.00, 1000.00, 20998.00, 'ORD-20240202-001'),
(20240203, 3, 10, 1, 89999.00, 0.00, 89999.00, 'ORD-20240203-001'),
(20240204, 14, 11, 8, 650.00, 200.00, 5000.00, 'ORD-20240204-001'),
(20240205, 4, 12, 1, 24999.00, 0.00, 24999.00, 'ORD-20240205-001'),
(20240206, 11, 1, 3, 1499.00, 0.00, 4497.00, 'ORD-20240206-001'),
(20240209, 5, 2, 1, 99999.00, 3000.00, 96999.00, 'ORD-20240209-001'),
(20240210, 13, 3, 5, 210.00, 0.00, 1050.00, 'ORD-20240210-001'),
(20240211, 6, 4, 2, 29999.00, 1000.00, 58998.00, 'ORD-20240211-001'),
(20240212, 8, 5, 1, 54999.00, 0.00, 54999.00, 'ORD-20240212-001'),
(20240213, 12, 6, 1, 5999.00, 0.00, 5999.00, 'ORD-20240213-001'),
(20240216, 7, 7, 2, 1999.00, 0.00, 3998.00, 'ORD-20240216-001'),
(20240217, 15, 8, 5, 450.00, 0.00, 2250.00, 'ORD-20240217-001'),
(20240218, 1, 9, 1, 45999.00, 0.00, 45999.00, 'ORD-20240218-001'),
(20240219, 9, 10, 2, 3999.00, 500.00, 7498.00, 'ORD-20240219-001'),
(20240220, 2, 11, 1, 69999.00, 2000.00, 67999.00, 'ORD-20240220-001'),
(20240223, 3, 12, 1, 89999.00, 0.00, 89999.00, 'ORD-20240223-001'),
(20240224, 14, 1, 10, 650.00, 300.00, 6200.00, 'ORD-20240224-001'),
(20240225, 4, 2, 1, 24999.00, 0.00, 24999.00, 'ORD-20240225-001'),
(20240226, 10, 3, 1, 10999.00, 0.00, 10999.00, 'ORD-20240226-001'),
(20240227, 5, 4, 1, 99999.00, 4000.00, 95999.00, 'ORD-20240227-001'),
(20240228, 11, 5, 4, 1499.00, 0.00, 5996.00, 'ORD-20240228-001');

-- Update customer aggregated fields based on fact data
UPDATE dim_customer c
SET 
    total_orders = (
        SELECT COUNT(DISTINCT order_number) 
        FROM fact_sales f 
        WHERE f.customer_key = c.customer_key
    ),
    total_spent = (
        SELECT COALESCE(SUM(total_amount), 0)
        FROM fact_sales f 
        WHERE f.customer_key = c.customer_key
    ),
    last_order_date = (
        SELECT MAX(d.full_date)
        FROM fact_sales f
        JOIN dim_date d ON f.date_key = d.date_key
        WHERE f.customer_key = c.customer_key
    );

-- Update customer segments based on spending
UPDATE dim_customer 
SET customer_segment = 
    CASE 
        WHEN total_spent >= 100000 THEN 'High Value'
        WHEN total_spent >= 30000 THEN 'Medium Value'
        ELSE 'Low Value'
    END;

-- Update loyalty tiers based on total orders
UPDATE dim_customer 
SET loyalty_tier = 
    CASE 
        WHEN total_orders >= 10 THEN 'Platinum'
        WHEN total_orders >= 5 THEN 'Gold'
        WHEN total_orders >= 2 THEN 'Silver'
        ELSE 'Bronze'
    END;
