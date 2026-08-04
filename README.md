# SQL Data Warehouse from Scratch

A hands-on data engineering project that designs and builds a modern SQL Data Warehouse from the ground up — covering ETL pipelines, the Medallion Architecture (Bronze, Silver, Gold), dimensional modeling, and data quality testing.

> Based on the tutorial **"SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project"** by Data with Baraa ([watch here](https://www.youtube.com/watch?v=9GVqKuTVANE)).

---

## 📌 Project Overview

This project simulates a real-world enterprise data warehousing workflow — from raw data ingestion to a business-ready analytical model — following practices used by professional data architects and engineers.

---

## 🏗️ Architecture

The warehouse is built using the **Medallion Architecture**, applying the *Separation of Concerns* principle across three layers:

| Layer | Purpose | Access |
|-------|---------|--------|
| **Bronze (Raw)** | Ingests raw data directly from CSV source files, unmodified | Data Engineers only |
| **Silver (Cleansed)** | Cleans, standardizes, and transforms raw data | Data Engineers / Analysts |
| **Gold (Analytical)** | Business-ready data modeled with a **Star Schema** (Fact & Dimension tables) | Business Users / Reporting |

---

## ⚙️ Core Concepts Covered

### 1. Foundations of Data Warehousing
- Bill Inmon's definition: **subject-oriented, integrated, time-variant, non-volatile**
- Why enterprises move away from scattered, manual spreadsheet reporting

### 2. ETL Pipeline
- Full **Extract, Transform, Load** workflow
- **Slowly Changing Dimensions (SCD)**
  - Type 1: Overwrite old data
  - Type 2: Preserve historical versions

### 3. Data Architecture
- Layered Bronze → Silver → Gold design
- Star Schema modeling for optimized business reporting

### 4. Testing & Quality Control
- Automated SQL data quality checks:
  - Surrogate key validation
  - Data model integrity checks
  - Uniqueness constraints
- Documentation and repository structuring for GitHub portfolio presentation

---

## 🛠️ Tech Stack

- SQL Server (T-SQL / SSMS)
- CSV file sources
- Star Schema dimensional modeling

---

## 📂 Repository Structure (suggested)

```
sql-data-warehouse-project/
│
├── datasets/              # Raw source CSV files
├── scripts/
│   ├── bronze/            # Raw ingestion scripts
│   ├── silver/            # Cleaning & transformation scripts
│   └── gold/               # Star schema views/tables
├── tests/                 # Data quality check scripts
├── docs/                  # Data models, architecture diagrams, notes
└── README.md
```

---

## 🚀 Key Takeaways

- End-to-end experience designing a production-style data warehouse
- Practical implementation of ETL and SCD logic
- Applied Medallion Architecture and dimensional modeling
- Built quality gates to ensure trustworthy analytics
- Portfolio-ready project structured for GitHub and LinkedIn showcase

---

## 👤 About Me

**Utkarsh Pal**
Third-year Electronics and Communication Engineering (ECE) student at JSS Academy of Technical Education, Noida, aspiring Data Analyst.

- 🔧 Skills: Python, SQL, Excel (Power Query, Power Pivot, DAX), Power BI
- 📜 Cisco Data Analytics Essentials certified
- 🔗 GitHub: [github.com/UtkarshPal0510](https://github.com/UtkarshPal0510)

---

## 📺 Reference

Full tutorial: [SQL Data Warehouse from Scratch — Data with Baraa](https://www.youtube.com/watch?v=9GVqKuTVANE)
