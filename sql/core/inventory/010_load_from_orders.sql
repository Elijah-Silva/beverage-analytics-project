SET SEARCH_PATH = core;

INSERT INTO core.batch_inventory (
	product_id,
	order_item_id,
	production_date,
	quantity_count,
	quantity_weight,
	is_in_stock
)
SELECT
	oi.product_id,
	oi.order_item_id,
	oi.production_date,
	oi.quantity_count,
	oi.quantity_weight,
	p.is_active
FROM core.order_items   oi
LEFT JOIN core.products p
	ON p.product_id = oi.product_id;