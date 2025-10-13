SET SEARCH_PATH = util;

INSERT INTO util.session_batch_review
  (session_code, product_name, vendor_name, quantity_used, role, reason)
SELECT
  sbi.session_code, sbi.product_name, sbi.vendor_name, sbi.quantity_used, sbi.role,
  CASE
    WHEN v.vendor_id   IS NULL THEN 'NO_MATCH_VENDOR'
    WHEN p.product_id  IS NULL THEN 'NO_MATCH_PRODUCT'
    WHEN r.role_id     IS NULL THEN 'NO_MATCH_ROLE'
    WHEN s.session_id  IS NULL THEN 'NO_MATCH_SESSION'
    ELSE 'OTHER'
  END AS reason
FROM stage.session_batch_inventory sbi
LEFT JOIN core.vendors  v ON v.vendor_name  = sbi.vendor_name
LEFT JOIN core.products p ON p.product_name = sbi.product_name AND p.vendor_id = v.vendor_id
LEFT JOIN ref.roles     r ON r.role_name    = sbi.role
LEFT JOIN core.sessions s ON s.session_code = sbi.session_code
WHERE v.vendor_id IS NULL
   OR p.product_id IS NULL
   OR r.role_id IS NULL
   OR s.session_id IS NULL;

SELECT * from util.session_batch_review;