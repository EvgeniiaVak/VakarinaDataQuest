/* 
 * 
 * Write a query that works out how many customers that are in the USA 
 * and have purchased more than $90 are assigned to each sales support agent. 
 * For the purposes of this exercise, no two employees have the same name.
 * 
 * Your result should have the following columns, in order:
 * - employee_name - The first_name and last_name of the employee separated by a space, eg Luke Skywalker.
 * - customers_usa_gt_90 - The number of customer assigned to that employee 
 * 		that are both from the USA and have have purchased more than $90 worth of tracks.
 * The result should include all employees with the title "Sales Support Agent", but not employees with any other title.
 * Order your results by the employee_name column.
 * 
 */

SELECT 
	e.first_name || ' ' || e.last_name AS employee_name,
	e.employee_id 
FROM employee e 
WHERE e.title = 'Sales Support Agent'
ORDER BY employee_name
;

SELECT *
FROM customer_gt_90_dollars cgd 
INTERSECT 
SELECT *
FROM customer_usa cu 
;

SELECT 
	support_rep_id,
	count(*) AS customers_usa_gt_90
FROM (
		SELECT *
		FROM customer_gt_90_dollars cgd 
		INTERSECT 
		SELECT *
		FROM customer_usa cu 
	)
GROUP BY support_rep_id
;

WITH c AS (
	SELECT 
		support_rep_id,
		count(*) AS customers_usa_gt_90
	FROM (
			SELECT *
			FROM customer_gt_90_dollars cgd 
			INTERSECT 
			SELECT *
			FROM customer_usa cu 
		)
	GROUP BY support_rep_id
)
SELECT 
	e.first_name || ' ' || e.last_name AS employee_name,
	COALESCE (c.customers_usa_gt_90, 0) AS customers_usa_gt_90
FROM employee e 
LEFT JOIN c ON c.support_rep_id = e.employee_id 
WHERE e.title = 'Sales Support Agent'
ORDER BY employee_name
;

