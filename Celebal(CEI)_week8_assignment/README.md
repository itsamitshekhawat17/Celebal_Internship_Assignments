# E-Commerce Order Analytics System

An end-to-end analytics pipeline: generate messy e-commerce data, clean it with Pandas,
load it into SQLite, analyze it with SQL (joins, window functions, CTEs, cohort analysis),
and query it through a command-line reporting tool.

## Architecture

```
ecommerce-analytics-system/
│── data/
│   ├── raw/              # generated CSVs with intentional data issues
│   ├── cleaned/           # cleaned CSVs after validation
│   └── ecommerce.db       # SQLite database
│── notebooks/
│   ├── 01_generate_data.ipynb            # Step 1: create raw datasets
│   ├── 02_clean_data.ipynb               # Step 2: clean with Pandas
│   ├── 03_load_to_sql.ipynb              # Step 3: load into SQLite
│   ├── 04_sql_analytics.ipynb            # Steps 4-5: joins, aggregations, window functions, CTEs
│   ├── 05_cohort_and_segmentation.ipynb  # Steps 6-7: cohort/retention + RFM segmentation
│   └── 06_cli_demo_and_edge_cases.ipynb  # Steps 8-9: CLI demo + edge case tests
│── scripts/
│   └── report_cli.py      # command-line reporting tool
│── sql/
│   ├── schema.sql
│   ├── aggregations.sql
│   ├── window_functions.sql
│   └── cohort_analysis.sql
│── output/
│   └── sample_reports/    # saved CLI output + RFM csv
│── README.md
```

## How the pipeline works

1. **01_generate_data.ipynb** uses Faker to build `customers`, `products`, `orders`,
   `order_items` tables and injects intentional problems: nulls, duplicate rows,
   customer/order/product IDs that don't match across tables, negative prices/quantities,
   and future-dated orders. Saves to `data/raw/`.
2. **02_clean_data.ipynb** loads the raw CSVs, drops duplicates and bad rows, fixes
   negative values, fills missing categories/status, and drops any order/order_item
   whose foreign key doesn't exist in the parent table. Saves to `data/cleaned/`.
3. **03_load_to_sql.ipynb** creates `data/ecommerce.db` from `sql/schema.sql`
   (with PK/FK/NOT NULL constraints) and loads the cleaned CSVs in, then verifies
   row counts and checks for orphan rows.
4. **04_sql_analytics.ipynb** runs join/aggregation queries (revenue by customer,
   category, month; top products; AOV by segment) and window function/CTE queries
   (RANK/DENSE_RANK by lifetime value, running totals, moving averages, month-over-month
   growth with LAG).
5. **05_cohort_and_segmentation.ipynb** builds cohorts by first purchase month, computes
   a retention rate table, splits customers into repeat vs one-time, and does frequency/
   spend-tier segmentation plus a full RFM (Recency, Frequency, Monetary) score.
6. **06_cli_demo_and_edge_cases.ipynb** runs the CLI tool for every report type, tests
   edge cases (bad report name, missing args, empty result set, zero-order customer,
   bad DB path), and writes sample output to `output/sample_reports/`.

## Running the CLI tool directly

```bash
cd ecommerce-analytics-system
python3 scripts/report_cli.py --report revenue
python3 scripts/report_cli.py --report top_customers
python3 scripts/report_cli.py --report top_products
python3 scripts/report_cli.py --report retention
python3 scripts/report_cli.py --report segments
```

The tool can be run from any directory — the database path is resolved relative to the
script's own location, not the caller's working directory.

## Edge cases handled

- Unknown `--report` value is rejected by argparse with the valid choices listed.
- Missing `--report` argument prints a usage error instead of crashing.
- A query that returns zero rows prints "No data found" instead of an empty table.
- Database connection failures are caught and exit cleanly with a message.
- Customers with zero orders and future-dated orders are handled without breaking joins.

## Requirements

```
pandas
faker
tabulate
```

Install with:

```bash
pip install pandas faker tabulate
```

## Sample output

See `output/sample_reports/` for saved CLI output (`revenue.txt`, `top_customers.txt`,
`top_products.txt`, `retention.txt`, `segments.txt`) and `rfm_segmentation.csv` for the
full RFM scoring table.
