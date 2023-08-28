-- Ttieng Week 5 lab and HW Problem Set 5

-- Inclass queries - CTE
WITH ZIPCODESWITHTWOUSERS AS(
    SELECT user_zip_code,COUNT(*) AS Num
    FROM vb_users
    GROUP BY user_zip_code
    HAVING COUNT(*) >1
)
SELECT* FROM ZIPCODESWITHTWOUSERS AS z2
JOIN vb_users u ON u.user_zip_code = z2.user_zip_code



-- Query 1
SELECT * FROM vb_items;
SELECT * FROM vb_bids;

-- Left Join
SELECT *
FROM vb_items 
    JOIN vb_bids ON bid_item_id = item_id
WHERE bid_status = 'ok';

-- Groupings
SELECT item_name, item_reserve, MIN(bid_amount) AS min_bid, MAX(bid_amount) AS max_bid, item_soldamount
FROM vb_items i
    JOIN vb_bids b ON b.bid_item_id = i.item_id
WHERE b.bid_status = 'ok'
GROUP BY item_name, item_reserve, item_soldamount
ORDER BY item_reserve DESC;

-- Query 2
SELECT * FROM vb_bids;
SELECT * FROM vb_users;

SELECT s.user_firstname,s.user_lastname, s.user_email, COUNT(*) AS Bid_Count,
    CASE 
        WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'low'
        WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'moderate'
        ELSE 'high'
    END AS user_bid_activity
FROM vb_users s
    LEFT JOIN vb_bids b ON b.bid_user_id = s.user_id
WHERE b.bid_status = 'ok'
GROUP BY s.user_firstname, s.user_lastname, s.user_email;

--Create a CTE

WITH user_bids AS (
    SELECT s.user_firstname,s.user_lastname, s.user_email, COUNT(*) AS Bid_Count,
    CASE 
        WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'low'
        WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'moderate'
        ELSE 'high'
    END AS user_bid_activity
    FROM vb_users s
        LEFT JOIN vb_bids b ON b.bid_user_id = s.user_id
    WHERE b.bid_status = 'ok'
    GROUP BY s.user_firstname, s.user_lastname, s.user_email
)
SELECT user_bid_activity , COUNT(*) as user_count
FROM user_bids
GROUP BY user_bid_activity
ORDER BY user_count;

SELECT item_name, item_type, item_reserve, item_soldamount 
FROM vb_items i 
WHERE item_type = 'Collectables'
ORDER BY item_name ASC;

-- Homework Question 1
WITH query1 AS(
SELECT item_type, COUNT(*) AS Num_Of_Items, MIN(item_reserve) AS min_reserve, MAX(item_reserve) AS max_reserve
FROM vb_items
GROUP BY item_type
)
SELECT * FROM query1;


-- Homework Question 2
-- SELECT item_name, item_type, item_reserve, MIN(item_reserve) AS min_reserve, MAX(item_reserve), AVG(item_reserve) AS avg_reserve 
-- FROM vb_items
-- WHERE item_type = 'Antiques' OR item_type = 'Collectables'
-- GROUP BY item_type, item_name, item_reserve
-- ORDER BY item_type ASC;

WITH query2 AS (
    SELECT item_type, item_name, item_reserve MIN(item_reserve) AS min_reserve, MAX(item_reserve), AVG(item_reserve) AS avg_reserve 
    FROM vb_items 
    GROUP BY item_type, item_name, item_reserve
)
SELECT *
FROM query2
    JOIN query2 ON query2.item_type = i.item_type
GROUP BY item_type

-- Homework Question 3
SELECT u.user_firstname, u.user_lastname, COUNT(*) + COUNT(r.rating_for_user_id)as num_ratings, AVG(CAST(r.rating_value AS decimal)) AS avg_rating_score
FROM vb_users u
    JOIN vb_user_ratings r ON r.rating_for_user_id = u.user_id
GROUP BY u.user_firstname, u.user_lastname
ORDER BY avg_rating_score DESC;

-- Homework Question 4
SELECT i.item_name, COUNT(b.bid_item_id) AS num_of_Bids
FROM vb_items i
    JOIN vb_bids b ON b.bid_item_id = i.item_id
WHERE i.item_type = 'Collectables' 
GROUP BY i.item_name
HAVING COUNT(*) > 1
ORDER BY num_of_Bids DESC;

-- Homework Question 5
SELECT i.item_id, i.item_name, rank() OVER (PARTITION BY COUNT(*) ORDER BY b.bid_amount DESC) as bid_order, b.bid_amount, u.user_firstname +' '+ u.user_lastname AS 'bidder'
FROM vb_items i
    JOIN vb_bids b ON b.bid_user_id = i.item_buyer_user_id
    JOIN vb_users u ON u.user_id = b.bid_user_id
GROUP BY i.item_id, i.item_name, b.bid_amount, u.user_firstname, u.user_lastname;

-- Homework Questeion 6
with query6 AS (
    SELECT i.item_id, i.item_name, rank() OVER (PARTITION BY COUNT(*) ORDER BY b.bid_amount DESC) as bid_order, b.bid_amount, u.user_firstname +' '+ u.user_lastname AS 'bidder'
FROM vb_items i
    JOIN vb_bids b ON b.bid_user_id = i.item_buyer_user_id
    JOIN vb_users u ON u.user_id = i.item_seller_user_id
GROUP BY i.item_id, i.item_name, b.bid_amount, u.user_firstname, u.user_lastname
)
SELECT item_name, bid_order, bid_amount, bidder, lead(bidder) OVER (ORDER BY item_name) AS next_bidder
FROM query6;

-- Homework Question 7
-- SELECT u.user_firstname + ' ' + u.user_lastname AS username, u.user_email, AVG(rating_value) AS avg_rating
-- FROM vb_user_ratings r
--     JOIN vb_users u on u.user_id = r.rating_for_user_id
-- -- WHERE r.rating_value < AVG(r.rating_value)
-- GROUP BY user_firstname, u.user_lastname, u.user_email
-- HAVING COUNT(*) > 1 
-- ORDER BY avg_rating DESC;

WITH ratingAverage AS(
    SELECT u.user_firstname, u.user_lastname, user_email, MIN(r.rating_value) AS Min_Rating, MAX(r.rating_value) AS max_rating, AVG(CAST(r.rating_value AS decimal)) AS avg_rating
    FROM vb_user_ratings r
        JOIN vb_users u ON u.user_id = r.rating_by_user_id
    GROUP BY user_firstname, user_lastname, user_email
)
SELECT user_firstname, user_lastname, user_email
FROM ratingAverage RAVG
    JOIN vb_user_ratings AS RAT ON RAT.rating_value <= RAVG.avg_rating

-- Homework Question 8
SELECT u.user_firstname, u.user_lastname, COUNT(bid_item_id) AS total_bids, COUNT(bid_id) as num_bids_per_item, CAST(COUNT(*) / COUNT(item_id) as DECIMAL(20,6)) AS ratio
FROM vb_bids b
    JOIN vb_users u ON u.user_id = b.bid_user_id
    JOIN vb_items i ON i.item_id = b.bid_item_id
    -- JOIN vb_users u2 ON u2.user_id = i.item_seller_user_id
-- WHERE bid_status != 'low_bid'
GROUP BY u.user_firstname, u.user_lastname;

-- Ratings Query

WITH ratingAverage AS(
    SELECT MIN(rating_value) AS Min_Rating, MAX(rating_value) AS max_rating, AVG(CAST(rating_value AS decimal)) AS avg_rating
    FROM vb_user_ratings
)
SELECT * 
FROM ratingAverage RAVG
    JOIN vb_user_ratings AS RAT ON RAT.rating_value <= RAVG.avg_rating;


-- DATE example LAG/LEAD example

WITH bids AS(
SELECT bid_id, bid_datetime, bid_user_id, bid_status,
    LEAD(bid_datetime) OVER (PARTITION BY bid_user_id ORDER BY  bid_datetime) AS next_DT,
    LAG(bid_datetime) OVER (PARTITION BY bid_status ORDER BY bid_datetime) AS prev_DT
    -- LEAD(bid_datetime) OVER(PARTION BY bid_user_id ORDER BY bid_datetime) AS next_DT,
    -- LAG(bid_dateTime) OVER(PARTION BY bid_user_idORDER BY bid_datetime) AS prev_DT
FROM vb_bids
)
SELECT bid_id, bid_user_id, bid_status, bid_datetime, next_dt, DATEDIFF(ms, next_dt,bid_datetime)
FROM bids
ORDER BY bid_user_id, bid_datetime
-- Homework question 9
SELECT i.item_name, u.user_firstname, u.user_lastname, MAX(b.bid_amount) as MAX_Bid_Amount
FROM vb_items i
    JOIN vb_bids b ON b.bid_item_id =i.item_id 
    JOIN vb_users u ON U.user_id = b.bid_user_id
WHERE i.item_sold = 0
GROUP BY i.item_name, u.user_firstname, u.user_lastname
ORDER BY item_name ASC, MAX_Bid_Amount DESC;
