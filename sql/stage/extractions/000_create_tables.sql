SET SEARCH_PATH = stage;

CREATE TABLE extractions (
	session_code        UUID,
	extraction_number	INT,
	extraction_time		INT,
	water_temperature	INT,
	notes		TEXT
);
