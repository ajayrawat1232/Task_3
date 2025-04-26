use task3;

-- 1. Find all customer names who made a purchase (joined with fact_table)

SELECT DISTINCT cd.name
FROM customer_dim cd
INNER JOIN fact_table ft ON cd.coustomer_key = ft.coustomer_key;


-- 2. Get total spending of each customer (name-wise) ordered from highest to lowest

SELECT cd.name, SUM(ft.total_price) AS total_spent
FROM fact_table ft
JOIN customer_dim cd ON ft.coustomer_key = cd.coustomer_key
GROUP BY cd.name
ORDER BY total_spent DESC;


-- 3. Top 5 most expensive items sold

SELECT id.item_name, ft.unit_price
FROM fact_table ft
JOIN item_dim id ON ft.item_key = id.item_key
ORDER BY ft.unit_price DESC
LIMIT 5;


-- 4. Total revenue from each store

SELECT sd.division, sd.district, sd.upazila, SUM(ft.total_price) AS store_revenue
FROM fact_table ft
JOIN store_dim sd ON ft.store_key = sd.store_key
GROUP BY sd.division, sd.district, sd.upazila
ORDER BY store_revenue DESC;


-- 5. Sales done in Q2 of any year

SELECT ft.payment_key, td.date, td.quarter, ft.total_price
FROM fact_table ft
JOIN time_dim td ON ft.time_key = td.time_key
WHERE td.quarter = 'Q2';


-- 6. Transaction details with card payment only

SELECT ft.payment_key, cd.name, td.trans_type, td.bank_name
FROM fact_table ft
JOIN trans_dim td ON ft.payment_key = td.payment_key
JOIN customer_dim cd ON ft.coustomer_key = cd.coustomer_key
WHERE td.trans_type = 'card';


-- 7. Subquery: Customers who have spent more than average total spend

SELECT cd.name, SUM(ft.total_price) AS total_spent
FROM fact_table ft
JOIN customer_dim cd ON ft.coustomer_key = cd.coustomer_key
GROUP BY cd.name
HAVING total_spent > (
    SELECT AVG(total_price)
    FROM fact_table
);


-- 8. Create a view to find high-value transactions (over 100)

CREATE VIEW High_Value_Transactions AS
SELECT ft.payment_key, cd.name, ft.total_price
FROM fact_table ft
JOIN customer_dim cd ON ft.coustomer_key = cd.coustomer_key
WHERE ft.total_price > 100;

SELECT * FROM High_Value_Transactions;
