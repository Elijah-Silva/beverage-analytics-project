SET SEARCH_PATH = core;

CREATE TABLE batch_inventory (
	batch_inventory_id	INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id			INT				NOT NULL,
	order_item_id		INT,
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
	storage_location	TEXT			NOT NULL,
	is_in_stock			BOOLEAN			NOT NULL,
	best_before_date 	DATE,
	received_date    	DATE 			NOT NULL,
	created_date 		TIMESTAMPTZ		NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ		NOT NULL DEFAULT now(),
	notes				TEXT,
	CHECK (best_before_date IS NULL OR best_before_date >= received_date),
	FOREIGN KEY (product_id) REFERENCES core.products (product_id),
	FOREIGN KEY (order_item_id) REFERENCES core.order_items (order_item_id)
);

CREATE TABLE session_batch_inventory (
	session_batch_inventory_id	INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	session_id					INT				NOT NULL,
	batch_inventory_id			INT				NOT NULL,
	quantity_used				NUMERIC(7,2),
	role_id						INT				NOT NULL,
	notes						TEXT,
	FOREIGN KEY (session_id) REFERENCES core.sessions (session_id),
	FOREIGN KEY (batch_inventory_id) REFERENCES batch_inventory (batch_inventory_id),
	FOREIGN KEY (role_id) REFERENCES ref.roles (role_id)
);