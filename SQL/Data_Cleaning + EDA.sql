####################
  # Data Cleaning #
#####################

-- Take a look at the data first
SELECT * FROM layoffs;

-- Creating a copy of the raw table
CREATE TABLE layoffs_copy AS
SELECT * FROM layoffs;

SELECT * FROM layoffs_copy;

-- ------------------------------------------
	-- Check and Remove Duplicates if any
-- ------------------------------------------

-- Method 1
SELECT 
	company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions,
    COUNT(*)
FROM
	layoffs_copy
GROUP BY 
	company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions
HAVING COUNT(*) > 1;

-- Method 2
WITH dup_records AS
	(SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,
		funds_raised_millions ORDER BY company) AS row_num
	FROM layoffs_copy)
SELECT *
FROM dup_records
WHERE row_num > 1;

-- Deleting duplicate Records
CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_copy2 
WITH dup_records AS
(SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions ORDER BY company) AS row_num
FROM layoffs_copy)
SELECT *
FROM dup_records;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_copy2
WHERE row_num > 1;

SELECT * FROM layoffs_copy2; -- Duplicates are now removed

-- -------------------------------
	-- Standardizing Data
-- -------------------------------
SELECT company, TRIM(company) FROM layoffs_copy2;

UPDATE layoffs_copy2 SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_copy2 ORDER BY industry;

SELECT industry, count(*) FROM layoffs_copy2 WHERE industry REGEXP 'Crypto' GROUP BY industry;

-- Text issue fix 1
UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry REGEXP 'CryptoCurrency|Crypto Currency';

-- Text issue fix 2
UPDATE layoffs_copy2
SET country = 'United States'
WHERE country LIKE '%.%';

-- Changing `Date` from 'Text' to 'Date' format
SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT CAST(`date` AS DATE) FROM layoffs_copy2;

ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE; 

-- Looking for Null values
SELECT COUNT(*)
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_copy2
WHERE industry IS NULL
OR industry ='';

SELECT * FROM layoffs_copy2
WHERE company IN ('Airbnb','Bally''s Interactive','Carvana','Juul');

UPDATE layoffs_copy2 
SET industry = null
WHERE industry = ''; 

SELECT l1.industry, l2.industry,
COALESCE(l2.industry,l1.industry) AS final
FROM layoffs_copy2 l1
JOIN layoffs_copy2 l2
ON l1.company = l2.company
WHERE (l1.industry IS NULL OR l1.industry = '')
AND l2.industry IS NOT NULL;

UPDATE layoffs_copy2 l1
JOIN layoffs_copy2 l2
ON l1.company = l2.company
SET l1.industry = COALESCE(l2.industry,l1.industry)
WHERE l2.industry IS NOT NULL;

SELECT company,industry,COUNT(*)
FROM layoffs_copy2
WHERE company IN ('Airbnb','Bally''s Interactive','Carvana','Juul')
GROUP BY company,industry
ORDER BY COUNT(*) DESC;

# Getting rid of the null values,because imputation is not possible due to lack of required info's

DELETE FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; -- Now the output is 0

ALTER TABLE layoffs_copy2 DROP COLUMN row_num; 

SELECT * FROM layoffs_copy2;

#######################################
  # EDA : Exploratory Data Analysis #
#######################################

 SELECT * FROM layoffs_copy2;
 
 
 SELECT MAX(total_laid_off), MAX(percentage_laid_off)
 FROM layoffs_copy2;
 
 
SELECT * FROM
layoffs_copy2 WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; # The company 'Katerra' lost the highest number of employees which is 2434 
 
 
SELECT * FROM
layoffs_copy2 WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY company
ORDER BY Total_laid_off DESC; 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_copy2; #'2020-03-11' TO '2023-03-06'

SELECT industry, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY industry
ORDER BY Total_laid_off DESC; # Consumer & Retail industries hits the most

SELECT Country, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY Country
ORDER BY Total_laid_off DESC;

SELECT year(`date`) as `Year`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY `Year`
ORDER BY `Year` DESC;

SELECT Stage, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY Stage
ORDER BY Total_laid_off DESC;

SELECT company, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_copy2
GROUP BY company
ORDER BY Total_laid_off DESC; 

SELECT 
	SUBSTRING(`date`,1,7) AS `Month`,
	SUM(total_laid_off)
FROM
	layoffs_copy2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month`;

WITH rolling_total AS
		(SELECT SUBSTRING(`date`,1,7) AS `Month`,
			SUM(total_laid_off) AS Sum_total_laid_off
		FROM layoffs_copy2
		WHERE SUBSTRING(`date`,1,7) IS NOT NULL
		GROUP BY `Month`
		ORDER BY `Month`)
SELECT 
	`Month`, 
    Sum_total_laid_off,
    SUM(Sum_total_laid_off) OVER(ORDER BY `Month`) AS Rolling_total
FROM rolling_total;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY company,YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

SELECT * FROM
(WITH year_total AS(
	SELECT company,
		YEAR(`date`) AS Year_Of_Date,
		SUM(total_laid_off) AS total_lf
	FROM layoffs_copy2
	GROUP BY company,YEAR(`date`)
	ORDER BY SUM(total_laid_off) DESC)
SELECT *,
DENSE_RANK() OVER(PARTITION BY Year_Of_Date ORDER BY total_lf DESC) AS Ranking
FROM year_total
WHERE total_lf IS NOT NULL
AND Year_Of_Date IS NOT NULL
ORDER BY Ranking)a
WHERE Ranking <= 5
ORDER BY Year_Of_Date;








