USE sakila;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name , last_name FROM actor;
-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(UPPER(first_name), ' ', UPPER(last_name)) AS 'Actor Name' 
FROM actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name , last_name FROM actor
WHERE first_name = "Joe" ;
-- Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE "%GEN%";

-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name  FROM actor WHERE last_name LIKE "%LI%";
-- using IN display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country IN ("Afghanistan","Bangladesh","China");

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

	
-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;


-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) as last_name_count
FROM actor
GROUP BY last_name;


-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name) as last_name_count
FROM actor
GROUP BY last_name
HAVING count(last_name) >= 2;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE SCHEMA address;

-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name , staff.last_name, address.address
FROM staff
INNER JOIN address ON 
staff.address_id=address.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.staff_id, staff.first_name ,
staff.last_name, SUM(payment.amount) 
FROM staff 
INNER JOIN payment ON 
staff.staff_id=payment.staff_id WHERE payment.payment_date LIKE "2005-08%"
GROUP BY staff_id, first_name, last_name;

 
--  List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film
INNER JOIN film_actor ON 
film.film_id=film_actor.film_id
GROUP BY film.title;



-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title , COUNT(inventory.inventory_id) AS inventory
FROM film
INNER JOIN inventory ON 
film.film_id=inventory.film_id WHERE film.title =  "Hunchback Impossible"
GROUP BY film.title;


-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT customer.customer_id, customer.first_name, 
customer.last_name, SUM(payment.amount) AS total_paid
FROM payment
INNER JOIN customer ON 
payment.customer_id=customer.customer_id 
GROUP BY customer.customer_id
ORDER BY last_name ASC;



-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title FROM film
WHERE title like "K%" or title like "Q%" 
and (SELECT language_id FROM language WHERE name = 'English');

--  Use subqueries to display all actors who appear in the film Alone Trip.

SELECT
   actor.last_name, actor.first_name
FROM
   film_actor
       INNER JOIN
   actor ON film_actor.actor_id = actor.actor_id
WHERE
   film_actor.film_id = (SELECT
           film_id
       FROM
           film
       WHERE
           title = 'Alone Trip')
ORDER BY actor.last_name , actor.first_name;





-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, 
customer.email
FROM customer
INNER JOIN address ON 
customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
WHERE country.country = "Canada";

--  Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT  film.title
FROM film
INNER JOIN film_category ON 
film.film_id=film_category.film_id
INNER JOIN category ON 
film_category.category_id=category.category_id
WHERE category.name = "Family";

--  Display the most frequently rented movies in descending order.

SELECT  MAX(film.title)
FROM film
INNER JOIN inventory ON 
film.film_id=inventory.film_id
INNER JOIN rental ON 
inventory.inventory_id=rental.inventory_id;


--  Write a query to display how much business, in dollars, each store brought in.

SELECT  store.store_id, SUM(payment.amount)
FROM store
INNER JOIN staff ON 
store.store_id=staff.store_id
INNER JOIN payment ON 
staff.staff_id=payment.staff_id
GROUP BY store.store_id
;
-- Write a query to display for each store its store ID, city, and country.

SELECT  store.store_id, city.city ,country.country
FROM store
INNER JOIN address ON 
store.address_id=address.address_id
INNER JOIN city ON 
address.city_id=city.city_id
INNER JOIN country ON 
city.country_id=country.country_id;

--  List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from payment;
SELECT  category.name,  sum(payment.amount) AS amount
FROM category
INNER JOIN film_category ON 
category.category_id=film_category.category_id
INNER JOIN inventory ON 
film_category.film_id=inventory.film_id
INNER JOIN rental ON 
inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON
rental.customer_id=payment.customer_id
GROUP BY category.name
ORDER BY amount DESC;

--  In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
CREATE VIEW top_five_genres AS 
SELECT  category.name, sum(payment.amount) AS amount
FROM category
INNER JOIN film_category ON 
category.category_id=film_category.category_id
INNER JOIN inventory ON 
film_category.film_id=inventory.film_id
INNER JOIN rental ON 
inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON
rental.customer_id=payment.customer_id
GROUP BY category.name
ORDER BY amount DESC
LIMIT 5;
-- How would you display the view that you created in 8a?
SELECT * FROM top_five_genres ;
-- You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;














