-- =========================================================
-- Day 9: Indexes and EXPLAIN
-- =========================================================

-- 目的：
-- 学习 PostgreSQL 如何执行查询
-- 创建常用索引
-- 使用 EXPLAIN / EXPLAIN ANALYZE 理解查询计划

-- 注意：
-- EXPLAIN 只显示计划，不真正执行查询
-- EXPLAIN ANALYZE 会真正执行查询，并显示实际耗时
-- 本项目当前数据量很小，所以 PostgreSQL 可能仍然选择 Seq Scan，这是正常现象


-- =========================================================
-- Part 1: Basic EXPLAIN
-- =========================================================

-- 1. 查看一个简单商品查询的执行计划
EXPLAIN
SELECT
    product_id,
    product_name,
    category,
    price_yen,
    cost_yen
FROM products
WHERE product_id = 10;


-- 2. 查看实际执行耗时
EXPLAIN ANALYZE
SELECT
    product_id,
    product_name,
    category,
    price_yen,
    cost_yen
FROM products
WHERE product_id = 10;


-- =========================================================
-- Part 2: EXPLAIN for a business query
-- =========================================================

-- 3. 查看商品利润分析的执行计划
EXPLAIN ANALYZE
SELECT
    product_id,
    product_name,
    category,
    total_quantity,
    total_sales_yen,
    total_cost_yen,
    total_profit_yen,
    profit_margin_percent
FROM v_product_profit_summary
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 3: Create useful indexes
-- =========================================================

-- 4. 为订单状态创建索引
CREATE INDEX IF NOT EXISTS idx_orders_status
ON orders(status);

-- 5. 为订单时间创建索引
CREATE INDEX IF NOT EXISTS idx_orders_order_date
ON orders(order_date);

-- 6. 为 orders.customer_id 创建索引，用于 orders JOIN customers
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON orders(customer_id);

-- 7. 为 orders.store_id 创建索引，用于 orders JOIN stores
CREATE INDEX IF NOT EXISTS idx_orders_store_id
ON orders(store_id);

-- 8. 为 order_items.order_id 创建索引，用于 order_items JOIN orders
CREATE INDEX IF NOT EXISTS idx_order_items_order_id
ON order_items(order_id);

-- 9. 为 order_items.product_id 创建索引，用于 order_items JOIN products
CREATE INDEX IF NOT EXISTS idx_order_items_product_id
ON order_items(product_id);

-- 10. 为 products.category 创建索引，用于按分类筛选或统计
CREATE INDEX IF NOT EXISTS idx_products_category
ON products(category);


-- =========================================================
-- Part 4: Check created indexes
-- =========================================================

-- 11. 查看当前核心表上的索引
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename IN (
    'orders',
    'order_items',
    'products',
    'customers',
    'stores'
)
ORDER BY
    tablename,
    indexname;


-- =========================================================
-- Part 5: EXPLAIN after indexes
-- =========================================================

-- 12. 再次查看 completed 订单日期分析的执行计划
EXPLAIN ANALYZE
SELECT
    order_day,
    completed_order_count,
    total_sales_yen,
    total_cost_yen,
    total_profit_yen,
    profit_margin_percent
FROM v_daily_sales_summary
ORDER BY order_day;


-- 13. 查看基于基础表的 completed 订单查询执行计划
EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.customer_name,
    s.store_name,
    o.total_amount_yen
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
WHERE o.status = 'completed'
ORDER BY o.order_date;

-- =========================================================
-- Part 6: Force PostgreSQL to prefer indexes for learning
-- =========================================================

-- 14. 临时关闭顺序扫描，观察 status 索引是否会被使用
SET enable_seqscan = off;

EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    status,
    total_amount_yen
FROM orders
WHERE status = 'completed'
ORDER BY order_date;

-- 15. 恢复默认设置
SET enable_seqscan = on;

-- =========================================================
-- Part 7: Composite index
-- =========================================================

-- 16. 创建 status + order_date 的复合索引
CREATE INDEX IF NOT EXISTS idx_orders_status_order_date
ON orders(status, order_date);

-- 17. 临时关闭顺序扫描，观察复合索引是否会被使用
SET enable_seqscan = off;

EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    status,
    total_amount_yen
FROM orders
WHERE status = 'completed'
ORDER BY order_date;

-- 18. 恢复默认设置
SET enable_seqscan = on;