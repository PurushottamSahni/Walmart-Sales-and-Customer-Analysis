Walmart Case study  SQL Solutions
 Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

Create table
CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)

Generic Question
1.	How many unique cities does the data have?
SELECT DISTINCT city as city
FROM sales;
2.	In which city is each branch?
SELECT DISTINCT city,
branch
FROM sales;

Product Questions:
1.	How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;

2.	What is the most common payment method?
SELECT payment_method, COUNT(payment_method) as no_of_times
FROM sales 
GROUP BY payment_method
ORDER BY no_of_times DESC
Limit 1;

3.	What is the most selling product line?
SELECT product_line, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;

4.	What is the total revenue by month?
SELECT month_name, SUM(total) AS revenue FROM sales
GROUP BY month_name
ORDER BY revenue;

5.	What month had the largest COGS?
SELECT month_name, sum(cogs) AS total_cogs FROM sales
GROUP BY month_name
ORDER BY total_cogs Desc
LIMIT 1;


6.	What product line had the largest revenue?
SELECT product_line, SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC
limit 1;

7.	What is the city with the largest revenue?
SELECT city, SUM(total) AS revenue
FROM sales
GROUP BY city
ORDER BY revenue DESC
limit 1;

8.	What product line had the largest VAT?
SELECT product_line, sum(VAT) AS total_vat
FROM sales
GROUP BY product_line
ORDER BY total_vat DESC;

9.	Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line, quantity,
CASE WHEN quantity > (SELECT AVG(quantity) FROM sales) THEN 'Good'
ELSE 'Bad'
End AS sales_performance
from sales;

10.	Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING total_quantity > (SELECT AVG(quantity) FROM sales);

11.	What is the most common product line by gender?
SELECT product_line,gender, COUNT(quantity) AS total_quantity
FROM sales
GROUP BY product_line, gender
ORDER BY total_quantity desc
LIMIT 5;

12.	What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating FROM sales
GROUP BY product_line
ORDER BY avg_rating Desc;
Sales Questions:
1.	Number of sales made in each time of the day per weekday?
SELECT time_of_day, COUNT(invoice_id) AS sales_count
FROM sales
WHERE day_name IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
GROUP BY time_of_day
ORDER BY sales_count DESC;

2.	Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue desc;

3.	Which city has the largest tax percent/ VAT (**Value Added Tax**)?

4.	Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales
GROUP BY customer_type
ORDER BY total_VAT desc;


Customer
1.	How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

2.	How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;

3.	What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS cust_num
FROM sales
GROUP BY customer_type
ORDER BY cust_num desc;





4.	Which customer type buys the most?
SELECT customer_type, COUNT(customer_type) AS cust_num
FROM sales
GROUP BY customer_type
ORDER BY cust_num desc;

5.	What is the gender of most of the customers?
SELECT gender, COUNT(*) AS cust_num
FROM sales
GROUP BY gender
ORDER BY cust_num desc;

6.	What is the gender distribution per branch?
SELECT 
    branch,
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count
FROM sales
GROUP BY branch
ORDER BY male_count + female_count DESC;

7.	Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS total_rating
FROM sales
GROUP BY time_of_day
ORDER BY total_rating;

8.	Which time of the day do customers give most ratings per branch?
SELECT time_of_day,
SUM(CASE WHEN branch='A' then 1 ELSE 0 END) AS A_Branch,
SUM(CASE WHEN branch='B' then 1 ELSE 0 END) AS B_Branch,
SUM(CASE WHEN branch='C' then 1 ELSE 0 END) AS C_Branch
FROM SALES
GROUP BY time_of_day
ORDER BY A_Branch, B_Branch, C_Branch DESC;

9.	Which day fo the week has the best avg ratings?
SELECT day_name, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating desc;




10.	Which day of the week has the best average ratings per branch?
SELECT branch, day_name, avg_rating
FROM (
SELECT 
        branch, 
        day_name, 
        AVG(rating) AS avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_per_branch
    FROM sales
    GROUP BY branch, day_name) ranked_data
WHERE rank_per_branch = 1;
