SET SEARCH_PATH = util;

-- 1) Usage per batch (helper)
CREATE OR REPLACE VIEW util.v_usage_by_batch AS
SELECT
	sbi.batch_inventory_id,
	COALESCE(SUM(sbi.quantity_used), 0)::NUMERIC(12, 2) AS qty_used_g
FROM core.session_batch_inventory sbi
GROUP BY sbi.batch_inventory_id;

-- 2) Per-batch remaining (your view, simplified + safer)
CREATE OR REPLACE VIEW util.v_batch_inventory_remaining AS
SELECT
	--bi.batch_inventory_id,
	bi.product_id,
	p.product_name,
	bi.quantity_weight::NUMERIC(12, 2)                    AS initial_qty,
	COALESCE(ub.qty_used_g, 0)::NUMERIC(12, 2)            AS consumed_qty,
	GREATEST(bi.quantity_weight - COALESCE(ub.qty_used_g, 0), 0)::NUMERIC(12, 2)
	                                                      AS qty_remaining,
	(bi.quantity_weight - COALESCE(ub.qty_used_g, 0)) > 0 AS is_in_stock
--(bi.quantity_weight - COALESCE(ub.qty_used_g, 0)) < 0 AS is_overused
FROM core.batch_inventory       bi
JOIN core.products              p
	ON p.product_id = bi.product_id
LEFT JOIN util.v_usage_by_batch ub
	ON ub.batch_inventory_id = bi.batch_inventory_id
WHERE p.product_type_id IN (SELECT
	                            pt.product_type_id
                            FROM ref.product_types pt
                            WHERE pt.product_type_name IN ('Coffee', 'Tea'));

-- 3) Total sum across batches per product
CREATE OR REPLACE VIEW util.v_inventory_by_product AS
SELECT
	p.product_id,
	p.product_name,
	COUNT(*)                             AS batch_count,
	SUM(v.initial_qty)::NUMERIC(12, 2)   AS qty_received_g,
	SUM(v.consumed_qty)::NUMERIC(12, 2)  AS qty_used_g,
	SUM(v.qty_remaining)::NUMERIC(12, 2) AS qty_on_hand_g
FROM util.v_batch_inventory_remaining v
JOIN core.products                    p
	ON p.product_id = v.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name;


CREATE VIEW util.recent_sessions AS
WITH get_espresso_quantity AS
	     (SELECT
		      sbi.session_id,
		      sbi.quantity_used,
		      sbi.quantity_output
	      FROM core.session_batch_inventory sbi
	      JOIN core.batch_inventory         bi
		      USING (batch_inventory_id)
	      JOIN core.products                p
		      USING (product_id)
	      WHERE role_id = (SELECT
		                       role_id
	                       FROM ref.roles
	                       WHERE role_name = 'Espresso Dose'))
SELECT
	s.session_id,
	s.session_date::DATE,
	s.session_type,
	bm.brewing_method_name,
	(SELECT
		 STRING_AGG(product_name, ', ') AS tea_coffee_used
	 FROM core.session_batch_inventory sbi
	 JOIN core.batch_inventory         bi
		 USING (batch_inventory_id)
	 JOIN core.products                p
		 USING (product_id)
	 WHERE role_id IN (SELECT
		                   role_id
	                   FROM ref.roles
	                   WHERE role_name IN ('Espresso Dose', 'Tea Dose'))),
	s.rating,
	geq.quantity_used,
	geq.quantity_output,
	s.grind_size,
	e.extraction_time,
	e.water_temperature,
	(SELECT
		 STRING_AGG(product_name, ', ') AS equipment_used
	 FROM core.session_batch_inventory sbi
	 JOIN core.batch_inventory         bi
		 USING (batch_inventory_id)
	 JOIN core.products                p
		 USING (product_id)
	 WHERE role_id IN (SELECT
		                   role_id
	                   FROM ref.roles
	                   WHERE role_name NOT IN ('Espresso Dose', 'Tea Dose'))),
	s.notes,
	e.flavor_notes
FROM core.sessions              s
LEFT JOIN core.extractions      e
	USING (session_code)
LEFT JOIN get_espresso_quantity geq
	ON geq.session_id = s.session_id
JOIN ref.brewing_methods        bm
	USING (brewing_method_id);

SELECT *
FROM util.v_batch_inventory_remaining
ORDER BY is_in_stock DESC, product_id, consumed_qty DESC;

/*
SELECT *
FROM util.v_inventory_by_product
ORDER BY product_id;
 */

SELECT *
FROM util.recent_sessions
ORDER BY session_date DESC;