# Project State

## 项目名称

Mini Retail Data Platform

## 当前阶段

Day 1 完成：SQL 基础入门

## 当前数据库

数据库：retail_db

当前表：

- products

## 当前 SQL 文件

- sql/day01.sql

## 已完成内容

- 使用 Docker 启动 PostgreSQL
- 创建 retail_db 数据库环境
- 创建 products 商品表
- 插入 10 条商品数据
- 查询全部商品
- 查询指定列
- 计算商品利润
- 计算商品利润率
- 使用 WHERE 筛选数据
- 使用 AND 组合条件
- 使用 ORDER BY 排序
- 使用 LIMIT 查询 Top N 商品

## 已学习 SQL

- CREATE TABLE
- DROP TABLE IF EXISTS
- INSERT INTO
- SELECT
- FROM
- WHERE
- AND
- ORDER BY
- LIMIT
- AS
- ROUND

## 当前理解重点

- SELECT 决定显示哪些列
- WHERE 决定保留哪些行
- ORDER BY 决定结果排序
- LIMIT 决定返回多少行
- 可以在 SELECT 中计算临时列，例如 price_yen - cost_yen AS profit_yen

## 下一步任务

Day 2：进一步练习查询，并进入聚合分析。

计划学习：

- COUNT
- SUM
- AVG
- MIN
- MAX
- GROUP BY
- 按 category 统计商品数量、平均价格、平均利润
