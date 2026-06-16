-- Day 1: Create products table
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