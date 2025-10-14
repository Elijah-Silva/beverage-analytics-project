SET search_path TO stage;

INSERT INTO stage.order_items (
	order_number,
	product_name,
	unit_price,
	quantity_count,
	quantity_weight,
	subtotal
)
SELECT
	TRIM(UPPER(order_number)),
	TRIM(product_name),
	unit_price::NUMERIC(9, 2),
	quantity_count::INT,
	quantity_weight::NUMERIC(7, 2),
	subtotal::NUMERIC(9, 2)
FROM raw.order_items;


