use vijay_kumar_pal
TABLE1

SELECT * from Table1
SELECT state_code,landmark from table1
where landmark ='airport road, amritsar'

Table1 Queries
-- 1. Retrieve properties with balconies, sorted by the number of bedrooms in descending order.
SELECT * FROM Table1 WHERE Balcony > 0 ORDER BY beds DESC;

-- 2. Find the top 5 cities with the highest average number of bedrooms per property.
SELECT TOP 5 City, AVG(beds) AS AvgBedrooms FROM Table1 GROUP BY City ORDER BY AvgBedrooms DESC;

-- 3. Count the number of properties in each city.
SELECT City, COUNT(*) AS PropertyCount FROM Table1 GROUP BY City;

-- 4. Retrieve all properties with at least 3 bedrooms and 2 bathrooms.
SELECT * FROM Table1 WHERE beds >= 3 AND baths >= 2;

-- 5. Find properties in a specific state with a certain landmark.
SELECT * FROM Table1 WHERE State_code = 'Punjab' AND Landmark= 'airport road, amritsar';


TABLE2
1- Calculate the average price per square foot for properties built before 2010
SELECT * from Table2

SELECT AVG(price_per_sqft) AS avg_price_per_sq_ft
FROM Table2
WHERE year_built < 2010;

2- Find the total number of properties on each floor.
SELECT floor, COUNT(*) AS Flr
FROM table2
GROUP BY floor;

3.Retrieve properties with a carpet area greater than 1000 square feet and a status of 'Under Construction'.

SELECT *
FROM table2
WHERE carpetarea > 1000 AND status = 'Under Construction';

4. Calculate the Average Price Per Square Foot for Each Transaction Type
SELECT transaction_type, AVG(price_per_sqft) AS avg_price_per_sq_ft
FROM table2
GROUP BY transaction_type;

5. Find the Properties with the Highest Price Per Square Foot, Sorted in Descending Order
SELECT *, (price_per_sqft) AS price_per_sq_ft
FROM table2
ORDER BY price_per_sq_ft DESC;



TABLE3
select * from table3
1. Retrieve All Properties with a Furnished Status of 'Fully Furnished' and a Facing Direction of 'East'
SELECT *
FROM table3
WHERE furnished_status = 'Fully Furnished' AND facing = 'East';

SELECT *
FROM table3
WHERE furnished_status = 'Semi-Furnished' AND facing = 'East';

2. Calculate the Average Booking Amount for Properties With and Without Car Parking
SELECT car_parking, 
 AVG(CONVERT(decimal(18, 2), booking_amount)) AS avg_booking_amount
FROM table3
GROUP BY car_parking;



3. Find the Total Price of Properties with Different Types of Ownership
SELECT type_of_ownership, 
  SUM(buy_total_price) AS buy_total_price
FROM table3
GROUP BY type_of_ownership;

4. Retrieve Properties with a Booking Amount Greater Than 50000 and a Furnished Status of 'Semi Furnished'
SELECT *
FROM table3
WHERE booking_amount > 50000 AND furnished_status = 'Semi Furnished';

5. Find the Property with the Highest Booking Amount
SELECT TOP 1 *
FROM table3
ORDER BY booking_amount DESC;



Join SQL Queries  using all 3 tables
select * from table1,
select * from table2;

--1. Retrieve properties from table1 that have a higher price per square foot than the average price per square foot in table2.
SELECT t1.*
FROM table1 t1 join table2 t2
ON t1.table2key=t2.Sno
WHERE (price_per_sqft) > (
    SELECT AVG(price_per_sqft)
    FROM table2);

--2. Find the properties in table1 that are located in cities where the average price per square foot in 
--table2 is higher than the overall average price per square foot.
WITH OverallAvg AS (
    SELECT AVG(price_per_sqft) AS overall_avg_price_per_sqft
    FROM table2
),
CityAvg AS (
    SELECT city, AVG(price_per_sqft) AS avg_price_per_sqft
    FROM table2 join table1 
	ON table1.table2key=table2.Sno
    GROUP BY city
)
SELECT t1.*
FROM table1 t1
INNER JOIN CityAvg c ON t1.city = c.city
CROSS JOIN OverallAvg o
WHERE c.avg_price_per_sqft > o.overall_avg_price_per_sqft;


3. Retrieve properties from table1 with a certain landmark that have a lower price per square foot than the average price per square foot for properties with the same landmark in table2.
WITH LandmarkAvg AS (
    SELECT t1.landmark, AVG(t2.price_per_sqft) AS avg_price_per_sqft
    FROM table2 t2
    INNER JOIN table1 t1 ON t2.sno = t1.table2key
    WHERE t1.landmark = 'airport road, amritsar'  
    GROUP BY t1.landmark
)
SELECT t1.*
FROM table1 t1
join table2 t2
ON t2.sno = t1.table2key
INNER JOIN LandmarkAvg la ON t1.landmark = la.landmark
WHERE t1.landmark = 'airport road, amritsar'
AND t2.price_per_sqft < la.avg_price_per_sqft;


4. Retrieve properties from table2 with a price per square foot higher than the average booking amount in table3.
SELECT t2.*
FROM table2 t2
WHERE (t2.price / t2.square_footage) > (
    SELECT AVG(booking_amount)
    FROM table3
);

5. Count the number of properties in table2 with more bedrooms than the maximum number of bedrooms in table3.
SELECT COUNT(*)
FROM table2 t2
WHERE t2.bedrooms > (
    SELECT MAX(bedrooms)
    FROM table3
);

6. Find the cities where the average booking amount in table3 is higher than the overall average booking amount, and retrieve properties from table1 located in those cities.
WITH OverallAvg AS (
    SELECT AVG(booking_amount) AS overall_avg_booking_amount
    FROM table3
),
CityAvg AS (
    SELECT city, AVG(booking_amount) AS avg_booking_amount
    FROM table3 t3 join table1 t1 ON t3.s_no = t1.table2key
    GROUP BY city
)
SELECT t1.*
FROM table1 t1
INNER JOIN CityAvg c ON t1.city = c.city
CROSS JOIN OverallAvg o
WHERE c.avg_booking_amountt > o.overall_avg_booking_amount;

7. Retrieve properties from table1 with a furnished status of 'Unfurnished' and a facing direction that does not exist in table3.
SELECT t1.*
FROM table1 t1
WHERE t1.furnished_status = 'Unfurnished'
AND t1.facing_direction NOT IN (
    SELECT DISTINCT facing_direction
    FROM table3
);
