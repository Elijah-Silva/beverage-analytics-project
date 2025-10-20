SET SEARCH_PATH = raw;

-- Seed country codes
COPY orders (vendor_name, order_date, order_number, shipping_cost, total_cost, order_status)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/orders.csv'
DELIMITER ',' CSV HEADER;