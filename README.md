# ☕ Monday Coffee Database Project

![Monday Coffee DB](<img width="1536" height="1024" alt="ChatGPT Image Sep 18, 2025, 09_15_07 PM" src="https://github.com/user-attachments/assets/fe5872ac-bb21-4b91-b83c-402aaad4645a" />
)

A PostgreSQL project simulating a **coffee shop database**.  
It covers database schema design, data import, and advanced queries for analytics.  


---

## 🗂️ Database Schema

**Database Name:** `Monday_coffee_db`

### Tables
- **city** → City information  
- **customers** → Customer details  
- **products** → Product catalog  
- **sales** → Sales transactions  

📌 **ER Diagram**  
![ERD]("C:\Users\Dell\Desktop\SQL Projects\Monday_coffee\ERD_SCHEMAS.pgerd.png")

---

## ⚙️ Setup Instructions

### 1. Create Database
```sql
CREATE DATABASE "Monday_coffee_db";
### 2. Load Schema
\i sql/Schemas.sql
3. Import Data
\copy products(product_id, product_name, price) 
FROM 'tables/products.csv' DELIMITER ',' CSV HEADER;

\copy sales(sale_id, sale_date, product_id, customer_id, total, rating) 
FROM 'tables/sales.csv' DELIMITER ',' CSV HEADER;

4. Run Advanced Queries
\i sql/Mondau_coffee_advance.sql

📊 Example Queries
1. Find average sales per customer per city
SELECT c.customer_id, ci.city_id, ROUND(AVG(s.total)::numeric, 2) AS avg_sales
FROM customers AS c
LEFT JOIN sales AS s ON c.customer_id = s.customer_id
JOIN city AS ci ON ci.city_id = c.city_id
GROUP BY c.customer_id, ci.city_id;

2. Top 5 products by sales amount
SELECT p.product_name, SUM(s.total) AS total_sales
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 5;

3. Customers with highest ratings
SELECT c.customer_name, AVG(s.rating) AS avg_rating
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_name
ORDER BY avg_rating DESC;

📌 Recommendations

Based on the analysis of sales, customers, and city data, the top three cities for new store openings are:

🏆 City 1: Pune

Average rent per customer is very low.

Highest total revenue among all cities.

Average sales per customer is also high.

🥈 City 2: Delhi

Highest estimated coffee consumers at 7.7 million.

Largest number of customers (68).

Average rent per customer is 330 (well under 500).

🥉 City 3: Jaipur

Highest number of customers at 69.

Average rent per customer is very low at 156.

Average sales per customer is 11.6k, making it highly profitable.

🚀 Features

Relational schema with primary/foreign keys

CSV-based sample data

Advanced queries (joins, grouping, aggregates)

ERD visualization and custom logo

Business insights for store expansion strategy

🛠️ Tools Used

PostgreSQL 17

pgAdmin / psql CLI

DBeaver (for ERD design)

👩‍💻 Author

Manasa Reddy
Graduate Student – Computer Science (Software Engineering & Data Analytics)



