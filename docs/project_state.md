<a id="ja"></a>

# 🧭 プロジェクト状態

[<kbd>🌐 English ver ↓</kbd>](#en)

## 🏷️ プロジェクト名

**Mini Retail Data Platform**

## 🚦 現在の段階

**Day 2 完了: 集計分析、複数テーブル、基本 JOIN**

## 🐘 現在のデータベース

- データベース: `retail_db`
- PostgreSQL コンテナ: `mini_retail_postgres`
- ユーザー: `retail_user`

## 🧱 現在のテーブル

- 📦 `products`
- 👤 `customers`
- 🏬 `stores`
- 🧾 `orders`

## 📄 現在の SQL ファイル

- `sql/day01.sql`
- `sql/day02.sql`

## ✅ 完了した内容

- 🐳 Docker で PostgreSQL を起動
- 🐘 `retail_db` データベース環境を作成
- 📦 `products` 商品テーブルを作成
- 👤 `customers` 顧客テーブルを作成
- 🏬 `stores` 店舗テーブルを作成
- 🧾 `orders` 注文テーブルを作成
- 🧪 サンプルデータを挿入
- 🔎 基本的な `SELECT` を実行
- 🎯 `WHERE` で条件検索
- 📊 `ORDER BY` と `LIMIT` で並び替えと件数制限
- 🧮 `COUNT` / `SUM` / `AVG` / `MIN` / `MAX` で集計
- 🧩 `GROUP BY` でカテゴリ別・性別別・店舗別に集計
- 🧹 `HAVING` で集計後のグループを絞り込み
- 🔗 `JOIN` で注文と顧客、注文と店舗を結合

## 🧮 学習済み SQL

- `CREATE TABLE`
- `DROP TABLE IF EXISTS`
- `INSERT INTO`
- `SELECT`
- `FROM`
- `WHERE`
- `AND`
- `ORDER BY`
- `LIMIT`
- `AS`
- `ROUND`
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

## 💡 現在の理解ポイント

- `SELECT` は表示する列を決める
- `WHERE` は集計前の行を絞り込む
- `ORDER BY` は結果の順番を決める
- `LIMIT` は返す行数を制限する
- `GROUP BY` は指定した列ごとにデータをまとめる
- `HAVING` は集計後のグループを絞り込む
- `JOIN` は別々のテーブルをキーで接続する
- 外部キー `REFERENCES` により、注文データが顧客・店舗データと関連付く

## 🎯 次のタスク

Day 3 では注文データをさらに実務に近い形で分析します。

- 📅 日別売上を集計する
- 🏬 店舗別売上ランキングを作る
- 👤 顧客別の購入回数と購入金額を分析する
- 🧺 注文明細テーブルを追加する
- 📦 商品と注文をつないだ売上分析に進む

---

<a id="en"></a>

# 🧭 Project State

[<kbd>🇯🇵 日本語版 ↑</kbd>](#ja)

## 🏷️ Project Name

**Mini Retail Data Platform**

## 🚦 Current Stage

**Day 2 completed: aggregate analysis, multiple tables, and basic JOIN**

## 🐘 Current Database

- Database: `retail_db`
- PostgreSQL container: `mini_retail_postgres`
- User: `retail_user`

## 🧱 Current Tables

- 📦 `products`
- 👤 `customers`
- 🏬 `stores`
- 🧾 `orders`

## 📄 Current SQL Files

- `sql/day01.sql`
- `sql/day02.sql`

## ✅ Completed Work

- 🐳 Started PostgreSQL with Docker
- 🐘 Created the `retail_db` database environment
- 📦 Created the `products` table
- 👤 Created the `customers` table
- 🏬 Created the `stores` table
- 🧾 Created the `orders` table
- 🧪 Inserted sample data
- 🔎 Ran basic `SELECT` queries
- 🎯 Filtered rows with `WHERE`
- 📊 Sorted and limited results with `ORDER BY` and `LIMIT`
- 🧮 Aggregated data with `COUNT` / `SUM` / `AVG` / `MIN` / `MAX`
- 🧩 Grouped data by category, gender, and store with `GROUP BY`
- 🧹 Filtered aggregated groups with `HAVING`
- 🔗 Joined orders with customers and stores using `JOIN`

## 🧮 SQL Learned

- `CREATE TABLE`
- `DROP TABLE IF EXISTS`
- `INSERT INTO`
- `SELECT`
- `FROM`
- `WHERE`
- `AND`
- `ORDER BY`
- `LIMIT`
- `AS`
- `ROUND`
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

## 💡 Current Understanding

- `SELECT` controls which columns are displayed
- `WHERE` filters rows before aggregation
- `ORDER BY` controls result order
- `LIMIT` controls how many rows are returned
- `GROUP BY` groups data by selected columns
- `HAVING` filters groups after aggregation
- `JOIN` connects separate tables by keys
- Foreign keys with `REFERENCES` connect order data to customer and store data

## 🎯 Next Tasks

Day 3 will analyze order data in a more realistic business style.

- 📅 Aggregate daily sales
- 🏬 Build store sales rankings
- 👤 Analyze customer purchase counts and total spending
- 🧺 Add an order detail table
- 📦 Move into sales analysis that connects products and orders
