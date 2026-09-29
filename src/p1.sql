/*
Problem 1 - Table Creation (DDL)

Database: MariaDB 10.4 (MySQL-compatible), tested in XAMPP phpMyAdmin.

Creates the five tables used by the later problems, adds primary keys,
foreign keys and CHECK constraints (bonus), and inserts dummy data.

Type mapping from the question (PostgreSQL names) to MySQL:
  integer -> INT
  text    -> VARCHAR(n)     can be indexed normally 
  numeric -> DECIMAL(10,2)  stores money exactly, unlike FLOAT/DOUBLE
  date    -> DATE

Table design:
  employees    - independent table
  customers    - parent of orders and sales
  inventories  - parent of sales (the product catalogue)
  orders       - one row per order (who ordered, when, total amount)
  sales        - one row per product within an order (the order's items),
                 so one order can have several sales rows

The script can be run repeatedly: it drops the tables first,
children before parents, so no foreign key blocks the drop.

Key decisions:
  - sales has a composite primary key (order_id, product_id): an order
    can contain several products, but each product appears once per
    order. order_id is a foreign key to orders.
  - sales.customer_id and sale_date repeat information already in
    orders. They are kept to match the design given in the question;
    a more normalised design would remove them.
  - Foreign keys use ON DELETE RESTRICT: a customer, order or product
    that still has related records cannot be deleted.

Constraints:
  Primary keys, foreign keys and CHECK constraints are defined inside
  each CREATE TABLE. CHECK constraints (e.g. no negative salary or
  price, sales quantity > 0) are enforced in MariaDB 10.2.1+ and
  MySQL 8.0.16+.

*/

-- Drop child tables first (sales, orders), then parent tables,
-- because a parent cannot be dropped while a child still references it.
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS inventories;

CREATE TABLE employees (
    id          INT             NOT NULL     AUTO_INCREMENT,
    name        VARCHAR(100)    NOT NULL,
    position    VARCHAR(200),
    department  VARCHAR(200),
    salary      DECIMAL(10,2)   NOT NULL   DEFAULT 0.00,
    PRIMARY KEY (id),
    CONSTRAINT chk_employees_salary CHECK (salary >= 0)
);

CREATE TABLE customers (
    customer_id     INT             NOT NULL    AUTO_INCREMENT,
    customer_name   VARCHAR(100)    NOT NULL,
    city            VARCHAR(100),
    PRIMARY KEY (customer_id)
);

CREATE TABLE inventories (
    product_id      INT             NOT NULL    AUTO_INCREMENT,
    product_name    VARCHAR(200)    NOT NULL,
    quantity        INT             NOT NULL    DEFAULT 0,
    price           DECIMAL(10,2)   NOT NULL    DEFAULT 0.00,
    PRIMARY KEY (product_id),
    CONSTRAINT chk_inventories_quantity CHECK (quantity>=0),
    CONSTRAINT chk_inventories_price CHECK (price>=0)
);

CREATE TABLE orders (
    order_id        INT             NOT NULL    AUTO_INCREMENT,
    order_date      DATE            NOT NULL,
    customer_id     INT             NOT NULL,
    total_amount    DECIMAL(10,2)   NOT NULL     DEFAULT 0.00,
    PRIMARY KEY (order_id),
    CONSTRAINT chk_orders_total_amount CHECK (total_amount>=0),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON DELETE RESTRICT
);

CREATE TABLE sales (
    order_id    INT     NOT NULL,
    customer_id INT     NOT NULL,
    product_id  INT     NOT NULL,
    quantity    INT     NOT NULL,
    sale_date   DATE    NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT chk_sales_quantity CHECK (quantity>0), -- a sale must include at least one item
    CONSTRAINT fk_sales_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_sales_inventory
        FOREIGN KEY (product_id) REFERENCES inventories (product_id)
        ON DELETE RESTRICT
);

INSERT INTO employees (id, name, position, department, salary) VALUES 
    (1,  'John Tan',    'Sales Manager',       'Sales',       72000.00),
    (2,  'Mary Lim',    'Sales Executive',     'Sales',       50000.00),
    (3,  'Ahmad Ali',   'Sales Executive',     'Sales',       52000.00),
    (4,  'Lily Chen',   'Sales Intern',        'Sales',       30000.00),
    (5,  'Siti Rahman', 'Senior Engineer',     'Engineering', 95000.00),
    (6,  'Kevin Wong',  'Senior Engineer',     'Engineering', 95000.00),
    (7,  'Priya Nair',  'Software Engineer',   'Engineering', 68000.00),
    (8,  'Daniel Lee',  'Marketing Manager',   'Marketing',   70000.00),
    (9,  'Grace Ng',    'Marketing Executive', 'Marketing',   45000.00),
    (10, 'Farah Aziz',  'HR Manager',          'HR',          60000.00),
    (11, 'Jason Koh',   'HR Assistant',        'HR',          38000.00);

INSERT INTO customers (customer_id, customer_name, city) VALUES 
    (1, 'Alice Johnson', 'New York'),
    (2, 'Bob Smith',     'Los Angeles'),
    (3, 'Carol White',   'New York'),
    (4, 'David Brown',   'Chicago'),
    (5, 'Emma Davis',    'New York'),
    (6, 'Frank Miller',  'Houston');     -- no orders (useful for Problem 7)

INSERT INTO inventories (product_id, product_name, quantity, price) VALUES
    (1, 'Laptop',         25, 1200.00),
    (2, 'Wireless Mouse', 150,  25.00),
    (3, 'Keyboard',       100,  45.00),
    (4, 'Monitor',         40, 300.00),
    (5, 'USB-C Cable',    300,  10.00),
    (6, 'Desk Lamp',       60,  35.00);

-- total_amount = sum of (quantity x price) of the order's sales rows
INSERT INTO orders (order_id, order_date, customer_id, total_amount) VALUES
    (101, '2024-01-05', 1, 1250.00),
    (102, '2024-01-12', 2,  630.00),
    (103, '2024-02-03', 3,   70.00),
    (104, '2024-02-15', 1,  300.00),
    (105, '2024-03-01', 4, 2470.00),
    (106, '2024-03-10', 5,   85.00),
    (107, '2024-03-22', 3, 1545.00),
    (108, '2024-04-02', 2,  100.00),
    (109, '2024-04-18', 5,  110.00),
    (110, '2024-05-06', 1,  130.00);

INSERT INTO sales (order_id, customer_id, product_id, quantity, sale_date) VALUES
    (101, 1, 1, 1, '2024-01-05'),   -- Laptop       1 x 1200 = 1200
    (101, 1, 2, 2, '2024-01-05'),   -- Mouse        2 x 25   =   50  -> 1250
    (102, 2, 4, 2, '2024-01-12'),   -- Monitor      2 x 300  =  600
    (102, 2, 5, 3, '2024-01-12'),   -- Cable        3 x 10   =   30  ->  630
    (103, 3, 3, 1, '2024-02-03'),   -- Keyboard     1 x 45   =   45
    (103, 3, 2, 1, '2024-02-03'),   -- Mouse        1 x 25   =   25  ->   70
    (104, 1, 4, 1, '2024-02-15'),   -- Monitor      1 x 300  =  300  ->  300
    (105, 4, 1, 2, '2024-03-01'),   -- Laptop       2 x 1200 = 2400
    (105, 4, 6, 2, '2024-03-01'),   -- Desk Lamp    2 x 35   =   70  -> 2470
    (106, 5, 5, 5, '2024-03-10'),   -- Cable        5 x 10   =   50
    (106, 5, 6, 1, '2024-03-10'),   -- Desk Lamp    1 x 35   =   35  ->   85
    (107, 3, 1, 1, '2024-03-22'),   -- Laptop       1 x 1200 = 1200
    (107, 3, 4, 1, '2024-03-22'),   -- Monitor      1 x 300  =  300
    (107, 3, 3, 1, '2024-03-22'),   -- Keyboard     1 x 45   =   45  -> 1545
    (108, 2, 2, 4, '2024-04-02'),   -- Mouse        4 x 25   =  100  ->  100
    (109, 5, 3, 2, '2024-04-18'),   -- Keyboard     2 x 45   =   90
    (109, 5, 5, 2, '2024-04-18'),   -- Cable        2 x 10   =   20  ->  110
    (110, 1, 6, 3, '2024-05-06'),   -- Desk Lamp    3 x 35   =  105
    (110, 1, 2, 1, '2024-05-06');   -- Mouse        1 x 25   =   25  ->  130