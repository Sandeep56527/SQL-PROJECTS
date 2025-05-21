/*
Project: Spotify Data Analysis

Description:
This SQL project analyzes the Spotify data set to gain insights into users' music and podcast preferences, subscription habits, and listening behaviors. 
The dataset includes demographic information such as age and gender, as well as variables related to music and podcast usage. The goal of this project is to explore patterns, trends, and correlations within the data, and present the findings through interactive visualizations using Tableau.

*/
-- Creating spotifydata table 
USE spotify_dataset;
DROP TABLE IF EXISTS spotifydata ;
CREATE TABLE spotifydata 
(
Age VARCHAR(20),
Gender VARCHAR(15),
spotify_usage_period VARCHAR(30),
spotify_listening_device VARCHAR(150) ,
spotify_subscription_plan VARCHAR(130),
premium_sub_willingness VARCHAR(15),
preferred_premium_plan VARCHAR(150) ,
preferred_listening_content VARCHAR(10),
fav_music_genre VARCHAR(130),
music_time_slot VARCHAR(130),
music_Influencial_mood VARCHAR(150),
music_lis_frequency VARCHAR(150),
pod_lis_frequency VARCHAR(130),
fav_pod_genre VARCHAR(130),
preferred_pod_format VARCHAR(130),
preferred_pod_duration VARCHAR(30)
)

-- 1) Selecting everything from the table
SELECT * FROM spotifydata;

-- 2) Total number of Male, Female, and Others:
SELECT Gender, COUNT(Gender) AS TotalCount
FROM spotifydata
GROUP BY Gender;

-- 3) Total number of users in different age groups by gender:
SELECT Gender, Age, COUNT(*) AS TotalCount
FROM spotifydata
GROUP BY Gender, Age
ORDER BY TotalCount DESC;

-- 4) Users with Spotify usage period more than '2 years' who opted for premium subscription:
SELECT Age, Gender, spotify_usage_period, premium_sub_willingness, COUNT(*) AS TotalCount
FROM spotifydata
WHERE spotify_usage_period = 'More than 2 years'
 AND premium_sub_willingness = 'Yes'
 GROUP BY Age, Gender
 ORDER BY TotalCount DESC;
 
 -- 5) Most listened music moods by different age categories:
 SELECT Age, music_Influencial_mood,
  CASE 
    WHEN Age BETWEEN '20' AND '35' THEN 'Adults'
    WHEN Age BETWEEN '12' AND '20' THEN 'School Going'
    WHEN Age BETWEEN 6 AND 12 THEN 'Kids'
    WHEN Age BETWEEN '35' AND '60' THEN 'Middle Aged'
    ELSE 'Senior Citizens'
  END AS Age_Category,
  COUNT(*) AS Total_times_played
FROM spotifydata
GROUP BY Age, music_Influencial_mood, Age_Category
ORDER BY Total_times_played DESC;

 -- 6) User's preferred listening content and its distribution:
SELECT preferred_listening_content, COUNT(*) AS TotalCount
FROM spotifydata
GROUP BY preferred_listening_content;

-- 7) Average age and gender count using the PARTITION BY clause:
SELECT Age, Gender, preferred_listening_content,
COUNT(Gender) OVER (PARTITION BY Gender) AS GenderCount,
AVG(Age) OVER (PARTITION BY Gender) AS AvgAge
FROM spotifydata
WHERE Gender = 'Male';

-- 8) Podcast statistics by genre and age group:
SELECT Age, fav_pod_genre, COUNT(*) AS TotalCount
FROM spotifydata
WHERE fav_pod_genre IS NOT NULL
GROUP BY Age, fav_pod_genre
ORDER BY TotalCount DESC;

-- 9) Average age of users listening to podcasts of different genres:
SELECT fav_pod_genre, AVG(Age) AS AvgAge
FROM spotifydata
WHERE fav_pod_genre IS NOT NULL
GROUP BY fav_pod_genre
ORDER BY AvgAge DESC;



