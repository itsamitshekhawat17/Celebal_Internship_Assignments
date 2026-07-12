import argparse
import os
import sqlite3
import sys
from tabulate import tabulate

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(SCRIPT_DIR, '..', 'data', 'ecommerce.db')

QUERIES = {
    'revenue': '''
        SELECT strftime('%Y-%m', o.order_date) AS month,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY month
        ORDER BY month
    ''',
    'top_customers': '''
        SELECT c.customer_id, c.name,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY c.customer_id, c.name
        ORDER BY revenue DESC
        LIMIT 10
    ''',
    'top_products': '''
        SELECT p.product_name, SUM(oi.quantity) AS units_sold,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        GROUP BY p.product_name
        ORDER BY revenue DESC
        LIMIT 10
    ''',
    'retention': '''
        WITH first_purchase AS (
            SELECT customer_id, MIN(strftime('%Y-%m', order_date)) AS cohort_month
            FROM orders
            GROUP BY customer_id
        )
        SELECT fp.cohort_month,
               COUNT(DISTINCT o.customer_id) AS active_customers,
               strftime('%Y-%m', o.order_date) AS order_month
        FROM orders o
        JOIN first_purchase fp ON o.customer_id = fp.customer_id
        GROUP BY fp.cohort_month, order_month
        ORDER BY fp.cohort_month, order_month
    ''',
    'segments': '''
        SELECT c.segment, COUNT(DISTINCT c.customer_id) AS n_customers,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY c.segment
    ''',
}


def get_connection():
    try:
        conn = sqlite3.connect(DB_PATH)
        conn.execute('SELECT 1')
        return conn
    except sqlite3.Error as e:
        print(f'Database connection error: {e}')
        sys.exit(1)


def run_report(report_name, conn):
    query = QUERIES.get(report_name)
    if query is None:
        print(f'Unknown report "{report_name}". Available: {", ".join(QUERIES)}')
        return

    cur = conn.cursor()
    cur.execute(query)
    rows = cur.fetchall()
    headers = [d[0] for d in cur.description]

    if not rows:
        print(f'No data found for report "{report_name}".')
        return

    print(tabulate(rows, headers=headers, tablefmt='grid'))


def main():
    parser = argparse.ArgumentParser(description='E-commerce order analytics CLI')
    parser.add_argument(
        '--report',
        required=True,
        choices=list(QUERIES.keys()),
        help='Which report to run'
    )
    args = parser.parse_args()

    conn = get_connection()
    try:
        run_report(args.report, conn)
    finally:
        conn.close()


if __name__ == '__main__':
    main()
