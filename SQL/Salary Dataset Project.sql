/*
Analyzing Salary Dataset: Investigating Salary Patterns and Employment Dynamics Across Industries.
-------------------------------------------------------------------------------------------------
*/
CREATE DATABASE race_and_salary;

USE race_and_salary;

DROP TABLE IF EXISTS salary_dataset;
CREATE TABLE salary_dataset
(
Id INT PRIMARY KEY auto_increment,
Age INT NULL,
Gender VARCHAR(15),
Education_Level VARCHAR(35),
Job_Title VARCHAR(50),
    Year_of_Experience FLOAT(4) NULL,
    Salary INT NULL,
    Country VARCHAR(35),
    Race VARCHAR(35)
);

SELECT * FROM salary_dataset;

-- 1) This query calculates the total salary for each gender in the 'salary_dataset' table. 
SELECT Gender,
SUM(Salary) AS Total_salary
FROM salary_dataset
GROUP BY Gender;

-- 2) Exploring Salary Trends for 'Analyst' Job Titles
SELECT 
Job_Title,
Country,
ROUND(AVG(Salary),1) as Avg_Salary
FROM
salary_dataset
WHERE 	
Job_Title LIKE  '%Analyst'
GROUP BY Job_Title,Country
ORDER BY Avg_Salary DESC;

-- 3) Average Salary by Education Level:
SELECT Education_Level, 
ROUND(AVG(Salary),2) AS Avg_Salary
FROM salary_dataset
GROUP BY Education_Level
ORDER BY Avg_Salary DESC;

-- 4) Salary Distribution By Country
SELECT Country, COUNT(*) AS Number_of_Employees, 
MIN(Salary) AS Min_Salary, MAX(Salary) AS Max_Salary, 
ROUND(AVG(Salary),2) AS Avg_Salary
FROM salary_dataset
GROUP BY Country
ORDER BY Max_Salary DESC;

-- 5) Top Job Titles with Highest Salaries:
SELECT Job_Title, ROUND(AVG(Salary),2) AS Avg_Salary 
FROM salary_dataset
GROUP BY Job_Title
ORDER BY Avg_Salary DESC
LIMIT 5;

-- 6) Years of Experience vs. Average Salary:
SELECT Year_of_Experience, ROUND(AVG(Salary),2) AS Avg_Salary
FROM salary_dataset
GROUP BY Year_of_Experience
ORDER BY Year_of_Experience DESC;

-- 7) Salary Statistics by Gender and Race:
SELECT Gender, Race, COUNT(*) AS Number_of_Employees, 
MIN(Salary) AS Min_Salary, 
MAX(Salary) AS Max_Salary, 
ROUND(AVG(Salary),2) AS Avg_Salary 
FROM salary_dataset
GROUP BY Gender, Race
ORDER BY Max_Salary DESC;

-- 8) Employees with the Highest Salary in Each Job Title:
SELECT Job_Title, MAX(Salary) AS Max_Salary
FROM salary_dataset
GROUP BY Job_Title;

