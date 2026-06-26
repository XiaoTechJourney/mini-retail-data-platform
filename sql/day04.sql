-- =========================================================
-- Day 4: order_items table and product sales analysis
-- =========================================================

-- 订单明细表 order_items
-- 作用：记录每笔订单中具体购买了哪些商品、数量和单价
-- 前提：products 和 orders 表已经存在

DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_yen INTEGER NOT NULL CHECK (unit_price_yen > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- =========================================================
-- Part 1: Insert order item data
-- =========================================================

INSERT INTO order_items (order_id, product_id, quantity, unit_price_yen)
VALUES
    (1, 3, 1, 680),

    (2, 1, 1, 180),
    (2, 2, 1, 150),

    (3, 4, 1, 1280),

    (4, 6, 1, 498),

    (5, 10, 1, 980),

    (6, 9, 1, 398),

    (7, 5, 1, 160),

    (8, 3, 1, 680),
    (8, 8, 1, 130),

    (9, 2, 1, 150),

    (10, 4, 1, 1280),

    (11, 6, 1, 498),
    (11, 1, 1, 180),

    (12, 10, 1, 980);
    -- =========================================================
-- Part 2: Basic SELECT for order_items
-- =========================================================

-- 1. 查询全部订单明细
SELECT *
FROM order_items;

-- 2. 查询每条明细的小计金额
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price_yen,
    quantity * unit_price_yen AS line_amount_yen
FROM order_items;

-- 3. 查询 order_id = 2 的订单明细
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price_yen,
    quantity * unit_price_yen AS line_amount_yen
FROM order_items
WHERE order_id = 2;

-- =========================================================
-- Part 3: Check order total consistency
-- =========================================================

-- 4. 检查 orders.total_amount_yen 是否等于 order_items 明细合计
SELECT
    o.order_id,
    o.total_amount_yen AS order_total_yen,
    SUM(oi.quantity * oi.unit_price_yen) AS item_total_yen,
    SUM(oi.quantity * oi.unit_price_yen) - o.total_amount_yen AS diff_yen
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.total_amount_yen
HAVING o.total_amount_yen <> SUM(oi.quantity * oi.unit_price_yen)
ORDER BY o.order_id;

-- =========================================================
-- Part 4: Fix inconsistent order total
-- =========================================================

-- 5. 修正 order_id = 11 的订单总金额
UPDATE orders
SET total_amount_yen = 678
WHERE order_id = 11;

-- 6. 再次检查是否还有不一致的订单
SELECT
    o.order_id,
    o.total_amount_yen AS order_total_yen,
    SUM(oi.quantity * oi.unit_price_yen) AS item_total_yen,
    SUM(oi.quantity * oi.unit_price_yen) - o.total_amount_yen AS diff_yen
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.total_amount_yen
HAVING o.total_amount_yen <> SUM(oi.quantity * oi.unit_price_yen)
ORDER BY o.order_id;

-- =========================================================
-- Part 5: JOIN order_items and products
-- =========================================================

-- 7. 查询订单明细，并显示商品名称和分类
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price_yen,
    oi.quantity * oi.unit_price_yen AS line_amount_yen
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
ORDER BY
    oi.order_id,
    oi.order_item_id;

    -- =========================================================
-- Part 6: Product sales analysis
-- =========================================================

-- 8. 按商品统计 completed 订单中的销售数量和销售额
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_sales_yen DESC;

-- 9. 按商品分类统计 completed 订单中的销售数量和销售额
SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price_yen) AS total_sales_yen
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY total_sales_yen DESC;


