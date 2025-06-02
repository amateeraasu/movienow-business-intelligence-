-- ================================================================
-- 02_CUSTOMER_INTELLIGENCE.SQL
-- MovieNow Business Intelligence - Customer Analysis & Segmentation
-- ================================================================

-- PURPOSE: Analyze customer behavior, preferences, and segmentation
-- for targeted marketing and retention strategies

-- ================================================================
-- 1. CUSTOMER ACQUISITION ANALYSIS
-- ================================================================

-- Market entry timeline - First customer by country
SELECT 
    country,
    MIN(date_account_start) AS first_account,
    COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY first_account;

-- Customer growth patterns
SELECT 
    DATE_TRUNC('month', date_account_start) AS month,
    COUNT(*) AS new_customers
FROM customers
WHERE date_account_start IS NOT NULL
GROUP BY DATE_TRUNC('month', date_account_start)
ORDER BY month;

-- ================================================================
-- 2. CUSTOMER ENGAGEMENT & ACTIVITY LEVELS
-- ================================================================

-- High-value customers - 10+ rentals (VIP segment)
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM renting
    GROUP BY customer_id
    HAVING COUNT(*) > 10
)
ORDER BY name;

-- Active customers with ratings - Quality engagement
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM renting r
    WHERE r.customer_id = c.customer_id 
        AND rating IS NOT NULL
);

-- Low engagement customers - Potential churn risk
SELECT *
FROM customers c
WHERE 5 > (
    SELECT COUNT(*)
    FROM renting r
    WHERE r.customer_id = c.customer_id
);

-- ================================================================
-- 3. CUSTOMER SATISFACTION ANALYSIS
-- ================================================================

-- Dissatisfied customers - Ratings below 4 (Retention focus)
SELECT 
    c.*,
    sub.min_rating,
    sub.avg_rating,
    sub.total_rentals
FROM customers c
JOIN (
    SELECT 
        customer_id,
        MIN(rating) AS min_rating,
        AVG(rating) AS avg_rating,
        COUNT(*) AS total_rentals
    FROM renting
    WHERE rating IS NOT NULL
    GROUP BY customer_id
    HAVING MIN(rating) < 4
) sub ON c.customer_id = sub.customer_id
ORDER BY sub.min_rating;

-- Customer rating behavior analysis
SELECT 
    customer_id,
    AVG(rating) AS avg_rating,
    COUNT(rating) AS number_ratings,
    COUNT(*) AS number_rentals,
    ROUND(COUNT(rating) * 100.0 / COUNT(*), 2) AS rating_completion_rate
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7  -- Focus on active customers
ORDER BY avg_rating;

-- ================================================================
-- 4. DEMOGRAPHIC SEGMENTATION
-- ================================================================

-- Geographic customer distribution
SELECT 
    country,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY country
ORDER BY customer_count DESC;

-- Gender distribution by country
SELECT 
    country,
    gender,
    COUNT(*) AS customer_count
FROM customers
WHERE gender IS NOT NULL
GROUP BY country, gender
ORDER BY country, customer_count DESC;

-- Age cohort analysis
SELECT 
    CASE 
        WHEN date_of_birth BETWEEN '1950-01-01' AND '1959-12-31' THEN '1950s'
        WHEN date_of_birth BETWEEN '1960-01-01' AND '1969-12-31' THEN '1960s'
        WHEN date_of_birth BETWEEN '1970-01-01' AND '1979-12-31' THEN '1970s'
        WHEN date_of_birth BETWEEN '1980-01-01' AND '1989-12-31' THEN '1980s'
        WHEN date_of_birth BETWEEN '1990-01-01' AND '1999-12-31' THEN '1990s'
        ELSE 'Other'
    END AS birth_decade,
    COUNT(*) AS customer_count
FROM customers
WHERE date_of_birth IS NOT NULL
GROUP BY birth_decade
ORDER BY birth_decade;

-- ================================================================
-- 5. CUSTOMER LIFETIME VALUE ANALYSIS
-- ================================================================

-- Customer value metrics
SELECT 
    c.customer_id,
    c.name,
    c.country,
    COUNT(r.renting_id) AS total_rentals,
    SUM(m.renting_price) AS total_spent,
    AVG(m.renting_price) AS avg_rental_price,
    AVG(r.rating) AS avg_rating,
    MIN(r.date_renting) AS first_rental,
    MAX(r.date_renting) AS last_rental
FROM customers c
JOIN renting r ON c.customer_id = r.customer_id
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY c.customer_id, c.name, c.country
HAVING COUNT(r.renting_id) >= 5  -- Focus on regular customers
ORDER BY total_spent DESC;

-- ================================================================
-- 6. CUSTOMER PREFERENCES BY DEMOGRAPHICS
-- ================================================================

-- Belgian customer analysis - Market-specific insights
SELECT 
    c.name,
    c.gender,
    AVG(r.rating) AS avg_rating,
    COUNT(*) AS rental_count
FROM renting r
LEFT JOIN customers c ON r.customer_id = c.customer_id
WHERE c.country = 'Belgium'
GROUP BY c.customer_id, c.name, c.gender
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC;

-- 1970s generation movie preferences
SELECT 
    m.title,
    m.genre,
    COUNT(*) AS rental_count,
    AVG(r.rating) AS avg_rating
FROM renting r
JOIN customers c ON c.customer_id = r.customer_id
JOIN movies m ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
    AND r.rating IS NOT NULL
GROUP BY m.movie_id, m.title, m.genre
HAVING COUNT(*) > 1
ORDER BY avg_rating DESC, rental_count DESC;

-- ================================================================
-- 7. CUSTOMER CHURN RISK ANALYSIS
-- ================================================================

-- Inactive customers - No recent rentals
SELECT 
    c.*,
    MAX(r.date_renting) AS last_rental_date,
    COUNT(r.renting_id) AS total_rentals
FROM customers c
LEFT JOIN renting r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.name, c.country, c.gender, c.date_of_birth, c.date_account_start
HAVING MAX(r.date_renting) < '2019-01-01' OR MAX(r.date_renting) IS NULL
ORDER BY last_rental_date DESC NULLS LAST;

-- Single rental customers - Conversion opportunity
SELECT 
    c.*,
    r.date_renting,
    r.rating,
    m.title,
    m.genre
FROM customers c
JOIN renting r ON c.customer_id = r.customer_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE c.customer_id IN (
    SELECT customer_id
    FROM renting
    GROUP BY customer_id
    HAVING COUNT(*) = 1
)
ORDER BY r.date_renting DESC;

-- ================================================================
-- 8. CUSTOMER SEGMENTATION SUMMARY
-- ================================================================

-- Customer segments based on activity and satisfaction
SELECT 
    CASE 
        WHEN rental_count >= 10 AND avg_rating >= 7 THEN 'VIP Happy'
        WHEN rental_count >= 10 AND avg_rating < 7 THEN 'VIP At Risk'
        WHEN rental_count BETWEEN 5 AND 9 AND avg_rating >= 7 THEN 'Regular Happy'
        WHEN rental_count BETWEEN 5 AND 9 AND avg_rating < 7 THEN 'Regular At Risk'
        WHEN rental_count BETWEEN 2 AND 4 THEN 'Casual'
        ELSE 'One-time'
    END AS customer_segment,
    COUNT(*) AS segment_size
FROM (
    SELECT 
        c.customer_id,
        COUNT(r.renting_id) AS rental_count,
        AVG(r.rating) AS avg_rating
    FROM customers c
    LEFT JOIN renting r ON c.customer_id = r.customer_id
    GROUP BY c.customer_id
) customer_metrics
GROUP BY customer_segment
ORDER BY segment_size DESC;
