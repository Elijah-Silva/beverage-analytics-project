SET SEARCH_PATH = raw;

-- Seed country codes
COPY extractions (session_code, extraction_number, extraction_time, water_temperature, flavor_notes)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/extractions.csv'
DELIMITER ',' CSV HEADER;