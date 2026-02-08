# 🛒 dbt E-Commerce Analytics Project (Snowflake)

An **end-to-end analytics engineering project** built using **dbt** and **Snowflake**, transforming raw e-commerce data into **production-ready fact and dimension tables** following industry best practices.

This project uses the **Olist Brazilian E-Commerce Dataset** and demonstrates how to design a **modern analytics warehouse** with strong data quality guarantees.

---

## 📌 Project Objective

The goal of this project is to:

* Ingest raw e-commerce data into Snowflake
* Transform it using **dbt**
* Build a **star schema** with fact and dimension tables
* Enforce **data quality tests**
* Enable reliable **business analytics & BI reporting**

---

## 🧱 Tech Stack

| Tool             | Purpose                       |
| ---------------- | ----------------------------- |
| **dbt**          | Data transformation & testing |
| **Snowflake**    | Cloud data warehouse          |
| **SQL**          | Transformation logic          |
| **Python**       | Dependency management         |
| **Git & GitHub** | Version control               |

---

## 📂 Project Structure

```text
dbt_project/
│
├── models/
│   ├── staging/               # Cleaned raw source data
│   ├── intermediate/          # Business logic & joins
│   └── marts/
│       ├── dimensions/        # Dimension tables
│       └── facts/             # Fact tables
│
├── snapshots/                 # Slowly changing dimensions
│
├── tests/                     # Custom data quality tests
│
├── olist_dataset/             # Raw CSV source data
│
├── dbt_project.yml            # dbt project configuration
│
├── sql_snowflake_scripts/     # Snowflake setup & automation
│
└── requirements.txt
```

---

## 🔄 Data Modeling Approach

This project follows a **layered dbt architecture**.

### 1️⃣ Staging Layer

* Standardizes raw Olist datasets
* Cleans column names and data types
* Applies light transformations

### 2️⃣ Intermediate Layer

* Applies business rules
* Joins multiple staging models
* Validates entity relationships

### 3️⃣ Mart Layer (Star Schema)

#### 📊 Fact Tables

* `fct_orders`
* `fct_order_items`
* `fct_payments`
* `fct_reviews`

#### 📐 Dimension Tables

* `dim_customers`
* `dim_products`
* `dim_sellers`
* `dim_geo`
* `dim_dates`

Each fact table uses **surrogate keys** and supports analytical queries at scale.

---

## ⏳ Snapshots (SCD Type 2)

Snapshots track historical changes for:

* **Products**
* **Sellers**

This enables:

* Point-in-time analysis
* Change tracking over time

---

## ✅ Data Quality & Testing

The project includes **extensive dbt tests**, including:

### Built-in Tests

* `not_null`
* `unique`
* `relationships`

### Custom Tests

* Negative order amounts
* Invalid timestamps
* Basket value mismatches
* Missing geo coordinates
* Invalid product dimensions
* Orders delivered before purchase
* Zero-value payments

These ensure **high trust in analytics outputs**.

---

## ❄️ Snowflake Integration

The `sql_snowflake_scripts/` folder contains:

* Database & table creation scripts
* COPY commands for CSV ingestion
* User & role permissions
* Stored procedures
* Task automation

This makes the project **production-ready** in Snowflake.

---

## 🚀 How to Run the Project

### Prerequisites

* Python 3.8+
* dbt installed
* Snowflake account
* Snowflake profile configured

### Installation

```bash
pip install -r requirements.txt
```

### Run Models

```bash
dbt run
```

### Run Tests

```bash
dbt test
```

### Run Snapshots

```bash
dbt snapshot
```

---

## 📊 Analytics Use Cases

* Sales & revenue analysis
* Customer behavior insights
* Product performance tracking
* Seller performance monitoring
* BI dashboards (Power BI, Tableau, Looker)

---

## 🎯 Key Highlights

✔ Real-world e-commerce dataset
✔ Star schema design
✔ Advanced dbt testing
✔ SCD snapshots
✔ Snowflake-ready deployment
✔ Portfolio-grade analytics project

---

## 👤 Author

**Swaraj Kadu**
📌 Analytics / Data Engineer
🔗 GitHub: [https://github.com/SWARAJ-KADU](https://github.com/SWARAJ-KADU)

---

## 📜 License

This project is intended for **learning, demonstration, and portfolio purposes**.

