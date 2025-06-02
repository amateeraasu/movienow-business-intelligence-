-- ================================================================
-- 01_EXPLORATORY_ANALYSIS.SQL
-- MovieNow Business Intelligence - Data Exploration & Validation
-- ================================================================

-- PURPOSE: Initial data exploration, quality checks, and basic statistics
-- to understand the MovieNow database structure and data patterns

-- ================================================================
-- 1. DATABASE OVERVIEW & DATA VALIDATION
-- ================================================================

-- Basic table exploration - Understanding the rental transaction data
SELECT *  
FROM renting
LIMIT 10;

-- Key columns for rating analysis
SELECT movie_id, rating  
FROM renting
WHERE rating IS NOT NULL
LIMIT 10;

-- Data quality check - Count total records per table
SELECT 'Movies' AS table_name, COUNT(*) AS record_count FROM movies
UNION ALL
SELECT 'Actors' AS table_name, COUNT(*) AS record_count FROM actors
UNION ALL
SELECT 'Customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION ALL
SELECT 'Renting' AS table_name, COUNT(*) AS record_count FROM renting
UNION ALL
SELECT 'ActsIn' AS table_name, COUNT(*) AS record_count FROM actsin;

-- ================================================================
-- 2. TIME-BASED DATA EXPLORATION
-- ================================================================

-- Rentals for specific date - Data quality check
SELECT *
FROM renting
WHERE date_renting = DATE('2018-10-09');

-- Rentals within date range - Seasonal analysis preparation
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY date_renting DESC;

-- Annual rental activity - Business performance baseline
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' 
    AND rating IS NOT NULL;

-- ================================================================
-- 3. MOVIE CATALOG EXPLORATION
-- ================================================================

-- Genre distribution - Content strategy insights
SELECT *
FROM movies
WHERE genre != 'Drama'
ORDER BY genre;

-- Specific high-profile movies analysis
SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter');

-- Pricing structure analysis
SELECT *
FROM movies
ORDER BY renting_price DESC;

-- ================================================================
-- 4. CUSTOMER DEMOGRAPHICS BASELINE
-- ================================================================

-- Generation analysis - 1980s born customers
SELECT COUNT(*) AS gen_1980s_customers
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31';

-- Geographic distribution - German market size
SELECT COUNT(*) AS german_customers
FROM customers
WHERE country = 'Germany';

-- Market reach - Total countries served
SELECT COUNT(DISTINCT country) AS countries_served
FROM customers;

-- ================================================================
-- 5. RATING SYSTEM ANALYSIS
-- ================================================================

-- Rating distribution for specific movie (ID 25)
SELECT 
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating,
    COUNT(rating) AS number_ratings
FROM renting
WHERE movie_id = 25;

-- ================================================================
-- 6. ANNUAL PERFORMANCE OVERVIEW (2019)
-- ================================================================

-- Complete 2019 rental activity
SELECT COUNT(*) AS total_rentals_2019
FROM renting
WHERE date_renting >= '2019-01-01';

-- Key performance metrics for 2019
SELECT 
    COUNT(*) AS number_renting,
    AVG(rating) AS average_rating,
    COUNT(rating) AS number_ratings
FROM renting
WHERE date_renting >= '2019-01-01';

-- ================================================================
-- 7. DATA RELATIONSHIPS VALIDATION
-- ================================================================

-- Sample join validation - Customer rental data
SELECT 
    r.renting_id,
    r.customer_id,
    c.name,
    c.country,
    r.movie_id,
    r.rating,
    r.date_renting
FROM renting r
LEFT JOIN customers c ON r.customer_id = c.customer_id
LIMIT 5;

-- Sample movie-actor relationship validation
SELECT 
    m.title,
    a.name AS actor_name,
    a.nationality
FROM movies m
JOIN actsin ai ON m.movie_id = ai.movie_id
JOIN actors a ON ai.actor_id = a.actor_id
LIMIT 10;

-- ================================================================
-- 8. BUSINESS METRICS FOUNDATION
-- ================================================================

-- Rating completeness analysis
SELECT 
    COUNT(*) AS total_rentals,
    COUNT(rating) AS rated_rentals,
    ROUND(COUNT(rating) * 100.0 / COUNT(*), 2) AS rating_completion_rate
FROM renting;

-- Date range validation
SELECT 
    MIN(date_renting) AS earliest_rental,
    MAX(date_renting) AS latest_rental,
    MAX(date_renting) - MIN(date_renting) AS business_duration_days
FROM renting;
