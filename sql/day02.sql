
-- Day 2: Aggregate Functions and GROUP BY
-- 学习目标：
-- 1. 理解聚合函数 COUNT / SUM / AVG / MIN / MAX
-- 2. 理解 GROUP BY 的作用
-- 3. 能按 category 对商品进行分类统计

-- 注意：
-- 本文件依赖 Day 1 创建的 products 表。
-- 如果 products 表不存在，请先执行：
-- docker exec -i mini_retail_postgres psql -U retail_user -d retail_db < sql/day01.sql

-- =========================================================
-- Cleanup dependent tables
-- =========================================================
-- orders 表会依赖 customers 和 stores。
-- 所以重复执行本文件时，要先删除 orders，再删除 customers / stores。

DROP TABLE IF EXISTS orders;

-- =========================================================
-- Part 1: COUNT - 统计数量
-- =========================================================

-- 1. 统计 products 表中一共有多少个商品
SELECT
    COUNT(*) AS product_count
FROM products;
-- =========================================================
-- Part 2: Basic Aggregate Functions
-- =========================================================

-- 2. 统计所有商品的价格总和
SELECT
    SUM(price_yen) AS total_price_yen
FROM products;

-- 3. 统计所有商品的平均价格
SELECT
    AVG(price_yen) AS avg_price_yen
FROM products;

-- 4. 查询最高商品价格
SELECT
    MAX(price_yen) AS max_price_yen
FROM products;

-- 5. 查询最低商品价格
SELECT
    MIN(price_yen) AS min_price_yen
FROM products;

-- 6. 一次性统计多个指标
SELECT
    COUNT(*) AS product_count,
    SUM(price_yen) AS total_price_yen,
    AVG(price_yen) AS avg_price_yen,
    MAX(price_yen) AS max_price_yen,
    MIN(price_yen) AS min_price_yen
FROM products;

-- =========================================================
-- Part 3: GROUP BY category
-- =========================================================
    --GROUP BY category 的意思是：
    --按照 category 分组。
    --同一个 category 的商品放到一组。
    --组汇总成一行结果。
    --你的数据会被分成：
    --饮料：牛奶、咖啡、绿茶
    --食品：饭团、便当
    --日用品：洗面奶、牙膏、口罩
    --药品：感冒药、维生素片

-- 7. 按商品分类统计商品数量
SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category;

-- 8. 按分类统计商品数量、平均价格、最高价格、最低价格
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen), 2) AS avg_price_yen,
    MAX(price_yen) AS max_price_yen,
    MIN(price_yen) AS min_price_yen
FROM products
GROUP BY category;
-- 9. 按分类统计平均利润
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen - cost_yen), 2) AS avg_profit_yen
FROM products
GROUP BY category;

-- 10. 按平均价格从高到低排序
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen), 2) AS avg_price_yen
FROM products
GROUP BY category
ORDER BY avg_price_yen DESC;

-- 11. 按平均利润从高到低排序
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen - cost_yen), 2) AS avg_profit_yen
FROM products
GROUP BY category
ORDER BY avg_profit_yen DESC;

-- =========================================================
-- Part 4: WHERE + GROUP BY
-- =========================================================

-- 12. 只统计价格大于等于 300 日元的商品，并按分类汇总
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen), 2) AS avg_price_yen
FROM products
WHERE price_yen >= 300
GROUP BY category;

-- 13. 只统计非饮料类商品，并按分类汇总平均价格
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen),2) AS avg_price_yen
FROM products
WHERE category != '饮料'
GROUP BY category;

-- 14. 只统计利润大于等于 200 日元的商品，并按分类汇总
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen - cost_yen), 2) AS avg_profit_yen
FROM products
WHERE price_yen - cost_yen >= 200
GROUP BY category;

-- =========================================================
-- Part 5: HAVING - 分组后的筛选
-- =========================================================

-- 15. 筛选商品数量大于等于 3 的分类
SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) >= 3;

-- 16. 筛选平均价格大于等于 500 日元的分类
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen), 2) AS avg_price_yen
FROM products
GROUP BY category
HAVING AVG(price_yen) >= 500;

-- 17. 筛选平均利润大于等于 200 日元的分类
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen - cost_yen), 2) AS avg_profit_yen
FROM products
GROUP BY category
HAVING AVG(price_yen - cost_yen) >= 200;

-- 18. 先排除饮料，再筛选平均价格大于等于 300 日元的分类
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_yen), 2) AS avg_price_yen
FROM products
WHERE category <> '饮料'
GROUP BY category
HAVING AVG(price_yen) >= 300;
-- =========================================================
-- Part 6: Day 2 Practice
-- =========================================================
-- 19. 按分类统计总利润，并按总利润从高到低排序
SELECT
    category,
    COUNT(*) AS product_count,
    SUM(price_yen - cost_yen) AS total_profit_yen
FROM products
GROUP BY category
ORDER BY total_profit_yen DESC;

-- 20. 筛选总利润大于等于 400 日元的分类
SELECT
    category,
    COUNT(*) AS product_count,
    SUM(price_yen - cost_yen) AS total_profit_yen
FROM products
GROUP BY category
HAVING SUM(price_yen - cost_yen) >= 400
ORDER BY total_profit_yen DESC;
-- =========================================================
-- Part 7: Create customers table
-- =========================================================

-- 顾客表 customers
-- 作用：保存顾客的基础信息
-- 注意：学习阶段使用 DROP TABLE，方便重复执行本文件

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female', 'unknown')),
    birth_date DATE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- Part 8: Insert customer data
-- =========================================================

INSERT INTO customers (customer_name, gender, birth_date)
VALUES
    ('佐藤太郎', 'male', '1995-04-12'),
    ('鈴木花子', 'female', '1998-09-23'),
    ('田中一郎', 'male', '1988-01-05'),
    ('高橋美咲', 'female', '2001-07-19'),
    ('伊藤健', 'male', '1992-11-30'),
    ('山本優子', 'female', '1996-03-08'),
    ('中村翔', 'male', '2000-12-15'),
    ('小林愛', 'female', '1999-06-21'),
    ('加藤直人', 'male', '1985-10-02'),
    ('渡辺玲奈', 'female', '1997-02-27');

-- =========================================================
-- Part 9: Basic SELECT for customers
-- =========================================================

-- 21. 查询全部顾客
SELECT *
FROM customers;

-- 22. 只查询顾客姓名和性别
SELECT
    customer_name,
    gender
FROM customers;

-- 23. 查询女性顾客
SELECT
    customer_id,
    customer_name,
    gender
FROM customers
WHERE gender = 'female';

-- 24. 查询 1995 年以后出生的顾客
SELECT
    customer_id,
    customer_name,
    birth_date
FROM customers
WHERE birth_date >= '1995-01-01';

-- 25. 按出生日期从早到晚排序
SELECT
    customer_id,
    customer_name,
    birth_date
FROM customers
ORDER BY birth_date ASC;

-- 26. 按性别统计顾客数量
SELECT
    gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY gender;
-- =========================================================
-- Part 10: Customer age analysis
-- =========================================================

-- 27. 计算每个顾客的年龄
SELECT
    customer_id,
    customer_name,
    gender,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
FROM customers;

-- 28. 查询年龄小于 30 岁的顾客
SELECT
    customer_id,
    customer_name,
    gender,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age
FROM customers
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) < 30;

-- 29. 按性别统计平均年龄
SELECT
    gender,
    COUNT(*) AS customer_count,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date))), 2) AS avg_age
FROM customers
GROUP BY gender;

-- =========================================================
-- Part 11: Create stores table
-- =========================================================

-- 门店表 stores
-- 作用：保存门店的基础信息
-- 后续 orders 表会通过 store_id 关联到 stores 表

DROP TABLE IF EXISTS stores;

CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    store_type VARCHAR(50) NOT NULL CHECK (store_type IN ('convenience', 'drugstore', 'supermarket')),
    opened_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- Part 12: Insert store data
-- =========================================================

INSERT INTO stores (store_name, city, store_type, opened_date)
VALUES
    ('奈良中央店', 'Nara', 'drugstore', '2018-04-01'),
    ('大阪梅田店', 'Osaka', 'convenience', '2020-07-15'),
    ('京都駅前店', 'Kyoto', 'drugstore', '2019-10-10'),
    ('東京新宿店', 'Tokyo', 'supermarket', '2021-03-20'),
    ('大阪難波店', 'Osaka', 'drugstore', '2022-09-05');

-- =========================================================
-- Part 13: Basic SELECT for stores
-- =========================================================

-- 30. 查询全部门店
SELECT *
FROM stores;

-- 31. 查询门店名称、城市和类型
SELECT
    store_name,
    city,
    store_type
FROM stores;

-- 32. 查询大阪的门店
SELECT
    store_id,
    store_name,
    city,
    store_type
FROM stores
WHERE city = 'Osaka';

-- 33. 按开业日期从早到晚排序
SELECT
    store_id,
    store_name,
    city,
    opened_date
FROM stores
ORDER BY opened_date ASC;

-- 34. 按城市统计门店数量
SELECT
    city,
    COUNT(*) AS store_count
FROM stores
GROUP BY city;

-- 35. 按门店类型统计门店数量
SELECT
    store_type,
    COUNT(*) AS store_count
FROM stores
GROUP BY store_type;

-- 36. 按城市统计门店数量，并按门店数量从高到低排序
SELECT
    city,
    COUNT(*) AS store_count
FROM stores
GROUP BY city
ORDER BY store_count DESC;

-- 37. 按门店类型统计门店数量，并按门店数量从高到低排序
SELECT
    store_type,
    COUNT(*) AS store_count
FROM stores
GROUP BY store_type
ORDER BY store_count DESC;

-- =========================================================
-- Part 14: Create orders table
-- =========================================================

-- 订单表 orders
-- 作用：保存顾客在门店下单的记录
-- customer_id 来自 customers 表
-- store_id 来自 stores 表

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    store_id INTEGER NOT NULL REFERENCES stores(store_id),
    order_date TIMESTAMP NOT NULL,
    total_amount_yen INTEGER NOT NULL CHECK (total_amount_yen > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('completed', 'cancelled', 'refunded')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- =========================================================
-- Part 15: Insert order data
-- =========================================================

INSERT INTO orders (customer_id, store_id, order_date, total_amount_yen, status)
VALUES
    (1, 1, '2026-06-01 10:15:00', 680, 'completed'),
    (2, 2, '2026-06-01 12:30:00', 330, 'completed'),
    (3, 1, '2026-06-02 09:45:00', 1280, 'completed'),
    (4, 3, '2026-06-02 18:20:00', 498, 'completed'),
    (5, 4, '2026-06-03 14:10:00', 980, 'completed'),
    (6, 5, '2026-06-03 16:40:00', 398, 'completed'),
    (7, 2, '2026-06-04 08:25:00', 160, 'completed'),
    (8, 3, '2026-06-04 20:05:00', 810, 'completed'),
    (9, 1, '2026-06-05 11:50:00', 150, 'cancelled'),
    (10, 5, '2026-06-05 13:30:00', 1280, 'refunded'),
    (1, 2, '2026-06-06 17:15:00', 528, 'completed'),
    (2, 4, '2026-06-06 19:45:00', 980, 'completed');

-- =========================================================
-- Part 16: Basic SELECT for orders
-- =========================================================

-- 38. 查询全部订单
SELECT *
FROM orders;

-- 39. 查询已完成订单
SELECT
    order_id,
    customer_id,
    store_id,
    order_date,
    total_amount_yen,
    status
FROM orders
WHERE status = 'completed';

-- 40. 查询订单金额大于等于 800 日元的订单
SELECT
    order_id,
    customer_id,
    store_id,
    total_amount_yen,
    status
FROM orders
WHERE total_amount_yen >= 800;

-- 41. 按订单金额从高到低排序
SELECT
    order_id,
    customer_id,
    store_id,
    total_amount_yen,
    status
FROM orders
ORDER BY total_amount_yen DESC;

-- 42. 查询订单金额最高的 3 笔订单
SELECT
    order_id,
    customer_id,
    store_id,
    total_amount_yen,
    status
FROM orders
ORDER BY total_amount_yen DESC
LIMIT 3;

-- =========================================================
-- Part 17: Aggregate queries for orders
-- =========================================================

-- 43. 统计订单总数、总销售额、平均订单金额
SELECT
    COUNT(*) AS order_count,
    SUM(total_amount_yen) AS total_sales_yen,
    ROUND(AVG(total_amount_yen), 2) AS avg_order_amount_yen
FROM orders;

-- 44. 按订单状态统计订单数和金额
SELECT
    status,
    COUNT(*) AS order_count,
    SUM(total_amount_yen) AS total_amount_yen
FROM orders
GROUP BY status;

-- 45. 只统计 completed 订单的销售额
SELECT
    COUNT(*) AS completed_order_count,
    SUM(total_amount_yen) AS completed_sales_yen,
    ROUND(AVG(total_amount_yen), 2) AS avg_completed_order_amount_yen
FROM orders
WHERE status = 'completed';

-- 46. 按门店统计订单数和销售额
SELECT
    store_id,
    COUNT(*) AS order_count,
    SUM(total_amount_yen) AS total_sales_yen
FROM orders
WHERE status = 'completed'
GROUP BY store_id
ORDER BY total_sales_yen DESC;

-- 47. 按顾客统计订单数和消费金额
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_amount_yen) AS total_spent_yen
FROM orders
WHERE status = 'completed'
GROUP BY customer_id
ORDER BY total_spent_yen DESC;

-- =========================================================
-- Part 18: JOIN orders and customers
-- =========================================================

-- 48. 查询订单及对应顾客姓名
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.order_date,
    o.total_amount_yen,
    o.status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

-- 49. 查询已完成订单及对应顾客姓名
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.total_amount_yen,
    o.status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status = 'completed';

-- 50. 按顾客统计已完成订单数和消费金额，并显示顾客姓名
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(*) AS completed_order_count,
    SUM(o.total_amount_yen) AS total_spent_yen
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spent_yen DESC;

-- =========================================================
-- Part 19: JOIN orders and stores
-- =========================================================

-- 51. 查询订单及对应门店名称
SELECT
    o.order_id,
    s.store_name,
    s.city,
    o.order_date,
    o.total_amount_yen,
    o.status
FROM orders o
JOIN stores s
    ON o.store_id = s.store_id;

-- 52. 按门店统计已完成订单数和销售额，并显示门店名称
SELECT
    s.store_id,
    s.store_name,
    s.city,
    COUNT(*) AS completed_order_count,
    SUM(o.total_amount_yen) AS total_sales_yen
FROM orders o
JOIN stores s
    ON o.store_id = s.store_id
WHERE o.status = 'completed'
GROUP BY
    s.store_id,
    s.store_name,
    s.city
ORDER BY total_sales_yen DESC;
-- =========================================================
-- Part 20: JOIN orders, customers, and stores
-- =========================================================

-- 53. 查询订单、顾客姓名、门店名称
SELECT
    o.order_id,
    c.customer_name,
    s.store_name,
    s.city,
    o.order_date,
    o.total_amount_yen,
    o.status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
ORDER BY o.order_id;

--先从 orders 表出发；
--根据 customer_id 找到顾客信息；
--再根据 store_id 找到门店信息。

-- 54. 查询已完成订单、顾客姓名、门店名称，并按金额从高到低排序
SELECT
    o.order_id,
    c.customer_name,
    s.store_name,
    s.city,
    o.order_date,
    o.total_amount_yen
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
WHERE o.status = 'completed'
ORDER BY o.total_amount_yen DESC;

-- 55. 按城市统计已完成订单数和销售额
SELECT
    s.city,
    COUNT(*) AS completed_order_count,
    SUM(o.total_amount_yen) AS total_sales_yen
FROM orders o
JOIN stores s
    ON o.store_id = s.store_id
WHERE o.status = 'completed'
GROUP BY s.city
ORDER BY total_sales_yen DESC;