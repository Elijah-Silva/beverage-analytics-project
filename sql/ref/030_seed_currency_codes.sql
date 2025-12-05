SET SEARCH_PATH = ref;

-- Seed currency codes
COPY currency_codes (currency_code, currency_name)
FROM '/home/elijah/beverage/data/seeds/currency_codes-iso4217.csv'
DELIMITER ',' CSV HEADER;
