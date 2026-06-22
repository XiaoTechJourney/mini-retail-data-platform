
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