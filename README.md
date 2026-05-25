# Smart Inventory Management System (Smart IMS --- IMS_D43)

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Web%20App-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)

Enterprise AI-Powered Inventory Management System built on Java JSP +
Python Flask microservices.

------------------------------------------------------------------------

## Table of Contents

1.  [System Architecture Overview](#system-architecture-overview)
2.  [Functional System Requirements](#functional-system-requirements)
3.  [Cross Platform Deployment
    Pipelines](#cross-platform-deployment-pipelines)
    -   [Windows Installation](#windows-installation)
    -   [Linux Ubuntu Installation](#linux-ubuntu-installation)
    -   [macOS Installation](#macos-installation)
4.  [System Access Credentials](#system-access-credentials)

------------------------------------------------------------------------

## System Architecture Overview

-   Java Servlet + JSP (Tomcat)
-   Python Flask AI microservice (port 5000)

------------------------------------------------------------------------

## Functional System Requirements

### Transactional Layer

-   Authentication system
-   Inventory management
-   Sales and billing
-   Reporting

### AI Layer

-   Restock prediction
-   Stock classification
-   Sales trend analysis
-   Alerts system

------------------------------------------------------------------------

## Cross Platform Deployment

### Windows

``` bash
cd IMS_D43\ai_api
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

### Linux

``` bash
cd IMS_D43/ai_api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```

### macOS

``` bash
cd IMS_D43/ai_api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```

------------------------------------------------------------------------

## System Access Credentials

  Role    Username   Password
  ------- ---------- ---------------
  Admin   admin      admin123
  Staff   staff      staffstaff123
