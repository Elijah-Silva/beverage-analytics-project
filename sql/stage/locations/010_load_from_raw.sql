SET search_path TO stage;

TRUNCATE stage.locations;

INSERT INTO locations (
	location_name,
	address,
	city,
	state,
	country_code,
	latitude,
	longitude
)
SELECT
	TRIM(location_name),
	TRIM(address),
	TRIM(city),
	TRIM(UPPER(state)),
	TRIM(UPPER(country_code)),
	latitude::NUMERIC(9, 6),
	longitude::NUMERIC(9, 6)
FROM raw.locations;
