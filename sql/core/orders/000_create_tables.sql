SET search_path TO core;

CREATE TABLE orders (
	order_id 			INT				GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	vendor_id			INT				NOT NULL,
	order_date			DATE         	NOT NULL DEFAULT now(),
    order_number        TEXT            NOT NULL,
	shipping_cost		NUMERIC(7,2)	NOT NULL,
	total_cost			NUMERIC(9,2)	NOT NULL,
	order_status_id		INT				NOT NULL,
	created_date 		DATE    		NOT NULL DEFAULT now(),
	last_modified_date 	DATE    		NOT NULL DEFAULT now(),
	FOREIGN KEY (vendor_id) REFERENCES core.vendors (vendor_id),
	FOREIGN KEY (order_status_id) REFERENCES ref.order_status (order_status_id)
);