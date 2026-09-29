/*
Problem 3 - Sales Analysis

Approach:
The sales table has one row per product within an order, so one order
can have several sales rows (19 rows for 10 orders in the dummy data).
The average must therefore be calculated in two steps:
  1. The subquery groups sales by order_id and adds up each order's
     quantity, giving one total per order.
  2. The outer query adds up those order totals (total quantity sold)
     and averages them (average quantity per order).

*/

SELECT  SUM(order_quantity) AS total_quantity_sold,
        ROUND(AVG(order_quantity),2) AS average_quantity_sold
FROM (
    SELECT  order_id,
            SUM(quantity) AS order_quantity
    FROM sales
    GROUP BY order_id
) AS order_totals;

/*
Expected result:
total_quantity_sold | average_quantity_sold
36                  | 3.60
*/

/*
Bonus - include the total sales amount and average sales amount per order

sales does not store prices, so it is joined with inventories on
product_id. Each order's sales amount is the sum of quantity x price
over its product lines, calculated in the subquery alongside the
quantity. The outer query then adds up and averages those order amounts.

*/

SELECT  SUM(order_quantity) AS total_quantity_sold,
        ROUND(AVG(order_quantity),2) AS average_quantity_sold,
        ROUND(SUM(sales_amount),2) AS total_sales_amount,
        ROUND(AVG(sales_amount),2) AS average_sales_amount
FROM (
    SELECT  s.order_id,
            SUM(s.quantity) AS order_quantity,
            SUM(s.quantity*i.price) AS sales_amount 
    FROM sales s
    JOIN inventories i ON s.product_id=i.product_id
    GROUP BY s.order_id
) AS order_totals;

/*
Expected result:
total_quantity_sold | average_quantity_sold | total_sales_amount | average_sales_amount
36                  | 3.60                  | 6690.00            | 669.00
*/