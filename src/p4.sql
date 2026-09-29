/*
Problem 4 - Update Product Price

Approach:
WHERE product_id = 1 uses the primary key, so exactly one row is
updated. Without a WHERE clause, every product would be changed.


*/

UPDATE  inventories 
SET     price = 800.00
WHERE   product_id=1;

/*
increase the price of all products by 10%

The new price is calculated from the current price (price * 1.10).
The WHERE clause is intentionally left out so every product is
updated. price is DECIMAL(10,2), so results are stored rounded to
2 decimal places.
*/

UPDATE  inventories
SET     price = (price*1.1);

/*
Expected: 6 rows affected.
product_id | product_name   | before  | after
1          | Laptop         | 1100.00 | 1210.00
2          | Wireless Mouse |   25.00 |   27.50
3          | Keyboard       |   45.00 |   49.50
4          | Monitor        |  300.00 |  330.00
5          | USB-C Cable    |   10.00 |   11.00
6          | Desk Lamp      |   35.00 |   38.50
*/