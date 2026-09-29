/*
Problem 2 - Retrieve Orders from 'New York'

Approach:
The city is stored in customers and the orders are stored in orders,
so the two tables are joined on customer_id. WHERE keeps only
customers whose city is 'New York'.

*/

SELECT  c.customer_name,
        o.order_date,
        o.total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE c.city='New York'
ORDER BY c.customer_id,o.order_date;

/*
Expected result (7 orders):
customer_name | order_date | total_amount
Alice Johnson | 2024-01-05 | 1250.00
Alice Johnson | 2024-02-15 |  300.00
Alice Johnson | 2024-05-06 |  130.00
Carol White   | 2024-02-03 |   70.00
Carol White   | 2024-03-22 | 1545.00
Emma Davis    | 2024-03-10 |   85.00
Emma Davis    | 2024-04-18 |  110.00
*/

/*
Include the average total amount per customer

The main query is modified by adding one column. AVG() OVER
(PARTITION BY customer_id) is a window function: it calculates the
average separately for each customer, like GROUP BY, but keeps every
order row instead of collapsing them into one row per customer.
So each order shows its own total_amount alongside its customer's
average.

GROUP BY alone could not be used here: it returns one row per
customer, so individual order dates and amounts would be lost.

*/

SELECT  c.customer_name, 
        o.order_date, 
        o.total_amount, 
        ROUND(AVG(o.total_amount) OVER(PARTITION BY c.customer_id),2) 
            AS avg_total_amount_per_customer
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE c.city = 'New York'
ORDER BY c.customer_id, o.order_date;


/*
Expected result:
customer_name | order_date | total_amount | avg_total_amount_per_customer
Alice Johnson | 2024-01-05 | 1250.00      | 560.00
Alice Johnson | 2024-02-15 |  300.00      | 560.00
Alice Johnson | 2024-05-06 |  130.00      | 560.00
Carol White   | 2024-02-03 |   70.00      | 807.50
Carol White   | 2024-03-22 | 1545.00      | 807.50
Emma Davis    | 2024-03-10 |   85.00      |  97.50
Emma Davis    | 2024-04-18 |  110.00      |  97.50
*/

