-- Day 1: Create products table

-- =========================================================
-- Part 1: Create products table
-- =========================================================
 DROP TABLE IF EXISTS products;      --如果 products 表已经存在，就先删掉。（初学多次运行，避免重复创建表导致错误）

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,      --serial是PostgreSQL中的一种数据类型，表示自增的整数
                                        --PRIMARY KEY表示该列是主键，唯一标识每一行数据（每个商品的唯一编号）也是后面数据的链接基础
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price_yen INTEGER NOT NULL CHECK (price_yen > 0),
    cost_yen INTEGER NOT NULL CHECK (cost_yen > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- Part 2: Insert product data
-- =========================================================
INSERT INTO products (product_name, category, price_yen, cost_yen)
VALUES
    ('牛奶', '饮料', 180, 120),
    ('饭团', '食品', 150, 90),
    ('洗面奶', '日用品', 680, 420),
    ('感冒药', '药品', 1280, 800),
    ('咖啡', '饮料', 160, 70),
    ('便当', '食品', 498, 300),
    ('牙膏', '日用品', 298, 150),
    ('绿茶', '饮料', 130, 60),
    ('口罩', '日用品', 398, 180),
    ('维生素片', '药品', 980, 500);

-- =========================================================
-- Part 3: Basic SELECT
-- =========================================================
-- 1. 查询全部商品
SELECT *
FROM products;
-- 2. 只查询商品名和价格
SELECT
    product_name,
    price_yen
FROM products;

-- 3. 查询商品名、分类和价格
SELECT
    product_name,
    category,
    price_yen
FROM products;

-- 4. 改变显示顺序：先显示价格，再显示商品名
SELECT
    price_yen,
    product_name
FROM products;

-- 5. 计算每个商品的利润
SELECT
    product_name,
    price_yen,
    cost_yen,
    price_yen - cost_yen AS profit_yen
FROM products;

-- 6. 计算每个商品的利润率
SELECT
    product_name,
    price_yen,
    cost_yen,
    price_yen - cost_yen AS profit_yen,
    ROUND((price_yen - cost_yen) * 100.0 / price_yen, 2) AS profit_margin_percent
FROM products;
-- 先算利润
-- 乘以 100.0 变成百分比
-- 再除以售价
-- 最后保留 2 位小数