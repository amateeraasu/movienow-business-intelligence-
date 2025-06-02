-- MovieNow Database Setup
-- Online Movie Rental Platform Schema

-- Create and populate movies table
DROP TABLE IF EXISTS "movies";
CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title TEXT,
    genre TEXT,
    runtime INT,
    year_of_release INT,
    renting_price NUMERIC
);

COPY movies
FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/3eebf2a145b76fee37357bcd55ac54577c03c805/movies_181127_2.csv"' 
(DELIMITER ',', FORMAT CSV, HEADER);

-- Create and populate actors table
DROP TABLE IF EXISTS "actors";
CREATE TABLE actors (
    actor_id INTEGER PRIMARY KEY,
    name CHARACTER VARYING,
    year_of_birth INTEGER,
    nationality CHARACTER VARYING,
    gender CHARACTER VARYING
);

COPY actors
FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/c67f20fa317e8229eed7586cda8bfce5fc177444/actors_181127_2.csv"' 
(DELIMITER ',', FORMAT CSV, HEADER);

-- Create and populate actsin junction table
DROP TABLE IF EXISTS "actsin";
CREATE TABLE actsin (
    actsin_id INTEGER PRIMARY KEY,
    movie_id INTEGER,
    actor_id INTEGER
);

COPY actsin
FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/6efc08575effcc9327c82fea18aaf22dfd61cc27/actsin_181127_2.csv"' 
(DELIMITER ',', FORMAT CSV, HEADER);

-- Create and populate customers table
DROP TABLE IF EXISTS "customers";
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name CHARACTER VARYING,
    country CHARACTER VARYING,
    gender CHARACTER VARYING,
    date_of_birth DATE,
    date_account_start DATE
);

COPY customers
FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/4b1767d8e638ab26e62d98517fef297d72260992/customers_181127_2.csv"' 
(DELIMITER ',', FORMAT CSV, HEADER);

-- Create and populate renting table
DROP TABLE IF EXISTS "renting";
CREATE TABLE renting (
    renting_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating INTEGER,
    date_renting DATE
);

COPY renting
FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/4068/datasets/d36ed7719976092a9b3387c8a2ac077914c9e1d2/renting_181127_2.csv"' 
(DELIMITER ',', FORMAT CSV, HEADER);

-- Data validation queries
SELECT 'Movies' AS table_name, COUNT(*) AS record_count FROM movies
UNION ALL
SELECT 'Actors' AS table_name, COUNT(*) AS record_count FROM actors
UNION ALL
SELECT 'ActsIn' AS table_name, COUNT(*) AS record_count FROM actsin
UNION ALL
SELECT 'Customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION ALL
SELECT 'Renting' AS table_name, COUNT(*) AS record_count FROM renting;
