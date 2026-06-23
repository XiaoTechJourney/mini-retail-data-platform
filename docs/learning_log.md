<a id="ja"></a>

# 📘 学習ログ

[<kbd>🌐 English ver ↓</kbd>](#en)

## ✅ Day 0: プロジェクト初期化

### 📚 学習内容

- GitHub リポジトリを作成
- リポジトリをローカルに clone
- プロジェクトのディレクトリ構成を作成
- プロジェクト状態ドキュメントを作成
- 学習ログを作成
- エラー記録用ドキュメントを作成

### 💡 今日の理解

GitHub は単にコードを保存する場所ではなく、プロジェクト全体の変更履歴を管理する中心です。

### 🎯 次の目標

PostgreSQL を立ち上げ、最初の SQL を学習します。

- `CREATE TABLE`
- `INSERT`
- `SELECT`

## ✅ Day 1: products テーブルと基本 SQL

### 📚 学習内容

最初のテーブル `products` を作成し、商品データの挿入と基本的な検索を練習しました。

### 🧮 学習した SQL

- `CREATE TABLE`
- `DROP TABLE IF EXISTS`
- `SERIAL PRIMARY KEY`
- `VARCHAR`
- `INTEGER`
- `NOT NULL`
- `CHECK`
- `DEFAULT CURRENT_TIMESTAMP`
- `INSERT INTO`
- `SELECT`
- `AS`
- `WHERE`
- `AND`
- `ORDER BY`
- `LIMIT`
- `ROUND`

### 💡 今日の理解

- `CREATE TABLE` はテーブル構造を作る
- `INSERT INTO` はデータを追加する
- `SELECT` はデータを取得する
- `WHERE` は行を絞り込む
- `ORDER BY` は結果の順番を決める
- `LIMIT` は返す行数を制限する
- `price_yen - cost_yen AS profit_yen` は一時的な計算列であり、実際に `products` テーブルへ保存される列ではない

### 📁 完成ファイル

- `sql/day01.sql`

### 🎯 次の目標

`WHERE`、`ORDER BY`、`LIMIT` をさらに練習し、集計関数と `GROUP BY` に進みます。

## ✅ Day 2: 集計、GROUP BY、HAVING、JOIN

### 📚 学習内容

商品データの集計に加えて、顧客・店舗・注文テーブルを作成し、複数テーブルを組み合わせる基本的な `JOIN` を練習しました。

### 🧮 学習した SQL

- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `GROUP BY`
- `HAVING`
- `EXTRACT`
- `AGE`
- `REFERENCES`
- `JOIN`
- テーブル別名: `orders o`, `customers c`, `stores s`

### 🧱 作成したテーブル

- 📦 `products`
- 👤 `customers`
- 🏬 `stores`
- 🧾 `orders`

### 💡 今日の理解

- 集計関数は複数行をまとめて 1 つの結果にする
- `GROUP BY` は指定した列ごとにデータをグループ化する
- `WHERE` は集計前の行を絞り込む
- `HAVING` は集計後のグループを絞り込む
- `JOIN` は別々のテーブルをキーでつなげて、より実務に近い分析を可能にする

### 📁 完成ファイル

- `sql/day02.sql`

### 🎯 次の目標

注文データをさらに実務的に分析します。

- 日別売上
- 店舗別売上ランキング
- 顧客別購入回数
- 注文明細テーブルの追加
- 商品と注文の関係を使った分析

---

<a id="en"></a>

# 📘 Learning Log

[<kbd>🇯🇵 日本語版 ↑</kbd>](#ja)

## ✅ Day 0: Project Initialization

### 📚 What I Learned

- Created the GitHub repository
- Cloned the repository locally
- Built the project directory structure
- Created the project state document
- Created the learning log
- Created the error tracking document

### 💡 Key Understanding

GitHub is not just a place to store code. It is the central place for managing the change history of the whole project.

### 🎯 Next Goal

Start PostgreSQL and learn the first SQL basics.

- `CREATE TABLE`
- `INSERT`
- `SELECT`

## ✅ Day 1: products Table and Basic SQL

### 📚 What I Learned

Created the first table, `products`, inserted product data, and practiced basic queries.

### 🧮 SQL Learned

- `CREATE TABLE`
- `DROP TABLE IF EXISTS`
- `SERIAL PRIMARY KEY`
- `VARCHAR`
- `INTEGER`
- `NOT NULL`
- `CHECK`
- `DEFAULT CURRENT_TIMESTAMP`
- `INSERT INTO`
- `SELECT`
- `AS`
- `WHERE`
- `AND`
- `ORDER BY`
- `LIMIT`
- `ROUND`

### 💡 Key Understanding

- `CREATE TABLE` creates a table structure
- `INSERT INTO` adds data
- `SELECT` reads data
- `WHERE` filters rows
- `ORDER BY` controls result order
- `LIMIT` controls how many rows are returned
- `price_yen - cost_yen AS profit_yen` is a temporary calculated column, not a real column stored in the `products` table

### 📁 Completed File

- `sql/day01.sql`

### 🎯 Next Goal

Practice `WHERE`, `ORDER BY`, and `LIMIT` more, then move into aggregate functions and `GROUP BY`.

## ✅ Day 2: Aggregates, GROUP BY, HAVING, and JOIN

### 📚 What I Learned

Practiced product aggregation, created customer, store, and order tables, and learned basic `JOIN` queries across multiple tables.

### 🧮 SQL Learned

- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `GROUP BY`
- `HAVING`
- `EXTRACT`
- `AGE`
- `REFERENCES`
- `JOIN`
- Table aliases: `orders o`, `customers c`, `stores s`

### 🧱 Tables Created

- 📦 `products`
- 👤 `customers`
- 🏬 `stores`
- 🧾 `orders`

### 💡 Key Understanding

- Aggregate functions summarize multiple rows into one result
- `GROUP BY` groups data by selected columns
- `WHERE` filters rows before aggregation
- `HAVING` filters groups after aggregation
- `JOIN` connects separate tables by keys and makes more realistic business analysis possible

### 📁 Completed File

- `sql/day02.sql`

### 🎯 Next Goal

Analyze order data in a more business-like way.

- Daily sales
- Store sales ranking
- Customer purchase counts
- Add an order detail table
- Analyze the relationship between products and orders
