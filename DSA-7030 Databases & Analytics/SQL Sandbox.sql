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
        , COUNT(*) as rent
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
        , COUNT(*) as rent
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
            SELECT  COUNT(*) as rent, inventory_id
            FROM    rental
            WHERE   rental_date IS NOT NULL
            GROUP BY inventory_id
            ORDER BY rent
        ) AS rentals
        ON i.inventory_id = rentals.inventory_id;


%%sql
EXPLAIN
SELECT  f.title, top_renter.rent AS rentals
FROM    rental AS r
        INNER JOIN (
        SELECT  COUNT(*) as rent
            FROM    rental
            GROUP BY customer_id
            ORDER BY rent DESC
            LIMIT 10
        ) as top_renters
        USING (customer_id)
        JOIN inventory AS i
        ON top_renters.inventory_id = i.inventory_id
        JOIN film AS f
        ON f.film_id = i.film_id;


%%sql
EXPLAIN 
SELECT  DISTINCT(f.title)
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id 
WHERE   r.customer_id IN (
            SELECT  customer_id
            FROM    rental
            GROUP BY customer_id
            ORDER BY COUNT(*) DESC
            LIMIT   10
        );

%%sql
EXPLAIN 
SELECT  DISTINCT(f.title)
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id
        INNER JOIN (
            SELECT  customer_id, COUNT(*) as rent
            FROM    rental
            GROUP BY customer_id
            ORDER BY rent DESC
            LIMIT   10
        ) AS top_renters
        ON top_renters.customer_id = r.customer_id;


%%sql
EXPLAIN
SELECT  f.title, COUNT(*) AS rentals
FROM    customer AS c
        INNER JOIN (
            SELECT  COUNT(*) as rent, customer_id
            FROM    rental
            GROUP BY customer_id
        ) as top_renters
        ON c.customer_id = top_renters.customer_id
        JOIN rental as r
        ON c.customer_id = r.customer_id
        JOIN inventory AS i
        ON r.inventory_id = i.inventory_id
        JOIN film AS f
        ON f.film_id = i.film_id
ORDER BY top_renters.rent DESC
LIMIT   10;


%%sql
EXPLAIN
SELECT  c.city, s.store_id, f.title
FROM    store AS s JOIN address AS a
        ON s.address_id = a.address_id
        JOIN city AS c
        ON a.city_id = c.city_id
        JOIN staff AS st
        ON s.store_id = st.store_id
        JOIN rental as r
        ON st.staff_id = r.staff_id
        JOIN inventory AS i
        ON r.inventory_id = i.inventory_id
        JOIN film AS f
        ON f.film_id = i.film_id
WHERE   f.film_id NOT IN (
            SELECT  film_id
            FROM    rental
            WHERE   rental_date IS NULL
        );

SELECT  DISTINCT(f.title), c.city, s.store_id
FROM    store AS s JOIN address AS a USING (address_id)
        JOIN city AS c USING (city_id)
, film AS f
;


%%sql
EXPLAIN
SELECT  c.city, s.store_id, f.title
FROM    store AS s JOIN address AS a USING (address_id)
        JOIN city AS c USING (city_id)
        CROSS JOIN film AS f
WHERE   NOT EXISTS (
            SELECT  'x'
            FROM    film AS f2 JOIN inventory AS i USING (film_id)
                    JOIN rental r USING (inventory_id)
                    JOIN staff AS st USING (staff_id)
                    JOIN store as s2 USING (store_id)
            WHERE   rental_date IS NOT NULL
                    AND f2.film_id = f.film_id
                    AND s2.store_id = s.store_id
        );


%%sql
EXPLAIN
SELECT  c.city, s.store_id, f.title
FROM    store AS s JOIN address AS a
        ON s.address_id = a.address_id
        JOIN city AS c

        CROSS JOIN film AS f
WHERE   NOT EXISTS (
            SELECT  'x'
            FROM    FROM film AS f2 JOIN inventory AS i
                    ON f.film_id = i.film_id  
                    JOIN rental AS r
                    ON i.inventory_id = r.inventory_id
                    JOIN staff AS st 
                    ON st.staff_id = r.staff_id
                    JOIN store AS s2
                    ON s2.store_id = s.store_id
            WHERE   rental_date IS NOT NULL
                    AND f2.film_id = f.film_id
                    AND s2.store_id = s.store_id
        );



%%sql
EXPLAIN
SELECT  c.city, s.store_id, f.title
FROM    store AS s JOIN address AS a
        ON s.address_id = a.address_id
        JOIN city AS c
        ON a.city_id = c.city_id
        CROSS JOIN film AS f
WHERE   NOT EXISTS (
            SELECT  'x'
            FROM    film AS f2 JOIN inventory AS i
                    ON f.film_id = i.film_id  
                    JOIN rental AS r
                    ON i.inventory_id = r.inventory_id
                    JOIN staff AS st 
                    ON st.staff_id = r.staff_id
            WHERE   rental_date IS NOT NULL
                    AND f2.film_id = f.film_id
                    AND st.store_id = s.store_id
        );








%%sql
EXPLAIN 
SELECT  DISTINCT f.title
        ,top_renters.rent
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id
        INNER JOIN (
            SELECT  customer_id
                    ,COUNT(i.inventory_id) as rent
            FROM    rental
            GROUP BY customer_id
            ORDER BY rent DESC
            LIMIT   10
        ) AS top_renters
        ON top_renters.customer_id = r.customer_id;




%%sql
SELECT  f.title
        ,COUNT(r.inventory_id) AS rentals
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id 
WHERE   r.customer_id IN (
            SELECT  customer_id
            FROM    rental
            GROUP BY customer_id
            ORDER BY COUNT(*) DESC
            LIMIT   10
        )
GROUP BY f.title;


SELECT  DISTINCT f.title
        ,top_renters.rent AS rentals
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id
        INNER JOIN (
            SELECT  customer_id
                    COUNT(customer_id) AS cust
                    ,COUNT(inventory_id) as rent
            FROM    rental
            GROUP BY customer_id
            ORDER BY cust DESC
            LIMIT   10
        ) AS top_renters
        ON top_renters.customer_id = r.customer_id;

--take a look at q5, select titles count them from film then join inventory, 
--rental and check for customer ids in as per q5 top ten renters

%%sql
EXPLAIN 
SELECT  f.title, COUNT(f.title) AS rentals
FROM    film AS f JOIN inventory AS i
        ON f.film_id = i.film_id
        JOIN rental AS r
        ON i.inventory_id = r.inventory_id 
WHERE   r.customer_id IN (
            SELECT  customer_id
            FROM    rental
            GROUP BY customer_id
            ORDER BY COUNT(*) DESC
            LIMIT   10
        )
GROUP BY f.title;
\df and \df+

UPDATE jch5x8.survey 
SET reading = 0.111
WHERE taken = 751
AND person = 'lake' 
AND quant = 'sal';

jch5x8


SELECT * FROM jch5x8.survey
WHERE person = 'lake'
and quant = 'sal';

SELECT * FROM jch5x8.dr1_measurements;


UPDATE jch5x8.survey 
SET reading = 0.1
WHERE taken = 751
AND person = 'lake' 
and quant = 'sal';


SELECT * FROM jch5x8.survey_audit;

CREATE OR REPLACE VIEW
    jch5x8.dr1_measurements
AS
SELECT v.dated as date_taken
    , s.quant, s.reading
FROM jch5x8.visited v JOIN jch5x8.survey s ON (v.id::int=s.taken::int)
WHERE v.site='DR-1';


CREATE OR REPLACE VIEW
    jch5x8.dr1_radiation
AS

SELECT  v.dated as date_taken
        ,place.lat as latitude
        ,place.long as longitude
        ,s.reading as radiation
FROM    jch5x8.visited v
        JOIN jch5x8.survey s
        ON (v.id::int = s.taken::int)
        JOIN jch5x8.site as place
        ON (place.name = v.site)
WHERE   s.quant = 'rad'
        AND v.site = 'DR-1';

DROP VIEW jch5x8.dr1_radiation;

\d+ jch5x8.dr1_radiation

SELECT * FROM jch5x8.dr1_radiation



CREATE OR REPLACE FUNCTION jch5x8.totalSites ()
RETURNS integer AS $$
DECLARE
    total integer;
BEGIN
   SELECT count(*) INTO total FROM jch5x8.site;
   RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM jch5x8.totalSites


CREATE OR REPLACE FUNCTION jch5x8.totalReadingsForSite(p_site text)
RETURNS integer AS $$
DECLARE
    total integer;
BEGIN
   SELECT count(*) INTO total
    FROM jch5x8.visited v JOIN jch5x8.survey s ON (v.id::int=s.taken::int)
    WHERE v.site= p_site ;
   RETURN total;
END;
$$ LANGUAGE plpgsql;


\df+ jch5x8.totalReadingsForSite


select * from jch5x8.totalreadingsforsite('DR-3'::text);


UPDATE jch5x8.survey 
SET reading = reading + 0.01
WHERE person = 'roe';


CREATE OR REPLACE FUNCTION jch5x8.audit_jch5x8_survey_reading_insert()
  RETURNS TRIGGER 
  AS
$$
BEGIN
   INSERT INTO jch5x8.survey_audit
       (taken, person, quant, old_reading, new_reading)
   VALUES
       (NEW.taken, NEW.person, NEW.quant, NULL, NEW.reading);
   RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;



DROP TRIGGER IF EXISTS jch5x8_survey_insert_audit ON jch5x8.survey;

CREATE TRIGGER jch5x8_survey_insert_audit
  AFTER INSERT
  ON jch5x8.survey
  FOR EACH ROW
  EXECUTE PROCEDURE jch5x8.audit_jch5x8_survey_reading_insert();

\d jch5x8.survey


DROP TRIGGER IF EXISTS jch5x8_survey_update_audit ON jch5x8.survey;

CREATE TRIGGER jch5x8_survey_update_audit
  AFTER UPDATE
  ON jch5x8.survey
  FOR EACH ROW
  EXECUTE PROCEDURE jch5x8.audit_jch5x8_survey_reading_changes();


CREATE OR REPLACE FUNCTION jch5x8.audit_jch5x8_survey_reading_changes()
  RETURNS TRIGGER 
  AS
$$
BEGIN
    IF NEW.reading <> OLD.reading THEN
         INSERT INTO jch5x8.survey_audit
           (taken, person, quant, old_reading, new_reading)
           VALUES
           (OLD.taken, OLD.person, OLD.quant, OLD.reading, NEW.reading);
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;


INSERT INTO jch5x8.survey VALUES (619,'roe','rad',101);
Then

select * from jch5x8.survey_audit;

INSERT INTO jch5x8.survey VALUES 
(619,'lake','rad',8.72),
(619,'lake','sal',2.03),
(622,'lake','rad',8.8),
(622,'lake','sal',1.9);