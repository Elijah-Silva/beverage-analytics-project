-- =============================================
-- 001_beverage_schema.sql
-- Purpose: Initialize database structure
-- =============================================

----------------------
-- wipe data and reset
DROP SCHEMA IF EXISTS beverage CASCADE;
CREATE SCHEMA beverage;
SET search_path TO beverage;

---------------------
-- validation tables

CREATE TABLE country_codes (
	country_code_id		INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	country_code 		VARCHAR(2) 	NOT NULL,
	country_name 		TEXT 		NOT NULL
);

CREATE TABLE currency_codes (
	currency_code_id 	INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	currency_code		VARCHAR(3) 	NOT NULL,
	currency_name 		TEXT 		NOT NULL
);

CREATE TABLE product_types (
	product_type_id 	INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_type_name 	TEXT 		NOT NULL
);

CREATE TABLE brewing_methods (
	brewing_method_id 	INT			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	brewing_method_name	TEXT		NOT NULL UNIQUE
);

CREATE TABLE session_locations (
	session_location_id 	INT		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_location_name	TEXT	NOT NULL
);

CREATE TABLE order_status (
	order_status_id		INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_status_name	TEXT		NOT NULL
);

CREATE TABLE roles (
	role_id				INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	role_name			TEXT		NOT NULL
);

CREATE TABLE varietals (
  	varietal_id    		INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  	varietal_name  		TEXT 		NOT NULL UNIQUE
);

CREATE TABLE processing_methods (
  	processing_method_id    INT 	GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  	processing_method_name 	TEXT 	NOT NULL UNIQUE
);

CREATE TABLE materials (
	material_id			INT			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	material_name		TEXT		NOT NULL,
	category			TEXT		NOT NULL CHECK (category IN ('Metal','Ceramic','Glass','Wood','Natural','Synthetic')),
	UNIQUE (material_name)
);

CREATE TABLE clay_types (
  	clay_type_id   			INT 	GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  	clay_type_name 			TEXT 	NOT NULL,
  	UNIQUE (clay_type_name)
);


---------------------
-- core lookup tables

CREATE TABLE vendors (
 	vendor_id 			INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	vendor_name 		TEXT 		NOT NULL,
 	country_code_id		INT 		NOT NULL,
 	currency_code_id 	INT 		NOT NULL,
 	vendor_website_url 	TEXT,
 	FOREIGN KEY (country_code_id) REFERENCES country_codes (country_code_id),
 	FOREIGN KEY (currency_code_id) REFERENCES currency_codes (currency_code_id)
);

CREATE TABLE products (
	product_id 			INT 		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_name 		TEXT 		NOT NULL,
	product_type_id 	INT 		NOT NULL,
	vendor_id 			INT 		NOT NULL,
	is_active 			BOOLEAN 	NOT NULL DEFAULT TRUE,
	created_date 		TIMESTAMPTZ	NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ	NOT NULL DEFAULT now(),
	FOREIGN KEY (product_type_id) REFERENCES product_types (product_type_id),
	FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id)
);


CREATE TABLE locations (
	location_id 		INT 			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	address				TEXT			NOT NULL,
	city				TEXT			NOT NULL,
	state				TEXT			NOT NULL,
	country_code_id		INT				NOT NULL,
  	latitude        	NUMERIC(9,6)	NOT NULL CHECK (latitude  BETWEEN -90 AND 90),
  	longitude       	NUMERIC(9,6)	NOT NULL CHECK (longitude BETWEEN -180 AND 180),
	FOREIGN KEY (country_code_id) REFERENCES country_codes (country_code_id)
);

CREATE TABLE sessions (
	session_id			INT			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	brewing_method_id	INT			NOT NULL,
	rating				INT			NOT NULL CHECK (rating BETWEEN 1 and 10),
	water_type			TEXT		NOT NULL CHECK (water_type IN ('Tap', 'Spring', 'Filtered')),
	session_type		TEXT		NOT NULL CHECK (session_type IN ('Tea', 'Coffee')),
	session_date		TIMESTAMPTZ	NOT NULL DEFAULT now(),
	favorite_flag		BOOLEAN		NOT NULL DEFAULT FALSE,
	session_location_id	INT			NOT NULL,
	location_id			INT			NOT NULL,
	created_date 		TIMESTAMPTZ	NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ	NOT NULL DEFAULT now(),
	grind_size			NUMERIC,
	notes				TEXT,
	CHECK (session_type <> 'Coffee' OR grind_size IS NOT NULL),
	FOREIGN KEY (brewing_method_id) REFERENCES brewing_methods (brewing_method_id),
	FOREIGN KEY (session_location_id) REFERENCES session_locations (session_location_id),
	FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE extractions (
	extract_id 			INT			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_id			INT			NOT NULL,
	extraction_number	INT			NOT NULL CHECK (extraction_number BETWEEN 1 AND 99),
	extraction_time		INT			NOT NULL CHECK (extraction_time BETWEEN 1 AND 999999),
	water_temperature	INT			NOT NULL CHECK (water_temperature BETWEEN 1 AND 999),
	flavor_notes		TEXT,
	FOREIGN KEY (session_id) REFERENCES sessions (session_id)
		ON UPDATE RESTRICT
		ON DELETE CASCADE,
	UNIQUE (session_id, extraction_number)
);

CREATE TABLE orders (
	order_id 			INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	vendor_id			INT				NOT NULL,
	order_date			TIMESTAMPTZ 	NOT NULL DEFAULT now(),
	shipping_cost		NUMERIC(7,2)	NOT NULL,
	total_cost			NUMERIC(9,2)	NOT NULL,
	notes				TEXT,
	order_status_id		INT				NOT NULL,
	created_date 		TIMESTAMPTZ		NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ		NOT NULL DEFAULT now(),
	FOREIGN KEY (vendor_id) REFERENCES vendors (vendor_id),
	FOREIGN KEY (order_status_id) REFERENCES order_status (order_status_id)
);

CREATE TABLE order_items (
	order_item_id 		INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_id			INT				NOT NULL,
	product_id			INT				NOT NULL,
	unit_price			NUMERIC(9,2)	NOT NULL,
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
	subtotal			NUMERIC(9,2)	NOT NULL,
	notes				TEXT,
	FOREIGN KEY (order_id) REFERENCES orders (order_id),
	FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE batch_inventory (
	batch_inventory_id	INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id			INT				NOT NULL,
	order_item_id		INT,
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
	storage_location	TEXT			NOT NULL,
	is_in_stock			BOOLEAN			NOT NULL,
	best_before_date 	DATE,
	received_date    	DATE 			NOT NULL,
	created_date 		TIMESTAMPTZ		NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ		NOT NULL DEFAULT now(),
	notes				TEXT,
	CHECK (best_before_date IS NULL OR best_before_date >= received_date),
	FOREIGN KEY (product_id) REFERENCES products (product_id),
	FOREIGN KEY (order_item_id) REFERENCES order_items (order_item_id)
);

CREATE TABLE session_batch_inventory (
	session_batch_inventory_id	INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_id					INT				NOT NULL,
	batch_inventory_id			INT				NOT NULL,
	quantity_used				NUMERIC(7,2),
	role_id						INT				 NOT NULL,
	notes						TEXT,
	FOREIGN KEY (session_id) REFERENCES sessions (session_id),
	FOREIGN KEY (batch_inventory_id) REFERENCES batch_inventory (batch_inventory_id),
	FOREIGN KEY (role_id) REFERENCES roles (role_id)
);

------------------------
-- product subtype tables

CREATE TABLE product_coffee_details (
	product_id				INT		PRIMARY KEY REFERENCES products (product_id),
	roast_level				TEXT	NOT NULL CHECK (roast_level IN ('Light','Medium','Dark','Espresso')),
	roast_date				DATE	NOT NULL,
	country_id				INT,
	varietal_id				INT,
	altitude_meters			INT		CHECK (altitude_meters IS NULL OR altitude_meters >= 0),
	processing_method_id	INT,
	FOREIGN KEY (country_id) REFERENCES country_codes (country_code_id),
	FOREIGN KEY (varietal_id) REFERENCES varietals (varietal_id),
	FOREIGN KEY (processing_method_id) REFERENCES processing_methods (processing_method_id)
);

CREATE TABLE product_equipment_details (
	product_id				INT		PRIMARY KEY REFERENCES products (product_id),
	material_id				INT		NOT NULL,
	volume					INT,
	clay_type_id			INT,
	pour_speed				INT,
	color					TEXT	NOT NULL,
	notes					TEXT,
	FOREIGN KEY (material_id) REFERENCES materials (material_id),
	FOREIGN KEY (clay_type_id) REFERENCES clay_types (clay_type_id)
);

CREATE TABLE product_tea_details (
	product_id				INT		PRIMARY KEY REFERENCES products (product_id),
	country_code_id			INT		NOT NULL,
	tea_type				TEXT	NOT NULL CHECK (tea_type IN ('Green', 'White', 'Yellow', 'Oolong', 'Black', 'Puer (Shou)', 'Puer (Sheng)', 'Hei Cha', 'Herbal')),
	harvest_year			INT,
	storage_location		TEXT,
	cultivar				TEXT,
	processing_method_id	INT,
	FOREIGN KEY (processing_method_id) REFERENCES processing_methods (processing_method_id),
	FOREIGN KEY (country_code_id) REFERENCES country_codes (country_code_id)
);