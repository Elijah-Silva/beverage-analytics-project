SET SEARCH_PATH = raw;

-- Seed country codes
COPY sessions (session_code, brewing_method_name, rating, water_type, session_type, session_date,
              favorite_flag, session_location_name, location_name, created_date, last_modified_date,
              grind_size, notes)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/sessions.csv'
DELIMITER ',' CSV HEADER;