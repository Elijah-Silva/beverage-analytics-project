SET SEARCH_PATH = raw;

-- Seed country codes
COPY locations (location_name, address, city, state, country_code, latitude, longitude)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/locations.csv'
DELIMITER ',' CSV HEADER;