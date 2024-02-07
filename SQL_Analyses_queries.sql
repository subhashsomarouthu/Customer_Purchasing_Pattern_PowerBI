# Viewing the table
SELECT * FROM proem_analytics.proem_analytics_assignment;

# Count of Rows
select count(*) from proem_analytics.proem_analytics_assignment;

# Changing the data type of Match Dates and Booking dates to date and date time
UPDATE proem_analytics.proem_analytics_assignment
SET Booking_Date = STR_TO_DATE(Booking_Date, '%d-%m-%Y %H:%i');

ALTER TABLE proem_analytics.proem_analytics_assignment
MODIFY COLUMN Booking_Date DATETIME;

UPDATE proem_analytics_assignment
SET match_dates = STR_TO_DATE(match_dates, '%d-%m-%Y');

ALTER TABLE proem_analytics_assignment
MODIFY COLUMN match_dates DATE;

# verifying modifyinf data types
describe proem_analytics_assignment;

# checking for Null Values
select * from proem_analytics_assignment where match_dates is null;


# Data Analyses:
select * from proem_analytics_assignment;

#1.summmary Statistics

SELECT
    COUNT(DISTINCT Customer_Key) AS unique_customers,
    COUNT(DISTINCT match_dates) AS total_matches_held,
    MIN(match_dates) AS first_game_date,
    MAX(match_dates) AS last_game_date,
    MIN(item_rate) AS lowest_price_ticket,
    MAX(item_rate) AS highest_price_ticket,
    AVG(total_amount) AS avg_total_amount,
    SUM(total_amount) AS toal_revenue,
    SUM(quantity) AS total_tickets_sold,
    MAX(quantity) AS maximum_tickets_sold,
    MIN(quantity) AS minimum_tickets_sold
FROM proem_analytics_assignment;

#2. Ticket sales analyses
SELECT
    match_dates,
    SUM(total_amount) AS daily_total_sales,
    count(distinct(customer_key)) as num_customers
FROM proem_analytics_assignment
GROUP BY match_dates
ORDER BY match_dates;

#3.customer segmentation
select DISTINCT(item_rate) FROM proem_analytics_assignment;
SELECT
    CASE
        WHEN total_amount > 1000 THEN 'High Value'
        WHEN total_amount > 300 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(DISTINCT Customer_Key) AS num_customers,
    SUM(total_amount) AS total_sales
FROM proem_analytics_assignment
GROUP BY customer_segment;

#4.Source wise contributions
SELECT
    source,
    COUNT(DISTINCT Customer_Key) AS num_customers,
    SUM(total_amount) AS revenue_contribution
FROM proem_analytics_assignment
GROUP BY source
ORDER BY revenue_contribution DESC;

#5.Payment gateway analysis
SELECT
    payment_gateway,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT customer_key) AS number_of_customers,
    source
FROM proem_analytics_assignment
GROUP BY payment_gateway, source
ORDER BY transaction_count DESC;


#6. Most Valuable Customer
SELECT
    Customer_Key,
    COUNT(*) AS transaction_count,
    ROUND(AVG(total_amount), 2) AS avg_transaction_amount,
    max(total_amount) as max_amount_spent,
    MIN(total_amount) as min_amount_spent,
    SUM(total_amount) AS total_spending,
    max(quantity) AS max_tickets_purchased_in_single_transaction,
    max(item_group) AS preferred_group
FROM proem_analytics_assignment
GROUP BY Customer_Key
ORDER BY total_spending DESC
LIMIT 15;


#7.Most preferred group by audience
SELECT
    item_group,
    SUM(quantity) AS total_tickets_sold,
    SUM(total_amount) AS total_revenue_from_group,
    MAX(item_rate) AS max_price_of_group,
    MIN(item_rate) AS min_price_of_group,
    (SUM(total_amount) / (SELECT SUM(total_amount) FROM proem_analytics_assignment)) * 100 AS revenue_percentage
FROM proem_analytics_assignment
GROUP BY item_group
ORDER BY total_tickets_sold DESC;

#8.Hour Of booking analyses
SELECT
    EXTRACT(HOUR FROM Booking_Date) AS hour_of_day,
    SUM(quantity) AS tickets_sold,
    GROUP_CONCAT(DISTINCT source ORDER BY source desc) AS sources
FROM proem_analytics_assignment
GROUP BY hour_of_day
ORDER BY tickets_sold DESC, hour_of_day;

#9.When the customer is booking tickets
SELECT
    match_dates,
    DATE(Booking_Date) AS date_of_booking,
    SUM(quantity) AS tickets_sold
FROM proem_analytics_assignment
GROUP BY match_dates, date_of_booking
ORDER BY match_dates, tickets_sold DESC, date_of_booking;

#10. Total tickets sold on each booking day
SELECT
    Booking_Date,
    SUM(quantity) AS total_tickets_sold
FROM proem_analytics_assignment
GROUP BY Booking_Date
ORDER BY total_tickets_sold DESC;






















