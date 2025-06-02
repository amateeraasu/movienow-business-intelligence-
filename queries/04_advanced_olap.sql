-- ================================================================
-- 04_ADVANCED_OLAP.SQL
-- MovieNow Business Intelligence - OLAP Extensions & Multidimensional Analysis
-- ================================================================

-- PURPOSE: Advanced analytical queries using CUBE, ROLLUP, and GROUPING SETS
-- for multidimensional business intelligence and pivot table analysis

-- ================================================================
-- 1. CUSTOMER DEMOGRAPHICS ANALYSIS WITH CUBE
-- ================================================================

-- Customer distribution pivot table - Gender vs Country
SELECT 
    country,
    gender,
    COUNT(*) AS customer_count
FROM customers
WHERE country IS NOT NULL AND gender IS NOT NULL
GROUP BY CUBE (country, gender)
ORDER BY country NULLS LAST, gender NULLS LAST;

-- Enhanced customer analysis with totals and subtotals
SELECT 
    CASE 
        WHEN country IS NULL AND gender IS NULL THEN 'GRAND TOTAL'
        WHEN country IS NULL THEN CONCAT('TOTAL - ', gender)
        WHEN gender IS NULL THEN CONCAT(country, ' - TOTAL')
        ELSE CONCAT(country, ' - ', gender)
    END AS dimension,
    COUNT(*) AS customer_count
FROM customers
WHERE country IS NOT NULL AND gender IS NOT NULL
GROUP BY CUBE (country, gender)
ORDER BY 
    CASE WHEN country IS NULL AND gender IS NULL THEN 1 ELSE 2 END,
    country NULLS LAST, 
    gender NULLS LAST;

-- ================================================================
-- 2. CONTENT CATALOG ANALYSIS WITH CUBE
-- ================================================================

-- Movie inventory analysis - Genre vs Release Year
SELECT 
    genre,
    year_of_release,
    COUNT(*) AS movie_count,
    AVG(renting_price) AS avg_price,
    MIN(renting_price) AS min_price,
    MAX(renting_price) AS max_price
FROM movies
WHERE genre IS NOT NULL AND year_of_release IS NOT NULL
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release NULLS LAST, genre NULLS LAST;

-- ================================================================
-- 3. CUSTOMER PREFERENCES ANALYSIS WITH ROLLUP
-- ================================================================

-- Hierarchical customer analysis - Country -> Gender
SELECT 
    country,
    gender,
    COUNT(*) AS customers
FROM customers
WHERE country IS NOT NULL AND gender IS NOT NULL
GROUP BY ROLLUP (country, gender)
ORDER BY country NULLS LAST, gender NULLS LAST;

-- Genre preferences by country hierarchy
SELECT 
    c.country,
    m.genre,
    AVG(r.rating) AS avg_rating,
    COUNT(*) AS rental_count
FROM renting r
JOIN movies m ON m.movie_id = r.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.rating IS NOT NULL 
    AND c.country IS NOT NULL 
    AND m.genre IS NOT NULL
    AND r.date_renting >= '2018-01-01'
GROUP BY ROLLUP (c.country, m.genre)
ORDER BY c.country NULLS LAST, m.genre NULLS LAST;

-- ================================================================
-- 4. ADVANCED RATING ANALYSIS WITH GROUPING SETS
-- ================================================================

-- Multidimensional rating analysis - Country, Gender, and Overall
SELECT 
    c.country,
    c.gender,
    AVG(r.rating) AS avg_rating,
    COUNT(*) AS rental_count
FROM renting r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.rating IS NOT NULL 
    AND c.country IS NOT NULL 
    AND c.gender IS NOT NULL
    AND r.date_renting >= '2018-01-01'
GROUP BY GROUPING SETS (
    (c.country, c.gender),  -- Country-Gender combinations
    (c.country),            -- Country totals
    (c.gender),             -- Gender totals
    ()                      -- Grand total
)
ORDER BY c.country NULLS LAST, c.gender NULLS LAST;

-- ================================================================
-- 5. COMPREHENSIVE REVENUE ANALYSIS WITH CUBE
-- ================================================================

-- Revenue analysis across multiple dimensions
SELECT 
    c.country,
    m.genre,
    EXTRACT(YEAR FROM r.date_renting) AS year,
    SUM(m.renting_price) AS total_revenue,
    COUNT(*) AS rental_count,
    AVG(r.rating) AS avg_rating,
    COUNT(DISTINCT r.customer_id) AS unique_customers
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.date_renting >= '2018-01-01'
    AND c.country IS NOT NULL 
    AND m.genre IS NOT NULL
GROUP BY CUBE (c.country, m.genre, EXTRACT(YEAR FROM r.date_renting))
ORDER BY year NULLS LAST, c.country NULLS LAST, m.genre NULLS LAST;


