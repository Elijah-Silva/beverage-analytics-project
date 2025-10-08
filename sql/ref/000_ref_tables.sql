-- =============================================
-- 000_ref_tables.sql
-- Purpose: Create reference tables
-- =============================================
SET SEARCH_PATH = ref;

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
