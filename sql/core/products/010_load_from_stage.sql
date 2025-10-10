DO $$
DECLARE
  missing_count INT;
  missing_list  TEXT;
BEGIN
  -- vendors (stage.products)
  SELECT
    COUNT(DISTINCT p.vendor_name),
    STRING_AGG(COALESCE(p.vendor_name, '<NULL>'), ', ' ORDER BY COALESCE(p.vendor_name, '<NULL>'))
  INTO missing_count, missing_list
  FROM stage.products p
  LEFT JOIN core.vendors v
    ON v.vendor_name = p.vendor_name
  WHERE v.vendor_id IS NULL;

  IF missing_count > 0 THEN
    RAISE EXCEPTION '❌ Missing vendor(s) in stage.products: %', missing_list;
  END IF;

  -- product types (stage.products)
  SELECT
    COUNT(DISTINCT p.product_type),
    STRING_AGG(COALESCE(p.product_type, '<NULL>'), ', ' ORDER BY COALESCE(p.product_type, '<NULL>'))
  INTO missing_count, missing_list
  FROM stage.products p
  LEFT JOIN ref.product_types t
    ON t.product_type_name = p.product_type
  WHERE t.product_type_id IS NULL;

  IF missing_count > 0 THEN
    RAISE EXCEPTION '❌ Missing product_type(s) in stage.products: %', missing_list;
  END IF;

  -- processing methods (stage.products_coffee)
  SELECT
    COUNT(DISTINCT pc.processing_method),
    STRING_AGG(COALESCE(pc.processing_method, '<NULL>'), ', ' ORDER BY COALESCE(pc.processing_method, '<NULL>'))
  INTO missing_count, missing_list
  FROM stage.products_coffee pc
  LEFT JOIN ref.processing_methods pm
    ON pm.processing_method_name = pc.processing_method
  WHERE pm.processing_method_id IS NULL;

  IF missing_count > 0 THEN
    RAISE EXCEPTION '❌ Missing processing_method(s) in stage.products_coffee: %', missing_list;
  END IF;
END $$;



INSERT INTO core.products (product_name, product_type_id, vendor_id, region, is_active, notes,
                           created_date, last_modified_date)
SELECT p.product_name, pt.product_type_id, cv.vendor_id, p.region, p.is_active, p.notes, p.created_date,
       p.last_modified_date
FROM stage.products p
JOIN core.vendors        cv ON cv.vendor_name = p.vendor_name
JOIN ref.product_types   pt ON pt.product_type_name = p.product_type;

-- product coffee details
INSERT INTO core.product_coffee_details (product_id, roast_level, roast_date, origin_type, varietal_id,
                                         altitude_meters, processing_method_id)
SELECT p.product_id, pc.roast_level, pc.roast_date, pc.origin_type, var.varietal_id, pc.altitude_meters,
       pm.processing_method_id
FROM stage.products_coffee pc
    JOIN core.vendors cv ON cv.vendor_name = pc.vendor_name
    JOIN ref.product_types pt ON pt.product_type_name = 'Coffee'
    JOIN ref.varietals var ON var.varietal_name = pc.varietal
    JOIN ref.processing_methods pm ON pm.processing_method_name = pc.processing_method
    JOIN core.products p ON p.product_name = pc.product_name
                                AND p.vendor_id = cv.vendor_id
                                AND p.product_type_id = pt.product_type_id;

-- product tea details
INSERT INTO core.product_tea_details (product_id, tea_type, harvest_year, cultivar,
                                      altitude_meters, processing_method_id)
SELECT p.product_id, pt.tea_type, pt.harvest_year, pt.cultivar, pt.altitude_meters,
       pm.processing_method_id
FROM stage.products_tea pt
    JOIN core.vendors cv ON cv.vendor_name = pt.vendor_name
    JOIN ref.product_types prt ON prt.product_type_name = 'Tea'
    JOIN ref.processing_methods pm ON pm.processing_method_name = pt.processing_method
    JOIN core.products p ON p.product_name = pt.product_name
                                AND p.vendor_id = cv.vendor_id
                                AND p.product_type_id = prt.product_type_id;

-- product equipment details
INSERT INTO core.product_equipment_details (product_id, material_id, volume, clay_type_id, pour_speed, color)
SELECT p.product_id, m.material_id, pe.volume, ct.clay_type_id, pe.pour_speed, pe.color
FROM stage.products_equipment pe
    JOIN core.vendors cv ON cv.vendor_name = pe.vendor_name
    JOIN ref.product_types prt ON prt.product_type_name = 'Equipment'
    JOIN ref.materials m ON m.material_name = pe.material
    LEFT JOIN ref.clay_types ct ON ct.clay_type_name = pe.clay_type
    JOIN core.products p ON p.product_name = pe.product_name
                                AND p.vendor_id = cv.vendor_id
                                AND p.product_type_id = prt.product_type_id;