SET SEARCH_PATH = raw;

-- Seed country codes
COPY sessions (session_code, brewing_method_name, rating, water_type, session_type, session_date,
               favorite_flag, session_location_name, location_name, grind_size, notes)
	FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/sessions.csv'
	DELIMITER ',' CSV HEADER;

COPY session_batch_inventory (session_code, product_name, vendor_name, production_date, quantity_used,
                              quantity_output, role, batch_code, unit)
	FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/session_batch_inventory.csv'
	DELIMITER ',' CSV HEADER;