-- ***********************
-- Build Full Text Search
-- Adapated from: 
--    http://wiki.hsr.ch/Datenbanken/files/Full_Text_Search_in_PostgreSQL_Luetolf_Paper_final.pdf
-- ***********************
-------------------------
-- Schema , aka namespace
-------------------------
-- CREATE SCHEMA <yourpawprint>; -- created previously


-------------------------
-- Basic Table 
-------------------------

CREATE TABLE <yourpawprint>.BookLines(
	id SERIAL NOT NULL,
	name varchar(250) NOT NULL,
	line_no INT NOT NULL,
	line text NOT NULL
);

ALTER TABLE <yourpawprint>.BookLines
ADD CONSTRAINT pk_BookLines PRIMARY KEY (id);




-------------------------
-- Separate Ts_Vector column
-------------------------
-- TS_Vector for GIN INDEX
ALTER TABLE <yourpawprint>.BookLines 
  ADD COLUMN line_tsv_gin tsvector;

UPDATE <yourpawprint>.BookLines 
SET line_tsv_gin = to_tsvector('pg_catalog.english', line);

-- TS_Vector for GIST INDEX
ALTER TABLE <yourpawprint>.BookLines 
  ADD COLUMN line_tsv_gist tsvector;

UPDATE <yourpawprint>.BookLines 
SET line_tsv_gist = to_tsvector('pg_catalog.english', line);



-------------------------
-- keep it up-to-date 
-- with a Trigger
-- NOTE: See PG Documentation:
-- https://www.postgresql.org/docs/current/static/textsearch-features.html
-- Section 12.4.3. Triggers for Automatic Updates
-------------------------

--TRIGGER
CREATE TRIGGER tsv_gin_update 
	BEFORE INSERT OR UPDATE
	ON <yourpawprint>.BookLines 
	FOR EACH ROW 
	EXECUTE PROCEDURE 
	tsvector_update_trigger(line_tsv_gin,'pg_catalog.english',line);

CREATE TRIGGER tsv_gist_update 
	BEFORE INSERT OR UPDATE
	ON <yourpawprint>.BookLines 
	FOR EACH 
	ROW EXECUTE PROCEDURE
	tsvector_update_trigger(line_tsv_gist,'pg_catalog.english',line);



-------------------------
-- Create Indexes
-------------------------

-- Index on lines (Trigram needed,to use Gin Index)
-- CREATE EXTENSION pg_trgm; -- added previously

CREATE INDEX BookLines_line
ON <yourpawprint>.BookLines USING GIN(line gin_trgm_ops);

-- GIN INDEX on lines_tsv_gin
CREATE INDEX BookLines_line_tsv_gin
ON <yourpawprint>.BookLines USING GIN(line_tsv_gin);

-- GIST INDEX on lines_tsv_gist
CREATE INDEX BookLines_line_tsv_gist
ON <yourpawprint>.BookLines USING GIST(line_tsv_gist);

----------------------------
-- Permissions on ir schema
-- and objects
----------------------------
GRANT USAGE ON SCHEMA <yourpawprint> TO dsa_ro_user;
GRANT SELECT ON <yourpawprint>.BookLines TO dsa_ro_user;


