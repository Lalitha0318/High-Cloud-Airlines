select count(*) from maindata;

#  --KPI 1 No of Airline,No of Country,City,State,Operating_Region,Cover_Distance,Total_Passengers and No_OF_Aircraft

SELECT COUNT(`%Airline ID`) AS No_Of_Airlines
FROM maindata;

select count('%Aircraft Type ID') as No_OF_Aircraft
from maindata;

SELECT 
COUNT(DISTINCT(`Destination Country`)) AS No_Of_Country,
COUNT(DISTINCT(`Destination State`)) AS No_of_State,
COUNT(DISTINCT(`Destination City`)) AS No_of_City,
CONCAT(ROUND(SUM(`# Transported Passengers`)/1000000,2),'M') AS Total_Passengers,
CONCAT(ROUND(SUM(Distance)/1000000,2),'M Km') AS Cover_Distance,
COUNT(DISTINCT(`%Region Code`)) AS Total_Operating_Region
FROM maindata;


# --KPI 2 calcuate the following fields from the Year Month (#) Day fields ( First Create a Date Field from Year , Month , Day fields)

CREATE VIEW Date_field AS
SELECT 
STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Date_field,
`From - To City`,
`# Transported Passengers`,
`# Available Seats`,
`Unique Carrier`
FROM maindata;


CREATE VIEW KPI1 AS
SELECT 
Date_field,
YEAR(Date_field) AS Year_No,
MONTH(Date_field) AS Month_Number,
MONTHNAME(Date_field) AS Month_Name,
DAY(Date_field) AS Day_No,
DAYNAME(Date_field) AS Day_name,
CONCAT("Q",QUARTER(Date_field)) AS Quarter_No,
WEEKOFYEAR(Date_field) AS Week_Of_Year,
CONCAT(YEAR(Date_field),'-',MONTHNAME(Date_field)) AS YearMonth,

CASE
WHEN QUARTER(Date_field)=1 THEN "FQ-4"
WHEN QUARTER(Date_field)=2 THEN "FQ-1"
WHEN QUARTER(Date_field)=3 THEN "FQ-2"
WHEN QUARTER(Date_field)=4 THEN "FQ-3"
END AS Financial_Quarter,

CASE
WHEN MONTH(Date_field)=4 THEN "FM-1"
WHEN MONTH(Date_field)=5 THEN "FM-2"
WHEN MONTH(Date_field)=6 THEN "FM-3"
WHEN MONTH(Date_field)=7 THEN "FM-4"
WHEN MONTH(Date_field)=8 THEN "FM-5"
WHEN MONTH(Date_field)=9 THEN "FM-6"
WHEN MONTH(Date_field)=10 THEN "FM-7"
WHEN MONTH(Date_field)=11 THEN "FM-8"
WHEN MONTH(Date_field)=12 THEN "FM-9"
WHEN MONTH(Date_field)=1 THEN "FM-10"
WHEN MONTH(Date_field)=2 THEN "FM-11"
WHEN MONTH(Date_field)=3 THEN "FM-12"
END AS Financial_Month,

CASE
WHEN DAYNAME(Date_field) IN ('Saturday','Sunday') THEN 'Weekend'
ELSE 'Weekday'
END AS Weekday_Weekend,

`From - To City`,
`# Transported Passengers`,
`# Available Seats`,
`Unique Carrier`

FROM Date_field;


# --KPI 3 Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)

SELECT 
Year_No,
CONCAT(
ROUND(
SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100
,2),'%') AS Load_factor
FROM kpi1
GROUP BY Year_No
ORDER BY 
SUM(`# Transported Passengers`) / SUM(`# Available Seats`) DESC;


SELECT 
Quarter_No,
CONCAT(
ROUND(
SUM(`# Transported Passengers`) / 
SUM(`# Available Seats`) * 100
,2),'%') AS Load_factor
FROM kpi1
GROUP BY Quarter_No
ORDER BY 
SUM(`# Transported Passengers`) / 
SUM(`# Available Seats`) DESC;

SELECT 
Month_Name,
CONCAT(
ROUND(
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) * 100
,2),'%') AS Load_factor
FROM kpi1
GROUP BY Month_Name
ORDER BY 
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) DESC;


#-- KPI 4 Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

SELECT 
`Unique Carrier`,
CONCAT(
ROUND(
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) * 100
,2),'%') AS Load_factor
FROM maindata
GROUP BY `Unique Carrier`
ORDER BY 
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) DESC;

# --KPI 5 Identify Top 10 Carrier Names based passengers preference 

SELECT 
`Unique Carrier`,
SUM(`# Transported Passengers`) AS Passengers
FROM maindata
GROUP BY `Unique Carrier`
ORDER BY Passengers DESC
LIMIT 10;


# --KPI 6 Display top Routes ( from-to City) based on Number of Flights 

SELECT 
`From - To City`,
COUNT(`%Airline ID`) AS NO_OF_Flights
FROM maindata
GROUP BY `From - To City`
ORDER BY NO_OF_Flights DESC
LIMIT 10;


# --KPI 7 Identify the how much load factor is occupied on Weekend vs Weekdays.

SELECT 
Weekday_Weekend,
CONCAT(
ROUND(
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) * 100
,2),'%') AS Load_factor
FROM kpi1
GROUP BY Weekday_Weekend
ORDER BY 
SUM(`# Transported Passengers`) /
SUM(`# Available Seats`) DESC;


# --KPI 8 Identify number of flights based on Distance group

SELECT 
Distance,
COUNT(*) AS No_Of_Flights
FROM maindata
GROUP BY Distance
ORDER BY No_Of_Flights DESC
LIMIT 10;


# --KPI 9 Available Seats by Flight Type

SHOW COLUMNS FROM maindata;
SELECT 
`%Datasource ID`,
SUM(`# Available Seats`) AS Available_Seat
FROM maindata
GROUP BY `%Datasource ID`
ORDER BY Available_Seat DESC;


 # --KPI 10 Carrier Name wise Cover Distanse
 
SELECT 
`Unique Carrier`,
CONCAT(
ROUND(SUM(Distance)/1000000,2),
'M Km'
) AS Cover_Distance
FROM maindata
GROUP BY `Unique Carrier`
ORDER BY SUM(Distance) DESC
LIMIT 5;


# --KPI 11 Use the filter to provide a search capability to find the flights between Source Country, Source State, Source City to Destination Country ,
-- Destination State, Destination City

select `Origin Country`,`Destination Country`,`Origin State`,`Destination State`,`Origin City`,`Destination City`
from maindata;


# --KPI 12 Transported Passengers by Operating Region

SELECT 
`%Region Code`,
SUM(`# Transported Passengers`) AS Transported_Passenger
FROM maindata
GROUP BY `%Region Code`
ORDER BY Transported_Passenger DESC;

