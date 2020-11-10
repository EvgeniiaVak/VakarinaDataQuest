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
	sum(i.total) AS total
FROM invoice i 
INNER JOIN customer c
	ON c.customer_id = i.customer_id 
INNER JOIN employee e
	ON e.employee_id = c.support_rep_id 
WHERE i.invoice_date >= '2018-01-01 00:00:00'
GROUP BY 
	1
ORDER BY 2 DESC
;

