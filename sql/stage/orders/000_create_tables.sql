SET search_path TO stage;

CREATE TABLE orders (
	vendor_name			TEXT			NOT NULL,
	order_date			DATE         	NOT NULL,
    order_number        TEXT            NOT NULL,
	shipping_cost		NUMERIC(7,2)	NOT NULL,
	total_cost			NUMERIC(9,2)	NOT NULL,
	order_status		TEXT			NOT NULL,
	created_date 		DATE	    	NOT NULL,
	last_modified_date 	DATE    		NOT NULL
);