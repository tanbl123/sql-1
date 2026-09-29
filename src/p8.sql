/*
Problem 8 - Query Performance Optimization

Query to optimise:
  SELECT * FROM employees
  WHERE department = 'Sales' AND salary > 50000;

Without an index, the database performs a full table scan: it reads
every row in employees and checks both conditions on each one. This
becomes slow as the table grows.

Proposed index: a composite index on (department, salary).
*/

CREATE INDEX idx_employees_department_salary 
ON employees (department, salary);

/*
Reasoning

1. Both columns in the WHERE clause are included.
   A composite index is sorted by department first and, within each
   department, by salary. The database can jump straight to the
   'Sales' section and then, within it, straight to salaries above
   50,000, reading only the matching rows.

2. Column order: equality first, range last.
   department uses "=" and salary uses ">" (a range). Putting the
   equality column first keeps all Sales employees together, sorted
   by salary, so both conditions narrow down one continuous section
   of the index.
   The reverse order (salary, department) would be much less
   effective: the index would be sorted by salary, so "salary > 50000"
   would cover a large range, with Sales employees scattered through
   it. Once an index reaches a range condition, the columns after it
   can no longer be used to jump to rows.

3. Selectivity.
   Selectivity is how much a condition narrows down the rows. In a
   typical company, one department is a small share of all employees,
   while "salary > 50000" can match a large share of them. department
   is therefore the more selective starting point, which also supports
   putting it first.

4. Why not two separate single-column indexes?
   An index on department alone would find all Sales employees, but
   each of their rows would still have to be checked for salary.
   An index on salary alone would match a large share of the table.
   MySQL can sometimes combine two indexes (index merge), but a single
   composite index answering both conditions is generally more
   efficient.

5. The order of the conditions in the WHERE clause does not matter.
   "department = 'Sales' AND salary > 50000" and
   "salary > 50000 AND department = 'Sales'" use the index the same way;
   the query optimiser rearranges them. What matters is the column order
   inside the index.
*/

EXPLAIN
SELECT * FROM employees
WHERE department = 'Sales' AND salary > 50000;

/*
Before the index:
id |select_type | table     | type  | possible_keys | key  | key_len | ref  | rows | Extra
1  |SIMPLE	    | employees | ALL   | NULL	        | NULL | NULL	 | NULL | 11   | Using where	

After the index: 
id |select_type | table     | type  | possible_keys                   | key                             | key_len | ref  | rows | Extra
1  |SIMPLE	    | employees	| range | idx_employees_department_salary |	idx_employees_department_salary | 808	  | NULL |	2	| Using index condition	

With only 11 rows the time difference is tiny, but on a table with
thousands or millions of employees, reading only the matching rows
instead of the whole table is a significant improvement.

*/

/*
Trade-offs and drawbacks

1. Extra storage: the index is a separate sorted copy of the department
   and salary values (plus a pointer to each row), stored on disk and
   partly in memory. department is VARCHAR(200), which makes each index
   entry larger; a shorter column such as VARCHAR(100) would reduce the
   index size.

2. Slower writes: every INSERT and DELETE on employees, and every UPDATE
   that changes department or salary, must also update the index.
   A pay rise or department transfer therefore costs slightly more.

3. More indexes, more maintenance: each additional index adds storage
   and write cost, so indexes should only be created for queries that
   run often. Unused indexes should be removed.

4. The index only helps queries that filter on department first.
   A query filtering only on salary (e.g. WHERE salary > 50000, as in
   Problem 6) cannot use this index efficiently, because salary is the
   second column.

*/
