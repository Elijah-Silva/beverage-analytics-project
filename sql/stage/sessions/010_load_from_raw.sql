SET SEARCH_PATH = stage;

-- Seed country codes
INSERT INTO sessions (session_code, brewing_method_name, rating, water_type, session_type, session_date,
                      favorite_flag, session_location_name, location_name, grind_size, notes)
SELECT
    session_code::UUID,
    brewing_method_name,
    rating::INT,
    water_type,
    session_type,
    session_date::DATE,
    favorite_flag::BOOLEAN,
    session_location_name,
    location_name,
    grind_size::NUMERIC,
    notes
FROM raw.sessions;


INSERT INTO session_batch_inventory (session_code, product_name, vendor_name, quantity_used, role, batch_code, unit)
SELECT
    session_code::UUID,
    product_name,
    vendor_name,
    quantity_used::INT,
    role,
    batch_code,
    unit
FROM raw.session_batch_inventory;