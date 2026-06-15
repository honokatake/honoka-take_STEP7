--ユーザ
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    created_at DATE
);

--商品
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price INT
);

--注文
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

--注文明細
CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

--ユーザ
INSERT INTO users (id, name, age, gender, created_at) VALUES
 (1, '山田太郎', 28, 'male', '2024-01-10'),
 (2, '佐藤花子', 35, 'female', '2024-03-15'),
 (3, '鈴木次郎', 42, 'male', '2023-08-20'),
 (4, '田中美咲', 23, 'female', '2022-11-05'),
 (5, '高橋健一', 30, 'male', '2024-06-06');

--商品
INSERT INTO products (id, product_name, price) VALUES
 (1, 'テレビ', 50000),
 (2, '冷蔵庫', 70000),
 (3, '電子レンジ', 15000),
 (4, '掃除機', 20000),
 (5, '炊飯器', 18000);

--注文
INSERT INTO orders (id, user_id, order_date) VALUES
 (1, 1, '2024-05-01'),
 (2, 1, '2024-05-15'),
 (3, 2, '2024-06-01'),
 (4, 3, '2024-05-20'),
 (5, 4, '2024-06-03'),
 (6, 5, '2024-06-05');

 --注文明細
 INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
 (1, 1, 1, 1),--山田がテレビを1台
 (2, 1, 3, 2),--山田が電子レンジを２台
 (3, 2, 1, 1),--山田が冷蔵庫を１台

 (4, 3, 5, 1),--佐藤が炊飯器を１台

 (5, 4, 4, 1),--鈴木が掃除機を１台
 (6, 4, 3, 1),--鈴木が電子レンジを１台  

 (7, 5, 2, 1),--田中が冷蔵庫を１台

 (8, 6, 1, 1),--高橋がテレビを１台
 (9, 6, 5, 2);--高橋が炊飯器を２台

 --設問1
 SELECT * 
 FROM users;

 --設問2
 SELECT * 
 FROM users 
 WHERE created_at >= '2024-01-01'
    AND created_at <= '2024-12-31';

 --設問3
 SELECT * 
 FROM users 
 WHERE age > 30
    AND gender = 'female';

 --設問4
 SELECT product_name,price
 FROM products;

 --設問5
 SELECT users.name, orders.order_date 
 FROM users
 JOIN orders 
    ON users.id = orders.user_id;

--設問6
SELECT 
    products.product_name AS '商品名',
    order_items.quantity AS '数量',
    products.price AS '単価',
    order_items.quantity * products.price AS '金額'
FROM order_items
JOIN products
    ON order_items.product_id = products.id
GROUP BY order_items.id;

--設問7
SELECT 
    users.name AS 'ユーザ名',
    COUNT(orders.id) AS '注文件数'
FROM users
JOIN orders
    ON users.id = orders.user_id
GROUP BY users.id, users.name;

--設問8
SELECT users.name AS 'ユーザ名',
 SUM(products.price * order_items.quantity) AS '合計金額'
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON order_items.product_id = products.id
GROUP BY users.id;

--設問9
SELECT users.name AS 'ユーザ名',
        SUM(order_items.quantity * products.price) AS '注文金額'
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON products.id = order_items.product_id
GROUP BY users.id,users.name
ORDER BY 注文金額 DESC
LIMIT 1;

--設問10
SELECT
    products.product_name AS '商品名',
    SUM(order_items.quantity) AS '注文回数'
FROM products
JOIN order_items
    ON products.id = order_items.product_id
GROUP BY products.id,products.product_name;

--設問11
SELECT users.name
FROM users
LEFT JOIN orders
    ON users.id = orders.user_id
WHERE orders.id IS NULL;

--設問12
SELECT order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;


--設問13
SELECT DISTINCT users.name
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON products.id = order_items.product_id
WHERE products.product_name = 'テレビ';

--設問14
SELECT 
    orders.order_date AS '注文日',
    users.name AS 'ユーザ名',
    products.product_name AS '商品名',
    order_items.quantity AS '数量',
    order_items.quantity * products.price AS '合計金額'
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON products.id = order_items.product_id
ORDER BY orders.order_date;

--設問15
SELECT 
    products.product_name AS '商品名',
    SUM(order_items.quantity) AS '購入数'
FROM products
JOIN order_items
    ON products.id = order_items.product_id
GROUP BY products.id, products.product_name
ORDER BY SUM(order_items.quantity) DESC
LIMIT 1;

--設問16
SELECT
    MONTH(order_date) as '月',
    COUNT(*) AS '注文件数'
FROM orders
GROUP BY MONTH(order_date),
ORDER BY MONTH(order_date);

--設問17
SELECT products.product_name
FROM products
LEFT JOIN order_items
    ON products.id = order_items.product_id
WHERE order_items,product_id IS NULL;

--設問18
CREATE INDEX idx_order_items 
ON order_items(product_id);

--設問19
SELECT 
    users.name AS 'ユーザ名',
    AVG(orders_total.total_amount) AS '平均注文金額'
FROM users
JOIN (
    SELECT
        orders.id,
        orders.user_id,
        SUM(order_items.quantity * products.price) AS total_amount
    FROM orders
    JOIN order_items
        ON orders.id = order_items.order_id
    JOIN products
        ON products.id = order_items.product_id
    GROUP BY orders.id,orders.user_id
) AS orders_total
 ON users.id = orders_total.user_id
 GROUP BY users.id, users.name;


--設問20
SELECT 
    users.name AS 'ユーザ名',
    MAX(orders.order_date) AS '最新注文日'
FROM users
JOIN orders
    ON users.id = orders.user_id
GROUP BY users.id;

--設問21
INSERT INTO users(id,name,age,gender,created_at)
VALUES (6,'中村愛',25,'female','2025-06-01');

--設問22
INSERT INTO products(id,product_name,price)
VALUES (6,'エアコン',60000);

--設問23
INSERT INTO orders(id,user_id,order_date)
VALUES (10,1,'2025-06-10');

--設問24
INSERT INTO order_items(id,order_id,product_id,quantity)
VALUES (10,10,6,1);

--設問25
UPDATE users
SET age = 24
WHERE id = 4;

--設問26
UPDATE products
SET price = price * 1.10;

--設問27
UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date < '2024-05-01';

--設問28
DELETE
FROM users
WHERE id = 5;

--設問29
DELETE
FROM order_items
WHERE order_id = 5;

--設問30
DELETE 
FROM products
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items
    WHERE order_items.product_id = products.id
);