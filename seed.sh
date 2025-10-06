#!/bin/bash
set -e  # stop if any command fails

echo "🚀 Rebuilding and seeding database..."
psql -d beverage -f sql/master_seed.sql
echo "✅ Database seeded successfully."
