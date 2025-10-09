SET search_path TO stage;

CREATE TABLE locations (
    location_name       TEXT,
	address				TEXT,
	city				TEXT,
	state				TEXT,
	country_code		CHAR(2),
  	latitude        	NUMERIC(9,6),
  	longitude       	NUMERIC(9,6)
);