INSERT INTO core.order_items (
	order_id,
	product_id,
	production_date,
	unit_price,
	quantity_count,
	quantity_weight,
	subtotal
)
SELECT
	o.order_id,
	p.product_id,
	oi.production_date,
	oi.unit_price,
	oi.quantity_count,
	oi.quantity_weight,
	oi.subtotal
FROM stage.order_items oi
JOIN core.orders       o
	ON o.order_number = oi.order_number
JOIN core.products     p
	ON p.product_name = oi.product_name;