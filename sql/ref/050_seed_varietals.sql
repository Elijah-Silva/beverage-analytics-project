SET SEARCH_PATH = ref;

-- Seed currency codes
COPY varietals (varietal_name)
FROM '/home/elijah/beverage-analytics-project/data/seeds/varietals.csv'
DELIMITER ',' CSV HEADER;
