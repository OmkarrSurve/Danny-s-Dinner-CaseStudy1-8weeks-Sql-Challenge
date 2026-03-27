# 🍜 Case Study #1 — Danny's Diner

> **8 Week SQL Challenge** by Danny Ma | Tool: PostgreSQL 18

---

## 📌 Overview

Danny's Diner is a small Japanese restaurant that sells sushi, curry, and ramen. Danny wants to use his first few months of sales data to better understand customer behaviour, identify favourite items, and decide whether to expand his loyalty program.

This case study involves writing SQL queries against 3 relational tables to answer 10 business questions and 2 bonus challenges.

---

## 🗃️ Dataset

Three tables within the `dannys_diner` schema:

### `sales`
| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | VARCHAR | Unique customer identifier |
| `order_date` | DATE | Date of the purchase |
| `product_id` | INTEGER | ID of the item ordered |

### `menu`
| Column | Type | Description |
|--------|------|-------------|
| `product_id` | INTEGER | Unique product identifier |
| `product_name` | VARCHAR | Name of the menu item |
| `price` | INTEGER | Price in dollars |

### `members`
| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | VARCHAR | Customer identifier |
| `join_date` | DATE | Date they joined the loyalty program |

---

## ❓ Case Study Questions

| # | Question |
|---|----------|
| 1 | What is the total amount each customer spent at the restaurant? |
| 2 | How many days has each customer visited the restaurant? |
| 3 | What was the first item purchased by each customer? |
| 4 | What is the most purchased item and how many times was it purchased? |
| 5 | Which item was most popular for each customer? |
| 6 | Which item was purchased first after a customer became a member? |
| 7 | Which item was purchased just before a customer became a member? |
| 8 | What is the total items and amount spent before becoming a member? |
| 9 | How many points would each customer have? (sushi = 2x multiplier) |
| 10 | How many points do A and B have at the end of January with the first-week 2x bonus? |

### Bonus Questions
- **Join All The Things** — Recreate a combined table with a `member` Y/N flag
- **Rank All The Things** — Add member-only purchase rankings (NULL for non-members)

---

## 💡 Key Insights

| Finding | Detail |
|---------|--------|
| 🍜 Most ordered item | **Ramen** — ordered 8 times across all customers |
| 💰 Highest spender | **Customer A** — $76 total |
| 📅 Most frequent visitor | **Customer B** — 6 unique visit days |
| ⭐ Most points earned | **Customer A** — 1,370 points in January |
| 🎯 Pre-membership favourite | Both A and B ordered **sushi** just before joining |

---

## 🛠️ SQL Concepts Used

- `JOIN` and `LEFT JOIN` across multiple tables
- `GROUP BY` with aggregate functions (`SUM`, `COUNT`)
- `CASE WHEN` for conditional logic (membership flag, points multiplier)
- Window functions — `DENSE_RANK()`, `ROW_NUMBER()`, `RANK()`
- `PARTITION BY` for per-customer rankings
- CTEs (`WITH`) for readable multi-step queries
- `INTERVAL` for date arithmetic (first-week membership window)
- `DISTINCT` to deduplicate results

---

## 📁 Repository Structure

```
dannys-diner/
│
├── case1.sql    # Schema setup + all 10 questions + 2 bonus queries
└── README.md           # Project documentation
```

---

## 🚀 How to Run

1. Open your local PostgreSQL client
2. Copy and run the full `case1.sql` file
3. Each query is labelled and includes expected output in the comments



---

## 📚 Source

This is Case Study #1 from the [8 Week SQL Challenge](https://8weeksqlchallenge.com/case-study-1/) by **Danny Ma**.

---
