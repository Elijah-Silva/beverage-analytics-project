SET SEARCH_PATH = ref;

-- Seed country codes
COPY country_codes (country_code, country_name)
FROM '/home/elijah/beverage-analytics-project/data/seeds/country_codes-iso3166.csv'
DELIMITER ',' CSV HEADER;
