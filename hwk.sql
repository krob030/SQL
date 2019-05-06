USE sakila;
-- 1a. Display the first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;
-- 1b. Display 1st and last name of each actor in a single column in upper case. Name column Actor Name.
SELECT UPPER (CONCAT(first_name, " ", last_name)) AS "Actor Name" FROM actor;
-- 2a. find ID number, first name, and last name of an actor, of whom u know only first name, "Joe."
SELECT actor_id, first_name, last_name FROM actor WHERE first_name= "Joe";
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id,  first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";
-- 2c. Find all actors whose last names contain the letters LI. Order rows by last name and first name:
SELECT last_name, first_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name;
-- 2d. Using IN, display country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN("Afghanistan", "Bangladesh", "China");
-- 3a. Keep a description of each actor. Create a column in table actor named description and use the data type BLOB
ALTER TABLE actor ADD COLUMN description BLOB;
-- 3b. Delete the description column.
ALTER TABLE actor DROP COLUMN description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS "LAST_NAME_COUNT" FROM actor GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name. Only for names shared by at least two actors
SELECT last_name, COUNT(*) AS "LAST_NAME_REPEATED" FROM actor GROUP BY last_name HAVING COUNT(*) >=2;
-- 4c. actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name= "HARPO" WHERE first_name= "GROUCHO" AND last_name= "WILLIAMS";
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
UPDATE actor SET first_name= "GROUCHO" WHERE first_name= "HARPO" AND last_name= "WILLIAMS";
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
DESC address;
-- 6a. Use JOIN to display first and last names, address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address FROM staff AS s INNER JOIN address AS a ON (s.address_id= a.address_id);
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id, first_name, last_name, SUM(amount) AS "Total amount" FROM staff s INNER JOIN payment p 
ON s.staff_id = p.staff_id AND payment_date LIKE "2005-08%" GROUP BY s.staff_id;
-- 6c. List film and number of actors listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.actor_id) AS "Number of actors" FROM film_actor a INNER JOIN film f
ON f.film_id= a.film_id GROUP BY f.title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film_id, COUNT(film_id) AS "Inventory copies" FROM inventory WHERE film_id IN 
(SELECT film_id FROM film WHERE title= "Hunchback Impossible");
-- 6e. Use tables payment and customer and JOIN, list the total paid by each customer. List customers by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS "Total Amount Paid" FROM payment p INNER JOIN customer c
ON c.customer_id= p.customer_id GROUP BY c.first_name, c.last_name ORDER BY c.last_name ASC;
 -- 7a. Music of Queen and Kris Kristofferson resurgence. As consequence, films starting with K and Q have also soared in popularity.
	-- Use subqueries to display movie titles starting with K and Q whose language is English.
SELECT title FROM film WHERE title LIKE "K%" OR title LIKE "Q%" 
AND language_id IN (SELECT language_id FROM language WHERE name= "English");
-- 7b. Display actors in film Alone Trip.
SELECT first_name, last_name FROM actor a INNER JOIN film_actor f ON a.actor_id = f.actor_id
WHERE film_id IN (SELECT film_id FROM film WHERE title = 'Alone Trip');
-- 7c. Run an email marketing campaign in Canada, use names and email of customers. Use joins.
SELECT first_name, last_name, email FROM customer c JOIN address a ON (a.address_id = c.address_id)
JOIN city ci ON (a.city_id = ci.city_id) JOIN country co ON (ci.country_id = co.country_id) WHERE co.country= 'Canada';
-- 7d. Target all family movies
SELECT f.film_id, f.title FROM film f JOIN film_category fc ON (f.film_id= fc.film_id) JOIN category c ON (fc.category_id= c.category_id)
WHERE c.name= "Family";
-- 7e. Display the most frequently rented movies in descending order
SELECT f.title, COUNT(rental_date) AS "Rented times" FROM film f JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id= r.inventory_id) GROUP BY f.title ORDER BY COUNT(rental_date) DESC;
-- 7f. How much business, in dollars, each store brought in?
SELECT s.store_id, SUM(amount) AS "Business in dollars" FROM store s JOIN staff st ON (s.store_id= st.store_id)
JOIN payment p ON (st.staff_id= p.staff_id) GROUP BY s.store_id;
-- 7g. Display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country FROM store s JOIN address a ON (s.address_id= a.address_id)
JOIN city ci ON (ci.city_id= a.city_id) JOIN country co ON (ci.country_id= co.country_id);
-- 7h. List top5 genres in gross revenue in descending order. (tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(amount) AS "Gross revenue" FROM category c JOIN film_category fc ON (c.category_id= fc.category_id)
JOIN inventory i ON (fc.film_id= i.film_id) JOIN rental r ON (r.inventory_id= i.inventory_id)
JOIN payment p ON (p.rental_id= r.rental_id) GROUP BY c.name ORDER BY SUM(amount) DESC LIMIT 5;
-- 8a. Use the solution from the problem above to create a view.
CREATE VIEW top_five_genres AS
SELECT c.name, SUM(amount) AS "Gross revenue" FROM category c JOIN film_category fc ON (c.category_id= fc.category_id)
JOIN inventory i ON (fc.film_id= i.film_id) JOIN rental r ON (r.inventory_id= i.inventory_id)
JOIN payment p ON (p.rental_id= r.rental_id) GROUP BY c.name ORDER BY SUM(amount) DESC LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;