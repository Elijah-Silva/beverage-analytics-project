SET SEARCH_PATH = raw;

CREATE TABLE sessions (
    session_code            TEXT,
    brewing_method_name     TEXT,
    rating                  TEXT,
    water_type              TEXT,
    session_type            TEXT,
    session_date            TEXT,
    favorite_flag           TEXT,
    session_location_name   TEXT,
    location_name           TEXT,
    grind_size              TEXT,
    notes                   TEXT
);