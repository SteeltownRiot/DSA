-- ***********************
-- Build Full Text Search
-- Adapated from: 
--    http://wiki.hsr.ch/Datenbanken/files/Full_Text_Search_in_PostgreSQL_Luetolf_Paper_final.pdf
-- ***********************
-------------------------
-- Schema , aka namespace
-------------------------
CREATE SCHEMA <yourpawprint>;


-------------------------
-- Basic Table 
-------------------------

CREATE TABLE <yourpawprint>.BookSearch(
	id SERIAL NOT NULL,
	name varchar(250) NOT NULL,
	content text NOT NULL
);

ALTER TABLE <yourpawprint>.BookSearch
ADD CONSTRAINT pk_BookSearch PRIMARY KEY (id);




-------------------------
-- Separate Ts_Vector column
-------------------------
-- TS_Vector for GIN INDEX
ALTER TABLE <yourpawprint>.BookSearch 
  ADD COLUMN content_tsv_gin tsvector;

UPDATE <yourpawprint>.BookSearch 
SET content_tsv_gin = to_tsvector('pg_catalog.english', content);

-- TS_Vector for GIST INDEX
ALTER TABLE <yourpawprint>.BookSearch 
  ADD COLUMN content_tsv_gist tsvector;

UPDATE <yourpawprint>.BookSearch 
SET content_tsv_gist = to_tsvector('pg_catalog.english', content);



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
	ON <yourpawprint>.BookSearch 
	FOR EACH ROW 
	EXECUTE PROCEDURE 
	tsvector_update_trigger(content_tsv_gin,'pg_catalog.english',content);

CREATE TRIGGER tsv_gist_update 
	BEFORE INSERT OR UPDATE
	ON <yourpawprint>.BookSearch 
	FOR EACH 
	ROW EXECUTE PROCEDURE
	tsvector_update_trigger(content_tsv_gist,'pg_catalog.english',content);



-------------------------
-- Create Indexes
-------------------------

-- Index on content (Trigram needed,to use Gin Index)
CREATE EXTENSION pg_trgm;

CREATE INDEX BookSearch_content
ON <yourpawprint>.BookSearch USING GIN(content gin_trgm_ops);

-- GIN INDEX on content_tsv_gin
CREATE INDEX BookSearch_content_tsv_gin
ON <yourpawprint>.BookSearch USING GIN(content_tsv_gin);

-- GIST INDEX on content_tsv_gist
CREATE INDEX BookSearch_content_tsv_gist
ON <yourpawprint>.BookSearch USING GIST(content_tsv_gist);

----------------------------
-- Permissions on ir schema
-- and objects
----------------------------
GRANT USAGE ON SCHEMA <yourpawprint> TO dsa_ro_user;
GRANT SELECT ON <yourpawprint>.BookSearch TO dsa_ro_user;


