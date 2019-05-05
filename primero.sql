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
SELECT s.staff_id, first_name, last_name, SUM(amount) as "Total amount" FROM staff s INNER JOIN payment p 
ON s.staff_id = p.staff_id AND payment_date LIKE "2005-08%" GROUP BY s.staff_id;
