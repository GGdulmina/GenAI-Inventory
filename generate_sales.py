import mysql.connector
import random
from datetime import datetime, timedelta

conn = mysql.connector.connect(
    host='localhost', user='root', password='NewPassword123!', database='inventory_db'
)
cur = conn.cursor()

# Generate sales over the past 6 months
start_date = datetime.now() - timedelta(days=180)
invoice_num = 1000

for i in range(1000):
    # Bias: more sales on Fri/Sat/Sun
    sale_date = start_date + timedelta(
        days=random.randint(0, 180),
        hours=random.randint(8, 20),
        minutes=random.randint(0, 59)
    )
    # Weekend boost
    if sale_date.weekday() >= 4:
        if random.random() < 0.3:
            continue  # skip some to create pattern

    invoice = f"INV{invoice_num:05d}"
    invoice_num += 1

    cur.execute(
        "INSERT INTO sales (invoice_number, sale_date, total_amount, user_id) VALUES (%s, %s, 0, 1)",
        (invoice, sale_date)
    )
    sale_id = cur.lastrowid

    # 1-5 products per sale
    num_items = random.randint(1, 5)
    product_ids = random.sample(range(1, 51), num_items)
    total = 0

    for pid in product_ids:
        cur.execute("SELECT price FROM products WHERE id=%s", (pid,))
        row = cur.fetchone()
        if not row:
            continue
        price = float(row[0])
        qty = random.randint(1, 4)
        subtotal = price * qty
        total += subtotal
        cur.execute(
            "INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal) VALUES (%s,%s,%s,%s,%s)",
            (sale_id, pid, qty, price, subtotal)
        )

    cur.execute("UPDATE sales SET total_amount=%s WHERE id=%s", (total, sale_id))

conn.commit()
cur.close()
conn.close()
print("Done! 1000 sales records generated.")
