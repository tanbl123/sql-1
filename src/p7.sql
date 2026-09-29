/*
Problem 7 - Delete Customer

Approach:
WHERE customer_id = 6 uses the primary key, so exactly one customer is
deleted. Customer 6 (Frank Miller) has no orders or sales, so the
delete succeeds.

The foreign keys in p1.sql use ON DELETE RESTRICT, so a customer who
still has orders or sales cannot be deleted this way: MySQL blocks it
with a foreign key error to protect those records. The bonus handles
that case.

*/

DELETE FROM customers
WHERE customer_id = 6;

/*
Delete a customer together with their related records

Customer 1 (Alice Johnson) has orders and sales, so the related rows
are deleted first, from the deepest child table upwards:
  1. sales     - items belonging to the customer's orders
  2. orders    - the customer's orders
  3. customers - the customer
Deleting in any other order would be blocked by a foreign key
(e.g. orders cannot be deleted while sales still refer to them).

Sales are found through the customer's orders (order_id IN ...) rather
than sales.customer_id, so every item of every order is removed even if
the duplicated customer_id column were inconsistent.

The three deletes run inside a transaction, so they succeed or fail
together. If any statement fails, ROLLBACK undoes the others, and the
data is never left half-deleted.

*/


START TRANSACTION;

DELETE FROM sales
WHERE order_id IN (SELECT order_id FROM orders WHERE customer_id=1);

DELETE FROM orders
WHERE customer_id=1;

DELETE FROM customers
WHERE customer_id=1;
COMMIT;


