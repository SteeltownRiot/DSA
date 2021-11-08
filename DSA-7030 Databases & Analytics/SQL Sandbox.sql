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

