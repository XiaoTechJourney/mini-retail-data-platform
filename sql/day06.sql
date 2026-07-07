-- =========================================================
-- Day 6: Date and Time Analysis
-- =========================================================

-- 前提：
-- products, customers, stores, orders, order_items 已经存在
-- 只统计 completed 订单

-- =========================================================
-- Part 1: Daily sales analysis
-- =========================================================

-- 1. 按日期统计 completed 订单数、销售额和利润
SELECT
    DATE(o.order_date) AS order_day,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * p.cost_yen) AS total_cost_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY DATE(o.order_date)
ORDER BY order_day;


-- =========================================================
-- Part 2: Day of week analysis
-- =========================================================

-- 2. 按星期几统计 completed 订单数、销售额和利润
SELECT
    EXTRACT(DOW FROM o.order_date) AS day_of_week_number,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY EXTRACT(DOW FROM o.order_date)
ORDER BY day_of_week_number;


-- =========================================================
-- Part 3: Hourly sales analysis
-- =========================================================

-- 3. 按小时统计 completed 订单数、销售额和利润
SELECT
    EXTRACT(HOUR FROM o.order_date) AS order_hour,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY EXTRACT(HOUR FROM o.order_date)
ORDER BY order_hour;

-- =========================================================
-- Part 4: Day of week name analysis
-- =========================================================

-- 4. 按星期几统计 completed 销售额和利润，并显示星期名称
SELECT
    EXTRACT(DOW FROM o.order_date) AS day_of_week_number,
    CASE
        WHEN EXTRACT(DOW FROM o.order_date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM o.order_date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM o.order_date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM o.order_date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM o.order_date) = 6 THEN 'Saturday'
    END AS day_of_week_name,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    EXTRACT(DOW FROM o.order_date),
    CASE
        WHEN EXTRACT(DOW FROM o.order_date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM o.order_date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM o.order_date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM o.order_date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM o.order_date) = 6 THEN 'Saturday'
    END
ORDER BY day_of_week_number;

-- =========================================================
-- Part 4: Day of week name analysis
-- =========================================================

-- 4. 按星期几统计 completed 销售额和利润，并显示星期名称
SELECT
    EXTRACT(DOW FROM o.order_date) AS day_of_week_number,
    CASE
        WHEN EXTRACT(DOW FROM o.order_date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM o.order_date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM o.order_date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM o.order_date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM o.order_date) = 6 THEN 'Saturday'
    END AS day_of_week_name,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    EXTRACT(DOW FROM o.order_date),
    CASE
        WHEN EXTRACT(DOW FROM o.order_date) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM o.order_date) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM o.order_date) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM o.order_date) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM o.order_date) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM o.order_date) = 6 THEN 'Saturday'
    END
ORDER BY day_of_week_number;

-- =========================================================
-- Part 5: Top sales day
-- =========================================================

-- 5. 找出 completed 销售额最高的日期
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
ORDER BY total_sales_yen DESC
LIMIT 1;

-- 6. 找出 completed 利润最高的日期
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
ORDER BY total_profit_yen DESC
LIMIT 1;

-- =========================================================
-- Part 6: Time period analysis
-- =========================================================

-- 7. 按时间段统计 completed 订单数、销售额和利润
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END AS time_period,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END
ORDER BY total_sales_yen DESC;

-- 8. 按日期和时间段统计 completed 销售额和利润
SELECT
    DATE(o.order_date) AS order_day,
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END AS time_period,
    COUNT(DISTINCT o.order_id) AS completed_order_count,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen,
    SUM(oi.quantity * (oi.unit_price_yen - p.cost_yen)) AS total_profit_yen
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    DATE(o.order_date),
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END
ORDER BY
    order_day,
    time_period;

    -- =========================================================
-- Part 7: Time period profit margin analysis
-- =========================================================

-- 9. 按时间段统计 completed 销售额、成本、利润和利润率
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END AS time_period,
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
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY
    CASE
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 0 AND 11 THEN 'morning'
        WHEN EXTRACT(HOUR FROM o.order_date) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END
ORDER BY total_profit_yen DESC;

-- 10. 按日期统计 completed 销售额、成本、利润和利润率
SELECT
    DATE(o.order_date) AS order_day,
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
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY DATE(o.order_date)
ORDER BY profit_margin_percent DESC;
-- =========================================================
-- Part 8: DATE_TRUNC weekly and monthly analysis
-- =========================================================

-- 11. 按周统计 completed 销售额、成本、利润和利润率
SELECT
    DATE_TRUNC('week', o.order_date)::DATE AS order_week,
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
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY DATE_TRUNC('week', o.order_date)::DATE
ORDER BY order_week;


-- 12. 按月统计 completed 销售额、成本、利润和利润率
SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS order_month,
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
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY DATE_TRUNC('month', o.order_date)::DATE
ORDER BY order_month;