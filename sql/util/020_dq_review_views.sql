CREATE OR REPLACE VIEW util.session_batch_dq_review AS
SELECT
  sbi.session_code, sbi.product_name, sbi.vendor_name, sbi.role, sbi.quantity_used,
  CASE
    WHEN sbi.quantity_used IS NULL OR sbi.quantity_used <= 0 THEN 'QTY_NON_POSITIVE'
  END AS dq_reason
FROM stage.session_batch_inventory sbi
WHERE sbi.quantity_used IS NULL OR sbi.quantity_used <= 0;


-- in your .sql script (psql)
SELECT EXISTS(SELECT 1 FROM util.session_batch_dq_review) AS has_dq_issues \gset

\if :has_dq_issues
  \echo '⚠️ DQ issues found in "session_batch_inventory"'
  SELECT * FROM util.session_batch_dq_review;
\else
  \echo '✅ No DQ issues in "session_batch_inventory"'
\endif