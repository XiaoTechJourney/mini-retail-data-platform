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

-- =========================================================
-- Part 6: Customer-level profit analysis
-- =========================================================

-- 6. 按顾客统计 completed 销售额、成本和利润
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
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
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 7: City-level profit analysis
-- =========================================================

-- 7. 按城市统计 completed 销售额、成本和利润
SELECT
    s.city,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
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
GROUP BY s.city
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 8: CTE for completed order item detail
-- =========================================================

-- 8. 使用 CTE 先整理 completed 订单明细，再查询结果
WITH completed_items AS (
    SELECT
        o.order_id,
        o.order_date,
        c.customer_id,
        c.customer_name,
        s.store_id,
        s.store_name,
        s.city,
        p.product_id,
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
)
SELECT *
FROM completed_items
ORDER BY
    order_id,
    product_id;
-- 9. 使用 CTE 按商品统计利润
WITH completed_items AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        oi.quantity,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
)
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS total_quantity,
    SUM(line_sales_yen) AS total_sales_yen,
    SUM(line_cost_yen) AS total_cost_yen,
    SUM(line_profit_yen) AS total_profit_yen,
    ROUND(
        SUM(line_profit_yen) * 100.0 / SUM(line_sales_yen),
        2
    ) AS profit_margin_percent
FROM completed_items
GROUP BY
    product_id,
    product_name,
    category
ORDER BY total_profit_yen DESC;
-- 10. 使用 CTE 筛选总利润大于等于 400 的商品
WITH completed_items AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        oi.quantity,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
)
SELECT
    product_id,
    product_name,
    category,
    SUM(line_sales_yen) AS total_sales_yen,
    SUM(line_profit_yen) AS total_profit_yen
FROM completed_items
GROUP BY
    product_id,
    product_name,
    category
HAVING SUM(line_profit_yen) >= 400
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 9: CASE WHEN - Product profit level
-- =========================================================

-- 11. 使用 CASE WHEN 给商品划分利润等级
WITH completed_items AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        oi.quantity,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
),
product_profit AS (
    SELECT
        product_id,
        product_name,
        category,
        SUM(quantity) AS total_quantity,
        SUM(line_sales_yen) AS total_sales_yen,
        SUM(line_cost_yen) AS total_cost_yen,
        SUM(line_profit_yen) AS total_profit_yen,
        ROUND(
            SUM(line_profit_yen) * 100.0 / SUM(line_sales_yen),
            2
        ) AS profit_margin_percent
    FROM completed_items
    GROUP BY
        product_id,
        product_name,
        category
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    profit_margin_percent,
    CASE
        WHEN total_profit_yen >= 500 THEN 'high_profit'
        WHEN total_profit_yen >= 200 THEN 'middle_profit'
        ELSE 'low_profit'
    END AS profit_level
FROM product_profit
ORDER BY total_profit_yen DESC;

-- 12. 按利润等级统计商品数量、销售额和利润
WITH completed_items AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        oi.quantity,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
),
product_profit AS (
    SELECT
        product_id,
        product_name,
        category,
        SUM(quantity) AS total_quantity,
        SUM(line_sales_yen) AS total_sales_yen,
        SUM(line_cost_yen) AS total_cost_yen,
        SUM(line_profit_yen) AS total_profit_yen
    FROM completed_items
    GROUP BY
        product_id,
        product_name,
        category
),
product_profit_level AS (
    SELECT
        product_id,
        product_name,
        category,
        total_sales_yen,
        total_profit_yen,
        CASE
            WHEN total_profit_yen >= 500 THEN 'high_profit'
            WHEN total_profit_yen >= 200 THEN 'middle_profit'
            ELSE 'low_profit'
        END AS profit_level
    FROM product_profit
)
SELECT
    profit_level,
    COUNT(*) AS product_count,
    SUM(total_sales_yen) AS total_sales_yen,
    SUM(total_profit_yen) AS total_profit_yen
FROM product_profit_level
GROUP BY profit_level
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 10: CASE WHEN - Customer value level
-- =========================================================

-- 13. 按顾客消费金额划分顾客等级
WITH completed_items AS (
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_id,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
),
customer_profit AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(DISTINCT order_id) AS completed_order_count,
        SUM(line_sales_yen) AS total_sales_yen,
        SUM(line_cost_yen) AS total_cost_yen,
        SUM(line_profit_yen) AS total_profit_yen
    FROM completed_items
    GROUP BY
        customer_id,
        customer_name
)
SELECT
    customer_id,
    customer_name,
    completed_order_count,
    total_sales_yen,
    total_profit_yen,
    CASE
        WHEN total_sales_yen >= 1000 THEN 'vip'
        WHEN total_sales_yen >= 500 THEN 'regular'
        ELSE 'low_value'
    END AS customer_level
FROM customer_profit
ORDER BY total_sales_yen DESC;

-- =========================================================
-- Part 11: Customer level summary
-- =========================================================

-- 14. 按顾客等级汇总销售额和利润
WITH completed_items AS (
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_id,
        oi.quantity * oi.unit_price_yen AS line_sales_yen,
        oi.quantity * p.cost_yen AS line_cost_yen,
        oi.quantity * (oi.unit_price_yen - p.cost_yen) AS line_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
),
customer_profit AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(DISTINCT order_id) AS completed_order_count,
        SUM(line_sales_yen) AS total_sales_yen,
        SUM(line_cost_yen) AS total_cost_yen,
        SUM(line_profit_yen) AS total_profit_yen
    FROM completed_items
    GROUP BY
        customer_id,
        customer_name
),
customer_level AS (
    SELECT
        customer_id,
        customer_name,
        completed_order_count,
        total_sales_yen,
        total_cost_yen,
        total_profit_yen,
        CASE
            WHEN total_sales_yen >= 1000 THEN 'vip'
            WHEN total_sales_yen >= 500 THEN 'regular'
            ELSE 'low_value'
        END AS customer_level
    FROM customer_profit
)
SELECT
    customer_level,
    COUNT(*) AS customer_count,
    SUM(completed_order_count) AS completed_order_count,
    SUM(total_sales_yen) AS total_sales_yen,
    SUM(total_profit_yen) AS total_profit_yen,
    ROUND(AVG(total_sales_yen), 2) AS avg_sales_per_customer,
    ROUND(AVG(total_profit_yen), 2) AS avg_profit_per_customer
FROM customer_level
GROUP BY customer_level
ORDER BY total_profit_yen DESC;