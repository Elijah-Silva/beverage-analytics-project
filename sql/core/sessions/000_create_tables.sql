SET SEARCH_PATH = core;

CREATE TABLE sessions
(
	session_id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_code        UUID        NOT NULL,
	brewing_method_id   INT         NOT NULL,
	rating              INT         NOT NULL CHECK (rating BETWEEN 1 AND 10),
	water_type          TEXT        NOT NULL CHECK (water_type IN ('Tap', 'Spring', 'Filtered')),
	session_type        TEXT        NOT NULL CHECK (session_type IN ('Tea', 'Coffee')),
	grind_size          NUMERIC,
	session_date        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	favorite_flag       BOOLEAN     NOT NULL DEFAULT FALSE,
	session_location_id INT         NOT NULL,
	location_id         INT         NOT NULL,
	created_date        DATE        NOT NULL DEFAULT NOW(),
	last_modified_date  DATE        NOT NULL DEFAULT NOW(),
	notes               TEXT,
	FOREIGN KEY (brewing_method_id) REFERENCES ref.brewing_methods (brewing_method_id),
	FOREIGN KEY (session_location_id) REFERENCES ref.session_locations (session_location_id),
	FOREIGN KEY (location_id) REFERENCES core.locations (location_id),
	UNIQUE (session_code)
);
