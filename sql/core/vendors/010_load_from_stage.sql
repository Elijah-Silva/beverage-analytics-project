INSERT INTO core.vendors (vendor_name, country_code_id, currency_code_id, vendor_website_url)
SELECT v.vendor_name, cc.country_code_id, cur.currency_code_id, v.vendor_website_url
FROM stage.vendors v
JOIN ref.country_codes  cc  ON cc.country_code  = v.country_code
JOIN ref.currency_codes cur ON cur.currency_code = v.currency_code;
