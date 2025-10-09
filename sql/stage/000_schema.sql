-- =============================================
-- 001_schema.sql
-- Purpose: Initialize database structure
-- =============================================

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