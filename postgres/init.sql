-- ===============================
-- Create application user
-- ===============================
CREATE USER weather_app WITH ENCRYPTED PASSWORD 'weatherpass';

-- ===============================
-- Create database
-- ===============================
CREATE DATABASE dataforcedb OWNER weather_app;

-- ===============================
-- Connect to database
-- ===============================
\c dataforcedb

-- ===============================
-- Ensure database timezone is UTC
-- ===============================
ALTER DATABASE dataforcedb SET timezone TO 'UTC';

-- ===============================
-- Create schema
-- ===============================
CREATE SCHEMA weather AUTHORIZATION weather_app;

ALTER ROLE weather_app SET search_path TO weather;

-- ===============================
-- Create table
-- ===============================
CREATE TABLE weather.weather_readings (
    id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    temperature FLOAT NOT NULL,
    humidity FLOAT NOT NULL,
    weather_description TEXT,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ===============================
-- Permissions
-- ===============================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA weather TO weather_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA weather TO weather_app;

-- ===============================
-- Optional: performance index for time-series queries
-- ===============================
CREATE INDEX idx_weather_readings_recorded_at
ON weather.weather_readings (recorded_at);
