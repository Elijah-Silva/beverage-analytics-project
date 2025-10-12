SET SEARCH_PATH = core;

-- Seed country codes
INSERT INTO core.sessions (session_code, brewing_method_id, rating, water_type, session_type, session_date,
                      favorite_flag, session_location_id, location_id, grind_size, notes)
SELECT
    s.session_code,
    bm.brewing_method_id,
    s.rating,
    s.water_type,
    s.session_type,
    s.session_date,
    s.favorite_flag,
    sl.session_location_id,
    l.location_id,
    s.grind_size,
    s.notes
FROM stage.sessions s
    JOIN ref.brewing_methods bm ON bm.brewing_method_name = s.brewing_method_name
    JOIN ref.session_locations sl ON sl.session_location_name = s.session_location_name
    JOIN core.locations l ON l.location_name = s.location_name;

/*
INSERT INTO core.session_batch_inventory (session_id, batch_inventory_id, quantity_used, role_id, batch_code, unit)
SELECT

 */