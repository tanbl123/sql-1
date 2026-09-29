# ASD Interview Questions

## Instructions

- Fork this repository into your own GitHub account. If you don't have a GitHub account, please create one.
- Commit all your changes to your forked repository, following clean Git commit hygiene.
    - Demonstrate clean Git commit hygiene, following best practices for commit messages and organizing your commits.
    - For guidelines on clean Git commit hygiene, you can refer to [this source](https://cbea.ms/git-commit/).
- Place all your source code files in the `src` folder.
    - For each question, create a file for the solution. e.g. `p1.sql`, `p2.sql`, etc.
- The bonus challenge in each problem is optional but greatly welcomed. You can choose to tackle it if you'd like.
- Include comments in your code to explain your approach, algorithms, and any important details.
- Preferred SQL syntax is PostgreSQL, but you are allowed to use any SQL syntax (e.g. MySQL, SQL server, etc).

## Problems

### Problem 1 - Table Creation (DDL)

Write SQL statements to create the following tables. Subsequent problems that follow will need to use these tables. Provide dummy data insert script for all tables.

**Table: employees**

| Column      | Type     |
|-------------|----------|
| id          | integer  |
| name        | text     |
| position    | text     |
| department  | text     |
| salary      | numeric  |

**Table: sales**

| Column        | Type     |
|---------------|----------|
| order_id      | integer  |
| customer_id   | integer  |
| product_id    | integer  |
| quantity      | integer  |
| sale_date     | date     |

**Table: customers**

| Column        | Type     |
|---------------|----------|
| customer_id   | integer  |
| customer_name | text     |
| city          | text     |

**Table: orders**

| Column        | Type     |
|---------------|----------|
| order_id      | integer  |
| order_date    | date     |
| customer_id   | integer  |
| total_amount  | numeric  |

**Table: inventories**

| Column        | Type     |
|---------------|----------|
| product_id    | integer  |
| product_name  | text     |
| quantity      | integer  |
| price         | numeric  |

**Bonus**: Write additional SQL statements to add constraints such as primary keys and foreign keys, to the created tables.

Note:
- You are allowed to counter propose table design as you see fit when tackling the subsequent problems.
- You are allowed to create additional tables if needed for a more normalized design in the subsequent problems.

### Problem 2 - Retrieve Orders from 'New York'

With reference to tables created in Problem 1, write an SQL query to retrieve the customer names, order dates, and total amounts for all orders placed by customers from the city 'New York'.

**Bonus**: Modify the query to include the average total amount per customer for orders placed in the city 'New York'.

### Problem 3 - Sales Analysis

With reference to tables created in Problem 1, write an SQL query to calculate the total quantity sold and the average quantity sold per order.

**Bonus**: Modify the query to include the total sales amount and average sales amount per order.

### Problem 4 - Update Product Price

With reference to tables created in Problem 1, write an SQL query to update the price of a specific product by specifying the `product_id`.

**Bonus**: Modify the query to update the price of all products by increasing it by 10%.

### Problem 5 - Department Statistics

With reference to tables created in Problem 1, write an SQL query to calculate the average salary for each department.

**Bonus**: Modify the query to calculate the highest salary for each department and retrieve the department name, highest salary, and the employee(s) with that salary.

### Problem 6 - Retrieve Employees with High Salary

With reference to tables created in Problem 1, write an SQL query to retrieve the names and positions of all employees with a salary greater than $50,000.

**Bonus**: Modify the query to retrieve the names, positions, and salaries of the top three highest-paid employees.

### Problem 7 - Delete Customer

With reference to the tables created in Problem 1, write an SQL statement to delete a specific customer. You can specify the customer to delete by their `customer_id`.

**Bonus**: Modify the query to delete any related records associated with the customer being deleted to maintain data integrity.

### Problem 8 - Query Performance Optimization

Consider the following SQL query:

```sql
SELECT *
FROM employees
WHERE department = 'Sales' AND salary > 50000;
```

With reference to the tables created in Problem 1, analyze the query and propose an index or indexes that can significantly improve its performance.

Explain your reasoning behind choosing the specific column(s) for the index(es) and how they would enhance the execution of the query. Consider the selectivity of the columns, the order of the conditions, and any other factors that may impact the query performance.

**Bonus**: Discuss any potential trade-offs or drawbacks of implementing the suggested index(es), such as increased storage space or impact on write operations.

---

## My Solution

### SQL dialect

All solutions are written for **MariaDB 10.4** (MySQL-compatible) and tested in XAMPP phpMyAdmin. The instructions allow any SQL dialect; I chose MySQL/MariaDB because it is the dialect I have hands-on experience with and can explain confidently.

The question's column types are mapped to MySQL types:

| Question | MySQL |
|---|---|
| integer | INT |
| text | VARCHAR(n) |
| numeric | DECIMAL(10,2) |
| date | DATE |

### How to run

1. Create an empty database, e.g. `CREATE DATABASE asd_sql;`
2. Run `src/p1.sql` first. It creates the tables and inserts the dummy data, and can be re-run at any time to reset the data.
3. Run any of `src/p2.sql` to `src/p8.sql`. Each file contains the main answer, the bonus answer, and the expected result in comments.

**Note:** `p4.sql` (update prices) and `p7.sql` (delete customers) change the data. Re-run `p1.sql` after them so the other files return the expected results. `p8.sql` creates an index, so re-run `p1.sql` before running it a second time.

### Design decisions

- **sales table:** `sales` stores the items within each order (one row per product per order), with a composite primary key `(order_id, product_id)` and a foreign key to `orders`. `sales.customer_id` and `sale_date` duplicate data already in `orders`; they are kept to match the given design, but a more normalised design would remove them.
- **Foreign keys use `ON DELETE RESTRICT`:** a customer with orders cannot be deleted by accident. Problem 7's bonus deletes the related records explicitly, inside a transaction.
- **Dummy data** is chosen to test the later problems, for example a salary tie in Engineering (Problem 5), a salary of exactly 50,000 (Problem 6), and a customer with no orders (Problem 7).