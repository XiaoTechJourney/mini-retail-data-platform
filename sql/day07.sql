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

-- =========================================================
-- Part 5: Include the product that crosses 80 percent
-- =========================================================

-- 7. 找出达到至少 80% 累计利润所需的核心商品
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
),
ranked_with_previous AS (
    SELECT
        product_id,
        product_name,
        category,
        total_sales_yen,
        total_profit_yen,
        profit_rank,
        cumulative_profit_yen,
        cumulative_profit_percent,
        LAG(cumulative_profit_percent) OVER (
            ORDER BY profit_rank
        ) AS previous_cumulative_profit_percent
    FROM ranked_profit
)
SELECT
    product_id,
    product_name,
    category,
    total_sales_yen,
    total_profit_yen,
    profit_rank,
    cumulative_profit_yen,
    previous_cumulative_profit_percent,
    cumulative_profit_percent
FROM ranked_with_previous
WHERE
    cumulative_profit_percent <= 80
    OR previous_cumulative_profit_percent < 80
ORDER BY profit_rank;
-- =========================================================
-- Part 6: Product profit share within category
-- =========================================================

-- 8. 计算每个商品在所属分类中的利润贡献占比
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
    SUM(total_profit_yen) OVER (
        PARTITION BY category
    ) AS category_total_profit_yen,
    ROUND(
        total_profit_yen * 100.0
        / SUM(total_profit_yen) OVER (
            PARTITION BY category
        ),
        2
    ) AS category_profit_share_percent,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_profit_yen DESC
    ) AS category_profit_rank
FROM product_profit
ORDER BY
    category,
    category_profit_rank;

    -- =========================================================
-- Part 7: Cumulative profit share within category
-- =========================================================

-- 9. 每个分类内部，按商品利润排名，计算分类内累计利润占比
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
    ) AS category_profit_rank,
    SUM(total_profit_yen) OVER (
        PARTITION BY category
        ORDER BY total_profit_yen DESC
    ) AS category_cumulative_profit_yen,
    SUM(total_profit_yen) OVER (
        PARTITION BY category
    ) AS category_total_profit_yen,
    ROUND(
        SUM(total_profit_yen) OVER (
            PARTITION BY category
            ORDER BY total_profit_yen DESC
        ) * 100.0
        / SUM(total_profit_yen) OVER (
            PARTITION BY category
        ),
        2
    ) AS category_cumulative_profit_percent
FROM product_profit
ORDER BY
    category,
    category_profit_rank;

    -- =========================================================
-- Part 8: Daily cumulative sales and profit
-- =========================================================

-- 10. 按日期统计销售额和利润，并计算累计销售额、累计利润
WITH daily_sales AS (
    SELECT
        DATE(o.order_date) AS order_day,
        COUNT(DISTINCT o.order_id) AS completed_order_count,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY DATE(o.order_date)
)
SELECT
    order_day,
    completed_order_count,
    total_sales_yen,
    total_profit_yen,
    SUM(total_sales_yen) OVER (
        ORDER BY order_day
    ) AS cumulative_sales_yen,
    SUM(total_profit_yen) OVER (
        ORDER BY order_day
    ) AS cumulative_profit_yen
FROM daily_sales
ORDER BY order_day;
-- 11. 按日期统计销售额和利润，并计算与前一个 completed 销售日的差异
WITH daily_sales AS (
    SELECT
        DATE(o.order_date) AS order_day,
        COUNT(DISTINCT o.order_id) AS completed_order_count,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY DATE(o.order_date)
)
SELECT
    order_day,
    completed_order_count,
    total_sales_yen,
    LAG(total_sales_yen) OVER (
        ORDER BY order_day
    ) AS previous_sales_yen,
    total_sales_yen
        - LAG(total_sales_yen) OVER (
            ORDER BY order_day
        ) AS sales_diff_yen,
    total_profit_yen,
    LAG(total_profit_yen) OVER (
        ORDER BY order_day
    ) AS previous_profit_yen,
    total_profit_yen
        - LAG(total_profit_yen) OVER (
            ORDER BY order_day
        ) AS profit_diff_yen
FROM daily_sales
ORDER BY order_day;

-- =========================================================
-- Part 9: Moving average of daily sales and profit
-- =========================================================

-- 12. 计算最近 3 个 completed 销售日的移动平均销售额和利润
WITH daily_sales AS (
    SELECT
        DATE(o.order_date) AS order_day,
        COUNT(DISTINCT o.order_id) AS completed_order_count,
        SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
        SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY DATE(o.order_date)
)
SELECT
    order_day,
    completed_order_count,
    total_sales_yen,
    total_profit_yen,
    ROUND(
        AVG(total_sales_yen) OVER (
            ORDER BY order_day
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_sales_3_days,
    ROUND(
        AVG(total_profit_yen) OVER (
            ORDER BY order_day
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_profit_3_days
FROM daily_sales
ORDER BY order_day;