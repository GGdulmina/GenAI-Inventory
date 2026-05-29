<div align="center">

# 🗂️ GenAI-Inventory

### Smart Inventory Management System with AI-Powered Analytics

*An enterprise-grade full-stack inventory platform integrating Java EE transactional operations with a Python Flask AI microservice for intelligent stock forecasting, sales trend analysis, and autonomous restock recommendations.*

---

![Java](https://img.shields.io/badge/Java-17+-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Jakarta%20EE-007396?style=for-the-badge&logo=java&logoColor=white)
![Servlet](https://img.shields.io/badge/Servlet-Jakarta%20EE-007396?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-2.x-000000?style=for-the-badge&logo=flask&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10+-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-4.x-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)
![REST API](https://img.shields.io/badge/REST-API-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![MIT License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</div>

---

## 📋 Project Overview

**GenAI-Inventory** is an AI-powered Smart Inventory Management System designed for academic and professional software engineering learning. The system demonstrates enterprise-grade multi-tier architecture by integrating a Java EE web application with a Python Flask AI microservice.

| Layer | Technology | Responsibility |
|-------|-----------|----------------|
| Web Application | Java EE (JSP / Servlets) | Core transactional business operations |
| AI Microservice | Python Flask (REST API) | Predictive analytics and AI-driven insights |
| Database | MySQL | Persistent relational data storage |
| Frontend | Bootstrap + Chart.js | Responsive UI and data visualization |

> This project was developed as part of a university software engineering curriculum and serves as a portfolio demonstration of full-stack development, service-oriented architecture, and applied AI integration.

---

## ✨ System Features

### 🔐 Authentication Module
- Secure login and session management
- Role-based access control (Admin / Staff)
- Session timeout and logout handling
- User account management

### 📦 Inventory Module
- Full product CRUD operations (Create, Read, Update, Delete)
- Real-time stock level tracking
- Low stock threshold alerts and monitoring
- Category and supplier management

### 🧾 Sales Module
- Point-of-sale billing and invoice generation
- Sales transaction recording
- Sales history with date-range filtering
- Stock auto-deduction on sale completion

### 📊 Reporting Module
- Interactive dashboard with KPI metrics
- Sales and inventory reports generation
- Data visualization via Chart.js (bar, line, pie charts)
- Exportable report summaries

### 🤖 AI Features *(via Python Flask Microservice)*
- AI-powered inventory insights and pattern recognition
- Automated restock quantity prediction
- Sales trend analysis and forecasting
- Inventory turnover intelligence
- Contextual AI recommendations for procurement decisions

---

## 🏗️ System Architecture

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT BROWSER                           │
│              (HTML / CSS / Bootstrap / Chart.js)                │
└──────────────────────────┬──────────────────────────────────────┘
                           │ HTTP Requests
┌──────────────────────────▼──────────────────────────────────────┐
│                    APACHE TOMCAT SERVER                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  PRESENTATION LAYER                       │  │
│  │              JavaServer Pages (JSP Views)                 │  │
│  └───────────────────────────┬───────────────────────────────┘  │
│                              │                                   │
│  ┌───────────────────────────▼───────────────────────────────┐  │
│  │                  CONTROLLER LAYER                         │  │
│  │              Java Servlets (Request Handling)             │  │
│  └──────────────┬────────────────────────┬────────────────────  │
│                 │                        │                       │
│  ┌──────────────▼───────────┐  ┌─────────▼──────────────────┐  │
│  │      DATA ACCESS LAYER   │  │    AI INTEGRATION LAYER    │  │
│  │   DAO Pattern + JDBC     │  │   HTTP REST Client Calls   │  │
│  └──────────────┬───────────┘  └─────────┬──────────────────┘  │
└─────────────────│───────────────────────│───────────────────────┘
                  │                        │
┌─────────────────▼───────────┐  ┌─────────▼──────────────────────┐
│       MySQL DATABASE        │  │   PYTHON FLASK AI MICROSERVICE  │
│   (inventory_db)            │  │        (ai_api/)                │
│                             │  │                                  │
│  - products                 │  │  - /api/predict-restock          │
│  - sales                    │  │  - /api/sales-trend              │
│  - users                    │  │  - /api/insights                 │
│  - categories               │  │  - /api/recommendations          │
└─────────────────────────────┘  └──────────────────────────────────┘
```

### Layer Descriptions

| Layer | Components | Description |
|-------|-----------|-------------|
| **Frontend** | JSP, HTML, CSS, Bootstrap 5, Chart.js | Responsive UI rendered server-side via JSP templates |
| **Backend** | Java Servlets, DAO Pattern, JDBC, Tomcat 10 | Handles HTTP lifecycle, business logic, and DB operations |
| **AI Layer** | Python 3, Flask, REST JSON API | Standalone microservice for ML-based predictions |
| **Database** | MySQL 8 | Normalized relational schema for all transactional data |

---

## 📁 Project Directory Structure

```
GenAI-Inventory/
│
├── IMS_D43/                          → Java EE Web Application (NetBeans Project)
│   ├── src/
│   │   └── java/
│   │       ├── controller/           → Java Servlet controllers (HTTP request handlers)
│   │       │   ├── LoginServlet.java
│   │       │   ├── InventoryServlet.java
│   │       │   ├── SalesServlet.java
│   │       │   └── AIServlet.java
│   │       ├── dao/                  → Data Access Objects (JDBC database operations)
│   │       │   ├── ProductDAO.java
│   │       │   ├── SalesDAO.java
│   │       │   └── UserDAO.java
│   │       ├── model/                → Entity/POJO classes
│   │       │   ├── Product.java
│   │       │   ├── Sale.java
│   │       │   └── User.java
│   │       └── util/                 → Utility classes (DB connection, helpers)
│   │           └── DBConnection.java
│   └── web/
│       ├── WEB-INF/
│       │   └── web.xml               → Servlet deployment descriptor
│       ├── jsp/                      → JSP view pages
│       │   ├── login.jsp
│       │   ├── dashboard.jsp
│       │   ├── inventory.jsp
│       │   ├── sales.jsp
│       │   └── ai_insights.jsp
│       ├── css/                      → Stylesheets
│       └── js/                       → JavaScript files (Chart.js configs)
│
├── ai_api/                           → Python Flask AI Microservice
│   ├── app.py                        → Flask application entry point
│   ├── requirements.txt              → Python dependencies
│   ├── routes/                       → API route definitions
│   │   ├── predict.py
│   │   ├── trends.py
│   │   └── insights.py
│   └── models/                       → AI/ML logic and data processing
│       └── inventory_model.py
│
├── inventory_db.sql                  → MySQL schema and seed data
├── generate_sales.py                 → Sales data generation utility script
└── README.md
```

---

## 🛠️ Technologies Used

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Java** | JDK 17+ | Core backend language |
| **JSP (JavaServer Pages)** | Jakarta EE | Server-side view rendering |
| **Java Servlets** | Jakarta EE | HTTP request/response handling |
| **MySQL** | 8.0+ | Relational database management |
| **Flask** | 2.x | Python web framework for AI microservice |
| **Python** | 3.10+ | AI/ML microservice language |
| **JDBC** | Standard | Java database connectivity |
| **Apache Tomcat** | 10+ | Java web application server |
| **Bootstrap** | 5.x | Responsive CSS framework |
| **Chart.js** | 4.x | Interactive data visualization |

---

## ⚙️ Prerequisites

### 🪟 Windows

- [Java JDK 17+](https://adoptium.net/) — ensure `JAVA_HOME` is set in environment variables
- [Apache Tomcat 10+](https://tomcat.apache.org/download-10.cgi) — configured in your IDE
- [MySQL Server 8.0+](https://dev.mysql.com/downloads/mysql/) + MySQL Workbench (optional)
- [Python 3.10+](https://www.python.org/downloads/) — ensure `pip` is available
- [Git](https://git-scm.com/)
- [NetBeans IDE 17+](https://netbeans.apache.org/) or [IntelliJ IDEA](https://www.jetbrains.com/idea/) with Jakarta EE support

### 🐧 Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install openjdk-17-jdk mysql-server python3.10 python3-pip git -y
```
Download Apache Tomcat 10 from the [official site](https://tomcat.apache.org/download-10.cgi) or install via package manager.

### 🍎 macOS

```bash
brew install openjdk@17 mysql python@3.10 git
brew install --cask netbeans
```
Install Apache Tomcat via `brew install tomcat` or download manually.

---

## 🗄️ Database Setup

### Step 1 — Start MySQL Service

**Windows:**
```cmd
net start MySQL80
```

**Linux:**
```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

**macOS:**
```bash
brew services start mysql
```

### Step 2 — Create the Database

```sql
CREATE DATABASE inventory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Step 3 — Import the SQL Schema

**Windows (Command Prompt):**
```cmd
mysql -u root -p inventory_db < inventory_db.sql
```

**Linux / macOS (Terminal):**
```bash
mysql -u root -p inventory_db < inventory_db.sql
```

### Step 4 — Verify Tables

```sql
USE inventory_db;
SHOW TABLES;
```

Expected tables: `users`, `products`, `categories`, `sales`, `sale_items`

### Step 5 — Update JDBC Connection String

In `IMS_D43/src/java/util/DBConnection.java`, update:

```java
private static final String URL      = "jdbc:mysql://localhost:3306/inventory_db";
private static final String USER     = "root";
private static final String PASSWORD = "your_mysql_password";
```

---

## 🐍 Python AI Microservice Setup

> **Note:** The `ai_api/` directory is located at the project root — **not** inside `IMS_D43/`.

A **Python virtual environment** isolates the project's dependencies from the global Python installation, preventing version conflicts across projects. Always activate the virtual environment before running the Flask API.

### 🪟 Windows

```cmd
cd ai_api
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

To deactivate the environment when done:
```cmd
deactivate
```

### 🐧 Linux

```bash
cd ai_api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```

To deactivate:
```bash
deactivate
```

### 🍎 macOS

```bash
cd ai_api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```

To deactivate:
```bash
deactivate
```

### Verify the API is Running

The Flask server will start at:
```
http://localhost:5000
```

Test with:
```bash
curl http://localhost:5000/api/insights
```

---

## ☕ Java Web Application Deployment

### Using NetBeans IDE

1. Open NetBeans → **File → Open Project** → select the `IMS_D43/` folder
2. Right-click the project → **Properties → Run** → configure your Apache Tomcat 10 server
3. Ensure the JDBC MySQL Connector JAR is present in `WEB-INF/lib/`
4. Right-click project → **Clean and Build** to compile and package as a `.war` file
5. Right-click project → **Run** to deploy to Tomcat and launch the browser

### Manual WAR Deployment

```bash
# Build the WAR file via NetBeans or Maven, then:
cp IMS_D43/dist/IMS_D43.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh   # Linux/macOS
$CATALINA_HOME\bin\startup.bat  # Windows
```

Access the application at:
```
http://localhost:8080/IMS_D43
```

> **Note:** Ensure the Python Flask API (`ai_api/`) is running before accessing AI Insights features within the web application.

---

## 🔑 Default System Credentials

> ⚠️ **Security Warning:** These are development-only credentials. **Change all default passwords before deploying to any production or public-facing environment.**

| Role | Username | Password |
|------|----------|----------|
| Administrator | `admin` | `admin123` |
| Staff | `staff` | `staff123` |

---

## 🔄 API Communication Flow

### Transactional Data Flow (Java ↔ MySQL)

```
Browser Request
     │
     ▼
JSP View  ──→  Java Servlet  ──→  DAO Layer  ──→  MySQL Database
                  (Controller)      (JDBC)          (inventory_db)
     ▲                                                    │
     └────────────────────────────────────────────────────┘
                       Response rendered via JSP
```

### AI Analytics Flow (Java ↔ Flask)

```
JSP AI Insights Page
     │
     ▼
AIServlet.java  ──→  HTTP REST Request  ──→  Flask AI API (localhost:5000)
                                                     │
                                              AI Model Processing
                                                     │
     ◀──────────────────  JSON Response  ────────────┘
     │
     ▼
JSP renders AI predictions and recommendations
```

**Example REST Endpoints exposed by the Flask API:**

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/insights` | General inventory AI insights |
| `POST` | `/api/predict-restock` | Restock quantity prediction for a product |
| `GET` | `/api/sales-trend` | Sales trend analysis over time |
| `GET` | `/api/recommendations` | Procurement recommendations |

---

## 📸 Screenshots

> *Add screenshots to the `/docs/screenshots/` directory and update the paths below.*

### Login Page
![Login Page](docs/screenshots/login.png)

### Dashboard
![Dashboard](docs/screenshots/dashboard.png)

### Inventory Management
![Inventory Page](docs/screenshots/inventory.png)

### Sales Module
![Sales Page](docs/screenshots/sales.png)

### AI Insights
![AI Insights](docs/screenshots/ai_insights.png)

---

## 🔒 Security Recommendations

For any deployment beyond a local development environment, apply the following practices:

| Concern | Recommendation |
|---------|---------------|
| **Password Storage** | Hash passwords using `bcrypt` (Python) or `BCrypt` (Java) — never store plaintext |
| **SQL Injection** | Use `PreparedStatement` exclusively in all DAO classes; never concatenate user input into SQL |
| **Environment Variables** | Store DB credentials, API keys, and secrets in environment variables or a `.env` file, never hardcoded |
| **HTTPS** | Configure SSL/TLS on Apache Tomcat using a valid certificate; redirect all HTTP to HTTPS |
| **Secret Management** | Add `.env`, `venv/`, and credential files to `.gitignore` before the first commit |
| **CORS Policy** | Restrict Flask API CORS origins to only the Tomcat application host |
| **Session Security** | Set session timeouts and use `HttpOnly` / `Secure` cookie flags in `web.xml` |

---

## 🗂️ GitHub Best Practices & `.gitignore`

Ensure the following are **never committed** to version control:

```gitignore
# Python virtual environment
venv/
__pycache__/
*.pyc
*.pyo
.env

# Java build artifacts
build/
dist/
*.class
*.war
*.jar

# NetBeans IDE metadata
nbproject/private/
nbbuild/
.nb-gradle/

# MySQL credentials / dumps with sensitive data
*.sql.bak

# OS artifacts
.DS_Store
Thumbs.db
```

> Initialize `.gitignore` **before your first `git add`** to avoid accidentally pushing sensitive files or IDE-specific clutter.

---

## 🚀 Future Improvements

| Feature | Description |
|---------|-------------|
| 🐳 **Docker Deployment** | Containerize both the Java app and Flask API using Docker Compose for environment-independent deployment |
| 🔐 **JWT Authentication** | Replace session-based auth with stateless JWT tokens for improved API security |
| ☁️ **Cloud Hosting** | Deploy on AWS, GCP, or Azure with managed MySQL (RDS / Cloud SQL) |
| 🧠 **Advanced AI Forecasting** | Integrate time-series models (Prophet, LSTM) for higher-accuracy demand forecasting |
| 📱 **Mobile Application** | Develop a companion mobile app (Android/iOS) consuming the REST API |
| 👥 **Role-Based Access Control** | Implement fine-grained RBAC with multiple user roles and permission sets |
| 📬 **Notification System** | Email/SMS alerts for low stock thresholds and restock triggers |
| 📦 **Supplier Integration** | API integration with supplier systems for automated purchase order creation |

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2024 GenAI-Inventory Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## 👥 Contributors

| Name | Role | GitHub |
|------|------|--------|
| *Your Full Name* | Lead Developer | [@your-github](https://github.com/your-github) |
| *Team Member 2* | Backend Developer | [@teammate2](https://github.com/teammate2) |
| *Team Member 3* | AI Integration | [@teammate3](https://github.com/teammate3) |
| *Team Member 4* | Frontend & UI | [@teammate4](https://github.com/teammate4) |

> Developed as a group project for the **Enterprise Architecture** module — *Higher National Diploma in Information Technology (HNDIT), NVQ Level 6*.

---

<div align="center">

*Built with Java EE, Python Flask, and a commitment to clean architecture.*

⭐ If this project was helpful, consider giving it a star on GitHub.

</div>
