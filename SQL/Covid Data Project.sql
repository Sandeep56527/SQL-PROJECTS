/*
This dataset contains data for Covid-19 vaccinations, tests, and various other metrics for different countries. 
It can be used to analyze and compare Covid-19 trends across countries, particularly focusing on the top infected countries 
like Brazil, USA, India, France, and Germany. 
By querying this table, valuable insights can be gained into the effectiveness of vaccination campaigns, testing strategies, 
and the impact of various factors such as population demographics, healthcare infrastructure, and economic indicators 
on the Covid-19 situation in these countries.
*/

-- COVID-19 Vaccinations and Metrics by Country: Analyzing Top Infected Nations

CREATE DATABASE Covid_Data;
USE Covid_Data;

DROP TABLE IF EXISTS CovidDeaths;
CREATE TABLE CovidDeaths (
iso_code VARCHAR(15),
continent VARCHAR(50),
location VARCHAR(150),
date VARCHAR(150),
population INT,
total_cases INT,
new_cases INT,
new_cases_smoothed FLOAT,
total_deaths INT,
new_deaths INT,
new_deaths_smoothed FLOAT,
total_cases_per_million FLOAT,
new_cases_per_million FLOAT,
new_cases_smoothed_per_million FLOAT,
total_deaths_per_million FLOAT,
new_deaths_per_million FLOAT,
new_deaths_smoothed_per_million FLOAT,
reproduction_rate FLOAT,
icu_patients INT,
icu_patients_per_million FLOAT,
hosp_patients INT,
hosp_patients_per_million FLOAT,
weekly_icu_admissions INT,
weekly_icu_admissions_per_million FLOAT,
weekly_hosp_admissions INT,
weekly_hosp_admissions_per_million FLOAT
);
UPDATE coviddeaths
SET date = STR_TO_DATE(date, '%d-%m-%Y');


DROP TABLE IF EXISTS CovidVaccinations;
CREATE TABLE CovidVaccinations (
iso_code VARCHAR(15),
continent VARCHAR(50),
location VARCHAR(150),
date VARCHAR(150),
new_tests INT,
total_tests_per_thousand FLOAT,
new_tests_per_thousand FLOAT,
new_tests_smoothed INT,
new_tests_smoothed_per_thousand FLOAT,
positive_rate FLOAT,
tests_per_case FLOAT,
tests_units VARCHAR(50),
total_vaccinations BIGINT,
people_vaccinated INT,
people_fully_vaccinated INT,
total_boosters INT,
new_vaccinations INT,
new_vaccinations_smoothed INT,
total_vaccinations_per_hundred FLOAT,
people_vaccinated_per_hundred FLOAT,
people_fully_vaccinated_per_hundred FLOAT,
total_boosters_per_hundred FLOAT,
new_vaccinations_smoothed_per_million INT,
new_people_vaccinated_smoothed INT,
new_people_vaccinated_smoothed_per_hundred FLOAT,
stringency_index FLOAT,
population_density FLOAT,
median_age FLOAT,
aged_65_older FLOAT,
aged_70_older FLOAT,
gdp_per_capita FLOAT,
extreme_poverty FLOAT,
cardiovasc_death_rate FLOAT,
diabetes_prevalence FLOAT,
female_smokers FLOAT,
male_smokers FLOAT,
handwashing_facilities FLOAT,
hospital_beds_per_thousand FLOAT,
life_expectancy FLOAT,
human_development_index FLOAT,
population INT,
excess_mortality_cumulative_absolute FLOAT,
excess_mortality_cumulative FLOAT,
excess_mortality FLOAT,
excess_mortality_cumulative_per_million FLOAT
);

UPDATE covidvaccinations
SET date = STR_TO_DATE(date, '%d-%m-%Y');

-- What is the first date that COVID-19 appeared in each location?
SELECT location,MIN(date) AS first_appearing_date
FROM coviddeaths
WHERE total_cases >= 1
GROUP BY location
ORDER BY first_appearing_date ASC;

-- What is the infection rate for each location and date?
SELECT location,
date,
population,
total_cases, 
ROUND((total_cases/population)* 100,2) AS infection_rate
FROM coviddeaths
ORDER BY location,date;

-- What is the death percentage for location that contains the word "states" in its name and date?
SELECT location,
date,
total_cases,
total_deaths,
ROUND((total_deaths/total_cases)*100, 2) AS Death_percentage
FROM coviddeaths
WHERE location LIKE '%states%'
ORDER BY location,date;

-- What is the highest infection rate for each country, ranked by infection rate?
SELECT location, 
population, 
MAX(total_cases) AS HighestInfectionCount, 
MAX(ROUND((total_cases/population)* 100,2)) AS infection_rate
FROM coviddeaths 
GROUP BY location, population
ORDER BY infection_rate DESC;

-- What is the total death count for each country, ranked by total death count?
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths 
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- What is the total death count for each continent, ranked by total death count?
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

 -- What is the total number of new cases and deaths, and the death percentage, for each date?
SELECT date, 
SUM(new_cases) AS TotalNewCases,
SUM(new_deaths) AS TotalNewDeaths,
ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS NewDeathPercentage
FROM coviddeaths 
GROUP BY date
HAVING NewDeathPercentage IS NOT NULL
ORDER BY date;

-- What is the total number of new cases, deaths, and the death percentage, for all dates?
SELECT SUM(new_cases) AS TotalNewCases,
SUM(new_deaths) AS TotalNewDeaths,
ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS NewDeathPercentage
FROM coviddeaths;

-- On which date did India conduct the most COVID-19 tests?
SELECT date
FROM covidvaccinations
WHERE location = 'India'
ORDER BY new_tests DESC
LIMIT 1;

-- How many new tests were conducted in the United States Virgin Islands on August 21, 2020?
SELECT new_tests 
FROM covidvaccinations
WHERE location = 'United States Virgin Islands'
AND date ='21-08-2020';

-- Which country has the highest number of tests per thousand people?
SELECT location
FROM covidvaccinations
WHERE total_tests_per_thousand =
(
SELECT MAX(total_tests_per_thousand)
FROM covidvaccinations
);

-- What is the total number of tests performed in each country?
SELECT location,SUM(new_tests_smoothed) AS TotalTestsDone
FROM covidvaccinations
GROUP BY location
ORDER BY TotalTestsDone DESC;

-- How does the number of new tests change over time in Brazil?
SELECT date,new_tests
FROM covidvaccinations
WHERE location = 'Brazil'
ORDER BY date ASC;

-- What is the highest positive rate of COVID-19 tests in France?
SELECT MAX(positive_rate) AS Postive_rate
FROM covidvaccinations
WHERE location = 'France';

-- How does the number of vaccinations in India compare to the total population?
SELECT MAX(total_vaccinations) AS TotalVaccinationCount, population
FROM covidvaccinations
WHERE location ='India'
GROUP BY population;

-- What is the percentage of the population that has been fully vaccinated in Germany?
SELECT MAX(people_fully_vaccinated) AS FullyVaccinatedCount, population ,
ROUND(MAX(people_fully_vaccinated)/population *100,2) AS FullyVaccinatedPercent
FROM
covidvaccinations
WHERE location = 'Germany'
GROUP BY population;

-- What is the vaccination rate per thousand people in South America?
SELECT  
    continent, 
  SUM(total_vaccinations) / SUM(population) * 1000 AS vaccination_rate_per_thousand
FROM covidvaccinations
WHERE continent = "South America";

-- Looking at Total Population VS Vaccinations
SELECT
cd.location,
SUM(cv.total_vaccinations) / SUM(cd.population) * 100 AS VaccinationRate
FROM coviddeaths cd
JOIN covidvaccinations cv
ON cd.location = cv.location
GROUP BY cd.location
ORDER BY VaccinationRate DESC;



  

























