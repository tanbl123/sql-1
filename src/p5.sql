/*
Problem 5 - Department Statistics

Approach:
"For each department" means one result per department, so GROUP BY
department puts each department's employees into one group, and AVG()
calculates one average per group. department is selected so each
average is labelled with its department. ROUND(..., 2) keeps the
result to 2 decimal places.

*/

SELECT  department,
        ROUND(AVG(salary),2) AS average_salary
FROM    employees
GROUP BY    department
ORDER BY    department;

/*
Expected result:
department  | average_salary
Engineering | 86000.00
HR          | 49000.00
Marketing   | 57500.00
Sales       | 51000.00
*/

/*
Highest salary for each department, and the employee(s) with that salary

This needs two steps, because GROUP BY collapses each department into
one row, so it cannot also show which individual employees earn the
highest salary:
  1. The subquery (dept_max) finds the highest salary in each
     department using GROUP BY and MAX().
  2. The outer query joins employees to dept_max and keeps only the
     employees whose salary equals the highest salary of their own
     department.

The join matches on BOTH department and salary. Matching on salary
alone could wrongly include an employee whose salary happens to equal
another department's maximum.

Ties are handled automatically: every employee whose salary equals the
maximum is returned. In the dummy data, Kevin Wong and Siti Rahman
share Engineering's highest salary, so both appear.

*/

SELECT  e.department,
        e.salary AS highest_salary,
        e.name
FROM    employees e
JOIN(
    SELECT  department,
        MAX(salary) AS max_salary
    FROM    employees
    GROUP BY    department
) AS dept_max
    ON  e.department = dept_max.department
    AND e.salary = dept_max.max_salary
ORDER BY e.department, e.name;

/*
Expected result (Engineering has a tie, so it appears twice):
department  | highest_salary | name
Engineering | 95000.00       | Kevin Wong
Engineering | 95000.00       | Siti Rahman
HR          | 60000.00       | Farah Aziz
Marketing   | 70000.00       | Daniel Lee
Sales       | 72000.00       | John Tan
*/
