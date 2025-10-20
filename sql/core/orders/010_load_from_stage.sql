INSERT INTO core.orders (
	vendor_id, order_date, order_number, shipping_cost, total_cost, order_status_id)
SELECT
	v.vendor_id,
	o.order_date,
	o.order_number,
	o.shipping_cost,
	o.total_cost,
	os.order_status_id
FROM stage.orders     o
JOIN vendors          v
	ON v.vendor_name = o.vendor_name
JOIN ref.order_status os
	ON os.order_status_name = o.order_status;