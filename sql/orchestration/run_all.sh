#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"   # -> /sql
PSQL="psql -d beverage -v ON_ERROR_STOP=1"

echo "🚀 Rebuilding and seeding database..."

$PSQL -f "$SQL_DIR/bootstrap/000_create_schemas.sql"
$PSQL -f "$SQL_DIR/ref/000_ref_tables.sql"
$PSQL -f "$SQL_DIR/ref/010_seed_static_lookups.sql"
$PSQL -f "$SQL_DIR/ref/020_seed_country_codes.sql"
$PSQL -f "$SQL_DIR/ref/030_seed_currency_codes.sql"
$PSQL -f "$SQL_DIR/raw/vendors/000_create_tables.sql"
$PSQL -f "$SQL_DIR/raw/vendors/010_load.sql"
$PSQL -f "$SQL_DIR/stage/vendors/000_create_tables.sql"
$PSQL -f "$SQL_DIR/stage/vendors/010_load_from_raw.sql"
$PSQL -f "$SQL_DIR/core/vendors/000_create_tables.sql"
$PSQL -f "$SQL_DIR/core/vendors/010_load_from_stage.sql"


#$PSQL -f "$SQL_DIR/stage/vendors/000_create_tables.sql"
#$PSQL -f "$SQL_DIR/stage/vendors/010_load_from_raw.sql"

echo "✅ Database rebuilt and seeded successfully."