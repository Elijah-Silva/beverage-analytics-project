SET SEARCH_PATH = stage;

CREATE TABLE sessions (
    session_code          UUID,
    brewing_method_name   TEXT,
    rating                INT,
    water_type            TEXT,
    session_type          TEXT,
    session_date          DATE,
    favorite_flag         BOOLEAN,
    session_location_name TEXT,
    location_name         TEXT,
    grind_size            NUMERIC,
    notes                 TEXT
);

CREATE TABLE session_batch_inventory (
    session_code            UUID,
    product_name            TEXT,
    vendor_name             TEXT,
    quantity_used           INT,
    role                    TEXT,
    batch_code              TEXT,
    unit                    TEXT
);