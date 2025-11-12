-- Initial database setup for Orbit ERP

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For full-text search

-- Set timezone to Brazil
SET timezone = 'America/Sao_Paulo';

-- Create initial schema
CREATE SCHEMA IF NOT EXISTS public;

-- Grant permissions
GRANT ALL ON SCHEMA public TO orbit;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO orbit;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO orbit;

-- Log initialization
DO $$
BEGIN
  RAISE NOTICE 'Orbit ERP database initialized successfully';
END $$;
