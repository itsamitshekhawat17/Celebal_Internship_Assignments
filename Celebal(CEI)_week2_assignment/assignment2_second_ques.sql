-- ############################################################################
-- ShopEase E-Commerce Sales Database
-- Week 2 Assignment | Summer Internship Program 2026
-- Engine: MySQL
-- ############################################################################


-- ----------------------------------------------------------------------------
-- PART 1: BUILDING THE SCHEMA
-- ----------------------------------------------------------------------------

-- Make the database
CREATE DATABASE e_commerce_data;

-- Switch into it
USE e_commerce_data;

/* Four tables are defined below:
     - customers
     - products
     - orders
     - order_items                                                            */

CREATE TABLE customers (
    customer_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    is_premium BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (customer_id)
);

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_qty INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    PRIMARY KEY (product_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')),
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL(5,2) DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Supporting indexes for faster lookups
CREATE INDEX idx_customers_city    ON customers(city);
CREATE INDEX idx_customers_state   ON customers(state);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_date       ON orders(order_date);
CREATE INDEX idx_orders_status     ON orders(status);


-- ----------------------------------------------------------------------------
-- PART 2: LOADING SAMPLE RECORDS
-- ----------------------------------------------------------------------------

-- Populate customers
INSERT INTO customers VALUES
(101, 'Aarav',  'Sharma', 'aarav.s@email.com',  'Mumbai',    'Maharashtra', '2024-01-15', TRUE),
(102, 'Priya',  'Patel',  'priya.p@email.com',  'Ahmedabad', 'Gujarat',     '2024-02-20', FALSE),
(103, 'Rohan',  'Gupta',  'rohan.g@email.com',  'Delhi',     'Delhi',       '2024-03-10', TRUE),
(104, 'Sneha',  'Reddy',  'sneha.r@email.com',  'Hyderabad', 'Telangana',   '2024-04-05', FALSE),
(105, 'Vikram', 'Singh',  'vikram.s@email.com', 'Jaipur',    'Rajasthan',   '2024-05-12', TRUE),
(106, 'Ananya', 'Iyer',   'ananya.i@email.com', 'Chennai',   'Tamil Nadu',  '2024-06-18', FALSE),
(107, 'Karan',  'Mehta',  'karan.m@email.com',  'Pune',      'Maharashtra', '2024-07-22', TRUE),
(108, 'Divya',  'Nair',   'divya.n@email.com',  'Kochi',     'Kerala',      '2024-08-30', FALSE);

-- Populate products
INSERT INTO products VALUES
(201, 'Wireless Earbuds',     'Electronics', 'BoAt',         1499.00, 250),
(202, 'Cotton T-Shirt',       'Clothing',    'Levis',         799.00, 500),
(203, 'Smart Watch',          'Electronics', 'Noise',        2999.00, 150),
(204, 'Running Shoes',        'Clothing',    'Nike',         4599.00, 120),
(205, 'Bluetooth Speaker',    'Electronics', 'JBL',          3499.00, 200),
(206, 'Bedsheet Set',         'Home',        'Spaces',       1299.00, 300),
(207, 'Laptop Stand',         'Electronics', 'AmazonBasics',  899.00, 180),
(208, 'Cushion Covers (Set)', 'Home',        'HomeCenter',    599.00, 400);

-- Populate orders
INSERT INTO orders VALUES
(1001, 101, '2024-08-01', 'Delivered', 4498.00),
(1002, 102, '2024-08-03', 'Delivered',  799.00),
(1003, 103, '2024-08-05', 'Shipped',   7498.00),
(1004, 101, '2024-08-10', 'Delivered', 3499.00),
(1005, 104, '2024-08-12', 'Cancelled', 2999.00),
(1006, 105, '2024-08-15', 'Delivered', 5898.00),
(1007, 106, '2024-08-18', 'Pending',   1299.00),
(1008, 103, '2024-08-20', 'Delivered',  899.00),
(1009, 107, '2024-08-25', 'Shipped',   6098.00),
(1010, 108, '2024-08-28', 'Delivered', 1598.00);

-- Populate order_items
INSERT INTO order_items VALUES
(5001, 1001, 201, 2, 1499.00,  0),
(5002, 1001, 207, 1,  899.00, 10),
(5003, 1002, 202, 1,  799.00,  0),
(5004, 1003, 203, 1, 2999.00,  0),
(5005, 1003, 204, 1, 4599.00,  5),
(5006, 1004, 205, 1, 3499.00,  0),
(5007, 1005, 203, 1, 2999.00,  0),
(5008, 1006, 201, 1, 1499.00, 10),
(5009, 1006, 204, 1, 4599.00,  5),
(5010, 1007, 206, 1, 1299.00,  0),
(5011, 1008, 207, 1,  899.00,  0),
(5012, 1009, 205, 1, 3499.00,  0),
(5013, 1009, 208, 2,  599.00, 15),
(5014, 1010, 206, 1, 1299.00,  0),
(5015, 1010, 208, 1,  599.00,  0);


-- ----------------------------------------------------------------------------
-- SECTION A — Core SQL Retrieval & Database Constraints
-- ----------------------------------------------------------------------------

-- Q1. Show every column and every row in the customers table.
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;


-- Q2. Pull just the first_name, last_name, and city for every customer.
SELECT
    first_name, last_name, city
FROM customers;


-- Q3. List the distinct categories found in the products table.
SELECT
    DISTINCT category
FROM products;


-- Q4. Name each table's Primary Key and say why a PK has to be unique and NOT NULL.
/* Primary Keys by table:
     customers   -> customer_id
     products    -> product_id
     orders      -> order_id
     order_items -> item_id

   A Primary Key is what the table uses to tell one row apart from another. The
   "unique" rule guarantees that two rows can never carry the same identifier, and
   the NOT NULL rule guarantees that every row actually has an identifier at all.
   Drop either rule and the engine can no longer dependably locate, modify, or link
   a given row, which opens the door to inconsistent data.                          */


-- Q5. Which constraints sit on the email column, and what happens on a duplicate?
/* The email column in customers carries two constraints: UNIQUE and NOT NULL.
   Attempting to add a row whose email already exists trips the UNIQUE rule, and
   MySQL refuses the row with a "Duplicate entry" error — so two customers can never
   end up sharing one email. The NOT NULL rule additionally forces every customer to
   supply an email in the first place.                                              */


-- Q6. Try inserting a product priced at -50. What happens, and what blocks it?
INSERT INTO products VALUES (209, 'Pillow Cover', 'Home', 'AmazonBasics', -50, 20);
/* Outcome:
     The statement fails and nothing is written — a CHECK constraint error is raised.
   Responsible constraint:
     CHECK (unit_price > 0) on the products table.
   Why:
     A unit_price of -50 does not satisfy unit_price > 0. MySQL tests the CHECK
     condition first, finds it false, and turns the row away with a check-violation
     message.                                                                        */


-- ----------------------------------------------------------------------------
-- SECTION B — Data Filtering & Query Performance
-- ----------------------------------------------------------------------------

-- Q7. Retrieve all orders that have been successfully delivered.
SELECT *
FROM orders
WHERE status = 'Delivered';


-- Q8. Electronics products priced above 2000.
SELECT *
FROM products
WHERE category = 'Electronics' AND unit_price > 2000;


-- Q9. Customers from Maharashtra who joined during 2024.
SELECT *
FROM customers
WHERE state = 'Maharashtra'
  AND join_date >= '2024-01-01' AND join_date < '2025-01-01';


-- Q10. Non-cancelled orders dated between 2024-08-10 and 2024-08-25 (inclusive).
SELECT *
FROM orders
WHERE status <> 'Cancelled'
  AND order_date BETWEEN '2024-08-10' AND '2024-08-25';


-- Q11. Describe what idx_orders_date does and give a query that takes advantage of it.
/* idx_orders_date is a B-tree index built on orders(order_date). It keeps the
   order_date values pre-sorted, each one paired with a pointer back to its row. As a
   result the engine can seek directly to the date range it needs rather than reading
   the whole table top to bottom. That makes equality and range filters on order_date
   noticeably faster.                                                                 */
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-15';


-- Q12. Will the join_date index help YEAR(join_date) = 2024? Rewrite it to be SARGable.
/* It will not. Once the column is wrapped inside YEAR(...), the predicate is no
   longer SARGable — the engine has to evaluate YEAR() on every single row before it
   can compare, which defeats the sorted index and forces a full scan. Expressing the
   same logic as a plain range on the bare column lets the index do its job:          */
SELECT *
FROM customers
WHERE join_date >= '2024-01-01' AND join_date < '2025-01-01';


-- ----------------------------------------------------------------------------
-- SECTION C — Aggregation & Summary Analytics
-- ----------------------------------------------------------------------------

-- Q13. Determine the total number of orders present in the database.
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- Q14. Sum the revenue across all 'Delivered' orders.
SELECT
    SUM(total_amount) AS total_delivered_revenue
FROM orders
WHERE status = 'Delivered';


-- Q15. Average product unit_price within each category.
SELECT
    category,
    AVG(unit_price) AS avg_price
FROM products
GROUP BY category;


-- Q16. Per status: how many orders and how much revenue, highest revenue first.
SELECT
    status,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;


-- Q17. Highest- and lowest-priced product in each category.
SELECT
    category,
    MAX(unit_price) AS maximum_price,
    MIN(unit_price) AS minimum_price
FROM products
GROUP BY category;


-- Q18. Categories whose average unit_price exceeds 2000 (using HAVING).
SELECT
    category,
    AVG(unit_price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;


-- ----------------------------------------------------------------------------
-- SECTION D — Table Relationships and JOIN Operations
-- ----------------------------------------------------------------------------

-- Q19. INNER JOIN each order to its customer's first and last name.
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    o.total_amount
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;


-- Q20. LEFT JOIN to list every customer alongside their orders (NULLs when none).
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;


-- Q21. Chain three tables together (orders -> order_items -> products).
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id;


-- Q22. How does LEFT JOIN differ from RIGHT JOIN, and when is FULL OUTER JOIN useful?
/* A LEFT JOIN keeps every row from the left-hand table and attaches matching right-
   hand rows, filling NULL where no match exists. A RIGHT JOIN flips that around —
   every row from the right-hand table is kept, with left-hand matches attached.
       LEFT:  customers LEFT JOIN orders  -> all customers, even order-less ones.
       RIGHT: customers RIGHT JOIN orders -> all orders, even one with no customer.
   A FULL OUTER JOIN keeps everything from both sides at once, pairing rows where it
   can and leaving NULLs where it cannot — handy when you want unmatched rows from
   either side in a single result (customers without orders AND orders without a
   customer). MySQL provides no FULL OUTER JOIN keyword, so it is reproduced by
   UNION-ing a LEFT JOIN with a RIGHT JOIN.                                          */


-- Q23. List the Foreign Keys; what happens if you insert an order with customer_id = 999?
/* Foreign Key links:
     orders.customer_id     -> customers.customer_id
     order_items.order_id   -> orders.order_id
     order_items.product_id -> products.product_id

   Inserting an order with customer_id = 999 is rejected, because no customer numbered
   999 exists for the foreign key to point at. MySQL raises a "Cannot add or update a
   child row: a foreign key constraint fails" error. This is referential integrity at
   work — an order is not allowed to reference a customer that isn't really there.    */


-- ----------------------------------------------------------------------------
-- SECTION E — Advanced SQL Concepts & Transactions
-- ----------------------------------------------------------------------------

-- Q24. Use CASE to bucket products into price tiers.
SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 1000 THEN 'Budget'
        WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_tier
FROM products;


-- Q25. CASE within an aggregate: 'Delivered' vs 'Not Delivered' counts on one row.
SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_orders
FROM orders;


-- Q26. Walk through ACID using a money-transfer scenario.
/* Picture moving 1000 from account A to account B. The four ACID properties:
     A - Atomicity:   The whole transfer is one indivisible unit. Either both the
                      debit on A and the credit on B go through, or neither does — if
                      the credit fails, the debit is undone, so money is never lost.
     C - Consistency: Every transaction takes the database from one valid state to
                      another while respecting all rules. The combined balance of the
                      two accounts is identical before and after.
     I - Isolation:   Simultaneous transactions stay out of each other's way. Run two
                      transfers together and neither one sees the other's half-done
                      changes — each works against a coherent view.
     D - Durability:  After a commit, the change is permanent. Should the server crash
                      a moment later, the updated balances are still there on restart. */


-- Q27. Atomic transaction: add order 1011, two items, decrement stock; COMMIT/ROLLBACK.
START TRANSACTION;

-- Step 1: create the order header
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

-- Step 2: add the two line items (item_id is mandatory since it is the PK)
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES
    (5016, 1011, 201, 1, 1499.00, 0),
    (5017, 1011, 207, 1,  899.00, 0);

-- Step 3: draw down the stock for each product bought
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 201;
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 207;

-- Step 4: finalize once every step has gone through cleanly
COMMIT;
-- Should any statement above have errored, issue  ROLLBACK;  in place of COMMIT
-- to discard the whole transaction and leave the data exactly as it was.

-- ############################################################################
-- ASSIGNMENT COMPLETED
-- ############################################################################
