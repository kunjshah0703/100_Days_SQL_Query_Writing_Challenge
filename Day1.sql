-- Day 1

/*
Namastekart, an e-commerce company, has observed a notable surge in return orders recently. 
They suspect that a specific group of customers may be responsible for a significant portion of these 
returns. To address this issue, their initial goal is to identify customers who have returned more than
50% of their orders. 
This way, they can proactively reach out to these customers to gather feedback.

 For instance, if a customer named ABC has placed 4 orders and returned 3 of them, they should be 
 included in the output. On the other hand, if a customer named XYZ has placed 5 orders but only 
 returned 2, they should not be included in the output. 
 Write an SQL to find list of customers along with their return percent(Round to 2 decimal places).

 Alexa has placed 4 orders and returned 3 of them which is 75 percent (3/4) so Alexa is in output 
 while Ramesh has placed 3 orders but reurned only 1 order which is 33.33% (1/3) so Ramesh is not in
 output.

Expected Output:
 customer_name	Return_Percent
 Alexa			75.0
*/


CREATE TABLE orders_day1
(
order_id int,
order_date DATE,
customer_name varchar(20),
sales int
);

CREATE TABLE returns_day1
(
order_id int,
return_date DATE
);

INSERT INTO orders_day1 VALUES
(1, '2023-01-01', 'Alexa', 1239),
(2, '2023-01-02', 'Alexa', 1239),
(3, '2023-01-03', 'Alexa', 1239),
(4, '2023-01-03', 'Alexa', 1239),
(5, '2023-01-01', 'Ramesh', 1239),
(6, '2023-01-02', 'Ramesh', 1239),
(7, '2023-01-03', 'Ramesh', 1239),
(8, '2023-01-03', 'Neha', 1239);

INSERT INTO returns_day1 VALUES
(1, '2023-01-02'),
(2, '2023-01-04'),
(3, '2023-01-05'),
(7, '2023-01-06');

SELECT * FROM orders_day1;
SELECT * FROM returns_day1;

-- Solution 1 : 
WITH CTE1
AS
(SELECT customer_name, COUNT(1) AS total_orders
FROM orders_day1
GROUP BY customer_name)
, CTE2 AS
(SELECT o.customer_name, COUNT(1) AS orders_returned
FROM orders_day1 o
FULL OUTER JOIN returns_day1 r
ON o.order_id = r.order_id
WHERE r.order_id IS NOT NULL
GROUP BY o.customer_name)
, CTE3 AS
(SELECT CTE2.customer_name,ROUND((100.0*orders_returned  / total_orders),2) AS Return_Percent
FROM CTE2
JOIN CTE1
ON CTE2.customer_name = CTE1.customer_name)
SELECT customer_name, Return_Percent
FROM CTE3
WHERE Return_Percent > 50;

-- Solution 2:

SELECT customer_name
,ROUND(COUNT(r.order_id)*100.0/COUNT(*),2) AS Return_Percent
FROM orders_day1 o
LEFT JOIN returns_day1 r on o.order_id=r.order_id
GROUP BY customer_name
HAVING  COUNT(r.order_id) > COUNT(*)*0.5 

