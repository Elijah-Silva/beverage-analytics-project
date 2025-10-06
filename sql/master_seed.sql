\set ON_ERROR_STOP on

\echo 'Running 000_schema.sql...'
\i sql/000_schema.sql

\echo 'Running 010_seed_lookups.sql...'
\i sql/010_seed_lookups.sql

\echo 'Running 020_seed_parents.sql...'
\i sql/020_seed_parents.sql

\echo 'Running 030_seed_children.sql...'
\i sql/099_dml.sql

\echo '✅ All scripts completed successfully.'