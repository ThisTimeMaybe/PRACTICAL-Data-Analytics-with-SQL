CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

-- check the number of unique apps in both tablesAppleAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIds
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIds
FROM applestore_description_combined

--check for any missing values in the key fieldsAppleAppleStore

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS null OR user_rating IS null OR prime_genre IS NULL

SELECT COUNT(DISTINCT id) AS UniqeAppIds
From applestore_description_combined
WHERE app_desc IS null 

--Find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
Group BY prime_genre
ORDER BY NumApps DESC

--Get an overview of the apps' ratings

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

-Get the distribution of app prices

SELECT 
      (price / 2 ) *2 AS PriceBinStart,
      ((price / 2) *2 AS PriceBinEnd,
      COUNT(*) AS NumApps
 FRom AppleStore
       
 GROUP BY PriceBinStart
 ORDER BY PriceBinStart
       
 **Data Analysis**
       
 --Determine whether paid apps have higher rating than free apps
       
  SELECT CASE 
              WHEN price > 0 THEN 'Paid'
              else 'Free'
              END AS App_Type,
              avg(user_rating) As Avg_Rating
  FROM AppleStore
  GROUP BY App_Type
       
  --Check if apps with more supported languages have higher ratings
       
  SELECT CASE 
            WHEN lang_num < 10 THEN '<10 languages'
        WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
       ELSE '>10 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
    FROM AppleStore
    GROUP BY language_bucket
    ORDER BY Avg_Rating DESC 
       
       
       --Check genre with low ratings
       
       
       SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
     FROM AppleStore
       GROUP BY prime_genre
      ORDER BY Avg_Rating ASC
       LIMIT 10 
       
       --Check if there is corelation between the length of the app description and the user rating
       
       SELECT 
    CASE 
        WHEN LENGTH(b.app_desc) < 500 THEN 'Short'
        WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'long'
    END AS description_length_bucket,
    AVG(a.user_rating) AS average_rating
FROM
    AppleStore AS a
JOIN 
    applestore_description_combined AS b ON a.id = b.id 
GROUP BY 
    CASE 
        WHEN LENGTH(b.app_desc) < 500 THEN 'Short'
        WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'long'
    END
ORDER BY 
    average_rating DESC;

       
   --Check the top-rated apps for each genre 
       
     SELECT 
    prime_genre,
    track_name,
    user_rating
FROM (
    SELECT 
        prime_genre,
        track_name,
        user_rating,
        RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM
        appleStore
) AS a
WHERE 
    a.rank = 1;
