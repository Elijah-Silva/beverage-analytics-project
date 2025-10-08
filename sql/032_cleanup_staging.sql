-- =============================================
-- 032_cleanup_staging.sql
-- Purpose: Truncates or drops the staging tables.
-- =============================================

SET search_path TO beverage;

BEGIN;

/*
 * TRUNCATE staging_products; or DROP TABLE staging_products;
 */

COMMIT;