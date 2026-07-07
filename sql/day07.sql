-- =========================================================
-- Day 7: Window Functions
-- =========================================================

-- 前提：
-- products, orders, order_items 已经存在
-- 只分析 completed 订单

-- =========================================================
-- Part 1: Product profit ranking
-- =========================================================

-- 1. 按商品统计利润，并使用 ROW_NUMBER 做排名
WITH product_profit AS (
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
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    profit_margin_percent,
    ROW_NUMBER() OVER (
        ORDER BY total_profit_yen DESC
    ) AS profit_rank
FROM product_profit
ORDER BY profit_rank;
-- =========================================================
-- Part 2: ROW_NUMBER vs RANK vs DENSE_RANK
-- =========================================================

-- 2. 对比 ROW_NUMBER, RANK, DENSE_RANK
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
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
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    ROW_NUMBER() OVER (
        ORDER BY total_profit_yen DESC
    ) AS row_number_rank,
    RANK() OVER (
        ORDER BY total_profit_yen DESC
    ) AS rank_rank,
    DENSE_RANK() OVER (
        ORDER BY total_profit_yen DESC
    ) AS dense_rank_rank
FROM product_profit
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 3: Ranking products within each category
-- =========================================================

-- 3. 每个商品分类内部，按商品利润排名
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
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
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_profit_yen DESC
    ) AS category_profit_rank
FROM product_profit
ORDER BY
    category,
    category_profit_rank;

-- 4. 每个商品分类中，取利润最高的商品
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
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
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        category,
        total_sales_yen,
        total_profit_yen,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_profit_yen DESC
        ) AS category_profit_rank
    FROM product_profit
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    category_profit_rank
FROM ranked_products
WHERE category_profit_rank = 1
ORDER BY total_profit_yen DESC;

-- =========================================================
-- Part 4: Cumulative sales and profit
-- =========================================================

-- 5. 按商品利润排名，计算累计销售额、累计利润和累计利润占比
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
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
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    ROW_NUMBER() OVER (
        ORDER BY total_profit_yen DESC
    ) AS profit_rank,
    SUM(total_sales_yen) OVER (
        ORDER BY total_profit_yen DESC
    ) AS cumulative_sales_yen,
    SUM(total_profit_yen) OVER (
        ORDER BY total_profit_yen DESC
    ) AS cumulative_profit_yen,
    ROUND(
        SUM(total_profit_yen) OVER (
            ORDER BY total_profit_yen DESC
        ) * 100.0
        / SUM(total_profit_yen) OVER (),
        2
    ) AS cumulative_profit_percent
FROM product_profit
ORDER BY profit_rank;

-- 6. 找出累计利润占比在 80% 以内的核心商品
WITH product_profit AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
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
),
ranked_profit AS (
    SELECT
        product_id,
        product_name,
        category,
        total_sales_yen,
        total_profit_yen,
        ROW_NUMBER() OVER (
            ORDER BY total_profit_yen DESC
        ) AS profit_rank,
        SUM(total_profit_yen) OVER (
            ORDER BY total_profit_yen DESC
        ) AS cumulative_profit_yen,
        ROUND(
            SUM(total_profit_yen) OVER (
                ORDER BY total_profit_yen DESC
            ) * 100.0
            / SUM(total_profit_yen) OVER (),
            2
        ) AS cumulative_profit_percent
    FROM product_profit
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    profit_rank,
    cumulative_profit_yen,
    cumulative_profit_percent
FROM ranked_profit
WHERE cumulative_profit_percent <= 80
ORDER BY profit_rank;
