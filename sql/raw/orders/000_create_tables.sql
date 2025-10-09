SET SEARCH_PATH = raw;

CREATE TABLE orders (
	vendor_name			TEXT,
	order_date			TEXT,
    order_number		TEXT,
	shipping_cost		TEXT,
	total_cost			TEXT,
	order_status		TEXT,
	created_date 		TEXT,
	last_modified_date 	TEXT
);