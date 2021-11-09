-- #1
\d cities

SELECT city, population FROM cities WHERE country IN ('South Africa', 'Egypt');

     city     | population
--------------+------------
 Cairo        |    7734600
 Alexandria   |    3811500
 Cape Town    |    3740000
 Al Jizah     |    3628100
 Durban       |    3425800
 Johannesburg |    2026500
 Soweto       |    1695000
 Pretoria     |    1619400
(8 rows)


-- #2
SELECT state_alpha_code, state_number_code FROM util_us_states WHERE state_name IN ('MISSOURI', 'NEW YORK');
 state_alpha_code | state_number_code
------------------+-------------------
 MO               |                29
 NY               |                36
(2 rows)



SELECT  city, population 
FROM    cities 
WHERE   country IN ('United States', 'United Kingdom') 
        AND population < 5000000


        SELECT city, population FROM cities WHERE country = 'United Kingdom';

%%sql
SELECT  film_id, title
FROM    film
WHERE   (rental_duration < 4 AND rental_rate = 0.99)
        OR (rental_duration > 6 AND rental_rate = 2.99);


%%sql
SELECT  return_date, rental_date, rental_id
FROM    rental
WHERE   return_date IS NOT NULL
ORDER BY return_date DESC, rental_date
LIMIT   20;

%%sql
SELECT  first_name, last_name
FROM    actor
WHERE   last_name LIKE 'N%'
ORDER BY last_name DESC;


%%sql
SELECT  amount
FROM    payment
LIMIT   8
ORDER BY amount;


%%sql
SELECT  *
FROM    Person
WHERE   id LIKE '%a%';

%%sql
SELECT  *
FROM    Survey
WHERE   person IN ('bp', 'lake')
        AND (quant = 'rad' OR quant = 'temp');

%%sql
SELECT  DISTINCT person, quant
FROM    Survey
WHERE   quant = 'temp'
        AND quant IS NOT NULL;


%%sql
SELECT  DISTINCT taken
FROM    Survey;


%%sql
SELECT  *
FROM    Person
ORDER BY family;

%%sql
SELECT  reading
FROM    Survey
WHERE   quant = 'temp'
ORDER BY reading DESC;

%%sql 
SELECT  * 
FROM    person 
LIMIT   2;

%%sql
SELECT  *
FROM    Survey
WHERE   quant = 'rad'
LIMIT   3;

%%sql
SELECT  *
FROM    Survey
WHERE   quant = 'temp'
ORDER BY reading DESC
LIMIT   3;

%%sql
SELECT  *
FROM    Survey
WHERE   person LIKE '%e%'
        AND reading > 0
ORDER BY reading;


%%sql 
SELECT * 
FROM survey 
WHERE person like '%e%' 
AND reading > 0 
ORDER BY reading;


CREATE TABLE jch5x8.whoami (pawprint_id char(20) UNIQUE, name varchar(70));

INSERT INTO jch5x8.whoami VALUES ('jch5x8','John Hopson');

EXPLAIN 
SELECT COUNT(*)
FROM  (
        SELECT
            SUM(return_date - rental_date) as rental_time,
            MAX(return_date-rental_date), customer_id
        , COUNT(*) as cnt
        FROM rental
        WHERE 
        GROUP BY customer_id 
        HAVING SUM(return_date - rental_date) > '170 days'::interval
    ) as top_renters
USING (customer_id);

SELECT  p.personal
        ,p.family
FROM    Person p 
WHERE   p.id NOT IN (
            SELECT DISTINCT person
            FROM Survey
            WHERE person IS NOT NULL
        )

SELECT  COUNT(*) AS "actors_w/_more_than_35_movies"
FROM    (
                SELECT actor_id, COUNT(*) 
                FROM film_actor 
                GROUP BY actor_id 
                HAVING COUNT(*) > 35
        ) as movie_counts;

%%sql
EXPLAIN 
SELECT  title
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
WHERE   i.inventory_id NOT IN (
            SELECT  inventory_id
            FROM    rental
            WHERE   rental_date::date = '2005-05-31'
        );


%%sql
EXPLAIN 
SELECT  customers.first_name, customers.last_name, a.phone, r.rental_date, f.title
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id
WHERE   i.inventory_id NOT IN (
            SELECT  inventory_id
            FROM    rental
            WHERE   rental_date::date = '2005-05-31'
        );


%%sql
EXPLAIN 
SELECT  customers.first_name, customers.last_name, a.phone, r.rental_date, f.title
FROM    customer AS c 
WHERE    (
        SELECT
            SUM(return_date - rental_date) as rental_time,
            MAX(return_date-rental_date), customer_id
        , COUNT(*) as cnt
        FROM rental
        GROUP BY customer_id 
        HAVING SUM(return_date - rental_date) > '170 days'::interval
    ) as top_renters
    JOIN address AS a
        ON c.address_id = r.address_id
        JOIN inventory AS i
        ON r.inventory_id = i.inventory_id
USING (customer_id);

%%sql
EXPLAIN 
SELECT  c.first_name, c.last_name, a.phone, rentals.title, rentals.rental_date
FROM    customer AS c JOIN address AS a
        ON c.address_id = r.address_id
        INNER JOIN (
            SELECT  f.title, r.rental_date 
            FROM    rental AS r JOIN inventory AS i
                    ON r.inventory_id = i.inventory_id
                    JOIN film AS f
                    ON f.film_id = i.film_id
                    WHERE   return_date IS NULL
        ) AS rentals
        ON c.customer_id = rentals.customer_id;

%%sql
EXPLAIN 
SELECT  c.first_name, c.last_name, a.phone, f.title, rentals.rental_date
FROM    customer AS c JOIN address AS a
        ON c.address_id = a.address_id
        INNER JOIN (
            SELECT  rental_date, inventory_id, customer_id
            FROM    rental
            WHERE   return_date IS NULL
        ) AS rentals
        ON c.customer_id = rentals.customer_id
        JOIN inventory AS i
        ON rentals.inventory_id = i.inventory_id
        JOIN film AS f
        ON f.film_id = i.film_id;


%%sql
EXPLAIN 
SELECT  f.title
FROM    film
WHERE   f.film_id NOT IN (
            SELECT  DISTINCT category_id, film_id
            FROM    category
            WHERE   name = 'Children'
        );

%%sql
EXPLAIN 
SELECT  title
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        INNER JOIN (
            SELECT  COUNT(*) as cnt, inventory_id
            FROM    rental
            WHERE   rental_date IS NOT NULL
            GROUP BY inventory_id
            ORDER BY cnt
        ) AS rentals
        ON i.inventory_id = rentals.inventory_id;


%%sql
EXPLAIN
SELECT  f.title, top_renter.cnt AS rentals
FROM    rental AS r
        INNER JOIN (
        SELECT  COUNT(*) as cnt
            FROM    rental
            GROUP BY customer_id
            ORDER BY cnt DESC
            LIMIT 10
        ) as top_renters
        USING (customer_id)
        JOIN inventory AS i
        ON top_renters.inventory_id = i.inventory_id
        JOIN film AS f
        ON f.film_id = i.film_id;