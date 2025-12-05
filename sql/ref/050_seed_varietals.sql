SET SEARCH_PATH = ref;

-- Seed currency codes
COPY varietals (varietal_name)
FROM '/home/elijah/beverage/data/seeds/varietals.csv'
DELIMITER ',' CSV HEADER;
