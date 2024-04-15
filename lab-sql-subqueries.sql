use sakila;

-- 1 Determine the number of copies of the film "Hunchback Impossible" 
-- that exist in the inventory system

SELECT 
    COUNT(*) AS num_copies
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');


-- 2 List all films whose length is longer than the average length of all
--  the films in the Sakila database.

SELECT 
    title AS films, length
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film);
            
-- 3 Use a subquery to display all actors who appear in the 
-- film "Alone Trip".

SELECT 
    actor.actor_id,
    actor.first_name,
    actor.last_name
FROM 
    actor
WHERE 
    actor.actor_id IN (
        SELECT 
            film_actor.actor_id
        FROM 
            film_actor
        WHERE 
            film_actor.film_id = (
                SELECT 
                    film_id
                FROM 
                    film
                WHERE 
                    title = 'Alone Trip'
            )
    );


-- 4 Sales have been lagging among young families, and you 
-- want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT 
    title
FROM 
    film
WHERE 
    film.film_id IN (
        SELECT 
            film_category.film_id
        FROM 
            film_category
        WHERE 
            film_category.category_id IN (
                SELECT 
                    category_id
                FROM 
                    category
                WHERE 
                    name = 'Family'
            )
    );
    
-- 5 Retrieve the name and email of customers from Canada using
--  both subqueries and joins. To use joins, you will need to 
-- identify the relevant tables and their primary and foreign keys.

SELECT 
    c.first_name, c.last_name,c.email
FROM
    customer c
WHERE
    c.address_id IN (SELECT 
            a.address_id
        FROM
            address a
        WHERE
            a.city_id IN (SELECT 
                    ci.city_id
                FROM
                    city ci
                WHERE
                    ci.country_id IN (SELECT 
                            co.country_id
                        FROM
                            country co
                        WHERE
                            co.country = 'canada')));


-- 6 Determine which films were starred by the most
--  prolific actor(the actor who has acted in the most number of films.)
--  in the Sakila database.
-- you will need to find the most prolific actor and then use that actor_id
--  to find the different films that he or she starred in

SELECT 
    title
FROM 
    film
WHERE 
    film_id IN (
        SELECT 
            film_id
        FROM 
            film_actor
        WHERE 
            actor_id = (
                SELECT 
                    actor_id
                FROM 
                    film_actor
                GROUP BY 
                    actor_id
                ORDER BY 
                    COUNT(*) DESC
                LIMIT 1
            )
    );
    
-- 7 Find the films rented by the most
--  profitable customer(the customer who has made the largest sum of payments.)
-- in the Sakila database

SELECT 
    f.title
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.customer_id = (
        SELECT 
            customer_id
        FROM 
            payment
        GROUP BY 
            customer_id
        ORDER BY 
            SUM(amount) DESC
        LIMIT 1
    );
 

