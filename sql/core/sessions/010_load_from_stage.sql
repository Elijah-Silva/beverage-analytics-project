SET SEARCH_PATH = core;

INSERT INTO core.sessions (
	session_code,
	brewing_method_id,
	rating,
	water_type,
	session_type,
	session_date,
	favorite_flag,
	session_location_id,
	location_id,
	grind_size,
	notes
)
SELECT
	s.session_code,
	bm.brewing_method_id,
	s.rating,
	s.water_type,
	s.session_type,
	s.session_date,
	s.favorite_flag,
	sl.session_location_id,
	l.location_id,
	s.grind_size,
	s.notes
FROM stage.sessions        s
JOIN ref.brewing_methods   bm
	ON bm.brewing_method_name = s.brewing_method_name
JOIN ref.session_locations sl
	ON sl.session_location_name = s.session_location_name
JOIN core.locations        l
	ON l.location_name = s.location_name;

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
