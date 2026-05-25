from flask import Flask, jsonify
from flask_cors import CORS  # 1. IMPORT CORS HERE
import mysql.connector
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

app = Flask(__name__)
CORS(app)  # 2. ENABLE CORS FOR ALL ROUTES OVER PORT 5000

def get_db():
    return mysql.connector.connect(
        host='localhost', 
        user='root',
        password='NewPassword123!', 
        database='inventory_db'
    )

# ─────────────────────────────────────────────────────────────
# INTERNAL CORE SERVICE FUNCTIONS (Business Logic Layer)
# ─────────────────────────────────────────────────────────────

def fetch_restock_predictions():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT
            p.id, p.name, p.quantity AS current_stock, p.min_stock_level,
            COALESCE(SUM(si.quantity), 0) AS total_sold,
            COALESCE(SUM(si.quantity) / GREATEST(DATEDIFF(NOW(), MIN(s.sale_date)), 1), 0) AS daily_avg
        FROM products p
        LEFT JOIN sale_items si ON p.id = si.product_id
        LEFT JOIN sales s ON si.sale_id = s.id
            AND s.sale_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        GROUP BY p.id, p.name, p.quantity, p.min_stock_level
    """)
    products = cur.fetchall()
    cur.close()
    db.close()

    predictions = []
    for p in products:
        daily_avg = float(p['daily_avg']) if p['daily_avg'] else 0
        current = int(p['current_stock'])

        if daily_avg > 0:
            days_remaining = int(current / daily_avg)
            restock_qty = max(0, int(daily_avg * 30) - current)
            status = 'critical' if days_remaining <= 3 else 'low' if days_remaining <= 7 else 'ok'
            message = f"{p['name']} may run out in {days_remaining} days. Restock {restock_qty} units."
        else:
            days_remaining = 999
            restock_qty = 0
            status = 'no_sales'
            message = f"{p['name']} has no recent sales."

        predictions.append({
            'product_id': p['id'],
            'product_name': p['name'],
            'current_stock': current,
            'daily_avg_sales': round(daily_avg, 2),
            'days_remaining': days_remaining,
            'restock_qty': restock_qty,
            'status': status,
            'message': message
        })
    predictions.sort(key=lambda x: x['days_remaining'])
    return predictions


def fetch_product_analysis():
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT p.id, p.name, p.category,
            COALESCE(SUM(si.quantity), 0) AS units_sold,
            COALESCE(SUM(si.subtotal), 0) AS revenue
        FROM products p
        LEFT JOIN sale_items si ON p.id = si.product_id
        LEFT JOIN sales s ON si.sale_id = s.id
            AND s.sale_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        GROUP BY p.id, p.name, p.category
        ORDER BY units_sold DESC
    """)
    products = cur.fetchall()
    cur.close()
    db.close()

    # FIX: Cast to int to prevent decimal.Decimal vs float issues inside NumPy functions
    sales_values = [int(p['units_sold']) for p in products]
    if not sales_values:
        return []

    q66 = np.percentile(sales_values, 66)
    q33 = np.percentile(sales_values, 33)

    for p in products:
        sold = int(p['units_sold'])
        if sold == 0:
            p['classification'] = 'dead_stock'
            p['label'] = 'Dead Stock'
        elif sold >= q66:
            p['classification'] = 'fast'
            p['label'] = 'Fast Moving'
        elif sold >= q33:
            p['classification'] = 'moderate'
            p['label'] = 'Moderate'
        else:
            p['classification'] = 'slow'
            p['label'] = 'Slow Moving'
        
        # Cast the dict values to float/int so JSON serialization is clean
        p['units_sold'] = sold
        p['revenue'] = float(p['revenue'])
        
    return products


def fetch_sales_trends():
    db = get_db()
    cur = db.cursor(dictionary=True)

    # Daily sales last 60 days
    cur.execute("""
        SELECT DATE(sale_date) AS day,
               SUM(total_amount) AS revenue,
               COUNT(*) AS transactions,
               DAYOFWEEK(sale_date) AS day_of_week
        FROM sales
        WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 60 DAY)
        GROUP BY DATE(sale_date), DAYOFWEEK(sale_date)
        ORDER BY day
    """)
    daily = cur.fetchall()

    # Weekly sales
    cur.execute("""
        SELECT YEARWEEK(sale_date) AS week,
               SUM(total_amount) AS revenue,
               COUNT(*) AS transactions
        FROM sales
        WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 12 WEEK)
        GROUP BY YEARWEEK(sale_date)
        ORDER BY week
    """)
    weekly = cur.fetchall()

    # Monthly sales
    cur.execute("""
        SELECT DATE_FORMAT(sale_date,'%Y-%m') AS month,
               SUM(total_amount) AS revenue,
               COUNT(*) AS transactions
        FROM sales
        GROUP BY DATE_FORMAT(sale_date,'%Y-%m')
        ORDER BY month
    """)
    monthly = cur.fetchall()
    cur.close()
    db.close()

    weekend_avg, weekday_avg = 0, 0
    weekend_days = [d for d in daily if d['day_of_week'] in (1, 6, 7)]
    weekday_days = [d for d in daily if d['day_of_week'] not in (1, 6, 7)]
    
    if weekend_days:
        weekend_avg = sum(float(d['revenue']) for d in weekend_days) / len(weekend_days)
    if weekday_days:
        weekday_avg = sum(float(d['revenue']) for d in weekday_days) / len(weekday_days)

    insight = ""
    if weekend_avg > weekday_avg * 1.2:
        pct = round(((weekend_avg - weekday_avg) / weekday_avg) * 100)
        insight = f"Sales are {pct}% higher on weekends. Consider increasing stock on Thursdays."
    elif weekday_avg > weekend_avg * 1.1:
        insight = "Weekday sales outperform weekends for this store."
    else:
        insight = "Sales are relatively consistent throughout the week."

    if len(weekly) >= 4:
        last4 = [float(w['revenue']) for w in weekly[-4:]]
        predicted_next_week = round(sum(last4) / 4)
    else:
        predicted_next_week = 0

    return {
        'daily': [{'day': str(d['day']), 'revenue': float(d['revenue']), 'transactions': d['transactions']} for d in daily],
        'weekly': [{'week': str(w['week']), 'revenue': float(w['revenue'])} for w in weekly],
        'monthly': [{'month': m['month'], 'revenue': float(m['revenue'])} for m in monthly],
        'insight': insight,
        'predicted_next_week_revenue': predicted_next_week
    }


def fetch_intelligent_alerts():
    db = get_db()
    cur = db.cursor(dictionary=True)
    alerts = []

    # LOW STOCK
    cur.execute("SELECT id, name, quantity, min_stock_level FROM products WHERE quantity <= min_stock_level")
    for p in cur.fetchall():
        alerts.append({
            'type': 'low_stock',
            'severity': 'high' if p['quantity'] == 0 else 'medium',
            'product': p['name'],
            'message': f"LOW STOCK: {p['name']} has only {p['quantity']} units left (minimum: {p['min_stock_level']})"
        })

    # OVERSTOCK
    cur.execute("SELECT id, name, quantity, max_stock_level FROM products WHERE quantity > max_stock_level")
    for p in cur.fetchall():
        alerts.append({
            'type': 'overstock',
            'severity': 'low',
            'product': p['name'],
            'message': f"OVERSTOCK: {p['name']} has {p['quantity']} units (max: {p['max_stock_level']})"
        })

    # EXPIRING SOON
    cur.execute("""
        SELECT id, name, quantity, expiry_date FROM products
        WHERE expiry_date IS NOT NULL
        AND expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 7 DAY)
        AND quantity > 0
    """)
    for p in cur.fetchall():
        alerts.append({
            'type': 'expiring',
            'severity': 'high',
            'product': p['name'],
            'message': f"EXPIRING: {p['name']} expires on {p['expiry_date']} with {p['quantity']} units in stock"
        })

    # SUDDEN SALES DROP
    cur.execute("""
        SELECT p.name,
            SUM(CASE WHEN s.sale_date >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN si.quantity ELSE 0 END) AS this_week,
            SUM(CASE WHEN s.sale_date BETWEEN DATE_SUB(NOW(), INTERVAL 14 DAY) AND DATE_SUB(NOW(), INTERVAL 7 DAY) THEN si.quantity ELSE 0 END) AS last_week
        FROM products p
        JOIN sale_items si ON p.id = si.product_id
        JOIN sales s ON si.sale_id = s.id
        GROUP BY p.id, p.name
        HAVING last_week > 10 AND this_week < last_week * 0.3
    """)
    for p in cur.fetchall():
        alerts.append({
            'type': 'sales_drop',
            'severity': 'medium',
            'product': p['name'],
            'message': f"SALES DROP: {p['name']} sold {p['last_week']} units last week but only {p['this_week']} this week"
        })

    cur.close()
    db.close()
    alerts.sort(key=lambda a: {'high': 0, 'medium': 1, 'low': 2}[a['severity']])
    return alerts


# ─────────────────────────────────────────────────────────────
# EXPOSED API ENDPOINTS (Routing Layer)
# ─────────────────────────────────────────────────────────────

@app.route('/api/ai/restock', methods=['GET'])
def restock_prediction():
    return jsonify(fetch_restock_predictions())


@app.route('/api/ai/products', methods=['GET'])
def product_analysis():
    return jsonify(fetch_product_analysis())


@app.route('/api/ai/trends', methods=['GET'])
def sales_trends():
    return jsonify(fetch_sales_trends())


@app.route('/api/ai/alerts', methods=['GET'])
def intelligent_alerts():
    return jsonify(fetch_intelligent_alerts())


@app.route('/api/ai/dashboard', methods=['GET'])
def ai_dashboard():
    """Consolidated endpoint referencing clean internal logic blocks."""
    restock_data = fetch_restock_predictions()
    product_data = fetch_product_analysis()
    trend_data = fetch_sales_trends()
    alert_data = fetch_intelligent_alerts()

    fast = [p for p in product_data if p.get("classification") == "fast"]
    slow = [p for p in product_data if p.get("classification") == "slow"]
    dead = [p for p in product_data if p.get("classification") == "dead_stock"]

    return jsonify({
        "fast": fast,
        "slow": slow,
        "dead": dead,
        "alerts": alert_data,
        "trends": {
            "daily": trend_data["daily"],
            "weekly": trend_data["weekly"],
            "monthly": trend_data["monthly"],
            "insight": trend_data["insight"],
            "prediction": trend_data["predicted_next_week_revenue"]
        },
        "restock": restock_data
    })


if __name__ == '__main__':
    app.run(debug=True, port=5000)
