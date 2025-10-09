SET search_path TO stage;

CREATE TABLE raw_products (
    product_name        TEXT NOT NULL,
    product_type        TEXT,
    vendor_name         TEXT,
    region              TEXT,
    roast_level         TEXT,
    roast_date          DATE,
    origin_type         TEXT,
    varietal            TEXT,
    altitude_meters     INT,
    processing_method   TEXT,
    material            TEXT,
    volume              INT,
    clay_type           TEXT,
    pour_speed          INT,
    color               TEXT,
    tea_type            TEXT,
    harvest_year        INT,
    storage_location    TEXT,
    cultivar            TEXT,
    is_active           BOOLEAN,
    notes               TEXT,
    created_date        TIMESTAMPTZ,
    last_modified_date  TIMESTAMPTZ
);

CREATE TABLE products (
    product_name        TEXT NOT NULL,
    product_type        TEXT,
    vendor_name         TEXT,
    region              TEXT,
    is_active           BOOLEAN,
    notes               TEXT,
    created_date        TIMESTAMPTZ,
    last_modified_date  TIMESTAMPTZ
);

-- subtype stage tables
CREATE TABLE IF NOT EXISTS products_tea (
    product_name      TEXT NOT NULL,
    vendor_name       TEXT,
    tea_type          TEXT,
    harvest_year      INT,
    storage_location  TEXT,
    cultivar          TEXT,
    altitude_meters   TEXT,
    processing_method TEXT
);

CREATE TABLE IF NOT EXISTS products_coffee (
    product_name      TEXT NOT NULL,
    vendor_name       TEXT,
    roast_level       TEXT,
    roast_date        DATE,
    origin_type       TEXT,
    varietal          TEXT,
    altitude_meters   INT,
    processing_method TEXT
);

CREATE TABLE IF NOT EXISTS products_equipment (
    product_name      TEXT NOT NULL,
    vendor_name       TEXT,
    material          TEXT,
    volume            INT,
    clay_type         TEXT,
    pour_speed        INT,
    color             TEXT
);