SET search_path TO stage;

-- freshen
TRUNCATE stage.raw_products;
TRUNCATE stage.products;
TRUNCATE stage.products_tea;
TRUNCATE stage.products_coffee;
TRUNCATE stage.products_equipment;

INSERT INTO stage.raw_products (
    product_name, product_type, vendor_name, region, roast_level, roast_date, origin_type,
    varietal, altitude_meters, processing_method, material, volume, clay_type,
    pour_speed, color, tea_type, harvest_year, storage_location, cultivar,
    is_active, notes, created_date, last_modified_date
)
SELECT
    INITCAP(NULLIF(TRIM(product_name), '')),
    INITCAP(NULLIF(TRIM(product_type), '')),
    INITCAP(NULLIF(TRIM(vendor_name), '')),
    INITCAP(NULLIF(TRIM(region), '')),
    INITCAP(NULLIF(TRIM(roast_level), '')),
    NULLIF(roast_date,'')::date,
    INITCAP(NULLIF(TRIM(origin_type), '')),
    NULLIF(TRIM(varietal), ''),
    NULLIF(TRIM(altitude_meters), '')::int,
    INITCAP(NULLIF(TRIM(processing_method), '')),
    INITCAP(NULLIF(TRIM(material), '')),
    NULLIF(TRIM(volume), '')::int,
    INITCAP(NULLIF(TRIM(clay_type), '')),
    NULLIF(TRIM(pour_speed), '')::int,
    INITCAP(NULLIF(TRIM(color), '')),
    CASE WHEN tea_type IS NULL OR tea_type = '' THEN NULL
       ELSE tea_type END,
    NULLIF(TRIM(harvest_year), '')::int,
    NULLIF(TRIM(storage_location), ''),
    NULLIF(TRIM(cultivar), ''),
    CASE UPPER(TRIM(is_active)) WHEN 'TRUE' THEN TRUE WHEN 'FALSE' THEN FALSE ELSE NULL END,
    NULLIF(TRIM(notes), ''),
    CASE WHEN created_date ~ '^\d{4}-\d{2}-\d{2}' THEN created_date::timestamptz ELSE NULL END,
    CASE WHEN last_modified_date ~ '^\d{4}-\d{2}-\d{2}' THEN last_modified_date::timestamptz ELSE NULL END
FROM raw.products;


INSERT INTO stage.products (
    product_name,
    product_type,
    vendor_name,
    region,
    is_active,
    notes,
    created_date,
    last_modified_date
)
SELECT
    product_name,
    product_type,
    vendor_name,
    region,
    is_active,
    notes,
    created_date,
    last_modified_date
FROM stage.raw_products;

-- 2) Route to subtypes

-- TEA
INSERT INTO stage.products_tea (
    product_name,
    tea_type,
    harvest_year,
    storage_location,
    cultivar,
    processing_method
)
SELECT
    product_name,
    tea_type,
    harvest_year,
    storage_location,
    cultivar,
    processing_method
FROM stage.raw_products
WHERE product_type = 'Tea';

-- COFFEE
INSERT INTO stage.products_coffee (
    product_name,
    roast_level,
    roast_date,
    origin_type,
    varietal,
    altitude_meters,
    processing_method
)
SELECT
    product_name,
    roast_level,
    roast_date,
    origin_type,
    varietal,
    altitude_meters,
    processing_method
FROM stage.raw_products
WHERE product_type = 'Coffee';

-- EQUIPMENT
INSERT INTO stage.products_equipment (
    product_name,
    material,
    volume,
    clay_type,
    pour_speed,
    color
)
SELECT
    product_name,
    material,
    volume,
    clay_type,
    pour_speed,
    color
FROM stage.raw_products
WHERE product_type = 'Equipment';
