/*
In this project, I have demonstrated essential data analysis skills, including data cleaning, exploratory data analysis (EDA), 
and solving business questions. The project involved identifying and correcting spelling errors, organizing data alphabetically, 
and addressing inconsistencies to ensure data quality. Through EDA, I uncovered insights and trends in the dataset, and I answered 
key business-related questions to support decision-making. 
*/

-- DROP DATABASE IF EXISTS highest_paid_jobs;
-- CREATE DATABASE highest_paid_jobs;

SELECT * FROM position_salary;

# Looking at different positions and finding the most appeared position name
SELECT Position,COUNT(*) AS TotalCount
FROM position_salary
group by Position
ORDER BY TotalCount DESC; -- Most one being 'Research Analyst' followed by 'Cuda Developer'

####### Data Cleaning ######

SELECT DISTINCT Position 
FROM position_salary
ORDER BY Position;

# Updating the blank values to 'Unknown'
SELECT * FROM position_salary
WHERE Position = ''; -- Total 19 records have position as blank

SET SQL_SAFE_UPDATES = 0;

UPDATE position_salary
SET Position = 'Unknown'
WHERE Position = '';

# Let's fix the position names based on the alphabetical order
SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^A';

UPDATE position_salary
SET Position = 'Associate Lead Analyst'
WHERE Position = 'Associate Lead Analys';

UPDATE position_salary
SET Position = 'Ab Initio Developer'
WHERE Position = 'Ab initio';

UPDATE position_salary
SET Position = 'Ab Initio Developer'
WHERE Position = 'Ab intio';

UPDATE position_salary
SET Position = 'AWS CLOUD & DEVOPS ENGINEER'
WHERE Position = 'AWS CLOUD &amp; DEVOPS ENGINEER';

UPDATE position_salary
SET Position = 'Android Developer'
WHERE Position = 'ANDROID';

UPDATE position_salary
SET Position = 'Android Developer'
WHERE Position = 'andriod';

UPDATE position_salary
SET Position = 'Android Developer'
WHERE Position = 'andiriod';

UPDATE position_salary
SET Position = 'Azure virtual'
WHERE Position = 'AZURE VIRTUVAL';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^B';

UPDATE position_salary
SET Position = 'Big Data Tester/ Hadoop, Azure'
WHERE Position = 'Bigdata tester, Hadoop, Azure';

UPDATE position_salary
SET Position = 'Business Analyst'
WHERE Position = 'BUISINESS Analyst';

UPDATE position_salary
SET Position = 'Business Analyst'
WHERE Position = 'buusiness analyst';

UPDATE position_salary
SET Position = 'Business Analyst'
WHERE Position = 'Business Analysis';

UPDATE position_salary
SET Position = 'Business Analyst'
WHERE Position = 'Business analyst,data analyst';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^C';

UPDATE position_salary
SET Position = 'C+ & Linux'
WHERE Position = 'C+, Linux';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^D';

UPDATE position_salary
SET Position = 'Data Engineer'
WHERE Position = 'DATA ENGINEER';

UPDATE position_salary
SET Position = 'Data Analyst or Data Engineer'
WHERE Position = 'Data Analyst, Data Engineer,';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^D.*(Admin|admin)';

UPDATE position_salary
SET Position = 'Database Administrator'
WHERE Position = 'Database administraor';

UPDATE position_salary
SET Position = 'Database Administrator'
WHERE Position = 'Database Administra';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^D.*(Sec|Ops)';

UPDATE position_salary
SET Position = 'DevOps Eng'
WHERE Position = 'DevSecOps Engineer';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^F';

UPDATE position_salary
SET Position = 'Full Stack Web Developer'
WHERE Position = 'F u l l Stack Web Developer';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^G';

UPDATE position_salary
SET Position = 'Golang Developer'
WHERE Position = 'Golang';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^H';

UPDATE position_salary
SET Position = CASE
WHEN Position IN('HR DATA', 'HR Data Analsyt', 'HR Data Analyst BA', 'HR Data Business An', 'HR Data BA', 'HR Business Analyst', 'Hr data business analyst (BA)')
 THEN 'HR Data or Business Analyst'
ELSE Position END;

UPDATE position_salary
SET Position = 'HR Pricing resources, HealthRules'
WHERE Position = 'HRP Pricing resources, HealthRules';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^M';

UPDATE position_salary
SET Position = CASE
WHEN Position IN ('mean/mern','Meanstack Developer','Mean Stack','MernmStack','Mernstack','Meanstack')
THEN 'MEAN/MERN Stack Developer' ELSE Position END;

# Found a Position 'Muskan Parashar' which is invalid one, so categorizing this as well to Unknown
UPDATE position_salary
SET Position = 'Unknown'
WHERE Position = 'Muskan Parashar';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^P';

UPDATE position_salary
SET Position = 'Python AI-ML'
WHERE Position = 'PAYTHON AI-ML';

UPDATE position_salary
SET Position = 'Python ML'
WHERE Position = 'pythomn ML';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^R';

UPDATE position_salary
SET Position = CASE
WHEN Position IN ('Research analst','Resarch Analyst', 'Research Anlyst', 'Reasearch Analyst')
THEN 'Research Analyst' ELSE Position END;

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^S';

UPDATE position_salary
SET Position = 'Salesforce Developer'
WHERE Position = 'Salesfoce Developer';

UPDATE position_salary
SET Position = 'Snowflake'
WHERE Position = 'Snokflak';

UPDATE position_salary
SET Position = 'Salesforce'
WHERE Position = 'Slaesforce';

UPDATE position_salary
SET Position = 'Salesforce QA'
WHERE Position = 'Slaesforce QA';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^T';

UPDATE position_salary
SET Position = 'Technical Project Manager'
WHERE Position = 'Te chnic a l Pr o j e ct Mana g e r';

UPDATE position_salary
SET Position = 'Technical Project Manager'
WHERE Position = 'Te chnic a l Pr o j e ct Mana g e r';

SELECT DISTINCT Position 
FROM position_salary
WHERE Position REGEXP '^U';

UPDATE position_salary
SET Position = 'UI Developer'
WHERE Position = 'UI Develo[er';

UPDATE position_salary
SET Position = 'UI Developer'
WHERE Position = 'UI Developers';

UPDATE position_salary
SET Position = 'UI/UX Designer'
WHERE Position = 'UI/UI/UX Designer';

UPDATE position_salary
SET Position = 'UI/UX Designer'
WHERE Position = 'UI / UI/UX Designer';

UPDATE position_salary
SET Position = 'Consulting Practice Manager'
WHERE Position = '– Consulting Practice Manager'; -- All the spelling errors has been fixed now

# Creating a copy of the table and Trimming Leading or Trailing Spaces
DROP TABLE IF EXISTS position_salary_copy;
CREATE TABLE position_salary_copy AS
SELECT * FROM position_salary;
 
 SELECT * FROM position_salary_copy;
 
 # Removing Trailing commas
  SELECT Position,  TRIM(TRAILING ',' FROM Position) AS Updated_postion
  FROM position_salary_copy
  WHERE Position REGEXP ',$';
  
  UPDATE position_salary_copy
  SET Position = TRIM(TRAILING ',' FROM Position);

# Fixing those 'Position' lengths that are greater than 74 characters
SELECT Position, LENGTH(Position)
FROM position_salary_copy
WHERE LENGTH(Position) > 74;

UPDATE position_salary_copy
SET Position = 'RPA Developer and .NET Specialist'
WHERE Position = 'UiPath, Process Automate, Win Automation, Cicero, and AA (Automation Anywhere), C#.Net, VB.NET, Asp.net, Ajax, Visual Studio. Net, SQL server and SSIS, Web services, Ado.net, Big Bucket, VSS, TFS and SVN';

UPDATE position_salary_copy
SET Position = 'RPA Developer and .NET Specialist'
WHERE Position = 'C#, ASP.Net, ADO.Net, PHP, Automation Anywhere, UiPath (Trained), BluePrism (Knowledge), HTML, CSS, Microsoft .Net, SQL Server 2008, Microsoft Visio, Snagit and Lucid Chart, Visio, Jira, ServiceNow';

  
  # Removing white spaces from the 'Position' column
  UPDATE position_salary_copy
  SET Position = TRIM(Position); -- The 'Position' column has now been cleaned
  

  SELECT DISTINCT Location from
  position_salary_copy
 ORDER BY Location;
  
  UPDATE position_salary_copy
  SET Location = CASE
  WHEN Location IN('Mumbai Suburban', 'Mumbai, Maharashtra, pune - Maharashtra','Mumbai, Maharashtra - Maharashtra')
  THEN 'Mumbai' ELSE Location END;
  
UPDATE position_salary_copy
SET location = 'Ahmedabad'
WHERE location = 'Ahemdabad - Gujarat';

UPDATE position_salary_copy
SET location = 'Ayodhya'
WHERE location = 'Ayodhya - Uttar Pradesh';

UPDATE position_salary_copy
SET location = 'Cuttack'
WHERE location = 'Cuttack, Odisha - Odisha';

UPDATE position_salary_copy
SET location = 'Delhi'
WHERE location = 'Dehli - Delhi';

UPDATE position_salary_copy
SET location = 'Diva'
WHERE location = 'Diva - Maharashtra';

UPDATE position_salary_copy
SET location = 'Fazilka'
WHERE location = 'Fazilka , Punjab - Punjab';

UPDATE position_salary_copy
SET location = 'Meerut'
WHERE location = 'MEERUT - United States (USA)';

UPDATE position_salary_copy
SET location = 'Nagpur'
WHERE location = 'Nagaur';

UPDATE position_salary_copy
SET location = 'Navi Mumbai'
WHERE location = 'Navi Mumbai and pune - Maharashtra';

UPDATE position_salary_copy
SET location = 'New Delhi'
WHERE location = 'New Delhi, Delhi, NOIDA, Pune - Delhi';

UPDATE position_salary_copy
SET location = 'Noida'
WHERE location = 'nioda - Uttar Pradesh';

UPDATE position_salary_copy
SET location = 'Noida'
WHERE location = 'Noida, Delhi - Uttar Pradesh';

UPDATE position_salary_copy
SET location = 'Pune'
WHERE location = 'Pune, kolhapur - Maharashtra';

UPDATE position_salary_copy
SET location = 'Ranchi'
WHERE location = 'Ranchi - Madhya Pradesh';

UPDATE position_salary_copy
SET location = 'Rudrpur'
WHERE location = 'Rudrpur - Uttarakhand';

UPDATE position_salary_copy
SET location = 'Uttar Pradesh'
WHERE location = 'Uttar Pradesh - Uttar Pradesh';

UPDATE position_salary_copy
SET location = 'Visakhapatnam'
WHERE location = 'vishakapatnam - Andhra Pradesh';


# Changing the invalid location 'London - United Kingdom (UK)' to 'Not Mentioned'.
# Changing the invalid location 'work from home banglore - Karnataka' to 'Not Mentioned'.
  
UPDATE position_salary_copy
SET location = 'Not Mentioned'
WHERE location = 'London - United Kingdom (UK)';
 
UPDATE position_salary_copy
SET location = 'Not Mentioned'
WHERE location = 'work from home banglore - Karnataka';

UPDATE position_salary_copy
SET Location = TRIM(Location);

SELECT * FROM position_salary_copy;

#### Things to find out ####

-- 1) What is the average salary for employees with more than 10 years of experience?
SELECT AVG(Salary) AS Avg_salary
FROM position_salary_copy
WHERE `Experience (Years)` > 10; --  1494313.6688

-- 2) How many employees have a salary greater than the average salary of the entire dataset?
SELECT COUNT(*) AS Emp_count
FROM position_salary_copy
WHERE Salary > (SELECT AVG(Salary) FROM position_salary_copy); -- 1712

-- 3) Which location has the highest total salary across all employees?
SELECT location, SUM(Salary) AS TotalSalary
FROM position_salary_copy
GROUP BY location
ORDER BY TotalSalary DESC; -- New Delhi

-- 4) Which position has the highest average salary?
SELECT Position,avg(Salary) as Avg_Sal
 FROM position_salary_copy
 GROUP BY Position 
 ORDER BY Avg_Sal DESC
 LIMIT 1; -- System Engineer
 
 -- 5) Find the total experience of employees grouped by their education.
 SELECT Education, SUM(`Experience (Years)`) AS Tot_Exp
 FROM position_salary_copy
 GROUP BY Education
 ORDER BY Tot_Exp DESC;
 
  -- 6) Which education level has the highest average salary?
  SELECT Education, AVG(Salary) AS Avg_Sal
  FROM position_salary_copy
  GROUP BY Education
  ORDER BY Avg_Sal DESC
  LIMIT 1;
  
  -- 7) Identify the top 5 positions with the highest salaries.
  SELECT Position,
		 Salary
  FROM (
		SELECT Position,
			   Salary,
               RANK() OVER(ORDER BY Salary DESC) AS Rnk
		FROM position_salary_copy) AS Ranked_salaries
  WHERE Rnk <= 5
  ORDER BY Salary DESC;
  
  -- 8) What is the average salary for each location, and which location has the highest average?
  SELECT Location, AVG(Salary) AS Avg_Sal
  FROM position_salary_copy
  GROUP BY Location
  ORDER BY Avg_Sal DESC; -- Uttar Pradesh
  
  -- 9) Which positions have the most number of employees?
SELECT Position,COUNT(*) AS Total_Count
FROM position_salary_copy
GROUP BY Position
ORDER BY Total_Count DESC
LIMIT 1; -- Research Analyst

-- 10) What is the minimum salary for each position?
SELECT Position, MIN(Salary) AS Minimum_Sal
FROM position_salary_copy
GROUP BY Position;

-- 11) Which positions are the most common for employees with more than 15 years of experience?
SELECT Position, COUNT(*) AS Tot_Count
FROM position_salary_copy
WHERE `Experience (Years)` > 15
GROUP BY Position
ORDER BY Tot_Count DESC; -- Research Analyst, Cuda Developer, C++

-- 12) How many employees with a B.Tech/B.E. degree have a salary greater than 1.5 million?
SELECT COUNT(*) AS Emp_Count
FROM position_salary_copy
WHERE `Education` = 'B.Tech/B.E.'
AND Salary > 1500000; -- 626

-- 13) How many employees have worked for more than 20 years in their respective positions?
SELECT Position, COUNT(*) AS Emp_Count
FROM position_salary_copy
WHERE `Experience (Years)` > 20
GROUP BY Position
ORDER BY  Emp_Count DESC;

-- 14) Find the top 3 positions with the highest average salary for employees with a B.Tech/B.E. degree.
WITH Avg_finder AS
	(SELECT Position,
	AVG(Salary) AS Avg_Sal
	FROM position_salary_copy
	WHERE Education = 'B.Tech/B.E.'
	GROUP BY Position)
,Avg_filter AS
	(SELECT *,
	RANK() OVER(ORDER BY Avg_Sal DESC) AS Rnk
	FROM Avg_finder)
SELECT * FROM
Avg_filter
WHERE Rnk <= 3;

-- 15) What is the average salary for each education level?
SELECT Education, AVG(Salary) as Avg_Sal
FROM position_salary_copy
GROUP BY Education
ORDER BY Avg_Sal DESC;

-- 16) Find the highest salary for employees located in New Delhi.
SELECT Salary
FROM position_salary_copy
WHERE Salary = 
	(SELECT MAX(Salary) 
    FROM position_salary_copy 
    WHERE Location = 'New Delhi'); -- 2499925
    
-- 17) How many employees have a salary between 1 million and 2 million?
SELECT COUNT(*) AS Tot_Count
FROM position_salary_copy
WHERE Salary BETWEEN 1000000 AND 2000000;

-- 18) Which position has the highest number of employees with a BCA degree?
SELECT Position, COUNT(*) AS Tot_count
FROM position_salary_copy
WHERE Education = 'BCA'
GROUP BY Position
ORDER BY Tot_count DESC; -- Research Analyst

-- 19) Find the positions with the largest salary gap (difference between the highest and lowest salary).
SELECT Position,
	(Max_Salary - Min_Salary) AS Salary_Diff
FROM
	(SELECT 
		Position,
	MAX(Salary) OVER(PARTITION BY Position) AS Max_Salary,
	MIN(Salary) OVER(PARTITION BY Position) AS Min_Salary
	 FROM position_salary_copy) AS sq
GROUP BY Position, Max_Salary, Min_Salary
ORDER BY Salary_Diff DESC;

-- 20) How many positions are there with employees who have a salary greater than 2 million?
SELECT COUNT(Position) AS Tot_Count
FROM position_salary_copy
WHERE Salary > 2000000; -- 841

-- 21) What is the total salary paid in each location for employees with over 10 years of experience?
SELECT Location, SUM(Salary) AS Total_salary
FROM position_salary_copy
WHERE `Experience (Years)` > 10
GROUP BY Location
ORDER BY  Total_salary DESC;

