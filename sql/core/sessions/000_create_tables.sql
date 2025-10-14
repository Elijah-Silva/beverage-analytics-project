SET SEARCH_PATH = core;

CREATE TABLE sessions (
	session_id			INT			GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_code        UUID        NOT NULL,
	brewing_method_id	INT			NOT NULL,
	rating				INT			NOT NULL CHECK (rating BETWEEN 1 and 10),
	water_type			TEXT		NOT NULL CHECK (water_type IN ('Tap', 'Spring', 'Filtered')),
	session_type		TEXT		NOT NULL CHECK (session_type IN ('Tea', 'Coffee')),
	session_date		TIMESTAMPTZ	NOT NULL DEFAULT now(),
	favorite_flag		BOOLEAN		NOT NULL DEFAULT FALSE,
	session_location_id	INT			NOT NULL,
	location_id			INT			NOT NULL,
	created_date 		TIMESTAMPTZ	NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ	NOT NULL DEFAULT now(),
	grind_size			NUMERIC,
	notes				TEXT,
	FOREIGN KEY (brewing_method_id) REFERENCES ref.brewing_methods (brewing_method_id),
	FOREIGN KEY (session_location_id) REFERENCES ref.session_locations (session_location_id),
	FOREIGN KEY (location_id) REFERENCES core.locations (location_id),
	UNIQUE (session_code)
);

CREATE TABLE session_batch_inventory (
    session_batch_inventory_id  INT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_id                  INT     NOT NULL,
    batch_inventory_id          INT     NOT NULL,
    quantity_used               INT     NOT NULL CHECK (quantity_used >= 1),
    role_id                     INT     NOT NULL,
    batch_code                  TEXT,
    unit                        TEXT    NOT NULL CHECK (unit IN ('pcs', 'g')),
	UNIQUE (session_id, batch_inventory_id)
);