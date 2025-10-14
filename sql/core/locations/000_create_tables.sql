SET search_path TO core;

CREATE TABLE locations
(
	location_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	location_name   TEXT          NOT NULL,
	address         TEXT          NOT NULL,
	city            TEXT          NOT NULL,
	state           TEXT          NOT NULL,
	country_code_id INT           NOT NULL,
	latitude        NUMERIC(9, 6) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
	longitude       NUMERIC(9, 6) NOT NULL CHECK (longitude BETWEEN -180 AND 180),
	FOREIGN KEY (country_code_id) REFERENCES ref.country_codes (country_code_id),
	UNIQUE (location_name)
);