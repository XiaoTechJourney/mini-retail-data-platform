# Learning Log

## Day 0

### 学习内容

- 创建 GitHub 仓库
- clone 仓库到本地
- 建立项目目录结构
- 创建项目状态文档
- 创建学习记录文档
- 创建错误记录文档

### 今日重点

理解 GitHub 不是单纯存代码的地方，而是整个项目的版本管理中心。

### 明日目标

搭建 PostgreSQL，并开始学习最基础的 SQL：

- CREATE TABLE
- INSERT
- SELECT
## Day 1

### 学习内容

今天完成了第一张表 products 的创建、数据插入和基础查询。

### 已学习 SQL

- CREATE TABLE
- DROP TABLE IF EXISTS
- SERIAL PRIMARY KEY
- VARCHAR
- INTEGER
- NOT NULL
- CHECK
- DEFAULT CURRENT_TIMESTAMP
- INSERT INTO
- SELECT
- AS
- WHERE
- AND
- ORDER BY
- LIMIT
- ROUND

### 今日理解

CREATE TABLE 用来创建表结构，INSERT INTO 用来插入数据，SELECT 用来查询数据。

SELECT 决定显示哪些列，WHERE 决定保留哪些行，ORDER BY 决定结果顺序，LIMIT 决定返回多少行。

profit_yen 是通过 price_yen - cost_yen 临时计算出来的结果列，不是真的存进 products 表。

### 今日完成文件

- sql/day01.sql

### 当前状态

Day 1 SQL 基础完成。下一步进入 Day 2：继续练习 WHERE、ORDER BY、LIMIT，并开始接触 GROUP BY 和聚合函数。
