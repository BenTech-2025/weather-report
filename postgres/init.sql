-- Create application user
CREATE USER weather_app WITH ENCRYPTED PASSWORD 'weatherpass';

-- Create database
CREATE DATABASE dataforcedb OWNER weather_app;

\c dataforcedb

-- Create schema
CREATE SCHEMA weather AUTHORIZATION weather_app;

ALTER ROLE weather_app SET search_path TO weather;

-- Create table
CREATE TABLE weather.weather_readings (
    id SERIAL PRIMARY KEY,
    city VARCHAR(50),
    temperature FLOAT,
    humidity FLOAT,
    weather_description TEXT,
    recorded_at TIMESTAMP DEFAULT NOW()
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA weather TO weather_app;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA weather TO weather_app;

