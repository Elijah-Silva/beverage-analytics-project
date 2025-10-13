SET SEARCH_PATH = util;

-- FK integrity for session_batch_inventory
CREATE OR REPLACE VIEW util.session_batch_fk_review AS
SELECT
  sbi.session_code,
  sbi.product_name,
  sbi.vendor_name,
  sbi.role,
  CASE
    WHEN v.vendor_id IS NULL THEN 'NO_MATCH_VENDOR'
    WHEN r.role_id   IS NULL THEN 'NO_MATCH_ROLE'
    WHEN s.session_id IS NULL THEN 'NO_MATCH_SESSION'
    WHEN p.product_id IS NULL THEN 'NO_MATCH_PRODUCT'
    ELSE 'OTHER'
  END AS reason
FROM stage.session_batch_inventory sbi
LEFT JOIN core.vendors  v ON v.vendor_name  = sbi.vendor_name
LEFT JOIN ref.roles     r ON r.role_name    = sbi.role
LEFT JOIN core.sessions s ON s.session_code = sbi.session_code
LEFT JOIN core.products p ON p.product_name = sbi.product_name AND p.vendor_id = v.vendor_id
WHERE v.vendor_id IS NULL OR r.role_id IS NULL OR s.session_id IS NULL OR p.product_id IS NULL;

-- FK integrity for session_batch_inventory
CREATE OR REPLACE VIEW util.vendors_fk_review AS
SELECT
    sv.vendor_name,
    sv.country_code,
    sv.currency_code,
    CASE
        WHEN cv.vendor_id IS NULL THEN 'NO_MATCH_VENDOR'
        WHEN cc.country_code_id IS NULL THEN 'NO_MATCH_COUNTRY_CODE'
        WHEN currc.currency_code_id IS NULL THEN 'NO_MATCH_CURRENCY_CODE'
        ELSE 'OTHER'
    END AS reason
FROM stage.vendors sv
LEFT JOIN core.vendors cv ON cv.vendor_name = sv.vendor_name
LEFT JOIN ref.country_codes cc ON cc.country_code = sv.country_code
LEFT JOIN ref.currency_codes currc ON currc.currency_code = sv.currency_code
WHERE cv.vendor_id IS NULL
    OR cc.country_code_id IS NULL
    OR currc.currency_code_id IS NULL;

-- sessions
CREATE OR REPLACE VIEW util.sessions_fk_review AS
SELECT
    s.session_code,
    s.brewing_method_name,
    s.session_location_name,
    s.location_name,
    CASE
        WHEN bm.brewing_method_id IS NULL THEN 'NO_MATCH_BREWING_METHOD'
        WHEN sl.session_location_id IS NULL THEN 'NO_MATCH_SESSION_LOCATION'
        WHEN l.location_id IS NULL THEN 'NO_MATCH_LOCATION'
        ELSE 'OTHER'
    END AS reason
FROM stage.sessions s
LEFT JOIN ref.brewing_methods bm ON bm.brewing_method_name = s.brewing_method_name
LEFT JOIN ref.session_locations sl ON sl.session_location_name = s.session_location_name
LEFT JOIN core.locations l ON l.location_name = s.location_name
WHERE bm.brewing_method_id IS NULL
    OR sl.session_location_id IS NULL
    OR l.location_id IS NULL;

-- locations
CREATE OR REPLACE VIEW util.locations_fk_review AS
SELECT
    l.country_code,
    CASE
        WHEN cc.country_code_id IS NULL THEN 'NO_MATCH_COUNTRY'
        ELSE 'OTHER'
    END AS reason
FROM stage.locations l
LEFT JOIN ref.country_codes cc ON cc.country_code  = l.country_code
WHERE cc.country_code_id IS NULL;

-- PSQL Script
SELECT EXISTS(SELECT 1 FROM util.session_batch_fk_review) AS has_fk_sessions_batch_inv_issues \gset
SELECT EXISTS(SELECT 1 FROM util.vendors_fk_review) AS has_fk_vendors_issues \gset
SELECT EXISTS(SELECT 1 FROM util.sessions_fk_review) AS has_fk_sessions_issues \gset
SELECT EXISTS(SELECT 1 FROM util.locations_fk_review) AS has_fk_locations_issues \gset

\if :has_fk_sessions_batch_inv_issues
  \echo '⚠️ FK issues found in "session_batch_inventory"'
  SELECT * FROM util.session_batch_fk_review;
\else
  \echo '✅ No FK issues in "session_batch_inventory"'
\endif

\if :has_fk_vendors_issues
  \echo '⚠️ FK issues found in "vendors"'
  SELECT * FROM util.vendors_fk_review;
\else
  \echo '✅ No FK issues in "vendors"'
\endif

\if :has_fk_sessions_issues
  \echo '⚠️ FK issues found in "sessions"'
  SELECT * FROM util.sessions_fk_review;
\else
  \echo '✅ No FK issues in "sessions"'
\endif

\if :has_fk_locations_issues
  \echo '⚠️ FK issues found in "locations"'
  SELECT * FROM util.locations_fk_review;
\else
  \echo '✅ No FK issues in "locations"'
\endif