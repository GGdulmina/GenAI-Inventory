# Smart Inventory Management System (IMS_D43)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Web%20App-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)

![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/License-Academic-lightgrey?style=for-the-badge)

A Java Web Application with AI-based business insights, developed for the final assignment of the Java Web Application Development module.

## Overview

This system helps supermarket and retail shop owners manage inventory, record sales, and receive intelligent AI-driven recommendations — such as restock predictions, trend analysis, and smart alerts.

## Features

### Core System
- User authentication with Admin and Staff roles
- Product management (add, update, delete, search)
- Inventory management with low-stock alerts
- Sales recording and invoice generation
- Daily, monthly, and stock reports

### AI/ML Features
- **Restock Predictor** — predicts how many days until a product runs out and suggests restock quantity
- **Fast/Slow Moving Analysis** — identifies fast-selling, slow-selling, and dead stock with charts
- **Sales Trend Analysis** — analyses daily, weekly, and monthly trends and predicts future patterns
- **Intelligent Alerts** — flags low stock, overstock, sudden sales drops, and expiring products

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java Servlets / JSP (NetBeans) |
| Database | MySQL |
| AI/ML API | Python + Flask + scikit-learn |
| Frontend | HTML / CSS / JavaScript / Chart.js |
| Server | Apache Tomcat |

## Project Structure

```
GenAI-Inventory/
├── IMS_D43/                  # NetBeans Java Web project
│   ├── src/java/
│   │   ├── dao/              # Data access objects
│   │   ├── model/            # Java model classes
│   │   ├── Servlet/          # HTTP servlets
│   │   └── util/             # DB connection utility
│   └── web/                  # JSP pages and web config
├── ai_api/                   # Python Flask AI service (coming soon)
└── inventory_db.sql          # MySQL database schema and seed data
```

## Setup Instructions

### Prerequisites
- Java JDK 11+
- Apache Tomcat 10+
- MySQL 8+
- Python 3.9+ (for AI module)
- NetBeans IDE (recommended)

### Database Setup
```sql
-- In MySQL:
CREATE DATABASE inventory_db;
USE inventory_db;
SOURCE inventory_db.sql;
```

### Java Web App
1. Open `IMS_D43/` in NetBeans
2. Configure DB credentials in `src/java/util/DBConnection.java`
3. Right-click project → Clean and Build
4. Deploy to Tomcat (Run)

### AI Flask API
```bash
cd ai_api
pip install -r requirements.txt
python app.py
# Runs on http://localhost:5000
```

### Default Login
| Role | Username | Password |
|---|---|---|
| Admin | admin | admin123 |
| Staff | staff | staff123 |

## Screenshots

*Screenshots will be added after UI completion.*

## AI Model Explanation

The restock predictor uses linear regression on historical daily sales to calculate average consumption rate. The system estimates days remaining as `current_stock / avg_daily_sales` and recommends restock quantity as `(avg_daily_sales × 30) - current_stock`.
