SET SEARCH_PATH = ref;

-- Seed currency codes
COPY processing_methods (processing_method_name)
FROM '/home/elijah/beverage/data/seeds/processing_methods.csv'
DELIMITER ',' CSV HEADER;
