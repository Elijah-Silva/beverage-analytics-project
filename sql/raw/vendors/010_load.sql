SET SEARCH_PATH = raw;

-- Seed country codes
COPY vendors (vendor_name, country_code, currency_code, vendor_website_url)
FROM '/Users/elijahsilva/projects/beverage-analytics-project/data/raw/vendors.csv'
DELIMITER ',' CSV HEADER;