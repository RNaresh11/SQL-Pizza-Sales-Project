**Pizzas Sales Analysis SQL Project**

This project analyzes pizza sales data using SQL queries to extract key insights about revenue, orders. The dataset contains details about orders, customers, pizzas, and order details.



**Creating Databases**
CREATE DATABASE pizzahut;
USE pizzahut;

**Creating Tables**
CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id)
);

CREATE TABLE orders_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id)
);

**Selecting Tables**
SELECT * FROM orders;
SELECT * FROM orders_details;
SELECT * FROM pizza_types;
SELECT * FROM pizzahut.pizzas;


**Basic**
-- Retrieve the total number of orders placed.

SELECT COUNT(*) FROM orders;

-- Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(pizzas.price * orders_details.quantity),2)
FROM PIZZAS JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id;

-- Identify the highest-priced pizza.

SELECT pizzas.price ,pizza_types.name 
FROM pizzas JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT pizzas.size, COUNT(orders_details.order_id)
FROM pizzas JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT pizza_types.name , SUM(orders_details.quantity) AS total_sum
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.NAME
ORDER BY total_sum DESC;



**Intermediate**
-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category , COUNT(orders_details.quantity) AS total_count
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_count DESC;

-- Determine the distribution of orders by hour of the day.

SELECT HOUR(order_time) ,COUNT(order_id)
FROM orders
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT category , count(name) 
FROM pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT AVG(quantity) FROM
(SELECT orders.order_date , SUM(orders_details.quantity) AS quantity
FROM orders JOIN orders_details
ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS order_quanity;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name , ROUND(SUM(orders_details.quantity*pizzas.price),2) AS total_sum
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name 
ORDER BY total_sum DESC LIMIT 3;


**Advanced**
-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category ,ROUND(SUM(orders_details.quantity * pizzas.price) /(SELECT ROUND(SUM(orders_details.quantity * pizzas.price),2)
FROM orders_details JOIN pizzas
ON orders_details.pizza_id = pizzas.pizza_id)*100,2) AS revenue

FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category 
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time.

SELECT order_date, SUM(revenue)
OVER(ORDER BY order_date) AS  cumlative_revenue
FROM
(SELECT orders.order_date , SUM(orders_details.quantity * pizzas.price) AS revenue
FROM orders_details JOIN pizzas
ON orders_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name ,revenue FROM
(SELECT category,name , revenue ,
RANK() OVER(PARTITION BY category ORDER BY name DESC) AS rn
FROM 
(SELECT pizza_types.category,pizza_types.name,SUM(pizzas.price*orders_details.quantity) AS revenue
FROM pizza_types JOIN pizzas
ON  pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category,pizza_types.name) AS a) AS b
WHERE rn <= 3;


