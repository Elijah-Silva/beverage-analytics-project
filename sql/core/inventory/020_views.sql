SET SEARCH_PATH = core;

CREATE OR REPLACE VIEW core.v_batch_inventory_remaining AS
SELECT
    bi.batch_inventory_id,
    bi.product_id,
    p.product_name,
    bi.quantity_weight AS initial_qty,
    COALESCE(SUM(sbi.quantity_used), 0) AS consumed_qty,
    bi.quantity_weight - COALESCE(SUM(sbi.quantity_used), 0) AS qty_remaining,
    (bi.quantity_weight - COALESCE(SUM(sbi.quantity_used), 0)) > 0 AS is_in_stock
FROM core.batch_inventory bi
JOIN core.products p
  ON p.product_id = bi.product_id
LEFT JOIN core.session_batch_inventory sbi
  ON sbi.batch_inventory_id = bi.batch_inventory_id
WHERE product_type_id IN (
    SELECT product_type_id FROM ref.product_types WHERE product_type_name IN ('Coffee', 'Tea')
    )
GROUP BY bi.batch_inventory_id, bi.product_id, p.product_name, bi.quantity_weight;


SELECT * FROM core.v_batch_inventory_remaining;