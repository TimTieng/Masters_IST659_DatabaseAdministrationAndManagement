-- Homework Proble Set 4 -- Tim Tieng

-- Query 1 Collectibles
SELECT item_name, item_type, item_reserve,item_soldamount
FROM vb_items
WHERE item_type = 'Collectables';

-- Limit and sort
SELECT item_name, item_type, item_reserve,item_soldamount
FROM vb_items
WHERE item_type = 'Collectables'
ORDER BY item_name;

-- Query 2 Selleer of Antiques
SELECT *
FROM vb_items;

SELECT *
FROM vb_users;
-- JOIN
SELECT s.user_email,s.user_firstname, s.user_lastname, i.item_type, i.item_name
FROM vb_items i 
    JOIN vb_users s ON i.item_seller_user_id = s.user_id
WHERE i.item_type = 'Antiques';

-- Query 3 Seller's Report
SELECT *
FROM vb_items;

SELECT *
FROM vb_users;

SELECT s.user_email AS sellers_email, b.user_email AS buyers_email, i.item_soldamount - i.item_reserve AS item_margin, i.*
FROM vb_items i 
    JOIN vb_users s ON s.user_id = i.item_seller_user_id
    JOIN vb_users b ON b.user_id = i.item_buyer_user_id
WHERE i.item_sold = 1
ORDER BY item_margin DESC;

-- Questions 1
SELECT u.user_firstname, u.user_lastname,z.zip_city, z.zip_state, u.user_zip_code
FROM vb_users u
    JOIN vb_zip_codes z ON z.zip_code = u.user_zip_code
WHERE user_zip_code LIKE '13%';

--Question 2
SELECT u.user_firstname, u.user_lastname, u.user_email, u.user_zip_code, z.zip_state,z.zip_city 
FROM vb_users u
    JOIN vb_zip_codes z ON z.zip_code = u.user_zip_code
WHERE z.zip_state = 'NY'
ORDER BY z.zip_city, u.user_lastname ASC;

-- Question 3
SELECT item_id, item_name, item_type, item_reserve, item_sold 
FROM vb_items
WHERE item_sold = 0 AND item_reserve >= 350
ORDER BY item_reserve DESC;

--Question 4
SELECT item_id, item_name, item_type,item_reserve,
CASE 
    WHEN item_reserve >= 250 THEN 'High-Priced'
    WHEN item_reserve <= 50 THEN 'Low-Priced'
    ELSE 'Average-Priced'
END AS PriceCategory
FROM vb_items
WHERE item_type != 'All Other'
ORDER BY PriceCategory;

-- Question 5
SELECT b.bid_id,i.item_id,i.item_name,u.user_firstname, u.user_lastname,u.user_email ,b.bid_datetime, b.bid_amount
FROM vb_bids b
    JOIN vb_items i ON i.item_buyer_user_id = b.bid_user_id
    JOIN vb_users u ON u.user_id = i.item_buyer_user_id
WHERE b.bid_status = 'ok'
ORDER BY b.bid_datetime DESC;

-- Question 6
SELECT b.bid_datetime, u.user_id, u.user_firstname, u.user_lastname, u.user_email, i.item_id, b.bid_amount, b.bid_status
FROM vb_bids b
    JOIN vb_users u ON u.user_id = b.bid_user_id
    JOIN vb_items i ON i.item_id = b.bid_item_id
WHERE b.bid_status != 'ok'
ORDER BY u.user_lastname ASC, u.user_firstname ASC, b.bid_datetime DESC;

-- Question 7
SELECT b.bid_status, i.item_id, i.item_name, i.item_type, u.user_firstname, u.user_lastname, i.item_reserve, i.item_sold
FROM vb_bids b
    JOIN vb_items i ON i.item_id = b.bid_item_id
    JOIN vb_users u ON u.user_id = i.item_seller_user_id
WHERE i.item_sold =0;

-- Attempt 2
SELECT  i.item_id, i.item_name, i.item_type
FROM vb_items i 
WHERE NOT EXISTS
(
    SELECT *
    FROM vb_bids b
    WHERE b.bid_item_id = i.item_id
)

--Question 8
SELECT u.user_firstname, u.user_lastname, r.rating_for_user_id, u2.user_firstname,u2.user_lastname, r.rating_value, r.rating_comment, r.rating_astype
FROM vb_user_ratings r 
    JOIN vb_users u ON u.user_id = r.rating_by_user_id
    JOIN vb_users u2 ON u2.user_id = r.rating_for_user_id
WHERE rating_astype = 'Seller';

-- Question 9
SELECT i.item_id, i.item_name, i.item_type,i.item_soldamount, u.user_firstname AS Seller_FirstName, u.user_lastname AS Seller_LastName, z.zip_city AS Seller_ZipCode,
z.zip_state AS Seller_State, u2.user_firstname AS Buyer_FirstName, u2.user_lastname AS Buyer_LastName, z2.zip_city AS Buyer_ZipCode, z2.zip_state AS Buyer_State
FROM vb_users u
    JOIN vb_zip_codes z ON z.zip_code = u.user_zip_code
    JOIN vb_items i ON i.item_seller_user_id = u.user_id
    JOIN vb_users u2 on u2.user_id = i.item_buyer_user_id
    JOIN vb_zip_codes z2 ON z2.zip_code = u2.user_zip_code
WHERE i.item_sold = 1;

-- Question 10
SELECT DISTINCT u.user_firstname, u.user_lastname, u.user_email
FROM vb_users u 
    JOIN vb_items i ON i.item_buyer_user_id = u.user_id
    JOIN vb_bids b ON b.bid_item_id = i.item_id
WHERE b.bid_status != 'item_seller' AND b.bid_user_id != u.user_id
