-- Write a query that gathers data about the invoice with an invoice_id of 4. Include the following columns in order:

/*
The id of the track, track_id.
The name of the track, track_name.
The name of media type of the track, track_type.
The price that the customer paid for the track, unit_price.
The quantity of the track that was purchased, quantity.
*/ 

SELECT 
	il.track_id, 
	t.name AS track_name, 
	mt.name AS track_type,
	il.unit_price,
	il.quantity 
FROM invoice_line il 
JOIN track t ON t.track_id = il.track_id 
JOIN media_type mt ON mt.media_type_id = t.media_type_id 
WHERE il.invoice_id = 4
;

/*
Add a column containing the artists name to the query from the previous screen.
The column should be called artist_name
The column should be placed between track_name and track_type
 */

SELECT 
	il.track_id, 
	t.name AS track_name, 
	a.name AS artist_name,
	mt.name AS track_type,
	il.unit_price,
	il.quantity	
FROM invoice_line il 
JOIN track t ON t.track_id = il.track_id 
JOIN media_type mt ON mt.media_type_id = t.media_type_id 
JOIN album ON album.album_id = t.album_id 
JOIN artist a ON a.artist_id = album.artist_id 
WHERE il.invoice_id = 4
;

/*
 * a query that lists the top 10 artists, calculated by the number of times a track by that artist has been purchased
 */
SELECT
    t.track_id,
    ar.name artist_name
FROM track t
INNER JOIN album al ON al.album_id = t.album_id
INNER JOIN artist ar ON ar.artist_id = al.artist_id
;

SELECT
    ta.artist_name artist,
    COUNT(*) tracks_purchased
FROM invoice_line il
INNER JOIN (
            SELECT
                t.track_id,
                ar.name artist_name
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta
           ON ta.track_id = il.track_id
GROUP BY 1
ORDER BY 2 DESC LIMIT 10
;


/*
 * Write a query that returns the top 5 albums, 
 * as calculated by the number of times a track from that album has been purchased. 
 * Your query should be sorted from most tracks purchased to least tracks purchased 
 * and return the following columns, in order:
 * - album, the title of the album
 * - artist, the artist who produced the album
 * - tracks_purchased the total number of tracks purchased from that album
*/

SELECT 
	track_id, 
	SUM(quantity) AS tracks_purchased
FROM invoice_line il 
GROUP BY track_id 
;

SELECT 
	al.title AS album,
	SUM(tp.tracks_purchased) AS tracks_purchased
FROM track t 
INNER JOIN album al ON al.album_id = t.album_id 
INNER JOIN (
	SELECT 
		track_id, 
		SUM(quantity) AS tracks_purchased
	FROM invoice_line il 
	GROUP BY track_id 
) AS tp
GROUP BY album
ORDER BY tracks_purchased DESC
LIMIT 5
;


SELECT 
	al.title AS album,
	ar.name AS artist,
	SUM(tp.tracks_purchased) AS tracks_purchased
FROM track t
INNER JOIN album al ON al.album_id = t.album_id 
INNER JOIN artist ar ON ar.artist_id = al.artist_id 
INNER JOIN (
	SELECT 
		track_id, 
		SUM(quantity) AS tracks_purchased
	FROM invoice_line il 
	GROUP BY track_id 
) AS tp ON tp.track_id = t.track_id
GROUP BY album
ORDER BY tracks_purchased DESC
LIMIT 5
;


/*
Write a query that returns information about each employee and their supervisor.
The report should include employees even if they do not report to another employee.
The report should be sorted alphabetically by the employee_name column.
Your query should return the following columns, in order:
employee_name - containing the first_name and last_name columns separated by a space, eg Luke Skywalker
employee_title - the title of that employee
supervisor_name - the first and last name of the person the employee reports to, in the same format as employee_name
supervisor_title - the title of the person the employee reports to
*/

SELECT 
	e.first_name || ' ' || e.last_name AS employee_name,
	e.title AS employee_title,
	s.first_name || ' ' || s.last_name AS supervisor_name,
	s.title AS supervisor_title
FROM employee e
LEFT JOIN employee s ON s.employee_id = e.reports_to 
ORDER BY 1
;


/*
 * Write a query that summarizes the purchases of each customer. 
 * For the purposes of this exercise, we do not have any two customers with the same name.
Your query should include the following columns, in order:
customer_name - containing the first_name and last_name columns separated by a space, eg Luke Skywalker.
number_of_purchases, counting the number of purchases made by each customer.
total_spent - the total sum of money spent by each customer.
customer_category - a column that categorizes the customer based on their total purchases. The column should contain the following values:
	small spender - If the customer's total purchases are less than $40.
	big spender - If the customer's total purchases are greater than $100.
	regular - If the customer's total purchases are between $40 and $100 (inclusive).
Order your results by the customer_name column.
 */

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(*) AS number_of_purchases,
    SUM(i.total) AS total_spent,
    CASE 
    	WHEN SUM(i.total) < 40 THEN 'small spender'
    	WHEN SUM(i.total) BETWEEN 40 AND 100 THEN 'regular'
    	ELSE 'big spender'
    END AS customer_category
FROM customer c
LEFT JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY customer_name
ORDER BY customer_name
;


/*
 * Create a query that shows summary data for every playlist in the Chinook database:
Use a WITH clause to create a named subquery with the following info:
	The unique ID for the playlist.
	The name of the playlist.
	The name of each track from the playlist.
	The length of each track in seconds.
Your final table should have the following columns, in order:
	playlist_id - the unique ID for the playlist.
	playlist_name - The name of the playlist.
	number_of_tracks - A count of the number of tracks in the playlist.
	length_seconds - The sum of the length of the playlist in seconds.
The results should be sorted by playlist_id in ascending order.
*/

SELECT 
	p.playlist_id,
	p.name AS playlist_name,
	t.name AS track_name,
	CAST(t.milliseconds AS Float) / 1000 AS seconds
FROM playlist p
INNER JOIN playlist_track pt ON pt.playlist_id = p.playlist_id 
INNER JOIN track t ON t.track_id = pt.track_id
;


WITH ps AS 
	(
	SELECT 
		p.playlist_id,
		p.name AS playlist_name,
		t.name AS track_name,
		CAST(t.milliseconds AS Float) / 1000 AS seconds
	FROM playlist p
	INNER JOIN playlist_track pt ON pt.playlist_id = p.playlist_id 
	INNER JOIN track t ON t.track_id = pt.track_id
	)
SELECT 
	ps.playlist_id,
	ps.playlist_name,
	COUNT(*) AS number_of_tracks,
	SUM(ps.seconds) AS length_seconds
FROM ps
GROUP BY ps.playlist_id
ORDER BY ps.playlist_id
;

WITH ps AS 
	(
	SELECT 
		p.playlist_id,
		p.name AS playlist_name,
		t.name AS track_name,
		CAST(t.milliseconds AS Float) / 1000 AS seconds
	FROM playlist p
	LEFT JOIN playlist_track pt ON pt.playlist_id = p.playlist_id 
	LEFT JOIN track t ON t.track_id = pt.track_id
	)
SELECT 
	ps.playlist_id,
	ps.playlist_name,
	COUNT(*) AS number_of_tracks,
	SUM(ps.seconds) AS length_seconds
FROM ps
GROUP BY ps.playlist_id, ps.playlist_name
ORDER BY ps.playlist_id
;


/*
 * Create a query to find the customer from each country that has spent the most money at our store, ordered alphabetically by country. 
 * Your query should return the following columns, in order:
 * - country - The name of each country that we have a customer from.
 * - customer_name - The first_name and last_name of the customer from that country with the most total purchases, separated by a space, eg Luke Skywalker.
 * - total_purchased - The total dollar amount that customer has purchased.
 */

SELECT 
	c.customer_id, 
	c.first_name || ' ' || c.last_name AS customer_name,
	c.country AS country	
FROM customer c
;

SELECT 
	i.customer_id AS customer_id,
	SUM(i.total) AS total
FROM invoice i
GROUP BY customer_id
;

SELECT 
	i.customer_id AS customer_id,
	c.country AS country,
	c.first_name || ' ' || c.last_name AS customer_name,
	SUM(i.total) AS total_purchased
FROM customer c
LEFT JOIN invoice i ON c.customer_id = i.customer_id 
GROUP BY c.customer_id
;

WITH 
	ct AS (
		SELECT 
			c.country AS country,
			c.first_name || ' ' || c.last_name AS customer_name,
			SUM(i.total) AS total_purchased
		FROM customer c
		LEFT JOIN invoice i ON c.customer_id = i.customer_id 
		GROUP BY c.customer_id
	),
	max_ct AS (
		SELECT 
			country,
			MAX(total_purchased) AS total_purchased
		FROM ct 
		GROUP BY country 
	)
SELECT
	ct.country AS country,
	ct.customer_name AS customer_name,
	max_ct.total_purchased AS total_purchased
FROM ct
INNER JOIN max_ct ON ct.country = max_ct.country AND ct.total_purchased = max_ct.total_purchased
ORDER BY ct.country
;

SELECT 
	il.track_id AS track_id,
	sum(quantity) AS n_bought
FROM invoice_line il 
GROUP BY il.track_id
;

SELECT 
	t.track_id AS track_id,
	g.name AS genre
FROM track t
LEFT JOIN genre g ON g.genre_id = t.genre_id 
;

WITH 
	c AS (
		SELECT 
			il.track_id AS track_id,
			sum(quantity) AS n_bought
		FROM invoice_line il 
		GROUP BY il.track_id
	),
	g AS (
		SELECT 
			t.track_id AS track_id,
			g.name AS genre
		FROM track t
		INNER JOIN genre g ON g.genre_id = t.genre_id 
	)
SELECT 
	genre,
	sum(n_bought) AS n_bought
FROM g
INNER JOIN c ON c.track_id = g.track_id
WHERE 
	genre LIKE '%Hip%Hop%'
	OR 
	genre LIKE '%Punk%'
	OR 
	genre LIKE '%Pop%'
	OR 
	genre LIKE '%Blues%'
GROUP BY genre
ORDER BY n_bought DESC 
;

SELECT DISTINCT name
FROM genre 
WHERE 
	name LIKE '%Hip%Hop%'
	OR 
	name LIKE '%Punk%'
	OR 
	name LIKE '%Pop%'
	OR 
	name LIKE '%Blues%'
ORDER BY name
;

SELECT DISTINCT name
FROM genre 
;
