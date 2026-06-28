-- =========================================================
-- Day 5: Profit Analysis
-- =========================================================

-- 前提：
-- products, customers, stores, orders, order_items 已经存在
-- Day 4 已经修正 order_id = 11 的订单金额为 678

-- =========================================================
-- Part 1: Check completed sales consistency
-- =========================================================

-- 1. 检查 completed 订单总金额和 order_items 明细合计是否一致
SELECT
    SUM(o.total_amount_yen) AS completed_order_total_yen,
    (
        SELECT
            SUM(oi.quantity * oi.unit_price_yen)
        FROM order_items oi
        JOIN orders o2
            ON oi.order_id = o2.order_id
        WHERE o2.status = 'completed'
    ) AS completed_item_total_yen
FROM orders o
WHERE o.status = 'completed';


-- =========================================================
-- Part 2: Completed order item profit detail
-- =========================================================

-- 2. 查询 completed 订单明细的销售额、成本和利润
SELECT
    o.order_id,
    c.customer_name,
    s.store_name,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price_yen,
    p.cost_yen,
    oi.quantity * oi.unit_price_yen AS line_sales_yen,
    oi.quantity * p.cost_yen AS line_cost_yen,
    oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN stores s
    ON o.store_id = s.store_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
ORDER BY
    o.order_id,
    oi.order_item_id;


-- =========================================================
-- Part 3: Product-level profit analysis
-- =========================================================

-- 3. 按商品统计 completed 销售额、成本和利润
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * p.cost_yen) AS total_cost_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) * 100.0
        / SUM(oi.quantity * oi.unit_price_yen),
        2
    ) AS profit_margin_percent
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 4: Category-level profit analysis
-- =========================================================

-- 4. 按商品分类统计 completed 销售额、成本和利润
SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * p.cost_yen) AS total_cost_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) * 100.0
        / SUM(oi.quantity * oi.unit_price_yen),
        2
    ) AS profit_margin_percent
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY total_profit_yen DESC;


-- =========================================================
-- Part 5: Store-level profit analysis
-- =========================================================

-- 5. 按门店统计 completed 销售额、成本和利润
SELECT
    s.store_id,
    s.store_name,
    s.city,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * p.cost_yen) AS total_cost_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen,
    ROUND(
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) * 100.0
        / SUM(oi.quantity * oi.unit_price_yen),
        2
    ) AS profit_margin_percent
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN stores s
    ON o.store_id = s.store_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    s.store_id,
    s.store_name,
    s.city
ORDER BY total_profit_yen DESC;