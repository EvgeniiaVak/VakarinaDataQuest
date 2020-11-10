CREATE VIEW customer_usa AS 
	SELECT * FROM customer
	WHERE country = 'USA'
;


/*
 * 
 * Create a view called customer_gt_90_dollars:
 *  - The view should contain the columns from customers, in their original order.
 *  - The view should contain only customers who have purchased more than $90 in tracks from the store.
 * 
 * After the SQL query that creates the view, write a second query to display your newly created view: 
 * SELECT * FROM chinook.customer_gt_90_dollars;.
 * 
 */

CREATE VIEW customer_gt_90_dollars AS
	WITH customer_total
		AS (
			SELECT i.customer_id, SUM(i.total) AS total 
			FROM invoice i 
			GROUP BY i.customer_id 
		)
	SELECT customer.* FROM customer
	INNER JOIN customer_total ON customer.customer_id = customer_total.customer_id
		AND customer_total.total > 90
;

SELECT * FROM customer_gt_90_dollars;

SELECT i.customer_id, SUM(i.total) 
FROM invoice i 
GROUP BY i.customer_id 

WITH customer_total
AS (
	SELECT i.customer_id, SUM(i.total) AS total 
	FROM invoice i 
	GROUP BY i.customer_id 
)
SELECT customer.* FROM customer
INNER JOIN customer_total ON customer.customer_id = customer_total.customer_id
	AND customer_total.total > 90
;


