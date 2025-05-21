SELECT * FROM airline_data
LIMIT 100;

-- 1) Retrieve the top 10 nationalities with the highest average passenger ages.
WITH avg_passenger_age AS (
  SELECT Nationality, AVG(Age) AS avgAge
  FROM airline_data
  GROUP BY Nationality
)
SELECT Nationality
FROM avg_passenger_age
ORDER BY avgAge DESC
LIMIT 10;

-- 2) Find the total number of flights for each departure airport.
SELECT Airport_Name, COUNT(*) AS Total_Flights
FROM airline_data
GROUP BY Airport_Name
ORDER BY Total_Flights DESC;

-- 3) Calculate the average age of passengers for each airport country code.
SELECT Airport_Country_Code, AVG(Age) AS AvgAge
FROM airline_data
GROUP BY Airport_Country_Code
ORDER BY AvgAge DESC;

-- 4) List the passengers who have taken more than one flight in the dataset.
SELECT CONCAT(First_Name, ' ' , Last_Name) AS Full_Name
FROM airline_data
GROUP BY Full_Name
HAVING COUNT(*) > 1;

-- 5) Find the passengers who have never experienced a flight delay.
SELECT CONCAT(First_Name, ' ' ,Last_Name) AS Full_Name
FROM airline_data
WHERE Flight_Status = 'On Time';

-- 6) Calculate the percentage of flights that were delayed.
SELECT
	(SUM(CASE WHEN Flight_Status = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Delayed_Percentage
FROM
	airline_data;
    
-- 7) Identify the pilot(s) with the most flights in the dataset.
SELECT Pilot_Name
FROM airline_data
GROUP BY Pilot_Name
HAVING COUNT(*) > 1;

-- 8) Retrieve the passengers who have the same first name and last name as another passenger.
SELECT First_Name, Last_Name
FROM airline_data
GROUP BY First_Name, Last_Name
HAVING COUNT(*) > 1;

-- 9) Find the passengers who have traveled to the most countries based on airport country code.
WITH PassengersCountries AS (
    SELECT
        CONCAT(First_Name, ' ', Last_Name) AS Passenger_Name,
        COUNT(DISTINCT Airport_Country_Code) AS Countries_Count
    FROM
        airline_data
    GROUP BY
        CONCAT(First_Name, ' ', Last_Name)
)
SELECT
    Passenger_Name
FROM
    PassengersCountries
WHERE
    Countries_Count = (
        SELECT
            MAX(Countries_Count)
        FROM
            PassengersCountries
    );

-- 10) Identify the airport with the highest number of cancellations.
WITH High_Cancellation AS (
SELECT Airport_Name, COUNT(*) AS Times
FROM airline_data
WHERE Flight_Status = 'Cancelled'
GROUP BY Airport_Name
ORDER BY Times DESC
LIMIT 1
)
SELECT Airport_Name
FROM High_Cancellation;

-- 11) Calculate the average age of male and female passengers for each airport country code.
SELECT Airport_Country_Code, Gender, AVG(Age) AS AvgAge
FROM Airline_data
GROUP BY Gender, Airport_Country_Code
ORDER BY Airport_Country_Code;

-- 12) List the passengers who have taken flights on consecutive days.
WITH FlightDates AS (
    SELECT
        CONCAT(First_Name, ' ', Last_Name) AS Passenger_Name,
        Departure_Date,
        LAG(Departure_Date) OVER (PARTITION BY CONCAT(First_Name, ' ', Last_Name) ORDER BY Departure_Date) AS Previous_Departure_Date
    FROM
        airline_data
)
SELECT DISTINCT Passenger_Name
FROM FlightDates
WHERE Departure_Date - Previous_Departure_Date = 1;

-- 13) Calculate the percentage of flights that were on time for each airport country code.
SELECT * FROM airline_data
LIMIT 100;
SELECT 
	Airport_Country_Code,
    (ROUND(SUM(CASE WHEN Flight_Status = 'On TIme' THEN 1 ELSE 0 END) *100 / COUNT(*),2)) AS OnTimePercentage
FROM airline_data
GROUP BY Airport_Country_Code
ORDER BY OnTimePercentage DESC;

-- 14) Find the airport country code with the highest percentage of delayed flights.
SELECT 
	Airport_Country_Code,
    (ROUND(SUM(CASE WHEN Flight_Status = 'Delayed' THEN 1 ELSE 0 END) *100 / COUNT(*),2)) AS DelayTimePercentage
FROM airline_data
GROUP BY Airport_Country_Code
ORDER BY DelayTimePercentage DESC
LIMIT 1;

-- 15) List the passengers who have taken flights with different pilots with the same last name.
WITH PilotLastNames AS (
    SELECT
        Pilot_Name,
        SUBSTRING_INDEX(Pilot_Name, ' ', -1) AS Pilot_Last_Name
    FROM
        airline_data
),
PassengerPilots AS (
    SELECT
        CONCAT(First_Name, ' ', Last_Name) AS Passenger_Name,
        SUBSTRING_INDEX(Pilot_Name, ' ', -1) AS Pilot_Last_Name
    FROM
        airline_data
        )
SELECT DISTINCT Passenger_Name
FROM PassengerPilots
WHERE Pilot_Last_Name IN (
    SELECT DISTINCT Pilot_Last_Name
    FROM PilotLastNames
    GROUP BY Pilot_Last_Name
    HAVING COUNT(DISTINCT Pilot_Name) > 1
);
-- 16) Count the number of passengers who have a Flight Status of 'Cancelled'.
SELECT 
	COUNT(*) AS Total_Passenger_Count
FROM 
	airline_data
WHERE	
	Flight_Status = "On Time";

-- 17) List the unique Nationalities in the dataset.
SELECT DISTINCT Nationality
FROM
	airline_data;
    
-- 18) Calculate the average age of passengers for each continent.
SELECT 
	Continents,
	AVG(Age) AS Avg_Age
FROM 
	airline_data
GROUP BY 
	Continents;

-- 19) Retrieve the details of passengers who departed after '2022-09-01'.
SELECT
	Passenger_ID,
    CONCAT(First_Name, ' ',Last_Name) AS Full_Name,
    Gender,
    Age,
    Nationality
FROM 
	airline_data
WHERE 
	Departure_Date > '2022-09-01';
    
-- 20) Find the top 5 oldest passengers.
WITH old_aged_passenger AS (
SELECT DISTINCT
	CONCAT(First_Name, ' ',Last_Name) AS Full_Name,
    Age
FROM
	airline_data
ORDER BY Age DESC
)
SELECT 
	Full_Name
FROM
	old_aged_passenger
    LIMIT 5;

-- 21) Count the number of passengers for each country in North America.
SELECT 
	Country_Name, COUNT(*) AS Total_Passengers
FROM 
	airline_data
WHERE 
	Continents = 'North America'
GROUP BY 
	Country_Name;

-- 22) Update the Airport Name to 'Unknown' for passengers with a Flight Status of 'Cancelled'.
UPDATE airline_data SET Airport_Name = 'Unknown'
WHERE Flight_Status = 'Cancelled';

-- 23) Calculate the percentage of male and female passengers in the dataset.
SELECT
  Gender,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM airline_data),2) AS Percentage
FROM
  airline_data
GROUP BY
  Gender;
 -- 24) Delete the record for the passenger with Passenger ID '8IPFPE'.
DELETE FROM airline_data WHERE
 Passenger_ID ='8IPFPE';

 -- 25) Calculate the total number of passengers for each departure airport.
SELECT Airport_Name, COUNT(*) AS Passenger_Count
FROM airline_data
GROUP BY Airport_Name
ORDER BY Passenger_Count DESC;

-- 26) Rank passengers based on their age in ascending order.
 SELECT 
	CONCAT(First_Name, ' ', Last_Name) AS Full_Name,
    Age,
    DENSE_RANK() OVER (ORDER BY Age) AS Passenger_rank
FROM
	airline_data;
    
    -- 27) Find the countries with at least one passenger aged 80 or above.
         SELECT * FROM airline_data;
SELECT
	Nationality,
    COUNT(*) AS Total
FROM
	airline_data
 WHERE Age >= 80
GROUP BY
		Nationality
ORDER BY Total DESC;
