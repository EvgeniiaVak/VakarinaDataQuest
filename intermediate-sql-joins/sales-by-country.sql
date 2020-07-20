
/* 
 * Write a query that collates data on purchases from different countries.
 * 
 * Where a country has only one customer, collect them into an "Other" group.
 * The results should be sorted by the total sales from highest to lowest, 
 * with the "Other" group at the very bottom.
 * 
 * You have been given guidance to use the country value from the customers table, 
 * and ignore the country from the billing address in the invoice table.
 * 
 * For each country, include:
 * - total number of customers
 * - total value of sales
 * - average value of sales per customer
 * - average order value
 */

SELECT 
	i.customer_id AS customer_id,
	SUM(i.total) AS total,
	AVG(i.total) AS average_order 
FROM invoice i
GROUP BY 1
;

WITH 
	customer_spending AS 
		(
			SELECT 
				i.customer_id AS customer_id,
				SUM(i.total) AS total,
				AVG(i.total) AS average_order 
			FROM invoice i
			GROUP BY 1
		)
SELECT 
	c.country AS country_name,
	COUNT(c.customer_id) AS n_customers, 
	SUM(s.total) AS total,
	AVG(s.total) AS average_customer,
	AVG(s.average_order) AS average_order 
FROM customer c 
JOIN customer_spending s ON s.customer_id = c.customer_id 
GROUP BY 1
;


WITH 
	customer_spending AS 
		(
			SELECT 
				i.customer_id AS customer_id,
				SUM(i.total) AS total,
				AVG(i.total) AS average_order 
			FROM invoice i
			GROUP BY 1
		),
	country_spending AS 
		(
			SELECT 
				c.country AS country_name,
				COUNT(c.customer_id) AS n_customers, 
				SUM(s.total) AS total,
				AVG(s.total) AS average_customer,
				AVG(s.average_order) AS average_order 
			FROM customer c 
			JOIN customer_spending s ON s.customer_id = c.customer_id 
			GROUP BY 1
		)
SELECT 
	CASE 
		WHEN cs.n_customers = 1 THEN 1
		ELSE 0
	END AS sort,
	CASE 
		WHEN cs.n_customers = 1 THEN 'Other' 
		ELSE cs.country_name
	END AS country,
	SUM(cs.total) AS total,
	AVG(cs.average_customer) AS average_customer,
	AVG(cs.average_order) AS average_order 
FROM country_spending cs
GROUP BY 2
ORDER BY 1
;


WITH 
	customer_spending AS 
		(
			SELECT 
				i.customer_id AS customer_id,
				SUM(i.total) AS total,
				AVG(i.total) AS average_order 
			FROM invoice i
			GROUP BY 1
		),
	country_spending AS 
		(
			SELECT 
				c.country AS country_name,
				COUNT(c.customer_id) AS n_customers, 
				SUM(s.total) AS total,
				AVG(s.total) AS average_customer,
				AVG(s.average_order) AS average_order 
			FROM customer c 
			JOIN customer_spending s ON s.customer_id = c.customer_id 
			GROUP BY 1
		),
	country_spending_grouped AS 
		(
			SELECT 
				CASE 
					WHEN cs.n_customers = 1 THEN 1
					ELSE 0
				END AS sort,
				CASE 
					WHEN cs.n_customers = 1 THEN 'Other' 
					ELSE cs.country_name
				END AS country,
				SUM(cs.total) AS total,
				AVG(cs.average_customer) AS average_customer,
				AVG(cs.average_order) AS average_order 
			FROM country_spending cs
			GROUP BY 2
			ORDER BY 1
		)
SELECT
	country,
	ROUND(total, 2) AS total,
	ROUND(average_customer, 2) AS average_customer,
	ROUND(average_order, 2) AS average_order
FROM country_spending_grouped 
;
