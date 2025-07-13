SHOW databases;
Use walmart_db;
select *  from walmart;


select count(*) from walmart;
select payment_method, count(*)
from walmart
group by payment_method;

select count(distinct Branch)
from walmart;

-- q1. find the different payment method and number of transactions, number of qty sold
select payment_method,
count(*) as no_of_paymet,
sum(quantity) as no_of_quantity  from walmart
group by payment_method;

-- q2. Identify the highest-rated category in each branch, displaying the branch, category
--  AVG RATING

 SELECT *
 FROM 
 (select Branch, category,
AVG(rating) as avg_rating,
RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC ) as 'rank'
from walmart
group by Branch, category
) as t 
WHERE t.rank = 1 ;

-- Q3 identify the busiest day for each branch based on the number of transactions 

SELECT
    date,
    STR_TO_DATE(date, '%d/%m/%Y') AS formatted_date
FROM
    walmart;
   
  SELECT * FROM
  (SELECT
    Branch,
    DAYNAME(DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%d/%m/%y')) AS 'day',
    COUNT(*) as no_of_transactions,
RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as 'rank'
FROM
    walmart
    GROUP BY Branch,DAYNAME(DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%d/%m/%y')) 
    ) AS t
    WHERE t.rank = 1;
    
-- Q4 
-- Determine the avg, min, and max reating of category for each city
-- List the city, avg_rating, min_rating, and max_rating

SELECT city, category,
MIN(rating) as min_rating,
MAX(rating) as max_rating,
AVG(rating) AS avg_rating
FROM walmart
GROUP BY 1, 2;

-- Q6
-- Calculate the total profit for each category by considering total_profit as 
-- (unit_price* quantity*profit_margin)
-- List category and total_profit, ordered from highest to lowest profit

SELECT 
category,
SUM(total) AS total_revenue,
SUM(total * profit_margin) AS profit
FROM walmart
GROUP BY 1;

-- Q7 
-- Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method

WITH cte AS
(SELECT branch, 
payment_method,
COUNT(*) AS total_trans,
RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS 'branch_rank'
FROM walmart 
GROUP BY branch, payment_method) 
SELECT * FROM cte 
WHERE branch_rank = 1;


-- q8 Categorize sales into 3 groups MORNING, AFTERNOON AND EVENING
-- Find out each of the shift and number of invoices

SELECT branch,
CASE
    WHEN  HOUR(TIME(time)) <12 then 'Morning'
    WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END  AS Time_of_Day,
    COUNT(*)
    from
walmart 
GROUP BY branch, Time_of_Day;







