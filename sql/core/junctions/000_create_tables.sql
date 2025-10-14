SET SEARCH_PATH = core;

CREATE TABLE product_countries (
	product_origin_id			BIGINT		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	product_id     				INT			NOT NULL,
 	country_code_id				INT 		NOT NULL,
 	FOREIGN KEY (product_id) REFERENCES products(product_id),
 	FOREIGN KEY (country_code_id) REFERENCES ref.country_codes(country_code_id),
	UNIQUE (product_id, country_code_id)
);