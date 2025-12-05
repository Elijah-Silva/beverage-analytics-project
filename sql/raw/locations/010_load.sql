SET SEARCH_PATH = raw;

-- Seed country codes
COPY locations (location_name, address, city, state, country_code, latitude, longitude)
FROM '/home/elijah/beverage/data/raw/locations.csv'
DELIMITER ',' CSV HEADER;