# Smart Inventory Management System (Smart IMS — IMS_D43) 🧠📦

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Web%20App-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)

[cite_start]An Enterprise AI-Powered Inventory Management System built on a hybrid architecture combining Java Web Enterprise containers with an analytical Python predictive microservice[cite: 127, 131]. [cite_start]Developed for the final assignment of the *Java Web Application Development* module[cite: 1, 3].

---

## 📋 Table of Contents
1. [System Architecture Overview](#system-architecture-overview)
2. [Functional System Requirements](#functional-system-requirements)
3. [Cross-Platform Deployment Pipelines](#cross-platform-deployment-pipelines)
   - [Windows Environment Installation](#windows-environment-installation)
   - [Linux Mint / Ubuntu Installation](#linux-mint--ubuntu-installation)
   - [macOS Environment Installation](#macos-environment-installation)
4. [System Access Credentials](#system-access-credentials)
5. [Mathematical Framework of AI Models](#mathematical-framework-of-ai-models)

---

## 🏗️ System Architecture Overview

The platform uses an asynchronous, loose hybrid structure:
* [cite_start]**Transactional Web Node:** Built using standard Java Servlets and JSP pages mounted inside an Apache Tomcat web container[cite: 94, 127].
* [cite_start]**Machine Learning Node:** Built using a Python Flask microservice processing heavy calculation metrics via Port `5000` through active JSON endpoints[cite: 99, 129].

```bash
IMS_D43/
├── src/
│   └── java/
│       ├── dao/              # Data Access Objects (CRUD mappings)
│       ├── model/            # Business Object Models
│       ├── Servlet/          # Transactional Controllers
│       └── util/             # DBConnection utilities
│
├── web/                      # JSP Views + Static Assets
│
├── ai_api/                   # Python AI Microservice
│   ├── app.py                # Flask API core engine
│   └── requirements.txt      # Python dependencies
│
└── inventory_db.sql          # Database schema + seed data
```

---

## 🛠️ Functional System Requirements

### 1. Transactional Core Layer
* **Authentication Matrix:** Dynamic role mapping differentiating Admin access from basic Staff operations[cite: 29, 33].
* **Inventory & Asset Controls:** Comprehensive product profile configurations, real-time quantity audits, and low stock alarms[cite: 34, 39, 43].
* **Sales Ledger & Receipts:** Live point-of-sale recording with dynamic digital invoice compilation[cite: 44, 45, 46].
* **Reporting Pipelines:** Local calculation compilation delivering daily revenue summaries, monthly performance trackers, and stock level snapshots[cite: 48, 49, 50, 51].

### 2. Analytical AI Layer
* **Smart Restock Predictor:** Estimates product depletion timelines and outputs safe minimum reorder quantities[cite: 54, 60, 61].
* **Velocity Classification:** Organizes stock lines into Fast-Moving, Slow-Moving, and dead inventory pools, visualized via Chart.js configurations[cite: 62, 65, 66, 67, 68].
* **Time-Series Sales Trend Analysis:** Maps performance over daily, weekly, and monthly tracking windows to catch cyclical market patterns[cite: 69, 71, 72, 73].
* **Intelligent Warning Matrix:** Instantly surfaces overstock indicators, sudden performance drops, and expiring item batches[cite: 77, 80, 81, 82].

---

## 🚀 Cross-Platform Deployment Pipelines

### 🪟 Windows Environment Installation

#### 1. Database Provisioning
Launch your local MySQL Instance command-line interface and execute the initialization script:
```sql
CREATE DATABASE inventory_db;
USE inventory_db;
SOURCE C:/path_to_project/IMS_D43/inventory_db.sql;
```

1. Analytical Core Sandbox Configuration (Using Python Virtual Environment)

Open your Command Prompt (cmd) or PowerShell terminal inside the target directory:

```bash
cd IMS_D43\ai_api

:: Create the isolated virtual environment sandbox
python -m venv venv

:: Activate the execution profile context
:: For Command Prompt:
call venv\Scripts\activate.bat
:: For PowerShell:
.\venv\Scripts\Activate.ps1

:: Install dependencies safely inside the sandbox container
pip install --upgrade pip
pip install -r requirements.txt
```
2. Execution Phase
```bash
python app.py
:: Engine starts hosting on network socket: http://localhost:5000
```
### 🐧 Linux Mint / Ubuntu Installation
1. Native Environment Setup & Package Validation

Open your Bash terminal and update system package states to bring down required runtimes along with the isolated Python virtual environment builder:
```bash
sudo apt update
sudo apt install openjdk-17-jdk mysql-server tomcat10 python3 python3-pip python3-venv -y
```

2. Database Provisioning
```bash
sudo mysql -u root -p
```

Inside the MySQL prompt, run:
```bash
CREATE DATABASE inventory_db;
USE inventory_db;
SOURCE /home/username/IMS_D43/inventory_db.sql;
```

3. Analytical Core Sandbox Configuration (Using Python Virtual Environment)

Using an isolated environment is mandatory under modern Linux distributions to bypass global path restrictions:
```bash
cd /home/username/IMS_D43/ai_api

# Generate the isolated environment folder
python3 -m venv venv

# Activate using the shell hook context
source venv/bin/activate

# Safely update and unpack operational libraries within the workspace boundary
pip install --upgrade pip
pip install -r requirements.txt
```

4. Execution Phase
```bash
python3 app.py
```

### 🍏 macOS Environment Installation
1. Runtime Environment Assembly via Homebrew

Open your Zsh terminal session and execute the setup script:
```bash
# Verify Homebrew is operational, then pull runtimes down
brew install openjdk mysql python@3.11 tomcat

# Spin up target operational database daemons
brew services start mysql
```

2. Database Provisioning
```bash
sudo mysql -u root -p

Inside the MySQL prompt, run:
```bash
CREATE DATABASE inventory_db;
USE inventory_db;
SOURCE /Users/shared/IMS_D43/inventory_db.sql;
```

3. Analytical Core Sandbox Configuration (Using Python Virtual Environment)

Using an isolated workspace keeps macOS from blocking external script tools:
```bash
cd /Users/shared/IMS_D43/ai_api

# Provision local isolated file paths
python3 -m venv venv

# Bind environment settings to the terminal layer
source venv/bin/activate

# Pull down operational analytic modules inside the sandbox path
pip install --upgrade pip
pip install -r requirements.txt
```

4. Execution Phase
```bash
python3 app.py
```

#Common Java Enterprise Configuration (All Operating Systems)
- Open the primary root repository layout tracking code folder IMS_D43/ using NetBeans IDE.
- Locate the database gateway configuration mapping utility file at src/java/util/DBConnection.java.
- Modify network port access tokens and access passwords to align with your local system's active settings:

```bash
// Verify connection string ports match your local environment configuration (e.g., 3306 or 3606)
String url = "jdbc:mysql://localhost:3606/inventory_db";
String user = "root";
```

- Perform an administrative reset within your integrated developer workspace environment by executing Clean and Build.
- Click Run to deploy your compilation layout to the active Apache Tomcat container. Your system will launch the local entry portal automatically at http://localhost:8080/IMS_D43/.


## 🔐 System Access Credentials
The database contains preset administrative and staff testing accounts right out of the box:
```bash
|Role Authorization  |   Username Alias  |   Default System Key  |
|System Administrator|       admin       |        admin123       |
|Operational         |       Staff       |     staffstaff123     |
```


