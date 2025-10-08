-- =============================================
-- 031_transform_products.sql
-- Purpose: Inserts from staging into products and subtype tables using joins.
-- =============================================

SET search_path TO beverage;

BEGIN;

/*
 * The INSERT INTO products ... 
 * SELECT ... 
 * JOIN and subsequent subtype inserts 
 * (product_coffee_details, etc.).
 */

COMMIT;