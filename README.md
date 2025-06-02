MovieNow Business Intelligence Analysis
SQL-Driven Decision Making for Online Movie Rental Platform

**🎬 Project Overview:**

This project demonstrates comprehensive business intelligence analysis for MovieNow, a fictional online movie rental platform. Using PostgreSQL, I analyzed customer behavior, revenue patterns, movie preferences, and operational KPIs to support data-driven decision making.

**📊 Business Context:**

MovieNow is an online streaming platform where customers can rent movies for 24-hour periods. The company needs insights to:

Optimize movie catalog and pricing strategies
Understand customer preferences and engagement
Identify revenue opportunities
Make informed decisions about content acquisition

**🗄️ Database Schema.**

The analysis uses 5 interconnected tables:

**customers:** Customer demographics and account information
**movies:** Movie catalog with genres, pricing, and metadata
**renting:** Transaction records with ratings and rental dates
**actors:** Actor information and demographics
**actsin:** Many-to-many relationship between movies and actors

**🎯 Key Business Questions Analyzed:**

_1. Revenue & Financial Performance._

Total revenue analysis by time period, country, and genre
KPI tracking for 2018-2019 performance metrics
Pricing strategy insights through rental price analysis

_2. Customer Intelligence._

Customer segmentation by demographics and behavior
Customer satisfaction measurement through rating analysis
Customer engagement patterns and retention insights
Geographic analysis of customer preferences

_3. Content Strategy._

Movie popularity analysis and recommendation prioritization
Genre performance across different markets
Actor popularity and casting decision support
Content acquisition guidance based on ratings and demand

_4. Operational Analytics._

Platform usage patterns and seasonal trends
Rating system analysis for quality control
Customer lifetime value assessment
Market expansion opportunities by region

**📈 Key Findings & Business Impact:**

_Revenue Insights._

2019 Performance: Analyzed total rentals, average ratings, and revenue trends
Country-specific KPIs: Identified top-performing markets for strategic focus
Genre profitability: Determined which movie categories drive highest revenue

_Customer Behavior. _

High-value customers: Identified customers with 10+ rentals for retention programs
Satisfaction segments: Found customers with ratings below 4 for targeted improvement
Demographic preferences: Analyzed viewing patterns by age groups (e.g., customers born in 70s)

_Content Performance._

Popular content: Movies with 5+ views identified for promotional campaigns
Quality threshold: Movies with 8+ average ratings highlighted for featured content
Actor analysis: Nationality and gender diversity in comedy genre assessed

_Market Intelligence._

Geographic preferences: Genre preferences vary significantly by country
Demographic targeting: Gender-based viewing patterns inform content curation
Quality standards: Established minimum rating thresholds (3+ ratings) for reliable insights

**🛠️ Technical Implementation.**

_SQL Techniques Demonstrated._

**Complex JOINs:** Multi-table analysis across 5 normalized tables
**Subqueries & CTEs:** Nested queries for advanced filtering and analysis
**Window Functions:** Ranking and comparative analysis
**OLAP Extensions:** CUBE, ROLLUP, and GROUPING SETS for multidimensional analysis
**Correlated Queries:** Customer behavior analysis with related data
**Set Operations:** UNION, INTERSECT for complex data combinations

**Advanced Analytics Features**

Pivot Table Analysis: Using CUBE operator for cross-tabulated insights
Time Series Analysis: Date-based filtering and trend identification
Aggregation Hierarchies: ROLLUP for hierarchical summaries
Statistical Functions: MIN, MAX, AVG, COUNT for comprehensive metrics


**🎯 Business Recommendations.**

Immediate Actions (0-3 months).

Focus marketing on movies with 5+ views and 8+ ratings
Implement retention program for customers with 10+ rentals
Address satisfaction issues for customers rating below 4
Promote high-rated dramas (9+ average rating) in advertising

Strategic Initiatives (3-12 months).

Expand content acquisition in top-performing genres by country
Develop country-specific content strategies based on preference analysis
Optimize pricing strategy using revenue per genre insights
Create targeted campaigns for different customer segments

Long-term Planning (12+ months).

Market expansion to countries showing high engagement
Content partnerships with popular actors based on nationality analysis
Platform improvements informed by customer behavior patterns
Data-driven content creation based on successful genre combinations

**💼 Skills Demonstrated.**

Business Intelligence: KPI definition, metric calculation, performance monitoring
Data Analysis: Statistical analysis, trend identification, segmentation
SQL Proficiency: Advanced queries, OLAP functions, database optimization
Strategic Thinking: Business problem solving, recommendation development
Data Storytelling: Insight extraction and business communication

**🔧 Tools & Technologies.**

Database: PostgreSQL
SQL Features: OLAP extensions (CUBE, ROLLUP, GROUPING SETS)
Analysis Methods: Exploratory data analysis, cohort analysis, time series analysis
Business Intelligence: KPI development, dashboard creation, report generation

**📊 Data Quality & Methodology.**

Data Validation: Handled NULL values and missing ratings appropriately
Statistical Rigor: Used minimum thresholds (3+ ratings) for reliable averages
Time Period Consistency: Focused analysis on 2018-2019 for trend identification
Business Logic: Applied domain knowledge for meaningful customer segmentation

**🚀 Future Enhancements.**

Integration with visualization tools (Tableau, Power BI)
Real-time dashboard development
Predictive analytics for customer churn
A/B testing framework for pricing optimization
Machine learning models for recommendation systems
