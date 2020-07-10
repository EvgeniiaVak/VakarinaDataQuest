PRAGMA table_info('employee');

SELECT name FROM PRAGMA_TABLE_INFO('employee');

SELECT 
	first_name || ' ' || last_name AS name,
	hire_date 
FROM employee e 
WHERE title = 'Sales Support Agent'
;

SELECT 
	e.first_name || ' ' || e.last_name AS name,
	i.invoice_date,
	sum(i.total) AS total
FROM invoice i 
INNER JOIN customer c
	ON c.customer_id = i.customer_id 
INNER JOIN employee e
	ON e.employee_id = c.support_rep_id 
GROUP BY 
	1,
	2 
;

