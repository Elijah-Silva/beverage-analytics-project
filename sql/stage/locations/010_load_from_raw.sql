SET search_path TO stage;

TRUNCATE stage.locations;

INSERT INTO locations (location_name, address, city, state, country_code, latitude, longitude)
SELECT location_name,
       address,
       city,
       state,
       country_code,
       latitude::NUMERIC(9,6),
       longitude::NUMERIC(9,6)
FROM raw.locations;