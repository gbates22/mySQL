#1a
USE sakila;
SELECT first_name, last_name
FROM actor;

#1b
SELECT concat(first_name, ' ', last_name) as 'Actor Name' 
FROM actor;

#2a
SELECT last_name, actor_id
FROM actor WHERE first_name = 'Joe';

#2b
SELECT last_name, first_name, actor_id
FROM actor WHERE last_name LIKE '%GEN%';

#2c
SELECT last_name, first_namecountry
FROM actor WHERE last_name LIKE '%LI%';

#2d
SELECT * FROM country
WHERE country IN ('AFGHANISTAN', 'CHINA', 'BANGLADESH');

#3a
ALTER TABLE actor
ADD middle_name VARCHAR(50) 
AFTER first_name;

#3b
ALTER TABLE actor
MODIFY middle_name BLOB;

#3c
ALTER TABLE actor
DROP middle_name;

#4a
SELECT last_name, COUNT(last_name) 
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(last_name) AS count
FROM actor
GROUP BY last_name
HAVING count > 1;

#4c
SELECT first_name, last_name
FROM actor
WHERE first_name = 'GROUCHO';

#4d
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

#5a
SHOW CREATE TABLE address;
DESCRIBE address;
DESCRIBE staff;

#6a
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

#6b
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_payment
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id;

#6c
SELECT f.title, COUNT(fa.actor_id) AS actor_count
FROM film f
INNER JOIN film_actor fa 
ON f.film_id = fa.film_id
GROUP BY f.title;

#6d
SELECT f.title, COUNT(i.film_id) AS film_count
FROM film f 
JOIN inventory i 
ON f.film_id = i.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE';

#6e
SELECT c.first_name, c.last_name, SUM(p.amount) as payments
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;


SELECT l.name, f.title
FROM language l 
JOIN film f 
ON l.language_id = f.language_id
WHERE ((f.title LIKE 'k%') OR (f.title LIKE 'Q%')) 
AND l.name = 'ENGLISH';

#7a
SELECT title
FROM film
WHERE language_id IN
	(
    SELECT language_id
    FROM language 
    WHERE name = 'English'
    )
AND
	((title LIKE 'Q%') OR (title LIKE 'K%'));

#7b
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN 
	(
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(
        SELECT film_id 
        FROM film
        WHERE title = 'ALONE TRIP'));
        
#7c
SELECT cu.email, cu.first_name, cu.last_name
FROM country co
	INNER JOIN city ci
	ON co.country_id = ci.country_id
		INNER JOIN  address a
		ON a.city_id = ci.city_id
			INNER JOIN customer cu
			ON cu.address_id = a.address_id
				WHERE co.country = 'CANADA';

#7d
SELECT f.title
FROM film f 
WHERE f.film_id IN 
	(
    SELECT fcat.film_id 
    FROM film_category fcat
    WHERE fcat.category_id IN 
		(
        SELECT cat.category_id	
        FROM category cat
        WHERE name = 'FAMILY'
        ));
        
#7e
SELECT *
FROM rental;
SELECT COUNT(f.film_id) as rentals, f.title, i.inventory_id, r.rental_id
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id 
GROUP BY f.film_id
ORDER BY rentals DESC;

#7f
SELECT SUM(p.amount) AS revenue, s.store_id
	FROM payment p
	JOIN customer c
	ON p.customer_id = c.customer_id
		JOIN store s 
		ON s.store_id = c.store_id
			GROUP BY s.store_id;

#7g
SELECT s.store_id, co.country, ci.city
	FROM store s
	JOIN address a
	ON s.address_id = a.address_id
		JOIN city ci
		ON a.city_id = ci.city_id
			JOIN country co
			ON ci.country_id = co.country_id;

#7h/8a
CREATE VIEW Top_Movie_Rentals_by_Category AS
SELECT cat.name AS Genre, SUM(p.amount) AS 'Revenue by Category'
FROM category cat
	JOIN film_category fcat ON cat.category_id = fcat.category_id
	JOIN inventory i ON fcat.film_id = i.film_id 
	JOIN rental r ON i.inventory_id = r.inventory_id
	JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cat.name
ORDER BY 'Revenue by Category' DESC
LIMIT 5;

#8b/8c
SELECT * FROM Top_Movie_Rentals_by_Category;
DROP VIEW Top_Movie_Rentals_by_Category;
