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