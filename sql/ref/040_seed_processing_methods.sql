SET SEARCH_PATH = ref;

-- Seed currency codes
COPY processing_methods (processing_method_name)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/seeds/processing_methods.csv'
DELIMITER ',' CSV HEADER;
