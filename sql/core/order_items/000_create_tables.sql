SET SEARCH_PATH = core;

CREATE TABLE order_items (
	order_item_id 		INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	order_id			INT				NOT NULL,
	product_id			INT				NOT NULL,
	unit_price			NUMERIC(9,2)	NOT NULL,
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
	subtotal			NUMERIC(9,2)	NOT NULL,
	FOREIGN KEY (order_id) REFERENCES orders (order_id),
	FOREIGN KEY (product_id) REFERENCES products (product_id)
);
