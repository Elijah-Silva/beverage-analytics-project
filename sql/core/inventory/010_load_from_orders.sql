SET SEARCH_PATH = core;

INSERT INTO core.batch_inventory (product_id, order_item_id, quantity_count, quantity_weight,
                                  qty_on_hand, is_in_stock)
SELECT
	oi.product_id,
	oi.order_item_id,
	oi.quantity_count,
	oi.quantity_weight,
	oi.quantity_weight,
	p.is_active
FROM core.order_items oi
    LEFT JOIN core.products p ON p.product_id = oi.product_id;

INSERT INTO core.session_batch_inventory (session_id, batch_inventory_id, quantity_used, role_id)
SELECT 1, 20, 16, (SELECT role_id FROM ref.roles WHERE role_name = 'Espresso Dose');

INSERT INTO core.session_batch_inventory (session_id, batch_inventory_id, quantity_used, role_id)
SELECT 2, 20, 16, (SELECT role_id FROM ref.roles WHERE role_name = 'Espresso Dose');
