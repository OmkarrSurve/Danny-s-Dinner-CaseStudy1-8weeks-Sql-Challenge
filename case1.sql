CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);


INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');


CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


--Case Study Questions

--1) What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) as total_spent
FROM sales s
JOIN
menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_spent DESC;


--2) How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) as days_visited
FROM sales
GROUP BY customer_id;


--3) What was the first item from the menu purchased by each customer?

WITH ordered_sales AS (
  SELECT 
    s.customer_id, 
    s.order_date, 
    m.product_name,
    DENSE_RANK() OVER(
      PARTITION BY s.customer_id 
      ORDER BY s.order_date
    ) AS rank
  FROM sales AS s
  JOIN menu AS m
    ON s.product_id = m.product_id
)

SELECT 
  customer_id, 
  product_name
FROM ordered_sales
WHERE rank = 1
GROUP BY customer_id, product_name;


-- 4)What is the most purchased item on the menu, and how many
--   times was it purchased by all customers?

SELECT 
  m.product_name, 
  COUNT(s.product_id) AS total_purchases
FROM sales s
JOIN menu m 
  ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchases DESC
LIMIT 1;


--5) Which item was the most popular for each customer?

WITH customer_popularity AS (
  SELECT 
    s.customer_id, 
    m.product_name, 
    COUNT(s.product_id) AS order_count,
    DENSE_RANK() OVER(
      PARTITION BY s.customer_id 
      ORDER BY COUNT(s.product_id) DESC
    ) AS rank
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
)

SELECT 
  customer_id, 
  product_name, 
  order_count
FROM customer_popularity
WHERE rank = 1;


--6) Which item was purchased first by the customer after they became a member?

WITH member_sales AS (
  SELECT 
    s.customer_id, 
    m.product_name,
    DENSE_RANK() OVER(
      PARTITION BY s.customer_id 
      ORDER BY s.order_date
    ) AS rank
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members me ON s.customer_id = me.customer_id
  WHERE s.order_date >= me.join_date
)
SELECT customer_id, product_name
FROM member_sales
WHERE rank = 1;


--7) Which item was purchased just before the customer became a member?

WITH last_purchase_before_member AS (
  SELECT 
    s.customer_id, 
    m.product_name,
    s.order_date,
    DENSE_RANK() OVER(
      PARTITION BY s.customer_id 
      ORDER BY s.order_date DESC
    ) AS rank
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members me ON s.customer_id = me.customer_id
  WHERE s.order_date < me.join_date
)

SELECT 
  customer_id, 
  product_name
FROM last_purchase_before_member
WHERE rank = 1;


--8) What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id, 
       COUNT(s.product_id) AS total_items,
	   SUM(m.price) AS total_amount_spent
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
JOIN members me
ON s.customer_id = me.customer_id
WHERE s.order_date < me.join_date
GROUP BY s.customer_id;


--9) If each $1 spent equates to 10 points and sushi has a 2x 
--   points multiplier - how many points would each customer have?

SELECT 
  s.customer_id,
  SUM(
    CASE 
      WHEN m.product_name = 'sushi' THEN m.price * 20
      ELSE m.price * 10 
    END
  ) AS total_points
FROM sales AS s
JOIN menu AS m
  ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_points DESC;


--10) In the first week after a customer joins the program 
--(including their join date) they earn 2x points on all items, 
--not just sushi - how many points do customer A and B have at the end of January?

SELECT 
  s.customer_id,
  SUM(
    CASE 
      WHEN s.order_date BETWEEN me.join_date AND me.join_date + INTERVAL '6 days' THEN m.price * 20
	  WHEN m.product_name = 'sushi' THEN m.price * 20
      ELSE m.price * 10 
    END
  ) AS total_points
FROM sales AS s
JOIN menu AS m
  ON s.product_id = m.product_id
JOIN members me
ON s.customer_id = me.customer_id
GROUP BY s.customer_id
ORDER BY total_points DESC;


--BONUS

SELECT 
    s.customer_id, 
    s.order_date,
    m.product_name, 
    m.price,
    CASE 
        WHEN s.order_date >= me.join_date THEN 'Y'
        ELSE 'N'
    END AS member,
    CASE 
        WHEN s.order_date >= me.join_date THEN 
            DENSE_RANK() OVER(
                PARTITION BY s.customer_id, (s.order_date >= me.join_date)
                ORDER BY s.order_date
            ) 
        ELSE NULL 
    END AS ranking
FROM sales s
LEFT JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members me ON s.customer_id = me.customer_id
ORDER BY s.customer_id, s.order_date, m.product_name;







