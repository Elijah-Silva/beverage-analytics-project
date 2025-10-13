SET search_path TO stage;

TRUNCATE stage.vendors;

INSERT INTO stage.vendors (vendor_name, country_code, currency_code, vendor_website_url)
SELECT INITCAP(TRIM(vendor_name)),
       UPPER(TRIM(country_code)),
       UPPER(TRIM(currency_code)),
       NULLIF(TRIM(vendor_website_url),'')
FROM raw.vendors
WHERE vendor_name IS NOT NULL;
