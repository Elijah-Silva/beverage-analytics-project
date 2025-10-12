SET SEARCH_PATH = core;

CREATE TABLE batch_inventory (
	batch_inventory_id	INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id			INT				NOT NULL,
	order_item_id		INT,
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
    qty_on_hand         NUMERIC(10,2),
	is_in_stock			BOOLEAN			NOT NULL,
	best_before_date 	DATE,
	received_date    	DATE 			NOT NULL DEFAULT CURRENT_DATE,
	created_date 		TIMESTAMPTZ		NOT NULL DEFAULT now(),
	last_modified_date 	TIMESTAMPTZ		NOT NULL DEFAULT now(),
	FOREIGN KEY (product_id) REFERENCES core.products (product_id),
	FOREIGN KEY (order_item_id) REFERENCES core.order_items (order_item_id)
);