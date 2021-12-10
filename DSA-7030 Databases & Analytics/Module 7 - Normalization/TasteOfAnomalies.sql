CREATE  TABLE IF NOT EXISTS jch5x8.Employees(
        SSN INT PRIMARY KEY,
        name VARCHAR(50),
        lot INT,
        rating INT,
        hrly_wages REAL,
        hrs_worked REAL);

INSERT INTO jch5x8.Employees (SSN, name, lot, rating, hrly_wages, hrs_worked) VALUES
    (531515421, 'Vera', 24, 5, 12, 33.9),
    (429932160, 'Aubert', 8, 5, 12, 39.9),
    (440662487, 'Illarion', 6, 3, 9.5, 39.4),
    (408098083, 'Aifric', 5, 1, 7.5, 35),
    (576889349, 'Ève', 8, 2, 8, 38.4),
    (400329204, 'Hedvig', 28, 4, 10, 30),
    (501805927, 'Donnchadh', 18, 1, 7.5, 35.9),
    (525759852, 'Marion', 12, 4, 10, 34.5),
    (135137534, 'Bente', 13, 4, 10, 38),
    (469230198, 'Arlette', 12, 3, 9.5, 30.3),
    (247215030, 'Kresten', 17, 5, 12, 36.8),
    (545376537, 'Gobnet', 5, 2, 8, 37),
    (224546191, 'Yanis', 24, 4, 10, 35.25),
    (400166538, 'Amalie', 1, 1, 7.5, 39.25),
    (363369063, 'Rosa', 20, 2, 8, 34.7),
    (159829237, 'Miriam', 29, 1, 7.5, 37),
    (522396865, 'Jaromíra', 26, 5, 12, 35.5),
    (417728015, 'Gurutze', 22, 3, 9.5, 33.4),
    (520087141, 'Goizane', 18, 3, 9.5, 32),
    (306562516, 'Bistra', 16, 2, 8, 37.9);

CREATE TABLE jch5x8.Keep_Employees AS SELECT * FROM jch5x8.Employees;

UPDATE jch5x8.Employees SET hrly_wages = 100 WHERE lot = 1;

INSERT INTO jch5x8.Employees (SSN, name, lot, rating, hrly_wages, hrs_worked) VALUES
    (401662722, 'Věroslav', 4, 4, 10, 33.9),
    (425346068, 'Adrijana', 18, 5, NULL, 39.9);

DELETE FROM jch5x8.Employees WHERE rating = 1;

INSERT INTO jch5x8.Employees (SSN, name, lot, rating, hrly_wages, hrs_worked) VALUES
    (479182420, 'Valerie', 21, 1, 7.5, 36);

CREATE  TABLE IF NOT EXISTS jch5x8.Employees(
        ssn INT PRIMARY KEY,
        name VARCHAR(50),
        lot INT,
        rating INT REFERENCES jch5x8.Pay ON DELETE SET NULL ON UPDATE CASCADE,
        hrs_worked REAL);


DROP TABLE jch5x8.Keep_Employees, jch5x8.Pay;

CREATE  TABLE jch5x8.Keep_Employees(
        SSN INT PRIMARY KEY,
        name VARCHAR(50),
        lot INT,
        rating INT,
        hrly_wages REAL,
        hrs_worked REAL);

INSERT INTO jch5x8.Keep_Employees (SSN, name, lot, rating, hrs_worked) VALUES
    (531515421, 'Vera', 24, 5, 33.9),
    (429932160, 'Aubert', 8, 5, 39.9),
    (440662487, 'Illarion', 6, 3, 39.4),
    (408098083, 'Aifric', 5, 1, 35),
    (576889349, 'Ève', 8, 2, 38.4),
    (400329204, 'Hedvig', 28, 4, 30),
    (501805927, 'Donnchadh', 18, 1, 35.9),
    (525759852, 'Marion', 12, 4, 34.5),
    (135137534, 'Bente', 13, 4, 38),
    (469230198, 'Arlette', 12, 3, 30.3),
    (247215030, 'Kresten', 17, 5, 36.8),
    (545376537, 'Gobnet', 5, 2, 37),
    (224546191, 'Yanis', 24, 4, 35.25),
    (400166538, 'Amalie', 1, 1, 39.25),
    (363369063, 'Rosa', 20, 2, 34.7),
    (159829237, 'Miriam', 29, 1, 37),
    (522396865, 'Jaromíra', 26, 5, 35.5),
    (417728015, 'Gurutze', 22, 3, 33.4),
    (520087141, 'Goizane', 18, 3, 32),
    (306562516, 'Bistra', 16, 2, 37.9);

CREATE  TABLE IF NOT EXISTS jch5x8.Pay(
        rating INT PRIMARY KEY,
        hrly_wages REAL NOT NULL);

INSERT INTO jch5x8.Pay (rating, hrly_wages) VALUES
    (5, 12),
    (4, 10),
    (3, 9.5),
    (2, 8),
    (1, 7.5);

ALTER TABLE jch5x8.Keep_Employees 
DROP COLUMN hrly_wages,
ADD CONSTRAINT fk_Pay
    FOREIGN KEY (rating)
    REFERENCES Pay(rating);

UPDATE jch5x8.Keep_Employees SET hrly_wages = 100 WHERE name = 'Amalie';
UPDATE jch5x8.Pay SET hrly_wages = 100 WHERE name = 'Amalie';

INSERT INTO jch5x8.Keep_Employees (SSN, name, lot, rating, hrly_wages, hrs_worked) VALUES
    (401662722, 'Věroslav', 4, 4, 10, 33.9),
    (425346068, 'Adrijana', 18, 5, NULL, 39.9);

DELETE FROM jch5x8.Keep_Employees WHERE rating = 1;

INSERT INTO jch5x8.Keep_Employees (SSN, name, lot, rating, hrs_worked) VALUES
    (479182420, 'Valerie', 21, 1, 36);






WITH data(ssn, name, lot, rating, hrly_wages, hrs_worked) AS (
   VALUES
     (401662722, 'Věroslav', 4, 4, 10, 33.9),
     (425346068, 'Adrijana', 18, 5, NULL, 39.9)
   )
,ins1 AS (
   INSERT INTO jch5x8.Keep_Employees (ssn, name, lot, rating, hrs_worked) VALUES
   SELECT ssn
   FROM   data
   RETURNING ssn
   )
INSERT INTO jch5x8.Pay (rating, hrly_wages)
SELECT  d.rating, d.hrly_wages
FROM    data d JOIN ins1
        USING (ssn);



WITH data(ssn, name, lot, rating, hrly_wages, hrs_worked) AS (
   VALUES
     (401662722, 'Věroslav', 4, 4, 10, 33.9),
     (425346068, 'Adrijana', 18, 5, NULL, 39.9)
   )
,ins1 AS (
   INSERT INTO jch5x8.Keep_Employees (ssn, name, lot, rating, hrs_worked)
   SELECT ssn, name, lot, rating, hrs_worked
   FROM   data
   RETURNING ssn
   )
INSERT INTO jch5x8.Pay (rating, hrly_wages)
SELECT  d.rating, d.hrly_wages
FROM    data d JOIN ins1
        USING (ssn);

ALTER TABLE Employees ALTER COLUMN rating SET NOT NULL, ALTER COLUMN hrly_wages SET NOT NULL;

INSERT INTO jch5x8.Pay (rating, hrly_wages) VALUES
    (1, 7.5);