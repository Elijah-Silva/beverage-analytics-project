SET search_path TO stage;

TRUNCATE stage.locations;

INSERT INTO locations (address, city, state, country_code, latitude, longitude)
SELECT TRIM(address),
       TRIM(city),
       TRIM(state),
       country_code,
       latitude::NUMERIC(9,6),
       longitude::NUMERIC(9,6)
FROM raw.locations;