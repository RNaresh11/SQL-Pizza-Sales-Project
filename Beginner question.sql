-- Basic:
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


