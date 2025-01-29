-- Advanced:

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
