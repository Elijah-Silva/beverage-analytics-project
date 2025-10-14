SET SEARCH_PATH = core;

-- Seed country codes
INSERT INTO core.extractions (
	session_id,
	session_code,
	extraction_number,
	extraction_time,
	water_temperature,
	flavor_notes
)
SELECT
	s.session_id,
	s.session_code,
	e.extraction_number,
	e.extraction_time,
	e.water_temperature,
	e.flavor_notes
FROM stage.extractions e
JOIN core.sessions     s
	ON s.session_code = e.session_code;
