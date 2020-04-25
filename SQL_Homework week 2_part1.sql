1. Which actors have the first name 'Scarlett'
SELECT * 
FROM sakila.actor
where first_name = 'Scarlett'
//
2. Which actors have the last name 'Johansson'
SELECT *
FROM sakila.actor
Where last_name = 'Johansson'
//
3. How many distinct actors last names are there?
SELECT COUNT(DISTINCT last_name)
FROM sakila.actor;
//
4. Which last names are not repeated?
SELECT first_name, last_name, count(DISTINCT first_name)
FROM sakila.actor
GROUP BY last_name
HAVING count(first_name)<=1;
//
5. Which last names appear more than once?
SELECT first_name, last_name, count(DISTINCT first_name)
FROM sakila.actor
GROUP BY last_name
HAVING count(DISTINCT first_name)>1
ORDER BY count(DISTINCT first_name) DESC;
//
6. Which actor has appeared in the most films?
SELECT actor_id, max(films) as Max_films, first_name, last_name
FROM 
(SELECT a.actor_id, count(DISTINCT a.film_id) as films, b.first_name, b.last_name
FROM sakila.film_actor as a
JOIN sakila.actor as b
ON a.actor_id = b.actor_id
group by a.actor_id
order by count(DISTINCT a.film_id)desc)temp;
//
7. Is 'Academy Dinosaur' available for rent from Store 1?
 
-- Step 1: which copies are at Store 1?
 SELECT * 
FROM sakila.inventory
WHERE store_id=1
//
-- Step 2: pick an inventory_id to rent:
SELECT inventory_id, a.store_id, b.title 
FROM sakila.inventory as a
JOIN sakila.film as b
ON a.film_id=b.film_id
WHERE a.store_id=1 and b.title='Academy Dinosaur' and
inventory_id not in (select.......)
(or not exist)
//
8. Insert a record to represent Mary Smith renting 'Academy Dinosaur' from Mike Hillyer at Store 1 today .
 SELECT *
FROM
(SELECT *
FROM
(SELECT b.first_name, b.last_name, a.staff_id, a.inventory_id 
FROM sakila.rental as a
JOIN sakila.customer as b
ON a.customer_id = b.customer_id
WHERE b.first_name='Mary' and b.last_name='smith') as c
JOIN sakila.staff as d
ON c.staff_id=d.staff_id
WHERE c.staff_id=1 ) as e
JOIN sakila.inventory as f
ON e.inventory_id=f.inventory_id
WHERE inventory_id in
(SELECT inventory_id
FROM sakila.inventory as f
JOIN sakila.film as g
ON f.film_id=g.film_id
WHERE f.title='Academy Dinosaur')
//
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (NOW(), 1, 1, 1)
(如果value未知， 可以用insert into, select)
9. When is 'Academy Dinosaur' due?
 
-- Step 1: what is the rental duration?
 SELECT title, rental_duration
FROM sakila.film
WhERE title = 'ACADEMY DINOSAUR'
//
-- Step 2: Which rental are we referring to -- the last one.
 SELECT * 
FROM 
(SELECT a.title, a.film_id, b.inventory_id
FROM sakila.film as a
JOIN sakila.inventory as b
ON a.film_id=b.film_id
WHERE title = 'ACADEMY DINOSAUR') as c
JOIN sakila.rental as d
ON c.inventory_id=d.inventory_id
ORDER BY d.rental_date desc
-- Step 3: add the rental duration to the rental date.
SELECT d.*
DATE 
FROM 
(SELECT a.title, a.film_id, a.rental_duration, b.inventory_id
FROM sakila.film as a
JOIN sakila.inventory as b
ON a.film_id=b.film_id
WHERE title = 'ACADEMY DINOSAUR') as c
JOIN sakila.rental as d
ON c.inventory_id=d.inventory_id
ORDER BY d.rental_date desc
//
10. What is that average length of all the films in the sakila DB?
 SELECT avg(length) 
FROM sakila.film
//
11. What is the average length of films by category?
 SELECT category_id, avg(length)
FROM sakila.film as a
JOIN sakila.film_category as b
ON a.film_id = b.film_id
GROUP BY category_id
//
12. Which film categories are long? Long = lengh is longer than the average film length
SELECT category_id, avg(length)
FROM (select distinct * from sakila.film) as a
JOIN sakila.film_category as b
ON a.film_id = b.film_id
GROUP BY category_id
HAVING avg(length) >= (SELECT avg(length) FROM sakila.film)
ORDER BY avg(length) DESC