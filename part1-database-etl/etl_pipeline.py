#!/usr/bin/env python3
"""
ETL Pipeline for FlexiMart Data Architecture Project
Author: [Your Name]
Student ID: [Your ID]
"""

import pandas as pd
import mysql.connector
from mysql.connector import Error
import re
from datetime import datetime
import logging
import os

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ETLPipeline:
    def __init__(self, db_config):
        """
        Initialize ETL Pipeline with database configuration
        """
        self.db_config = db_config
        self.data_dir = 'data'
        self.report = {
            'customers': {'processed': 0, 'duplicates': 0, 'missing': 0, 'loaded': 0},
            'products': {'processed': 0, 'duplicates': 0, 'missing': 0, 'loaded': 0},
            'sales': {'processed': 0, 'duplicates': 0, 'missing': 0, 'loaded': 0}
        }
        
    def extract(self):
        """
        Extract data from CSV files
        """
        logger.info("Extracting data from CSV files...")
        
        try:
            # Read customers data
            customers_df = pd.read_csv(f'{self.data_dir}/customers_raw.csv')
            self.report['customers']['processed'] = len(customers_df)
            logger.info(f"Extracted {len(customers_df)} customer records")
            
            # Read products data
            products_df = pd.read_csv(f'{self.data_dir}/products_raw.csv')
            self.report['products']['processed'] = len(products_df)
            logger.info(f"Extracted {len(products_df)} product records")
            
            # Read sales data
            sales_df = pd.read_csv(f'{self.data_dir}/sales_raw.csv')
            self.report['sales']['processed'] = len(sales_df)
            logger.info(f"Extracted {len(sales_df)} sales records")
            
            return customers_df, products_df, sales_df
            
        except FileNotFoundError as e:
            logger.error(f"File not found: {e}")
            raise
        except Exception as e:
            logger.error(f"Error extracting data: {e}")
            raise
    
    def transform_customers(self, df):
        """
        Transform customers data
        """
        logger.info("Transforming customers data...")
        
        # Remove duplicates
        initial_count = len(df)
        df = df.drop_duplicates(subset=['customer_id'], keep='first')
        duplicates = initial_count - len(df)
        self.report['customers']['duplicates'] = duplicates
        logger.info(f"Removed {duplicates} duplicate customer records")
        
        # Handle missing emails
        missing_emails = df['email'].isnull().sum()
        df['email'] = df.apply(
            lambda row: f"{row['first_name'].lower()}.{row['last_name'].lower()}@fleximart.com" 
            if pd.isnull(row['email']) else row['email'], 
            axis=1
        )
        self.report['customers']['missing'] += missing_emails
        logger.info(f"Generated {missing_emails} missing emails")
        
        # Standardize phone format
        def standardize_phone(phone):
            if pd.isnull(phone):
                return None
            # Remove all non-digit characters
            digits = re.sub(r'\D', '', str(phone))
            # Format as +91-XXXXXXXXXX
            if len(digits) == 10:
                return f"+91-{digits}"
            elif len(digits) == 12 and digits.startswith('91'):
                return f"+{digits[:2]}-{digits[2:]}"
            elif len(digits) == 11 and digits.startswith('0'):
                return f"+91-{digits[1:]}"
            else:
                return f"+91-{digits[-10:]}"
        
        df['phone'] = df['phone'].apply(standardize_phone)
        
        # Standardize city names (capitalize first letter)
        df['city'] = df['city'].str.title()
        
        # Standardize date format
        def parse_date(date_str):
            if pd.isnull(date_str):
                return None
            try:
                # Try different date formats
                for fmt in ('%Y-%m-%d', '%d/%m/%Y', '%m-%d-%Y', '%d-%m-%Y'):
                    try:
                        return datetime.strptime(str(date_str), fmt).date()
                    except ValueError:
                        continue
                return None
            except:
                return None
        
        df['registration_date'] = df['registration_date'].apply(parse_date)
        
        # Fill missing dates with default
        df['registration_date'] = df['registration_date'].fillna(pd.Timestamp('2023-01-01').date())
        
        # Remove original customer_id (will use auto-increment)
        df = df.drop('customer_id', axis=1)
        
        logger.info(f"Transformed {len(df)} customer records")
        return df
    
    def transform_products(self, df):
        """
        Transform products data
        """
        logger.info("Transforming products data...")
        
        # Standardize category names
        category_map = {
            'electronics': 'Electronics',
            'ELECTRONICS': 'Electronics',
            'fashion': 'Fashion',
            'FASHION': 'Fashion',
            'groceries': 'Groceries',
            'GROCERIES': 'Groceries'
        }
        
        df['category'] = df['category'].str.title()
        df['category'] = df['category'].replace(category_map)
        
        # Handle missing prices - use category average
        missing_prices = df['price'].isnull().sum()
        category_avg = df.groupby('category')['price'].transform('mean')
        df['price'] = df['price'].fillna(category_avg)
        self.report['products']['missing'] += missing_prices
        logger.info(f"Filled {missing_prices} missing prices with category average")
        
        # Handle missing stock - set to 0
        missing_stock = df['stock_quantity'].isnull().sum()
        df['stock_quantity'] = df['stock_quantity'].fillna(0).astype(int)
        self.report['products']['missing'] += missing_stock
        logger.info(f"Filled {missing_stock} missing stock values with 0")
        
        # Clean product names
        df['product_name'] = df['product_name'].str.strip()
        
        # Remove original product_id (will use auto-increment)
        df = df.drop('product_id', axis=1)
        
        logger.info(f"Transformed {len(df)} product records")
        return df
    
    def transform_sales(self, df, customers_df, products_df):
        """
        Transform sales data
        """
        logger.info("Transforming sales data...")
        
        # Remove duplicates based on transaction_id
        initial_count = len(df)
        df = df.drop_duplicates(subset=['transaction_id'], keep='first')
        duplicates = initial_count - len(df)
        self.report['sales']['duplicates'] = duplicates
        logger.info(f"Removed {duplicates} duplicate sales records")
        
        # Handle missing customer_ids (filter them out for orders table)
        missing_customers = df['customer_id'].isnull().sum()
        self.report['sales']['missing'] += missing_customers
        
        # Handle missing product_ids (filter them out for order_items table)
        missing_products = df['product_id'].isnull().sum()
        self.report['sales']['missing'] += missing_products
        
        # Standardize date format
        def parse_date(date_str):
            if pd.isnull(date_str):
                return None
            try:
                # Try different date formats
                for fmt in ('%Y-%m-%d', '%d/%m/%Y', '%m-%d-%Y', '%Y/%m/%d'):
                    try:
                        return datetime.strptime(str(date_str), fmt).date()
                    except ValueError:
                        continue
                return None
            except:
                return None
        
        df['transaction_date'] = df['transaction_date'].apply(parse_date)
        
        # Filter out records with missing dates
        missing_dates = df['transaction_date'].isnull().sum()
        df = df.dropna(subset=['transaction_date'])
        self.report['sales']['missing'] += missing_dates
        
        # Calculate subtotal
        df['subtotal'] = df['quantity'] * df['unit_price']
        
        # Convert status to consistent format
        df['status'] = df['status'].str.title()
        
        # Prepare for database insertion
        # We'll split into orders and order_items later
        logger.info(f"Transformed {len(df)} sales records")
        return df
    
    def create_database_connection(self):
        """
        Create database connection
        """
        try:
            connection = mysql.connector.connect(**self.db_config)
            if connection.is_connected():
                logger.info("Connected to MySQL database")
                return connection
        except Error as e:
            logger.error(f"Error connecting to MySQL: {e}")
            raise
    
    def create_tables(self, connection):
        """
        Create database tables
        """
        logger.info("Creating database tables...")
        
        create_tables_query = """
        CREATE DATABASE IF NOT EXISTS fleximart;
        USE fleximart;

        CREATE TABLE IF NOT EXISTS customers (
            customer_id INT PRIMARY KEY AUTO_INCREMENT,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            phone VARCHAR(20),
            city VARCHAR(50),
            registration_date DATE
        );

        CREATE TABLE IF NOT EXISTS products (
            product_id INT PRIMARY KEY AUTO_INCREMENT,
            product_name VARCHAR(100) NOT NULL,
            category VARCHAR(50) NOT NULL,
            price DECIMAL(10,2) NOT NULL,
            stock_quantity INT DEFAULT 0
        );

        CREATE TABLE IF NOT EXISTS orders (
            order_id INT PRIMARY KEY AUTO_INCREMENT,
            customer_id INT NOT NULL,
            order_date DATE NOT NULL,
            total_amount DECIMAL(10,2) NOT NULL,
            status VARCHAR(20) DEFAULT 'Pending',
            FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        );

        CREATE TABLE IF NOT EXISTS order_items (
            order_item_id INT PRIMARY KEY AUTO_INCREMENT,
            order_id INT NOT NULL,
            product_id INT NOT NULL,
            quantity INT NOT NULL,
            unit_price DECIMAL(10,2) NOT NULL,
            subtotal DECIMAL(10,2) NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders(order_id),
            FOREIGN KEY (product_id) REFERENCES products(product_id)
        );
        """
        
        try:
            cursor = connection.cursor()
            for result in cursor.execute(create_tables_query, multi=True):
                pass
            connection.commit()
            logger.info("Database tables created successfully")
        except Error as e:
            logger.error(f"Error creating tables: {e}")
            raise
    
    def load_customers(self, connection, df):
        """
        Load customers data into database
        """
        logger.info("Loading customers data...")
        
        insert_query = """
        INSERT INTO customers (first_name, last_name, email, phone, city, registration_date)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        
        try:
            cursor = connection.cursor()
            records = df.to_dict('records')
            
            for record in records:
                try:
                    cursor.execute(insert_query, (
                        record['first_name'],
                        record['last_name'],
                        record['email'],
                        record['phone'],
                        record['city'],
                        record['registration_date']
                    ))
                except mysql.connector.IntegrityError:
                    # Skip duplicate emails
                    continue
            
            connection.commit()
            loaded_count = cursor.rowcount
            self.report['customers']['loaded'] = loaded_count
            logger.info(f"Loaded {loaded_count} customer records")
            
        except Error as e:
            logger.error(f"Error loading customers: {e}")
            raise
    
    def load_products(self, connection, df):
        """
        Load products data into database
        """
        logger.info("Loading products data...")
        
        insert_query = """
        INSERT INTO products (product_name, category, price, stock_quantity)
        VALUES (%s, %s, %s, %s)
        """
        
        try:
            cursor = connection.cursor()
            records = df.to_dict('records')
            
            for record in records:
                cursor.execute(insert_query, (
                    record['product_name'],
                    record['category'],
                    float(record['price']),
                    int(record['stock_quantity'])
                ))
            
            connection.commit()
            loaded_count = cursor.rowcount
            self.report['products']['loaded'] = loaded_count
            logger.info(f"Loaded {loaded_count} product records")
            
        except Error as e:
            logger.error(f"Error loading products: {e}")
            raise
    
    def load_sales(self, connection, df, customers_map, products_map):
        """
        Load sales data into orders and order_items tables
        """
        logger.info("Loading sales data...")
        
        # Group by customer and date to create orders
        orders_df = df.groupby(['customer_id', 'transaction_date']).agg({
            'subtotal': 'sum',
            'status': 'first'
        }).reset_index()
        
        orders_df = orders_df[orders_df['customer_id'].notna()]
        
        # Load orders
        orders_insert_query = """
        INSERT INTO orders (customer_id, order_date, total_amount, status)
        VALUES (%s, %s, %s, %s)
        """
        
        order_items_insert_query = """
        INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
        VALUES (%s, %s, %s, %s, %s)
        """
        
        try:
            cursor = connection.cursor()
            loaded_orders = 0
            loaded_items = 0
            
            # Process each order
            for _, order_row in orders_df.iterrows():
                # Get customer_id from mapping (we need to query actual customer_id from db)
                cursor.execute("SELECT customer_id FROM customers WHERE email LIKE %s", 
                             (f"%{order_row['customer_id'].lower()}%",))
                customer_result = cursor.fetchone()
                
                if not customer_result:
                    continue  # Skip if customer not found
                
                customer_id = customer_result[0]
                
                # Insert order
                cursor.execute(orders_insert_query, (
                    customer_id,
                    order_row['transaction_date'],
                    float(order_row['subtotal']),
                    order_row['status']
                ))
                
                order_id = cursor.lastrowid
                loaded_orders += 1
                
                # Get order items for this customer and date
                order_items = df[(df['customer_id'] == order_row['customer_id']) & 
                                (df['transaction_date'] == order_row['transaction_date'])]
                
                for _, item_row in order_items.iterrows():
                    if pd.isnull(item_row['product_id']):
                        continue
                    
                    # Get product_id from mapping
                    cursor.execute("SELECT product_id FROM products WHERE product_name LIKE %s", 
                                 (f"%{item_row['product_id']}%",))
                    product_result = cursor.fetchone()
                    
                    if not product_result:
                        continue  # Skip if product not found
                    
                    product_id = product_result[0]
                    
                    # Insert order item
                    cursor.execute(order_items_insert_query, (
                        order_id,
                        product_id,
                        int(item_row['quantity']),
                        float(item_row['unit_price']),
                        float(item_row['subtotal'])
                    ))
                    loaded_items += 1
            
            connection.commit()
            self.report['sales']['loaded'] = loaded_orders
            logger.info(f"Loaded {loaded_orders} orders and {loaded_items} order items")
            
        except Error as e:
            logger.error(f"Error loading sales: {e}")
            raise
    
    def generate_report(self):
        """
        Generate data quality report
        """
        logger.info("Generating data quality report...")
        
        report_content = """
        ========================================
        DATA QUALITY REPORT - FlexiMart ETL Pipeline
        ========================================
        
        CUSTOMERS DATA
        ---------------
        Records Processed: {cust_processed}
        Duplicates Removed: {cust_duplicates}
        Missing Values Handled: {cust_missing}
        Records Loaded: {cust_loaded}
        
        PRODUCTS DATA
        --------------
        Records Processed: {prod_processed}
        Duplicates Removed: {prod_duplicates}
        Missing Values Handled: {prod_missing}
        Records Loaded: {prod_loaded}
        
        SALES DATA
        -----------
        Records Processed: {sales_processed}
        Duplicates Removed: {sales_duplicates}
        Missing Values Handled: {sales_missing}
        Records Loaded: {sales_loaded}
        
        SUMMARY
        --------
        Total Records Processed: {total_processed}
        Total Duplicates Removed: {total_duplicates}
        Total Missing Values Handled: {total_missing}
        Total Records Loaded: {total_loaded}
        
        Generated on: {timestamp}
        ========================================
        """.format(
            cust_processed=self.report['customers']['processed'],
            cust_duplicates=self.report['customers']['duplicates'],
            cust_missing=self.report['customers']['missing'],
            cust_loaded=self.report['customers']['loaded'],
            prod_processed=self.report['products']['processed'],
            prod_duplicates=self.report['products']['duplicates'],
            prod_missing=self.report['products']['missing'],
            prod_loaded=self.report['products']['loaded'],
            sales_processed=self.report['sales']['processed'],
            sales_duplicates=self.report['sales']['duplicates'],
            sales_missing=self.report['sales']['missing'],
            sales_loaded=self.report['sales']['loaded'],
            total_processed=(self.report['customers']['processed'] + 
                           self.report['products']['processed'] + 
                           self.report['sales']['processed']),
            total_duplicates=(self.report['customers']['duplicates'] + 
                            self.report['products']['duplicates'] + 
                            self.report['sales']['duplicates']),
            total_missing=(self.report['customers']['missing'] + 
                          self.report['products']['missing'] + 
                          self.report['sales']['missing']),
            total_loaded=(self.report['customers']['loaded'] + 
                         self.report['products']['loaded'] + 
                         self.report['sales']['loaded']),
            timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )
        
        # Save report to file
        with open('part1-database-etl/data_quality_report.txt', 'w') as f:
            f.write(report_content)
        
        logger.info("Data quality report generated: data_quality_report.txt")
        print(report_content)
    
    def run(self):
        """
        Run the complete ETL pipeline
        """
        logger.info("Starting ETL Pipeline...")
        
        try:
            # Extract
            customers_df, products_df, sales_df = self.extract()
            
            # Transform
            customers_clean = self.transform_customers(customers_df)
            products_clean = self.transform_products(products_df)
            sales_clean = self.transform_sales(sales_df, customers_df, products_df)
            
            # Connect to database
            connection = self.create_database_connection()
            
            # Create tables
            self.create_tables(connection)
            
            # Load
            self.load_customers(connection, customers_clean)
            self.load_products(connection, products_clean)
            
            # Create mappings for sales loading
            cursor = connection.cursor()
            cursor.execute("SELECT email FROM customers")
            customers_map = {row[0]: i+1 for i, row in enumerate(cursor.fetchall())}
            
            cursor.execute("SELECT product_name FROM products")
            products_map = {row[0]: i+1 for i, row in enumerate(cursor.fetchall())}
            
            self.load_sales(connection, sales_clean, customers_map, products_map)
            
            # Generate report
            self.generate_report()
            
            logger.info("ETL Pipeline completed successfully!")
            
        except Exception as e:
            logger.error(f"ETL Pipeline failed: {e}")
            raise
        finally:
            if 'connection' in locals() and connection.is_connected():
                connection.close()
                logger.info("Database connection closed")

def main():
    """
    Main function to run ETL pipeline
    """
    # Database configuration
    db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': 'password',  # Change this to your MySQL password
        'database': 'fleximart'
    }
    
    # Run ETL pipeline
    etl = ETLPipeline(db_config)
    etl.run()

if __name__ == "__main__":
    main()
