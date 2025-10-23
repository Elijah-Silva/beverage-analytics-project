SET SEARCH_PATH = core;

INSERT INTO core.batch_inventory (
	product_id,
	order_item_id,
	production_date,
	quantity_count,
	quantity_weight,
	is_in_stock,
	received_date
)
SELECT
	oi.product_id,
	oi.order_item_id,
	oi.production_date,
	oi.quantity_count,
	oi.quantity_weight,
	p.is_active,
	o.order_date
FROM core.order_items   oi
LEFT JOIN core.products p
	ON p.product_id = oi.product_id
LEFT JOIN orders o
	ON o.order_id = oi.order_id;

INSERT INTO core.session_batch_inventory (
	session_id,
	batch_inventory_id,
	production_date,
	quantity_used,
	quantity_output,
	role_id,
	batch_code,
	unit
)
SELECT
	s.session_id,
	bi.batch_inventory_id,
	sbi.production_date,
	sbi.quantity_used,
	sbi.quantity_output,
	r.role_id,
	sbi.batch_code,
	sbi.unit
FROM stage.session_batch_inventory sbi
JOIN core.vendors                  v
	ON v.vendor_name = sbi.vendor_name -- gets vendor_id
JOIN core.products                 p
	ON p.product_name = sbi.product_name -- gets product_id
	AND p.vendor_id = v.vendor_id
JOIN core.batch_inventory          bi
	ON bi.product_id = p.product_id
	AND (
		   bi.production_date = sbi.production_date
			   OR bi.production_date IS NULL
		   )
JOIN ref.roles                     r
	ON r.role_name = sbi.role
JOIN core.sessions                 s
	ON s.session_code = sbi.session_code;