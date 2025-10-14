SET search_path TO core;

CREATE TABLE vendors (
 	vendor_id 			INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	vendor_name 		TEXT 		NOT NULL,
 	country_code_id		INT 		NOT NULL,
 	currency_code_id 	INT 		NOT NULL,
 	vendor_website_url 	TEXT,
 	FOREIGN KEY (country_code_id) REFERENCES ref.country_codes (country_code_id),
 	FOREIGN KEY (currency_code_id) REFERENCES ref.currency_codes (currency_code_id),
	UNIQUE (vendor_name, country_code_id)
);