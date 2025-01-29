**Pizzas Sales Analysis SQL Project**

This project analyzes pizza sales data using SQL queries to extract key insights about revenue, orders. The dataset contains details about orders, customers, pizzas, and order details.



**Creating Databases**
```sql
CREATE DATABASE pizzahut;
USE pizzahut;
```

**Creating Tables**
```sql
CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id)
);
```
```sql
CREATE TABLE orders_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id)
);
```

**Selecting Tables**
```sql
SELECT * FROM orders;
SELECT * FROM orders_details;
SELECT * FROM pizza_types;
SELECT * FROM pizzahut.pizzas;
```


**Basic Questions**
**Q1**.Retrieve the total number of orders placed.
```sql
SELECT COUNT(*) FROM orders;
```

**Q2**.Calculate the total revenue generated from pizza sales.
```sql
SELECT ROUND(SUM(pizzas.price * orders_details.quantity),2)
FROM PIZZAS JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id;
```

**Q3**.Identify the highest-priced pizza.
```sql
SELECT pizzas.price ,pizza_types.name 
FROM pizzas JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;
```

**Q4**.Identify the most common pizza size ordered.
```sql
SELECT pizzas.size, COUNT(orders_details.order_id)
FROM pizzas JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size;
```

**Q5**.List the top 5 most ordered pizza types along with their quantities.
```sql
SELECT pizza_types.name , SUM(orders_details.quantity) AS total_sum
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.NAME
ORDER BY total_sum DESC;
```



**Intermediate**

**Q1**.Join the necessary tables to find the total quantity of each pizza category ordered.
```sql
SELECT pizza_types.category , COUNT(orders_details.quantity) AS total_count
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_count DESC;
```

**Q2**.Determine the distribution of orders by hour of the day.
```sql
SELECT HOUR(order_time) ,COUNT(order_id)
FROM orders
GROUP BY HOUR(order_time);
```

**Q3**.Join relevant tables to find the category-wise distribution of pizzas.
```sql
SELECT category , count(name) 
FROM pizza_types
GROUP BY category;
```

**Q4**.Group the orders by date and calculate the average number of pizzas ordered per day.
```sql
SELECT AVG(quantity) FROM
(SELECT orders.order_date , SUM(orders_details.quantity) AS quantity
FROM orders JOIN orders_details
ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS order_quanity;
```

**Q5**.Determine the top 3 most ordered pizza types based on revenue.
```sql
SELECT pizza_types.name , ROUND(SUM(orders_details.quantity*pizzas.price),2) AS total_sum
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name 
ORDER BY total_sum DESC LIMIT 3;
```


**Advanced**

**Q1**.Calculate the percentage contribution of each pizza type to total revenue.
```sql
SELECT pizza_types.category ,ROUND(SUM(orders_details.quantity * pizzas.price) /(SELECT ROUND(SUM(orders_details.quantity * pizzas.price),2)
FROM orders_details JOIN pizzas
ON orders_details.pizza_id = pizzas.pizza_id)*100,2) AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details
ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category 
ORDER BY revenue DESC;
```


**Q2**.Analyze the cumulative revenue generated over time.
```sql
SELECT order_date, SUM(revenue)
OVER(ORDER BY order_date) AS  cumlative_revenue
FROM
(SELECT orders.order_date , SUM(orders_details.quantity * pizzas.price) AS revenue
FROM orders_details JOIN pizzas
ON orders_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS sales;
```

**Q3**.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
```sql
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
```

