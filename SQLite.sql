CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

Union ALL

Select * From appleStore_description4


**EXPLOTARY DATA ANALYSIS** 

-- Check the number of unique apps in both tableAppleStore

Select Count(distinct id) UniqueAppIDs
From AppleStore

Select Count(distinct id) UniqueAppIDs
From appleStore_description_combined

--Check for any missing values in key fields

Select Count(*) as missingValues
From AppleStore
Where track_name is null or user_rating is null or prime_genre is null

Select Count(*) as missingValues
From appleStore_description_combined
Where app_desc is null 

--Find out the number of apps per genere

Select prime_genre, count(*) as NumApps
From AppleStore
Group by prime_genre
order by NumApps DESC 

--Get an overview of apps' ratings

select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
From AppleStore

--Get the distribution of app prices

SELECT
      (price / 2) *2 as PriceBinStart,
      ((price / 2) *2) +2 as PriceBinEnd,
      Count(*) as NumApps
From AppleStore

Group by PriceBinStart
order by PriceBinStart

**DATA ANALYSIS**

--Determine wether paid apps have higher ratings than free apps

Select Case
            When price > 0 then 'Paid'
            else 'Free'
            End as App_Type,
            avg(user_rating) as Avg_Rating
from AppleStore 
group by App_Type

--Check if apps with more supported languages have higher ratings 

select case 
           when lang_num < 10 then '<10 languages'
           when lang_num between 10 and 30 then '10-30 languages'
           else '>30 languages'
       End as language_bucket,
       avg(user_rating) as Avg_Rating
FROM AppleStore
group by language_bucket
order by Avg_Rating DESC

--Check genres with lower ratings

Select prime_genre,
       avg(user_rating) as Avg_Rating
FROM AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

--Check if there is correlation between the length of the app description and the user rating

SELECT case 
           when length(b.app_desc) <500 then 'Short'
           when length(b.app_desc) between 500 and 1000 then 'Medium'
           Else 'Long'
       End as description_length_bucket,
       avg(a.user_rating) as average_rating
       
from AppleStore as A 
join 
     appleStore_description_combined as b 
 on
     a.id = b.id
     
group by description_length_bucket
order by average_rating DESC

--Check the top-rated apps for each genre 

Select
     prime_genre,
     track_name,
     user_rating
from (
       Select
       prime_genre,
       track_name,
       user_rating,
       RANK() OVER(PARTITION by prime_genre order by user_rating DESC, rating_count_tot DESC) as rank
       from 
       applestore
      ) as a 
where 
a.rank = 1



