SET search_path TO stage;

CREATE TABLE orders
(
	vendor_name        TEXT,
	order_date         DATE,
	order_number       TEXT,
	shipping_cost      NUMERIC(7, 2),
	total_cost         NUMERIC(9, 2),
	order_status       TEXT,
	created_date       DATE,
	last_modified_date DATE
);