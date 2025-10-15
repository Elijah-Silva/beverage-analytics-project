SET SEARCH_PATH = stage;

CREATE TABLE order_items (
	order_number		TEXT,
	product_name		TEXT,
	production_date     DATE,
	unit_price			NUMERIC(9,2),
	quantity_count		INT,
	quantity_weight		NUMERIC(7,2),
	subtotal			NUMERIC(9,2)
);
