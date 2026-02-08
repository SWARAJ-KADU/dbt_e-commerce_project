# 🛍️ Olist E-Commerce Analytics - dbt Project

<div align="center">

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![Status](https://img.shields.io/badge/status-active-success?style=for-the-badge)

**A production-ready dbt project transforming raw Olist Brazilian e-commerce data into actionable business insights**

[About](#-about) • [Architecture](#-project-architecture) • [Getting Started](#-getting-started) • [Models](#-data-models) • [Testing](#-data-quality) • [Documentation](#-documentation)

</div>

---

## 📖 About

This dbt project implements a complete **ELT pipeline** for the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), transforming raw transactional data into a **dimensional model** optimized for analytics and business intelligence.

### ✨ Key Features

- **🏗️ Medallion Architecture**: Implements staging → intermediate → marts data layers
- **📊 Star Schema Design**: Production-ready dimensional model with facts and dimensions
- **🔄 Incremental Loading**: Efficient incremental materialization strategies
- **📸 SCD Type 2**: Slowly Changing Dimensions for sellers and products using snapshots
- **✅ Data Quality**: Comprehensive data validation and testing framework
- **🎯 Business Ready**: Pre-built models for order analytics, customer behavior, and payment insights

### 📦 Dataset Overview

The Olist dataset contains **100,000+ orders** from 2016-2018 across multiple Brazilian marketplaces, including:
- Customer demographics and locations
- Order lifecycle (purchase → delivery)
- Product catalog with categories
- Payment transactions
- Customer reviews and ratings
- Seller information and geolocation

---

## 🏛️ Project Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         SOURCE LAYER                             │
│                      (Olist Raw Tables)                          │
│  customers | orders | order_items | payments | reviews |        │
│              products | sellers | geolocation                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                       STAGING LAYER                              │
│              (Light transformations & typing)                    │
│  stg_customers | stg_orders | stg_order_items |                 │
│  stg_payments | stg_reviews | stg_products | ...                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    INTERMEDIATE LAYER                            │
│              (Business logic & enrichment)                       │
│  int_customers | int_orders_lifecycle |                         │
│  int_order_items_metrics | int_order_payments_summary |         │
│  int_products | int_sellers | int_geo_reference                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        MARTS LAYER                               │
│              (Analytics-ready dimensional model)                 │
│                                                                   │
│  ┌──────────────────┐         ┌─────────────────────┐          │
│  │   DIMENSIONS     │         │       FACTS         │          │
│  ├──────────────────┤         ├─────────────────────┤          │
│  │ dim_customers    │         │ fct_orders          │          │
│  │ dim_products     │────────▶│ fct_order_items     │          │
│  │ dim_sellers      │         │ fct_payments        │          │
│  │ dim_geo          │         │ fct_reviews         │          │
│  │ dim_dates        │         │                     │          │
│  └──────────────────┘         └─────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ▼
                    📊 BI Tools / Analytics
```

---

## 🚀 Getting Started

### Prerequisites

- [dbt Core](https://docs.getdbt.com/docs/core/installation) >= 1.0.0 or [dbt Cloud](https://www.getdbt.com/signup/)
- Snowflake account (or adapt for your data warehouse)
- Python >= 3.8
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SWARAJ-KADU/dbt_e-commerce_project.git
   cd dbt_e-commerce_project
   ```

2. **Install dbt dependencies**
   ```bash
   dbt deps
   ```

3. **Configure your profile**
   
   Update `profiles.yml` with your Snowflake credentials:
   ```yaml
   dbt_project:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: your_account
         user: your_user
         password: your_password
         role: your_role
         database: olist_db
         warehouse: your_warehouse
         schema: analytics
         threads: 4
   ```

4. **Load the Olist dataset**
   
   Download from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and load into your data warehouse under the `raw` schema.

5. **Run the pipeline**
   ```bash
   # Run all models
   dbt run
   
   # Run tests
   dbt test
   
   # Generate documentation
   dbt docs generate
   dbt docs serve
   ```

---

## 📊 Data Models

### Staging Layer (`staging/`)
Clean, typed, and renamed source data with minimal transformations.

| Model | Description |
|-------|-------------|
| `stg_customers` | Customer master data with location |
| `stg_orders` | Order header information |
| `stg_order_items` | Line-level order details |
| `stg_order_payments` | Payment transactions |
| `stg_order_reviews` | Customer review ratings |
| `stg_products` | Product catalog |
| `stg_sellers` | Seller information |
| `stg_geolocation` | Brazilian geolocation data |
| `stg_product_category` | Product category translations |

### Intermediate Layer (`intermediate/`)
Business logic, calculations, and data enrichment.

| Model | Description |
|-------|-------------|
| `int_customers` | Enriched customer data |
| `int_orders_lifecycle` | Order timing and delivery metrics |
| `int_order_items_metrics` | Product-level order calculations |
| `int_order_payments_summary` | Aggregated payment data per order |
| `int_order_payments_enriched` | Detailed payment analysis |
| `int_order_basket_summary` | Shopping basket analytics |
| `int_order_reviews_summary` | Review metrics per order |
| `int_order_reviews_enriched` | Detailed review analysis |
| `int_products` | Product master with attributes |
| `int_sellers` | Seller master with metrics |
| `int_geo_reference` | Geographic reference data |

### Marts Layer (`marts/`)
Analytics-ready dimensional model for BI consumption.

#### 🔷 Dimensions
| Model | Type | Description |
|-------|------|-------------|
| `dim_customers` | SCD Type 1 | Customer dimension with demographics |
| `dim_products` | SCD Type 2* | Product dimension with categories |
| `dim_sellers` | SCD Type 2* | Seller dimension with location |
| `dim_geo` | SCD Type 1 | Geographic dimension (cities, states) |
| `dim_dates` | Static | Date dimension for time analysis |

*Implemented via dbt snapshots

#### 📈 Facts
| Model | Grain | Description |
|-------|-------|-------------|
| `fct_orders` | One row per order | Order header facts with metrics |
| `fct_order_items` | One row per order line | Product-level transaction details |
| `fct_payments` | One row per payment | Payment transaction facts |
| `fct_reviews` | One row per review | Customer review facts |

---

## 🧪 Data Quality

### Custom Data Tests

The project includes **comprehensive data quality tests** organized by domain:

| Test Category | Location | Purpose |
|---------------|----------|---------|
| **Order Lifecycle** | `tests/int_orders_lifecycle/` | Validate delivery dates, durations |
| **Order Items** | `tests/int_order_items/` | Check for negative amounts, invalid quantities |
| **Payments** | `tests/int_order_payments/` | Identify zero totals, payment mismatches |
| **Reviews** | `tests/int_order_reviews/` | Validate timestamps, rating bounds |
| **Products** | `tests/int_products/` | Check volume/weight constraints |
| **Sellers** | `tests/int_sellers/` | Verify location completeness |
| **Geolocation** | `tests/int_geo/` | Validate coordinate ranges |
| **Order Basket** | `tests/int_order_basket/` | Cross-check basket values |

Example tests:
```sql
-- tests/int_orders_lifecycle/orders_delivery_before_purchase.sql
-- Ensures delivery date is after purchase date
select *
from {{ ref('int_orders_lifecycle') }}
where delivered_date < purchase_date
```

### Running Tests

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --select int_orders_lifecycle

# Run specific test type
dbt test --select test_type:singular
```

---

## 📸 Snapshots

The project uses **dbt snapshots** to track historical changes:

- `products_snap` - Tracks product attribute changes over time
- `sellers_snap` - Maintains seller history for SCD Type 2 analysis

Run snapshots:
```bash
dbt snapshot
```

---

## 🎯 Common Use Cases

This dimensional model enables various analytics scenarios:

### 📊 Business Analytics
- **Sales Performance**: Track revenue trends, top products, seasonal patterns
- **Customer Behavior**: Analyze purchase frequency, customer lifetime value, cohort analysis
- **Delivery Performance**: Monitor delivery times, late deliveries, logistics efficiency
- **Payment Analysis**: Payment method preferences, installment trends, transaction volumes

### 🔍 Example Queries

**Monthly Revenue Trend**
```sql
SELECT 
    DATE_TRUNC('month', d.date) AS month,
    COUNT(DISTINCT o.order_sk) AS total_orders,
    SUM(o.total_amount) AS revenue
FROM marts.fct_orders o
JOIN marts.dim_dates d ON o.purchase_date_sk = d.date_sk
GROUP BY 1
ORDER BY 1;
```

**Top Selling Product Categories**
```sql
SELECT 
    p.category_name,
    COUNT(DISTINCT oi.order_item_sk) AS items_sold,
    SUM(oi.price) AS total_revenue
FROM marts.fct_order_items oi
JOIN marts.dim_products p ON oi.product_sk = p.product_sk
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;
```

---

## 🛠️ Macros & Utilities

### Custom Macros

- **`generate_surrogate_key`**: Creates unique surrogate keys for dimensions
- **`generate_schema_name`**: Custom schema naming convention

### dbt Packages Used

- [`dbt_utils`](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) (v1.3.3): Common utilities and macros

---

## 📁 Project Structure

```
dbt_e-commerce_project/
├── analyses/              # Ad-hoc analytical queries
├── macros/               # Custom macros and functions
│   ├── generate_schema_name.sql
│   └── generate_surrogate_key.sql
├── models/
│   ├── staging/          # Staging layer models
│   ├── intermediate/     # Intermediate transformations
│   ├── marts/            # Analytics-ready marts
│   │   ├── dimensions/   # Dimension tables
│   │   └── facts/        # Fact tables
│   └── source.yml        # Source definitions
├── seeds/                # Static lookup data
├── snapshots/            # SCD Type 2 snapshots
│   ├── products_snap.sql
│   └── sellers_snap.sql
├── tests/                # Custom data quality tests
│   ├── int_geo/
│   ├── int_order_basket/
│   ├── int_order_items/
│   ├── int_order_payments/
│   ├── int_order_reviews/
│   ├── int_orders_lifecycle/
│   ├── int_products/
│   └── int_sellers/
├── dbt_project.yml       # dbt project configuration
├── packages.yml          # dbt package dependencies
└── README.md
```

---

## 🔄 Incremental Strategy

Models use **incremental materialization** for efficiency:

- **Staging Layer**: Append-only incremental strategy
- **Marts Layer**: Merge strategy with surrogate keys
- **Filtered by**: `ingested_at` timestamp for incremental runs

```yaml
# Example configuration
{{ config(
    materialized='incremental',
    unique_key='order_sk',
    incremental_strategy='merge'
) }}
```

---

## 📚 Documentation

Generate and view comprehensive project documentation:

```bash
# Generate documentation
dbt docs generate

# Serve documentation site
dbt docs serve
```

The documentation includes:
- **Lineage graphs** showing data flow
- **Model descriptions** and column-level details
- **Test coverage** and results
- **Source freshness** checks

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- **Dataset**: [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) on Kaggle
- **dbt**: [Fishtown Analytics](https://www.getdbt.com/) for the amazing transformation framework
- **Community**: dbt community for best practices and inspiration

---

## 📧 Contact

**Swaraj Kadu**

- GitHub: [@SWARAJ-KADU](https://github.com/SWARAJ-KADU)
- Project Link: [https://github.com/SWARAJ-KADU/dbt_e-commerce_project](https://github.com/SWARAJ-KADU/dbt_e-commerce_project)

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star!**

Made with ❤️ using dbt

</div>