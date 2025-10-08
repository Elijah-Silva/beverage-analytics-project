SET SEARCH_PATH = ref;

-- Seed currency codes
COPY varietals (varietal_name)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/seeds/varietals.csv'
DELIMITER ',' CSV HEADER;
