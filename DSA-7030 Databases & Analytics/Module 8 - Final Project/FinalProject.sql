CREATE TABLE IF NOT EXISTS jch5x8.blocks(
        block_id INT PRIMARY KEY,
        block VARCHAR(150);

CREATE TABLE IF NOT EXISTS jch5x8.locations(
        loc_id INT PRIMARY KEY,
        location VARCHAR(250);

CREATE TABLE IF NOT EXISTS jch5x8.geolocs(
        geoloc_id INT PRIMARY KEY,
        x_coord DECIMAL(10,6),
        y_coord DECIMAL(10,6),
        lat DECIMAL(10,6),
        long DECIMAL(10,6),
        lat_long VARCHAR(50));

CREATE TABLE IF NOT EXISTS jch5x8.beats(
        beat INT PRIMARY KEY);

CREATE TABLE IF NOT EXISTS jch5x8.districts(
        district INT PRIMARY KEY);

CREATE TABLE IF NOT EXISTS jch5x8.wards(
        ward INT PRIMARY KEY);

CREATE TABLE IF NOT EXISTS jch5x8.community_areas(
        comm_area INT PRIMARY KEY);

CREATE TABLE IF NOT EXISTS jch5x8.nibrs_codes(
        nibrs INT PRIMARY KEY;

CREATE TABLE IF NOT EXISTS jch5x8.iucr_codes(
        iucr VARCHAR(50) PRIMARY KEY,
        offense_type VARCHAR(50),
        description VARCHAR(100),
        nibrs INT REFERENCES jch5x8.nibrs_codes ON DELETE SET NULL ON UPDATE CASCADE);

CREATE  TABLE IF NOT EXISTS jch5x8.cases(
        id INT PRIMARY KEY,
        case_num VARCHAR(50),
        date DATETIME,
        block_id INT jch5x8.blocks ON DELETE SET NULL ON UPDATE CASCADE,
        loc_id INT jch5x8.locations ON DELETE SET NULL ON UPDATE CASCADE,
        arrest BOOL,
        domestic BOOL,
        beat INT jch5x8.beats ON DELETE SET NULL ON UPDATE CASCADE,
        district INT jch5x8.districts ON DELETE SET NULL ON UPDATE CASCADE,
        ward INT jch5x8.wards ON DELETE SET NULL ON UPDATE CASCADE,
        comm_area INT jch5x8.community_areas ON DELETE SET NULL ON UPDATE CASCADE,
        geoloc_id INT jch5x8.geolocs ON DELETE SET NULL ON UPDATE CASCADE,
        updated_on DATETIME);

BEGIN;
COPY blocks FROM 'blocks.csv';
END;