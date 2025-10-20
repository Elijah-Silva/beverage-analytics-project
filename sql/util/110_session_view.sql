SET SEARCH_PATH = util;

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
	s.session_id as id,
	s.session_date::DATE as date,
	s.session_type as category,
	bm.brewing_method_name as brew,
	(SELECT
		 STRING_AGG(product_name, ', ') AS ingredient
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
	geq.quantity_used as input,
	geq.quantity_output as output,
	s.grind_size as grind,
	e.extraction_time as time,
	e.water_temperature as temp,
	(SELECT
		 STRING_AGG(product_name, ', ') AS equipment
	 FROM core.session_batch_inventory sbi
	 JOIN core.batch_inventory         bi
		 USING (batch_inventory_id)
	 JOIN core.products                p
		 USING (product_id)
	 WHERE role_id IN (SELECT
		                   role_id
	                   FROM ref.roles
	                   WHERE role_name NOT IN ('Espresso Dose', 'Tea Dose'))),
	s.notes as session_notes,
	e.notes as extraction_notes
FROM core.sessions              s
LEFT JOIN core.extractions      e
	USING (session_code)
LEFT JOIN get_espresso_quantity geq
	ON geq.session_id = s.session_id
JOIN ref.brewing_methods        bm
	USING (brewing_method_id);

SELECT *
FROM util.recent_sessions
ORDER BY date DESC;