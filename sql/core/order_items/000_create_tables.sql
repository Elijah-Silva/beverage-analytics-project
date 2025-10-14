SET SEARCH_PATH = core;

CREATE TABLE order_items (
	order_item_id 		INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_id			INT				NOT NULL,
	product_id			INT				NOT NULL,
	unit_price			NUMERIC(9,2)	NOT NULL CHECK (unit_price >= 0),
	quantity_count		INT             CHECK (quantity_count > 0),
	quantity_weight		NUMERIC(7,2)    CHECK (quantity_count > 0),
	subtotal			NUMERIC(9,2)	NOT NULL CHECK (subtotal >= 0),
	FOREIGN KEY (order_id) REFERENCES orders (order_id),
	FOREIGN KEY (product_id) REFERENCES products (product_id),
	CHECK ((quantity_count IS NULL) != (quantity_weight IS NULL)),
	UNIQUE (order_id, product_id)
);
