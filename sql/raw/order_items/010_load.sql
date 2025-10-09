SET SEARCH_PATH = raw;

-- Seed country codes
COPY order_items (order_number, product_name, unit_price, quantity_count, quantity_weight,
                  subtotal)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/order_items.csv'
DELIMITER ',' CSV HEADER;