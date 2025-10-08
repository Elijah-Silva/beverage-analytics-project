-- =============================================
-- 001_schema.sql
-- Purpose: Initialize database structure
-- =============================================


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
	role_id						INT				NOT NULL,
	notes						TEXT,
	FOREIGN KEY (session_id) REFERENCES sessions (session_id),
	FOREIGN KEY (batch_inventory_id) REFERENCES batch_inventory (batch_inventory_id),
	FOREIGN KEY (role_id) REFERENCES roles (role_id)
);

CREATE TABLE product_countries (
	product_origin_id			BIGINT		GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 	product_id     				INT			NOT NULL,
 	country_code_id				INT 		NOT NULL,
 	FOREIGN KEY (product_id) REFERENCES products(product_id),
 	FOREIGN KEY (country_code_id) REFERENCES country_codes(country_code_id)
);