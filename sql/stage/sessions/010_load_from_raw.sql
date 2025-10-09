SET SEARCH_PATH = stage;

-- Seed country codes
INSERT INTO sessions (session_code, brewing_method_name, rating, water_type, session_type, session_date,
                      favorite_flag, session_location_name, location_name, created_date,
                      last_modified_date, grind_size, notes)
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
    created_date::DATE,
    last_modified_date::DATE,
    grind_size::NUMERIC,
    notes
FROM raw.sessions;

