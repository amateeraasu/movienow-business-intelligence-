-- ================================================================
-- 03_REVENUE_ANALYSIS.SQL
-- MovieNow Business Intelligence - Revenue & Financial Performance
-- ================================================================

-- PURPOSE: Analyze revenue patterns, pricing strategies, and financial KPIs
-- to optimize business performance and profitability

-- ================================================================
-- 1. OVERALL BUSINESS PERFORMANCE METRICS
-- ================================================================

-- 2018 Annual KPIs - Revenue, Rentals, Active Customers
SELECT 
    SUM(m.renting_price) AS total_revenue,
    COUNT(*) AS total_rentals,
    COUNT(DISTINCT r.customer_id) AS active_customers,
    AVG(m.renting_price) AS avg_rental_price,
    AVG(r.rating) AS avg_customer_satisfaction
FROM renting r
LEFT JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting BETWEEN '2018-01-01' AND '2018-12-31';

-- 2019 Performance Comparison
SELECT 
    SUM(m.renting_price) AS total_revenue,
    COUNT(*) AS total_rentals,
    COUNT(DISTINCT r.customer_id) AS active_customers,
    AVG(m.renting_price) AS avg_rental_price,
    AVG(r.rating) AS avg_customer_satisfaction
FROM renting r
LEFT JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2019-01-01';

-- ================================================================
-- 2. REVENUE BY GEOGRAPHIC MARKETS
-- ================================================================

-- Country-level KPIs for 2019 - Market performance analysis
SELECT 
    c.country,
    COUNT(*) AS number_renting,
    AVG(r.rating) AS average_rating,
    SUM(m.renting_price) AS revenue,
    AVG(m.renting_price) AS avg_rental_price,
    COUNT(DISTINCT r.customer_id) AS active_customers
FROM renting r
LEFT JOIN customers c ON c.customer_id = r.customer_id
LEFT JOIN movies m ON m.movie_id = r.movie_id
WHERE r.date_renting >= '2019-01-01'
GROUP BY c.country
ORDER BY revenue DESC;

-- Market penetration analysis
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT r.customer_id) AS active_customers,
    ROUND(COUNT(DISTINCT r.customer_id) * 100.0 / COUNT(DISTINCT c.customer_id), 2) AS penetration_rate
FROM customers c
LEFT JOIN renting r ON c.customer_id = r.customer_id 
    AND r.date_renting >= '2019-01-01'
GROUP BY c.country
ORDER BY penetration_rate DESC;

-- ================================================================
-- 3. REVENUE BY CONTENT CATEGORIES
-- ================================================================

-- Genre performance analysis
SELECT 
    m.genre,
    COUNT(*) AS total_rentals,
    SUM(m.renting_price) AS total_revenue,
    AVG(m.renting_price) AS avg_price,
    AVG(r.rating) AS avg_rating,
    COUNT(DISTINCT m.movie_id) AS unique_movies
FROM movies m
JOIN renting r ON m.movie_id = r.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY m.genre
ORDER BY total_revenue DESC;

-- Revenue per movie analysis
SELECT 
    m.title,
    m.genre,
    m.renting_price,
    COUNT(*) AS rental_count,
    SUM(m.renting_price) AS total_revenue,
    AVG(r.rating) AS avg_rating
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY m.movie_id, m.title, m.genre, m.renting_price
ORDER BY total_revenue DESC
LIMIT 20;

-- ================================================================
-- 4. PRICING STRATEGY ANALYSIS
-- ================================================================

-- Price point performance
SELECT 
    CASE 
        WHEN m.renting_price < 1.0 THEN 'Budget (<$1.00)'
        WHEN m.renting_price BETWEEN 1.0 AND 1.99 THEN 'Economy ($1.00-$1.99)'
        WHEN m.renting_price BETWEEN 2.0 AND 2.99 THEN 'Standard ($2.00-$2.99)'
        WHEN m.renting_price BETWEEN 3.0 AND 3.99 THEN 'Premium ($3.00-$3.99)'
        ELSE 'Luxury ($4.00+)'
    END AS price_tier,
    COUNT(*) AS rental_count,
    SUM(m.renting_price) AS revenue,
    AVG(r.rating) AS avg_rating,
    COUNT(DISTINCT m.movie_id) AS movies_in_tier
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY price_tier
ORDER BY revenue DESC;

-- Price elasticity by genre
SELECT 
    m.genre,
    ROUND(AVG(m.renting_price), 2) AS avg_price,
    COUNT(*) AS demand,
    SUM(m.renting_price) AS revenue,
    AVG(r.rating) AS satisfaction
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY m.genre
ORDER BY avg_price DESC;

-- ================================================================
-- 5. TEMPORAL REVENUE PATTERNS
-- ================================================================

-- Monthly revenue trends (2018)
SELECT 
    EXTRACT(MONTH FROM r.date_renting) AS month,
    EXTRACT(YEAR FROM r.date_renting) AS year,
    COUNT(*) AS rentals,
    SUM(m.renting_price) AS revenue,
    AVG(m.renting_price) AS avg_price
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting BETWEEN '2018-01-01' AND '2018-12-31'
GROUP BY EXTRACT(YEAR FROM r.date_renting), EXTRACT(MONTH FROM r.date_renting)
ORDER BY year, month;

-- Weekend vs Weekday performance
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM r.date_renting) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS rentals,
    SUM(m.renting_price) AS revenue,
    AVG(r.rating) AS avg_rating
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY day_type
ORDER BY revenue DESC;

-- ================================================================
-- 6. CUSTOMER VALUE ANALYSIS
-- ================================================================

-- Revenue per customer by country
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(m.renting_price) AS total_revenue,
    ROUND(SUM(m.renting_price) / COUNT(DISTINCT c.customer_id), 2) AS revenue_per_customer,
    ROUND(AVG(customer_stats.rentals_per_customer), 1) AS avg_rentals_per_customer
FROM renting r
JOIN customers c ON r.customer_id = c.customer_id
JOIN movies m ON r.movie_id = m.movie_id
JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS rentals_per_customer
    FROM renting
    WHERE date_renting >= '2018-01-01'
    GROUP BY customer_id
) customer_stats ON r.customer_id = customer_stats.customer_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY c.country
ORDER BY revenue_per_customer DESC;

-- High-value customer revenue contribution
SELECT 
    'Top 10%' AS customer_segment,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(total_spent) AS revenue,
    ROUND(AVG(total_spent), 2) AS avg_spend_per_customer
FROM (
    SELECT 
        r.customer_id,
        SUM(m.renting_price) AS total_spent,
        NTILE(10) OVER (ORDER BY SUM(m.renting_price) DESC) AS decile
    FROM renting r
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE r.date_renting >= '2018-01-01'
    GROUP BY r.customer_id
) customer_deciles
WHERE decile = 1
UNION ALL
SELECT 
    'Bottom 50%' AS customer_segment,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(total_spent) AS revenue,
    ROUND(AVG(total_spent), 2) AS avg_spend_per_customer
FROM (
    SELECT 
        r.customer_id,
        SUM(m.renting_price) AS total_spent,
        NTILE(10) OVER (ORDER BY SUM(m.renting_price) DESC) AS decile
    FROM renting r
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE r.date_renting >= '2018-01-01'
    GROUP BY r.customer_id
) customer_deciles
WHERE decile >= 6;

-- ================================================================
-- 7. PROFITABILITY INSIGHTS
-- ================================================================

-- Most profitable movies (Revenue-generating champions)
SELECT 
    m.title,
    m.genre,
    m.renting_price,
    COUNT(*) AS times_rented,
    SUM(m.renting_price) AS total_revenue,
    AVG(r.rating) AS avg_rating,
    ROUND(SUM(m.renting_price) / COUNT(*), 2) AS revenue_per_rental
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY m.movie_id, m.title, m.genre, m.renting_price
HAVING COUNT(*) >= 5  -- Focus on consistently rented movies
ORDER BY total_revenue DESC
LIMIT 15;

-- Underperforming content - Low revenue movies
SELECT 
    m.title,
    m.genre,
    m.renting_price,
    COUNT(*) AS times_rented,
    SUM(m.renting_price) AS total_revenue,
    AVG(r.rating) AS avg_rating
FROM renting r
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY m.movie_id, m.title, m.genre, m.renting_price
HAVING COUNT(*) <= 2  -- Rarely rented content
ORDER BY total_revenue ASC
LIMIT 15;

-- ================================================================
-- 8. REVENUE OPTIMIZATION OPPORTUNITIES
-- ================================================================

-- Genre-Country revenue matrix for targeted marketing
SELECT 
    c.country,
    m.genre,
    SUM(m.renting_price) AS revenue,
    COUNT(*) AS rentals,
    AVG(r.rating) AS satisfaction
FROM renting r
JOIN customers c ON r.customer_id = c.customer_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.date_renting >= '2018-01-01'
GROUP BY c.country, m.genre
HAVING COUNT(*) >= 5  -- Significant sample size
ORDER BY c.country, revenue DESC;
