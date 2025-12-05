SET SEARCH_PATH = raw;

-- Seed country codes
COPY extractions (session_code, extraction_number, extraction_time, water_temperature, notes)
FROM '/home/elijah/beverage-analytics-project/data/raw/extractions.csv'
DELIMITER ',' CSV HEADER;