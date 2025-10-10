SET search_path TO stage;

-- freshen
TRUNCATE stage.raw_products;
TRUNCATE stage.products;
TRUNCATE stage.products_tea;
TRUNCATE stage.products_coffee;
TRUNCATE stage.products_equipment;

-- 1) Clean + cast from raw into a staging buffer (stage.raw_products)
INSERT INTO stage.raw_products (
    product_name, product_type, vendor_name, region,
    roast_level, roast_date, origin_type, varietal, altitude_meters,
    processing_method, material, volume, clay_type, pour_speed, color,
    tea_type, harvest_year, cultivar,
    is_active, notes, created_date, last_modified_date
)
SELECT
    product_name,
    product_type,
    vendor_name,
    region,
    roast_level,
    roast_date::DATE,
    origin_type,
    varietal,
    altitude_meters::INT,
    processing_method,
    material,
    volume::INT,
    clay_type,
    pour_speed::INT,
    color,
    tea_type,
    harvest_year::INT,
    cultivar,
    is_active::BOOLEAN,
    notes,
    created_date::DATE,
    last_modified_date::DATE
FROM raw.products;

-- 2) Slim main stage table (for core.products)
INSERT INTO stage.products (
    product_name, product_type, vendor_name, region, is_active, notes,
    created_date, last_modified_date
)
SELECT product_name, product_type, vendor_name, region, is_active, notes, created_date, last_modified_date
FROM stage.raw_products;

-- 3) Route to subtypes (match the same UPPER convention)
-- TEA
INSERT INTO stage.products_tea (
    product_name, vendor_name, tea_type, harvest_year, cultivar, altitude_meters, processing_method
)
SELECT product_name, vendor_name, tea_type, harvest_year, cultivar, altitude_meters, processing_method
FROM stage.raw_products
WHERE product_type = 'Tea';

-- COFFEE
INSERT INTO stage.products_coffee (
    product_name, vendor_name, roast_level, roast_date, origin_type, varietal,
    altitude_meters, processing_method
)
SELECT product_name, vendor_name, roast_level, roast_date, origin_type, varietal, altitude_meters, processing_method
FROM stage.raw_products
WHERE product_type = 'Coffee';

-- EQUIPMENT
INSERT INTO stage.products_equipment (
    product_name, vendor_name, material, volume, clay_type, pour_speed, color
)
SELECT product_name, vendor_name, material, volume, clay_type, pour_speed, color
FROM stage.raw_products
WHERE product_type = 'Equipment';
