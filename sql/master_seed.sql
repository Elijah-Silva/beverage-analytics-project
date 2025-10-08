\set ON_ERROR_STOP on

\echo 'Running 000_schema.sql...'
\i sql/000_schema.sql

\echo 'Running 010_seed_lookups.sql...'
\i sql/010_seed_lookups.sql

\echo 'Running 020_seed_parents.sql...'
\i sql/020_seed_parents.sql

\echo 'Running 030_stage_products.sql...'
\i sql/030_stage_products.sql

\echo 'Running 031_transform_products.sql...'
\i sql/031_transform_products.sql

\echo 'Running 032_cleanup_staging.sql...'
\i sql/032_cleanup_staging.sql

\echo '✅ All scripts completed successfully.'