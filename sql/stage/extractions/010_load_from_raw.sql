SET SEARCH_PATH = stage;

-- Seed country codes
INSERT INTO extractions (
	session_code,
	extraction_number,
	extraction_time,
	water_temperature,
	flavor_notes
)
SELECT
	session_code::UUID,
	extraction_number::INT,
	extraction_time::INT,
	water_temperature::INT,
	NULLIF(TRIM(flavor_notes),'')
FROM raw.extractions;

