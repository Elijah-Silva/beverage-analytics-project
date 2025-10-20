SET search_path TO stage;

INSERT INTO stage.orders (
	vendor_name,
	order_date,
	order_number,
	shipping_cost,
	total_cost,
	order_status
)
SELECT
	TRIM(vendor_name),
	order_date::DATE,
	TRIM(UPPER(order_number)),
	shipping_cost::NUMERIC(7, 2),
	total_cost::NUMERIC(9, 2),
	TRIM(order_status)
FROM raw.orders;
