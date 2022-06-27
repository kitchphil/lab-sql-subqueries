#Q1 How many copies of the film Hunchback Impossible exist in the inventory system?


SELECT
	COUNT(t1.film_id) AS Inventory
    , t2.title
FROM
	inventory as t1
INNER JOIN sakila.film AS t2 ON t1.film_id = t2.film_id
WHERE t2.title = 'Hunchback Impossible'
;


#Q2 List all films whose length is longer than the average of all the films.

SELECT
	film.title
FROM
	sakila.film
WHERE film.length > (
    SELECT
		AVG(film.length)
	FROM
		sakila.film
	)
        ;

#Q3 Use subqueries to display all actors who appear in the film Alone Trip.

SELECT
	CONCAT(actor.first_name, ' ', actor.last_name) AS Actors
FROM
	sakila.actor
WHERE actor_id IN 
	(
	SELECT
		film_actor.actor_id
	FROM
		sakila.film_actor
	WHERE film_id = 
		(
		SELECT
			film.film_id
		FROM
			sakila.film
		WHERE
			film.title = 'Alone Trip'
		)
	)
;
		

#Q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.


SELECT
	film.title
FROM
	sakila.film
WHERE film_id in
	(
	SELECT
		film_id
	FROM
		sakila.film_category
	WHERE category_id =
		(
        SELECT
			category_id
		FROM
			category
		WHERE 
			category.name = 'family'
        )
	)
;
		

#Q5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT 
	CONCAT(customer.first_name, ' ', customer.last_name) AS Name
    , customer.email
FROM
	sakila.customer 
WHERE customer.address_id IN
	(
    SELECT
		address.address_id
	FROM
		sakila.address
	WHERE address.city_id IN
		(
        SELECT 
			city.city_id
		FROM
			sakila.city
		WHERE country_id =
			(
			SELECT
				country.country_id
			FROM
				sakila.country
			WHERE country = 'Canada'
            )
		)
	)
;	



SELECT 
	CONCAT(t1.first_name, ' ', t1.last_name) AS Name
    , t1.email
FROM
	sakila.customer AS t1 
INNER JOIN address AS t2 ON t1.address_id = t2.address_id
INNER JOIN city AS t3 ON t2.city_id = t3.city_id
INNER JOIN country AS t4 ON t3.country_id = t4.country_id
WHERE 
	t4.country = 'Canada'
;



#Q6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT 
	film.title
FROM 
	sakila.film
WHERE film_id IN
	(
    SELECT 
		film_actor.film_id
	FROM
		sakila.film_actor
	WHERE film_actor.actor_id IN
		(SELECT 
			foo.actor_id 
		FROM
			(
			SELECT
				actor_id
				, count(film_actor.film_id) AS counts
			FROM
				film_actor
			GROUP BY 
				actor_id
			ORDER BY
				counts DESC
			Limit
				1
		) as foo)
	)
;
        
		


#Q7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments


SELECT
	film.title
FROM
	sakila.film
WHERE film.film_id IN
	(
    SELECT 
		inventory.film_id
	FROM
		sakila.inventory
	WHERE inventory.inventory_id IN
		(
		SELECT
			rental.inventory_id
		FROM
			sakila.rental
		WHERE
			rental.customer_id IN
            (
            SELECT
				customer.customer_id
			FROM
				sakila.customer
			WHERE customer.customer_id IN
				(SELECT 
					foo.customer_id 
				FROM
					(
					SELECT 
						payment.customer_id
						, sum(payment.amount) AS pay
					FROM
						sakila.payment
					GROUP BY
						payment.customer_id
					ORDER BY 
						pay DESC
					LIMIT
						1
					) AS foo
				)
			)
        )    
     )       
;				
		




#Q8 Customers who spent more than the average payments.
						

SELECT 
	CONCAT(last_name, ', ', first_name) AS Customer
FROM 
	sakila.customer
WHERE
	customer.customer_id IN 
    (
	SELECT 
		customer_id
    FROM 
		sakila.rental
    WHERE rental_id IN
			(
			SELECT 
				rental_id
			FROM 
				sakila.payment
			WHERE 
				payment.amount > 
                (
				SELECT 
					AVG(payment.amount)
				FROM
					sakila.payment
                )	
		)
	)
;		
	
	