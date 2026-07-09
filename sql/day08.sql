-- =========================================================
-- Day 8: Views for reusable analysis
-- =========================================================

-- 目的：
-- 把 completed 订单明细的多表 JOIN 封装成一个可复用视图
-- 后续销售额、利润、日期、商品、门店分析都可以直接基于这个视图写

-- =========================================================
-- Part 0: Drop existing views
-- =========================================================

-- 注意：
-- v_product_profit_summary 和 v_daily_sales_summary 依赖 v_completed_order_items
-- 所以必须先删除子视图，再删除基础视图

DROP VIEW IF EXISTS v_product_profit_summary;
DROP VIEW IF EXISTS v_daily_sales_summary;
DROP VIEW IF EXISTS v_completed_order_items;


-- =========================================================
-- Part 1: Create a completed order items view
-- =========================================================

CREATE VIEW v_completed_order_items AS
SELECT
    oi.order_item_id,
    o.order_id,
    o.order_date,
    DATE(o.order_date) AS order_day,
    EXTRACT(HOUR FROM o.order_date) AS order_hour,
    o.status,

    c.customer_id,
    c.customer_name,
    c.gender,

    s.store_id,
    s.store_name,
    s.city,
    s.store_type,

    p.product_id,
    p.product_name,
    p.category,

    oi.quantity,
    oi.unit_price_yen,
    p.cost_yen,

    oi.quantity * oi.unit_price_yen AS sales_amount_yen,
    oi.quantity * p.cost_yen AS cost_amount_yen,
    oi.quantity * (oi.unit_price_yen - p.cost_yen) AS profit_amount_yen

FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
WHERE o.status = 'completed';


-- =========================================================
-- Part 2: Check the view data
-- =========================================================

-- 1. 查看 completed 订单明细视图
SELECT
    order_item_id,
    order_id,
    order_day,
    order_hour,
    customer_name,
    store_name,
    city,
    product_name,
    category,
    quantity,
    sales_amount_yen,
    cost_amount_yen,
    profit_amount_yen
FROM v_completed_order_items
ORDER BY
    order_id,
    order_item_id;


-- =========================================================
-- Part 3: Product profit analysis using the view
-- =========================================================

-- 2. 使用视图按商品统计销售额、成本、利润和利润率
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 4: Daily sales analysis using the view
-- =========================================================

-- 3. 使用视图按日期统计销售额、成本、利润和利润率
SELECT
    order_day,
    COUNT(DISTINCT order_id) AS completed_order_count,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY order_day
ORDER BY order_day;


-- =========================================================
-- Part 5: Category profit analysis using the view
-- =========================================================

-- 4. 使用视图按商品分类统计销售额、成本、利润和利润率
SELECT
    category,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY category
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 6: Store profit analysis using the view
-- =========================================================

-- 5. 使用视图按门店统计销售额、成本、利润和利润率
SELECT
    store_id,
    store_name,
    city,
    store_type,
    COUNT(DISTINCT order_id) AS completed_order_count,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY
    store_id,
    store_name,
    city,
    store_type
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 7: Customer profit analysis using the view
-- =========================================================

-- 6. 使用视图按顾客统计销售额、成本、利润和利润率
SELECT
    customer_id,
    customer_name,
    gender,
    COUNT(DISTINCT order_id) AS completed_order_count,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY
    customer_id,
    customer_name,
    gender
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 8: Create product profit summary view
-- =========================================================

CREATE VIEW v_product_profit_summary AS
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY
    product_id,
    product_name,
    category;


-- 7. 查询商品利润汇总视图
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
-- Part 9: Create daily sales summary view
-- =========================================================

CREATE VIEW v_daily_sales_summary AS
SELECT
    order_day,
    COUNT(DISTINCT order_id) AS completed_order_count,
    SUM(sales_amount_yen) AS total_sales_yen,
    SUM(cost_amount_yen) AS total_cost_yen,
    SUM(profit_amount_yen) AS total_profit_yen,
    ROUND(
        SUM(profit_amount_yen) * 100.0
        / SUM(sales_amount_yen),
        2
    ) AS profit_margin_percent
FROM v_completed_order_items
GROUP BY order_day;


-- 8. 查询日期销售汇总视图
SELECT
    order_day,
    completed_order_count,
    total_sales_yen,
    total_cost_yen,
    total_profit_yen,
    profit_margin_percent
FROM v_daily_sales_summary
ORDER BY order_day;