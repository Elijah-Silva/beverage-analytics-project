SET SEARCH_PATH = ref;

-- Seed currency codes
COPY processing_methods (processing_method_name)
FROM '/home/elijah/beverage-analytics-project/data/seeds/processing_methods.csv'
DELIMITER ',' CSV HEADER;
