Part 2
------------------------------------------------------------------------------
 
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
 SELECT concat(upper(first_name),' ',upper(last_name)) as 'Actor Name' 
 FROM sakila.actor;
 
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
--  	What is one query would you use to obtain this information?
 SELECT actor_id, first_name, last_name 
 FROM sakila.actor
 WHERE first_name = 'Joe';
 
-- 2b. Find all actors whose last name contain the letters GEN:
 SELECT actor_id, first_name, last_name 
 FROM sakila.actor
 WHERE last_name like '%GEN%';
 
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
 SELECT actor_id, last_name, first_name
 FROM sakila.actor
 WHERE last_name like '%LI%'
 ORDER BY last_name, first_name;
 
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
 SELECT country_id, country
 FROM sakila.country
 WHERE country IN ('Afghanistan','Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
 ALTER TABLE sakila.actor
 ADD middle_name VARCHAR(255) After first_name;
 
-- 3b. You realize that some of these actors have tremendously long last names.
--  Change the data type of the middle_name column to blobs.
 ALTER TABLE sakila.actor
 MODIFY middle_name blob;
 
-- 3c. Now delete the middle_name column.
 ALTER TABLE sakila.actor
 DROP column middle_name; 
 
-- 4a. List the last names of actors, as well as how many actors have that last name.
 SELECT last_name, count(first_name)
 FROM sakila.actor
 GROUP BY last_name;
 
-- 4b. List last names of actors and the number of actors who have that last name,
-- 	but only for names that are shared by at least two actors
 SELECT last_name, count(first_name)
 FROM sakila.actor
 GROUP BY last_name
 Having count(first_name)>1;
 
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
-- 	the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
 UPDATE sakila.actor
 SET first_name='HARPO', last_name='WILLIAMS'
 WHERE first_name='GROUCHO' and last_name='WILLIAMS';
 
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct
-- name after all!
-- In a single query, if the first name of the actor is currently HARPO,
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what
-- the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER!
-- (Hint: update the record using a unique identifier.)
 UPDATE sakila.actor
 SET first_name=
 (CASE 
 WHEN (first_name = 'HARPO' and last_name = 'WILLIAM') THEN 'GROUCHO'
 ELSE (first_name = 'MUCHO GROUCHO')
 END)
 ????????;
 DAVID ANSWER
 UPDATE actor 
SET first_name = (
		CASE WHEN first_name = 'HARPO' 
		THEN 'GROUCHO' 
		ELSE 'MUCHO GROUCHO'
        END
	)
 WHERE actor_id = 172;
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE DATABASE address;
 ????????;
 DAVID ANSWER
 DESCRIBE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
 SELECT first_name, last_name, address
 FROM sakila.address as a
 JOIN sakila.staff as b
 ON a.address_id=b.address_id;
 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
 SELECT a.staff_id, b.first_name, b.last_name, sum(a.amount)
 FROM sakila.payment as a
 JOIN sakila.staff as b
 ON a.staff_id=b.staff_id
 WHERE Month(a.payment_date)=8 and Year(a.payment_date)=2005
 GROUP BY a.staff_id;
 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 SELECT a.film_id, a.title, count(b.actor_id)
 FROM sakila.film as a
 INNER JOIN sakila.film_actor as b
 ON a.film_id=b.film_id
 GROUP BY a.film_id;
 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 SELECT count(a.film_id)
 FROM sakila.inventory as a
 JOIN sakila.film as b
 ON a.film_id=b.film_id
 WHERE b.title = 'Hunchback Impossible';
 
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- 	List the customers alphabetically by last name:
 SELECT a.customer_id, a.first_name, a.last_name, sum(b.amount)
 FROM sakila.customer as a
 JOIN sakila.payment as b
 ON a.customer_id=b.customer_id
 GROUP BY a.customer_id
 ORDER BY a.last_name;
 
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of
--  movies starting with the letters K and Q whose language is English.
 SELECT title
 FROM sakila.film
 WHERE title like 'K%' or title like 'Q%' and language_id in
 (SELECT language_id
 FROM sakila.language
 WHERE name = 'English');
 
 SELECT a.film_id, a.title, b.name
 FROM sakila.film as a
 JOIN sakila.language as b
 ON a.language_id=b.language_id
 WHERE a.title like 'K%' or a.title like 'Q%' and b.name='English';
 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
 SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id in
 (SELECT actor_id
 FROM sakila.film_actor
 WHERE film_id in  
 (SELECT film_id
 FROM sakila.film
 WHERE title = 'ALONE TRIP'));
 
 SELECT a.actor_id, a.first_name, a.last_name, c.title
 FROM sakila.actor as a
 JOIN sakila.film_actor as b
 ON a.actor_id=b.actor_id
 Join sakila.film as c
 ON b.film_id=c.film_id
 WHERE c.title= 'ALONE TRIP';
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- 	email addresses of all Canadian customers.
-- 	Use joins to retrieve this information.
 SELECT a.customer_id, a.first_name, a.last_name, a.email, d.country
 FROM sakila.customer as a 
 JOIN sakila.address as b
 ON a.address_id=b.address_id
 JOIN sakila.city as c
 ON b.city_id=c.city_id
 JOIN sakila.country as d
 ON c.country_id=d.country_id
 WHERE d.country= 'CANADA';
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as famiy films.
 SELECT a.film_id, a.title, c.name
 FROM sakila.film as a
 JOIN sakila.film_category as b
 ON a.film_id=b.film_id
 JOIN sakila.category as c
 ON b.category_id=c.category_id
 WHERE c.name = 'FAMILY';
 
-- 7e. Display the most frequently rented movies in descending order.
 SELECT a.film_id, a.title, count(c.rental_id)
 FROM sakila.film as a
 JOIN sakila.inventory as b
 ON a.film_id=b.film_id
 JOIN sakila.rental as c
 ON b.inventory_id=c.inventory_id
 GROUP BY a.film_id
 ORDER BY count(c.rental_id) desc;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
 SELECT b.store_id, sum(a.amount)
 FROM sakila.payment as a
 JOIN sakila.staff as b
 ON a.staff_id=b.staff_id
 GROUP BY b.store_id;
 
-- 7g. Write a query to display for each store its store ID, city, and country.
 SELECT a.store_id, c.city, d.country
 FROM sakila.store as a
 JOIN sakila.address as b
 ON a.address_id=b.address_id
 JOIN sakila.city as c
 ON b.city_id=c.city_id
 JOIN sakila.country as d
 ON c.country_id=d.country_id
 GROUP BY a.store_id;
 
-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
 SELECT a.name as 'Genres', sum(e.amount) as 'Gross Revenue'
 FROM sakila.category as a
 JOIN sakila.film_category as b
 ON a.category_id=b.category_id
 JOIN sakila.inventory as c
 ON b.film_id=c.film_id
 JOIN sakila.rental as d
 ON c.inventory_id=d.inventory_id
 JOIN sakila.payment as e
 ON d.rental_id=e.rental_id
 GROUP BY a.name 
 ORDER BY sum(e.amount) desc
 Limit 5;
 
-- 8a. In your new role as an executive, you would like to have an easy way of viewing
--  	the Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  	If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TOP_Five_Genres_Gross_Revenue AS
 SELECT a.name as 'Genres', sum(e.amount) as 'Gross Revenue'
 FROM sakila.category as a
 JOIN sakila.film_category as b
 ON a.category_id=b.category_id
 JOIN sakila.inventory as c
 ON b.film_id=c.film_id
 JOIN sakila.rental as d
 ON c.inventory_id=d.inventory_id
 JOIN sakila.payment as e
 ON d.rental_id=e.rental_id
 GROUP BY a.name 
 ORDER BY sum(e.amount) desc
 Limit 5;
  
-- 8b. How would you display the view that you created in 8a?
 SELECT *
 FROM TOP_Five_Genres_Gross_Revenue;
 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TOP_Five_Genres_Gross_Revenue;
