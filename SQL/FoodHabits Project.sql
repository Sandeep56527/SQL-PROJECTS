/*
Description: This SQL project, "Exploratory Data Analysis of Participant Preferences and Behaviors," begins by creating a dedicated 
database called "food_habits" and a detailed table named "food_details" to house the dataset. The dataset contains diverse 
information about participants, covering areas such as gender, academic performance, culinary preferences, exercise habits, 
and more. The project consists of 14 SQL queries designed to extract valuable insights from the dataset.
*/

-- Title: Savoring Insights: Analyzing Food Preferences and Lifestyle Choices
   
CREATE DATABASE food_habits;
DROP TABLE IF EXISTS food_details;
CREATE TABLE food_details (
GPA FLOAT,
Gender VARCHAR(15),
breakfast VARCHAR(25),
coffee VARCHAR(25),
comfort_food VARCHAR(300),
comfort_food_reasons VARCHAR(300),
comfort_food_reasons_coded VARCHAR (100),
how_often_cook VARCHAR (50),
cuisine_ate_growing_up VARCHAR (100),
diet_current VARCHAR(300),
diet_current_coded VARCHAR(100),
drink_preference VARCHAR(150),
eating_changes VARCHAR(400),
eating_changes_coded VARCHAR (100),
eating_out_frequency VARCHAR (150),
employment VARCHAR (50),
exercise_freq VARCHAR (50),
fav_cuisine  VARCHAR (300),
fav_cuisine_coded VARCHAR(100),
fav_food VARCHAR (300),
fav_food_childhood VARCHAR (300),
fries VARCHAR (50),
fruit_day VARCHAR(100),
descibe_healthy_meal VARCHAR (300),
describe_ideal_diet VARCHAR (300),
ideal_diet_coded VARCHAR(100),
income VARCHAR(150),
indian_food VARCHAR(100),
italian_food VARCHAR(100),
thai_food VARCHAR(100),
persian_food VARCHAR(100),
ethnic_food VARCHAR(100),
marital_status VARCHAR (50),
mother_education VARCHAR(50),
mother_profession VARCHAR(50),
father_education VARCHAR(50), 
father_profession VARCHAR(50),
parents_cook_freq VARCHAR(50),
nutritional_check_freq VARCHAR(50),
living_on_off_campus VARCHAR(50),
self_perception_weight VARCHAR(50),
soup VARCHAR(50),
sports VARCHAR(50),
type_sports VARCHAR(70),
veggies_day VARCHAR(50),
vitamin_intake VARCHAR(50),
weight_pounds INT
);

SELECT * FROM food_details;

-- 1) Retrieve the total number of male and female from the dataset.
SELECT Gender, COUNT(*) AS Total_Count
FROM food_details
GROUP BY Gender;

-- 2) Calculate the average GPA of all participants.
SELECT ROUND(AVG(GPA),2) AS Average_GPA 
FROM food_details;

-- 3) Count the number of participants for each type of "drink_preference."
SELECT drink_preference, COUNT(*) AS TotalNumber
FROM food_details
GROUP BY drink_preference;

-- 4) List the distinct cuisines participants ate while growing up.
SELECT DISTINCT cuisine_ate_growing_up
FROM food_details;

-- 5) Calculate the average weight in pounds for participants with a GPA above 3.5.
SELECT ROUND(AVG(weight_pounds),2) AS Avg_Weight
FROM food_details
WHERE GPA > 3.5 ;

-- 6) List the top 3 reasons for consuming comfort foods.
SELECT comfort_food_reasons_coded, COUNT(*) AS TotalCount
FROM food_details
GROUP BY comfort_food_reasons_coded
ORDER BY TotalCount DESC
LIMIT 3;

-- 7) Find the most common type of exercise among participants.
SELECT  type_sports, COUNT(*) AS MostPlayedTimes
FROM food_details
WHERE type_sports <> "none"
GROUP BY type_sports
ORDER BY MostPlayedTimes DESC
LIMIT 1;

-- 8) Calculate the average income for participants who prefer Italian cuisine.
SELECT * FROM food_details;
SELECT ROUND(AVG(subquery.converted_income),2) AS AvgIncome
FROM (
  SELECT CASE
    WHEN income = 'less than $15,000' THEN 15000
    WHEN income = '$15,001 to $30,000' THEN 20000
    WHEN income = '$30,001 to $50,000' THEN 40000
    WHEN income = '$50,001 to $70,000' THEN 60000
    WHEN income = '$70,001 to $100,000' THEN 90000
    ELSE 100000
  END AS converted_income
  FROM food_details
  WHERE fav_cuisine = 'Italian'
) AS subquery;

-- 9) List the distinct values of "describe_healthy_meal."
ALTER TABLE food_details RENAME COLUMN descibe_healthy_meal TO describe_healthy_meal;

SELECT 
	DISTINCT describe_healthy_meal
FROM
	food_details;

-- 10) Calculate the percentage of participants who have "exercise_freq" as "Everyday."
    SELECT
		(COUNT(*)/(SELECT COUNT(*) FROM food_details)) * 100 AS Daily_Exercise_Percentage
	FROM
		food_details
	WHERE
		exercise_freq = 'Everyday';
 
-- 11) Find the most common marital status among participants who prefer Thai food.
SELECT 
	marital_status, COUNT(marital_status) AS appeared_times
FROM 
	food_details
WHERE
	fav_cuisine = 'Thai'
GROUP BY marital_status
ORDER BY appeared_times DESC
LIMIT 1;

-- 12) Count the number of participants for each level of "exercise_freq."
SELECT 
	exercise_freq, COUNT(exercise_freq) AS Count
FROM 
	food_details
GROUP BY exercise_freq;

-- 13) Find the most common "type_sports" among participants with a GPA below 3.
SELECT 
	type_sports, COUNT(*) AS count
FROM 
	food_details
    WHERE GPA < 3
GROUP BY type_sports
ORDER BY count DESC 
LIMIT 1;

-- 14) Find the average GPA of participants who prefer "basketball" as their favorite sport.
SELECT 
	ROUND(AVG(GPA),2) AS AvgGpa
FROM
	food_details
WHERE
	type_sports = "Basketball";
    
    -- ************************************ END *********************************************** --