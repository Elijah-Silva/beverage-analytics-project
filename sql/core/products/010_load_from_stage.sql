INSERT INTO core.products (
    product_name,
    product_type_id,
    vendor_id,
    region,
    is_active,
    notes,
    created_date,
    last_modified_date
)
SELECT
    p.product_name,
    pt.product_type_id,
    cv.vendor_id,
    p.region,
    p.is_active,
    p.notes,
    p.created_date,
    p.last_modified_date
FROM stage.products p
JOIN core.vendors        cv ON cv.vendor_name = p.vendor_name
JOIN ref.product_types   pt ON pt.product_type_name = p.product_type;