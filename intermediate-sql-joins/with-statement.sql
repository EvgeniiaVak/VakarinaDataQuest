/*
 * Write a query that uses multiple named subqueries in a WITH clause to gather total sales data on customers from India:
 * The first named subquery should return all customers that are from India.
 * The second named subquery should calculate the sum total for every customer.
 * The main query should join the two named subqueries, resulting in the following final columns:
 *  - customer_name - The first_name and last_name of the customer, separated by a space, eg Luke Skywalker.
 *  - total_purchases - The total amount spent on purchases by that customer.
 * The results should be sorted by the customer_name column in alphabetical order.
 */

SELECT 
	customer_id,
	first_name || ' ' || last_name AS customer_name
FROM customer  
WHERE country = 'India'
;

SELECT 
	c.customer_id,
	sum(i.total) AS total_purchases
FROM customer c
LEFT JOIN invoice i ON i.customer_id = c.customer_id 
GROUP BY c.customer_id
;

WITH 
	n AS (
		SELECT 
			customer_id,
			first_name || ' ' || last_name AS customer_name
		FROM customer  
		WHERE country = 'India'
	),
	p AS (
		SELECT 
			c.customer_id,
			sum(i.total) AS total_purchases
		FROM customer c
		LEFT JOIN invoice i ON i.customer_id = c.customer_id 
		GROUP BY c.customer_id
	)
SELECT 
	n.customer_name,
	p.total_purchases
FROM n
LEFT JOIN p ON p.customer_id = n.customer_id
ORDER BY n.customer_name
;

