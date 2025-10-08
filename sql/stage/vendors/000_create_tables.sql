SET search_path TO stage;

CREATE TABLE vendors (
 	vendor_name 		TEXT,
 	country_code		CHAR(2),
 	currency_code    	CHAR(3),
 	vendor_website_url 	TEXT
);