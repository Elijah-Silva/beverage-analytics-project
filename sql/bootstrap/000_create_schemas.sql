-- =============================================
-- 000_schema.sql
-- Purpose: Initialize database schemas
-- =============================================

BEGIN;
SET LOCAL client_min_messages = WARNING;  -- hides NOTICE

-- Drop existing schemas for a clean rebuild (DEV/STAGING ONLY)
DROP SCHEMA IF EXISTS util CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;
DROP SCHEMA IF EXISTS stage CASCADE;
DROP SCHEMA IF EXISTS raw CASCADE;
DROP SCHEMA IF EXISTS ref CASCADE;

-- Create schemas (lowest-dependency first)
CREATE SCHEMA IF NOT EXISTS ref;
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stage;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS util;

-- Optional: set default search path for convenience
ALTER DATABASE beverage
    SET search_path TO core, stage, ref, raw, util, public;

COMMIT;