# SQL - Project 1
/*
Question

Business model Customer to Customer (C2C) allows customers to do business with each other. This model is growing fast with
e-commerce platforms where sellers may be required to pay some amount and buyer can buy it without paying anything. E-Commerce 
website brings the seller and buyer to the same platform. 

Analyzing the user's database will lead to understanding the business perspective. Behaviour of the users can be traced in 
terms of business with exploration of the user’s database. 

Dataset: One .csv file with name users_data with 98913 rows and 24 columns

Tasks to be performed

1. Create new schema as ecommerce

2. Import .csv file users_data into MySQL
   (right click on ecommerce schema -> Table Data import Wizard -> Give path of the file -> Next -> choose options : Create a 
   new table , select delete if exist -> next -> next)

3. SQL command to see the structure of table

4. Run SQL command to select first 100 rows of the database

5. How many distinct values exist in table for field country and language

6. Check whether male users are having maximum followers or female users.

7. Calculate the total users those
   a. Uses Profile Picture in their Profile
   b. Uses Application for Ecommerce platform
   c. Uses Android app
   d. Uses ios app

8. Calculate the total number of buyers for each country and sort the result in descending order of total number of buyers. 
   (Hint: consider only those users having at least 1 product bought.)
   
9. Calculate the total number of sellers for each country and sort the result in ascending order of total number of sellers. 
   (Hint: consider only those users having at least 1 product sold.)
   
10. Display name of top 10 countries having maximum products pass rate.

11. Calculate the number of users on an ecommerce platform for different language choices.

12. Check the choice of female users about putting the product in a wishlist or to like socially on an ecommerce platform. 
   (Hint: use UNION to answer this question.)
   
13. Check the choice of male users about being seller or buyer. (Hint: use UNION to solve this question.)

14. Which country is having maximum number of buyers?

15. List the name of 10 countries having zero number of sellers.

16. Display record of top 110 users who have used ecommerce platform recently.

17. Calculate the number of female users those who have not logged in since last 100 days.

18. Display the number of female users of each country at ecommerce platform.

19. Display the number of male users of each country at ecommerce platform.

20. Calculate the average number of products sold and bought on ecommerce platform by male users for each country.
 
 */
 
# Tasks to be performed

-- 1. Create new schema as ecommerce

create database ecommerce;
show databases;

-- 2. Import .csv file users_data into MySQL
--    (right click on ecommerce schema -> Table Data import Wizard -> Give path of the file -> Next -> choose options : Create a 
--    new table , select delete if exist -> next -> next)

use ecommerce;
show tables;

-- 3. SQL command to see the structure of table

desc users_data;

-- 4. Run SQL command to select first 100 rows of the database

select * from users_data limit 100;

-- 5. How many distinct values exist in table for field country and language

select distinct country from users_data;
select count(distinct country) Country from users_data;

select distinct language from users_data;
select count(distinct language) Language from users_data;

-- OR

select count(distinct country), count(distinct language) from users_data;

-- 6. Check whether male users are having maximum followers or female users.

select * from users_data;
select gender 'Gender',sum(socialNbFollowers) No_of_followers from users_data where gender = 'M'   # 77038
union
select gender 'Gender',sum(socialNbFollowers) No_of_followers from users_data where gender = 'F';  # 262458

-- OR

SELECT 
    SUM(socialNbFollowers) socialNbFollowers, gender
FROM
    users_data
GROUP BY gender;

-- > Female has maximum count by 76121 and maximum follower by 262458 
-- > Male has minimum count by 22792 and minimum follower by 77038 

-- 7. Calculate the total users those
--    a. Uses Profile Picture in their Profile
--    b. Uses Application for Ecommerce platform
--    c. Uses Android app
--    d. Uses ios app

-- a. Uses Profile Picture in their Profile

select * from users_data;
select count(hasProfilePicture) from users_data where hasProfilePicture = 'True';

-- b. Uses Application for Ecommerce platform

select * from users_data;
select count(hasAnyApp) from users_data where hasAnyApp = 'True';

-- c. Uses Android app

select * from users_data;
select count(hasAndroidApp) from users_data where hasAndroidApp = 'True';

-- d. Uses ios app

select * from users_data;
select count(hasIosApp) from users_data where hasIosApp = 'True';

-- 8. Calculate the total number of buyers for each country and sort the result in descending order of total number of buyers. 
--    (Hint: consider only those users having at least 1 product bought.)

SELECT 
    country, COUNT(productsBought) total_number_of_buyer
FROM
    users_data
WHERE productsBought != 0
GROUP BY country
ORDER BY total_number_of_buyer DESC;
    
-- 9. Calculate the total number of sellers for each country and sort the result in ascending order of total number of sellers. 
--    (Hint: consider only those users having at least 1 product sold.)

SELECT 
    country, COUNT(productsSold) total_number_of_seller
FROM
    users_data
WHERE productsSold != 0
GROUP BY country
ORDER BY total_number_of_seller ;
   
-- 10. Display name of top 10 countries having maximum products pass rate.

select * from users_data;

SELECT 
    country, SUM(productsPassRate) productsPassRate
FROM
    users_data
GROUP BY country
ORDER BY productsPassRate DESC
LIMIT 10;

-- 11. Calculate the number of users on an ecommerce platform for different language choices.

select * from users_data;

SELECT 
    language, COUNT(language) Total_users
FROM
    users_data
GROUP BY language;

-- 12. Check the choice of female users about putting the product in a wishlist or to like socially on an ecommerce platform. 
--    (Hint: use UNION to answer this question.)

select * from users_data;

SELECT 'ProductsWished' category,count(productsWished) Female_user FROM users_data where productsWished>0 and gender = 'F'
UNION
SELECT 'socialProductsLiked' category,count(socialProductsLiked) Female_user FROM users_data where socialProductsLiked>0 and gender = 'F';

-- 13. Check the choice of male users about being seller or buyer. (Hint: use UNION to solve this question.)

select * from users_data;

SELECT 'seller' Category, count(productsSold) Male_user from users_data where productsSold>0 and gender='M'
UNION
SELECT 'buyer' Category, count(productsBought) Male_user from users_data where productsBought>0 and gender='M';


-- 14. Which country is having maximum number of buyers?
select * from users_data;

SELECT 
    country, COUNT(productsBought) No_of_buyers
FROM
    users_data
GROUP BY country
ORDER BY No_of_buyers DESC
LIMIT 1;

-- > France have maximum number of buyers

-- 15. List the name of 10 countries having zero number of sellers.

select * from users_data;

SELECT 
    country, COUNT(productsSold) no_of_ZeroSeller
FROM
    users_data
WHERE
    productsSold = 0
GROUP BY country
ORDER BY no_of_ZeroSeller DESC
LIMIT 10;

-- OR

SELECT 
    country, SUM(productsBought)
FROM
    users_data
GROUP BY country
ORDER BY SUM(productsBought)
LIMIT 10;

SELECT country,count(*) from users_data where productsSold =0 group by country ;

-- 16. Display record of top 110 users who have used ecommerce platform recently.

select * from users_data;

select identifierHash,type , daysSincelastLogin from users_data 
where daysSincelastLogin < 30 order by daysSincelastLogin asc limit 110;

-- 17. Calculate the number of female users those who have not logged in since last 100 days.

select * from users_data;
select count(gender) from users_data where gender = 'F' and daysSincelastLogin < 100;

-- 18. Display the number of female users of each country at ecommerce platform.

select * from users_data;

SELECT 
    country, COUNT(gender) Female
FROM
    users_data
WHERE
    gender = 'F'
GROUP BY country
order by Female desc;

-- 19. Display the number of male users of each country at ecommerce platform.

select * from users_data;

SELECT 
    country, COUNT(gender) Male
FROM
    users_data
WHERE
    gender = 'M'
GROUP BY country
order by Male desc;


-- 20. Calculate the average number of products sold and bought on ecommerce platform by male users for each country.

select * from users_data;

SELECT 
    AVG(productsSold) Avg_product_sold,
    AVG(productsBought) Avg_product_Bought,
    gender,
    country
FROM
    users_data
WHERE
    gender = 'M'
GROUP BY country;
