/*
Problem 6 - Retrieve Employees with High Salary

Approach:
WHERE salary > 50000 keeps only employees earning strictly more than
50,000. An employee earning exactly 50,000 is excluded (Mary Lim in
the dummy data tests this boundary); ">=" would be used if 50,000
itself should be included.
ORDER BY makes the output order predictable.

*/

SELECT name, position
FROM employees
WHERE salary > 50000.00
ORDER BY salary DESC, name;

/*
Expected result (7 employees; Mary Lim at exactly 50,000 is excluded):
name        | position
Kevin Wong  | Senior Engineer
Siti Rahman | Senior Engineer
John Tan    | Sales Manager
Daniel Lee  | Marketing Manager
Priya Nair  | Software Engineer
Farah Aziz  | HR Manager
Ahmad Ali   | Sales Executive
*/

/*
Top three highest-paid employees (names, positions, salaries)

ORDER BY salary DESC sorts employees from highest to lowest salary,
and LIMIT 3 keeps the first three rows. name is used as a second sort
column so employees with the same salary always appear in the same
order.

*/

SELECT name, position, salary
FROM employees
ORDER BY salary DESC, name
LIMIT 3;

/*
Expected result:
name        | position        | salary
Kevin Wong  | Senior Engineer | 95000.00
Siti Rahman | Senior Engineer | 95000.00
John Tan    | Sales Manager   | 72000.00
*/
