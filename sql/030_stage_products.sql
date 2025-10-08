-- =============================================
-- 030_stage_products.sql
-- Purpose: Creates staging_products table and loads CSV via COPY.
-- =============================================

SET search_path TO beverage;

BEGIN;

-- Create the staging table
CREATE UNLOGGED TABLE IF NOT EXISTS staging_products (
    -- Core product table
	product_name			TEXT			NOT NULL,
    product_type_name       TEXT        	NOT NULL,
    vendor_name             TEXT        	NOT NULL,
    is_active            	TEXT,
    notes					TEXT,

    -- Common attributes (not in core)
    processing_method		TEXT,

    -- Equipment-specific (nullable) ----
    material           		TEXT,
    volume               	INT,
    clay_type	          	TEXT,
    pour_speed              INT,
	color                   TEXT,

    -- Coffee-specific (nullable) ----
    roast_level             TEXT,
    roast_date              DATE,
    origin_type             TEXT,
    varietal	           	TEXT,
    altitude_meters         INT,

    -- Tea-specific (nullable) ----
    tea_type                TEXT,
    harvest_year            INT,
    storage_location        TEXT,
    cultivar				TEXT,

    -- ---- Multi-origin support ----
    -- Comma-separated ISO-2 (e.g., "BR,CO") for Coffee/Tea;
    -- explode to rows in transform → product_countries
    origin_country_codes    TEXT,

    -- ---- Load audit columns (super useful) ----
    source_file             TEXT,                   -- e.g., 'seeds/products.csv'
    source_row_number       INT,                    -- if you provide it
    loaded_at               TIMESTAMPTZ 	NOT NULL DEFAULT now()
);

-- 3) Make reloads idempotent
TRUNCATE staging_products;

COMMIT;