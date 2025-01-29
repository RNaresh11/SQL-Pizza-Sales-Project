-- Intermediate:
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
