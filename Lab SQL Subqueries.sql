USE sakila;

SELECT COUNT(*) AS copies_of_hunchback_impossible
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE');

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC, title;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
  SELECT fa.actor_id
  FROM film_actor fa
  WHERE fa.film_id = (SELECT film_id FROM film WHERE title = 'ALONE TRIP')
)
ORDER BY last_name, first_name;

SELECT title
FROM film
WHERE film_id IN (
  SELECT fc.film_id
  FROM film_category fc
  JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Family'
)
ORDER BY title;

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
  SELECT address_id FROM address
  WHERE city_id IN (
    SELECT city_id FROM city
    WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
  )
)
ORDER BY last_name, first_name;

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada'
ORDER BY c.last_name, c.first_name;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
  SELECT actor_id FROM (
    SELECT actor_id, COUNT(*) AS films_count
    FROM film_actor
    GROUP BY actor_id
    ORDER BY films_count DESC
    LIMIT 1
  ) x
)
ORDER BY f.title;

SELECT DISTINCT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = (
  SELECT customer_id FROM (
    SELECT customer_id, SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
    ORDER BY total_paid DESC
    LIMIT 1
  ) t
)
ORDER BY f.title;

SELECT customer_id AS client_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
  SELECT AVG(total_spent) FROM (
    SELECT SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
  ) s
)
ORDER BY total_amount_spent DESC, client_id;