<a id="ja"></a>

# 🛒 Mini Retail Data Platform

[<kbd>🌐 English ver ↓</kbd>](#en)

## 📌 プロジェクト概要

このプロジェクトは、SQL とデータエンジニアリングをゼロから学ぶための小さな小売データ基盤です。

最初は PostgreSQL と基本的な SQL から始め、学習の進捗に合わせて BigQuery、Kafka、RabbitMQ へ段階的に広げていきます。

## 🎯 学習目標

- 🧱 SQL の基本構文を身につける
- 🐘 PostgreSQL でテーブル設計とクエリを練習する
- 🛍️ 小売業務データを使って分析クエリを書く
- 🏗️ データウェアハウスの基礎を学ぶ
- 🔎 BigQuery で分析系クエリを実行する
- ⚡ Kafka でリアルタイム注文イベントを扱う
- 📬 RabbitMQ で非同期タスクキューを扱う
- 📚 学習過程を GitHub に残し、ポートフォリオとして見せられる形にする

## 🏪 プロジェクトシナリオ

小型の小売システムを想定し、以下のデータを扱います。

- 📦 商品
- 👤 顧客
- 🏬 店舗
- 🧾 注文
- 🧺 注文明細
- 💳 支払い
- 📊 在庫

今後は、このデータを使って売上分析、在庫アラート、顧客セグメント、リアルタイム注文処理を学習します。

## 🧰 技術スタック

- 🐘 PostgreSQL
- 🧮 SQL
- 🐳 Docker
- 🐍 Python
- ☁️ BigQuery
- ⚡ Kafka
- 📬 RabbitMQ
- 🔧 Git / GitHub

## 🚦 現在の進捗

現在の段階: **Day 2**

- ✅ Day 0: プロジェクト初期化
- ✅ Day 1: `products` テーブル、基本的な `SELECT`、`WHERE`、`ORDER BY`、`LIMIT`
- ✅ Day 2: 集計関数、`GROUP BY`、`HAVING`、`customers` / `stores` / `orders`、基本的な `JOIN`

## 📁 ディレクトリ構成

```text
mini-retail-data-platform/
├── app/
├── bigquery/
├── data/
├── docs/
│   ├── errors_and_solutions.md
│   ├── learning_log.md
│   └── project_state.md
├── kafka/
├── rabbitmq/
├── sql/
│   ├── day01.sql
│   └── day02.sql
└── docker-compose.yml
```

## 📝 ドキュメント

- 📘 [学習ログ](docs/learning_log.md)
- 🧯 [エラーと解決方法](docs/errors_and_solutions.md)
- 🧭 [プロジェクト状態](docs/project_state.md)

## 🔄 更新方針

この README と各ドキュメントは、学習の進捗に合わせて継続的に更新します。

---

<a id="en"></a>

# 🛒 Mini Retail Data Platform

[<kbd>🇯🇵 日本語版 ↑</kbd>](#ja)

## 📌 Project Overview

This project is a small retail data platform for learning SQL and data engineering from the ground up.

It starts with PostgreSQL and basic SQL, then gradually expands into BigQuery, Kafka, and RabbitMQ as the learning progress grows.

## 🎯 Learning Goals

- 🧱 Learn core SQL syntax
- 🐘 Practice table design and queries with PostgreSQL
- 🛍️ Write business analysis queries using retail data
- 🏗️ Learn the basics of data warehouse modeling
- 🔎 Run analytical queries with BigQuery
- ⚡ Simulate real-time order events with Kafka
- 📬 Handle asynchronous task queues with RabbitMQ
- 📚 Build a GitHub project that can show the learning process clearly

## 🏪 Project Scenario

The project simulates a small retail system with the following data areas.

- 📦 Products
- 👤 Customers
- 🏬 Stores
- 🧾 Orders
- 🧺 Order details
- 💳 Payments
- 📊 Inventory

Later, this data will be used for sales analysis, inventory alerts, customer segmentation, and real-time order processing.

## 🧰 Tech Stack

- 🐘 PostgreSQL
- 🧮 SQL
- 🐳 Docker
- 🐍 Python
- ☁️ BigQuery
- ⚡ Kafka
- 📬 RabbitMQ
- 🔧 Git / GitHub

## 🚦 Current Progress

Current stage: **Day 2**

- ✅ Day 0: Project initialization
- ✅ Day 1: `products` table, basic `SELECT`, `WHERE`, `ORDER BY`, and `LIMIT`
- ✅ Day 2: aggregate functions, `GROUP BY`, `HAVING`, `customers` / `stores` / `orders`, and basic `JOIN`

## 📁 Directory Structure

```text
mini-retail-data-platform/
├── app/
├── bigquery/
├── data/
├── docs/
│   ├── errors_and_solutions.md
│   ├── learning_log.md
│   └── project_state.md
├── kafka/
├── rabbitmq/
├── sql/
│   ├── day01.sql
│   └── day02.sql
└── docker-compose.yml
```

## 📝 Documents

- 📘 [Learning Log](docs/learning_log.md)
- 🧯 [Errors and Solutions](docs/errors_and_solutions.md)
- 🧭 [Project State](docs/project_state.md)

## 🔄 Update Policy

This README and the project documents will be updated continuously as the learning progress moves forward.
