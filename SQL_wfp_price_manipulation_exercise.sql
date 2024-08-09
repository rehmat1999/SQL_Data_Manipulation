USE assignments_atom ;

SELECT * FROM wfp_food_prices_pakistan_AS1;

-- Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal 50 PKR

SELECT cmname, mktname, price, date
FROM wfp_food_prices_pakistan_AS1
WHERE mktname IN ('Quetta', 'Karachi', 'Peshawar')
  AND price <= 50;

-- Query to check number of observations against each market/city in PK
  
  SELECT mktname, COUNT(mktname) from wfp_food_prices_pakistan_AS1 GROUP BY mktname;
  
  -- Show number of distinct cities
  
  SELECT count(distinct(mktname)) from wfp_food_prices_pakistan_as1;
  
  -- List down/show the names of cities in the table
  
  SELECT distinct(mktname) from wfp_food_prices_pakistan_as1;
 
 -- List down/show the names of commodities in the table
 
SELECT distinct(cmname) FROM wfp_food_prices_pakistan_as1;

-- List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.

SELECT cmname, AVG(price), mktname FROM wfp_food_prices_pakistan_as1
WHERE cmname = "Wheat flour - Retail"
GROUP BY mktname;

-- Calculate summary stats (avg price, max price) for each city separately for all cities except Karachi 
-- and sort alphabetically the city names, commodity names where commodity is Wheat (does not matter which one) 
-- with separate rows for each commodity

SELECT cmname, mktname, max(price), avg(price) FROM wfp_food_prices_pakistan_as1
WHERE mktname NOT IN ("Karachi") AND cmname LIKE "%Wheat%"
GROUP BY mktname, cmname
ORDER BY cmname;

-- Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less than 30

SELECT mktname, cmname, avg(price) AS avg_prices FROM wfp_food_prices_pakistan_as1
WHERE cmname = "Wheat - Retail" 
GROUP BY cmname, mktname
having avg_prices < 30;

-- Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 is HIGH, in between are FAIR)
SELECT mktname, cmname, price, 
	CASE
		WHEN price < 30 THEN "LOW"
        WHEN price > 250 THEN "HIGH"
        ELSE "FAIR"
	END AS Rating 
    FROM wfp_food_prices_pakistan_as1
    ORDER BY price DESC;

-- Create a query showing date, cmname, category, city, price, city_category where Logic for city category is: Karachi and Lahore are 
-- 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'

SELECT cmname, date, category, mktname, price,
	CASE
		WHEN mktname IN ("Karachi", "Lahore") THEN "Big City"
        WHEN mktname IN ("Multan", "Peshawar") THEN "Medium-sized City"
        ELSE "Small City"
	END AS city_category
FROM wfp_food_prices_pakistan_as1
ORDER BY mktname;

-- Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price is fair if less than 100, 
-- unfair if more than or equal to 100, if > 300 then 'Speculative' 

SELECT cmname, date, mktname, price,
	CASE
		WHEN price < 100 THEN "Fair"
        WHEN price >= 100 AND price < 300 THEN "Unfair"
        WHEN price > 300 THEN "Speculative"
        Else "Undefined"
	END AS price_fairness
FROM wfp_food_prices_pakistan_as1
ORDER BY price DESC;

-- Join the food prices and commodities table with a left join.

SELECT * FROM wfp_food_prices_pakistan_as1;
SELECT * FROM commodity_as1;

SELECT wfp_food_prices_pakistan_as1.cmname, wfp_food_prices_pakistan_as1.category, price, mktname, commodity_as1.category AS commodity_category
FROM wfp_food_prices_pakistan_as1
LEFT JOIN commodity_as1
ON wfp_food_prices_pakistan_as1.category = commodity_as1.category;

SELECT DISTINCT category FROM commodity_as1;
SELECT DISTINCT category FROM wfp_food_prices_pakistan_as1;
SELECT DISTINCT cmname FROM commodity_as1;
SELECT DISTINCT cmname FROM wfp_food_prices_pakistan_as1;

-- Join the food prices and commodities table with an inner join
SELECT wfp_food_prices_pakistan_as1.cmname, wfp_food_prices_pakistan_as1.category, commodity_as1.category AS commodity_category, commodity_as1.cmname
FROM wfp_food_prices_pakistan_as1
INNER JOIN commodity_as1
ON wfp_food_prices_pakistan_as1.cmname = commodity_as1.cmname;
