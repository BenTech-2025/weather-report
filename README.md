# Weather Data Ingestion & Visualization

A Dockerized pipeline that fetches weather data, stores it in PostgreSQL, and generates visualizations.


This project ingests weather data from an external API, stores it in a PostgreSQL database, and generates a visualization using Python. The system is containerized using Docker to mirror a production style data pipeline. 
This project serves as a practical exploration of Docker fundamentals, including container lifecycle management, networking, volumes, troubleshooting, and Linux system administration. The application code was generated with AI assistance, allowing the project to remain focused on infrastructure, deployment patterns, and operational problem-solving rather than application-level development.

## Project Purpose

This project was built to simulate a small, production-style data ingestion pipeline using containerized services.
The focus is not on application logic, but on:

- Running stateful services with Docker
- Managing container networking and volumes
- Separating ingestion, storage, and analytics workloads
- Troubleshooting real-world container lifecycle issues

## Key Engineering Decisions

- Named PostgreSQL volume:
  Used to persist data across container restarts, mirroring real-world database deployments.
- One-shot containers instead of long-running services:
  Fetcher and visualizer containers run to completion and exit, simplifying orchestration and failure handling.

## Scope & Limitations

- This is not a high-availability system
- No retry/backoff logic for API failures

## Architecture

The system consists of three containers:

1. PostgreSQL – Stores weather readings using a named volume as persistent data storage
2. Fetcher – Pulls weather data from an API and inserts it into the database
3. Visualizer – Runs headlessly and generates charts from stored data

## Example output

The visualizer container generates charts like this:

![visualizationexample](https://github.com/user-attachments/assets/57b84f4b-7d78-4216-9d8f-58e6a0ac3a59)

## Workflow diagram

[Fetcher Container] --> [PostgreSQL Container] --> [Visualizer Container] --> [Output]

## Requirements

- Docker
- Python 3.12 (only if this project is to be modified to run scripts locally)
- Weather API key from openweathermap.org

## Setup

1. Clone the repository:
   git clone https://github.com/BenTech-2025/weather-report.git
   
   cd weather-pipeline

3. Create docker volume:
   docker volume create weather_pgdata

4. Create docker network: 
   docker network create weather_net

5. Run PostgreSQL container:
   ```
   docker run -d \
    --network weather_net \
    --name weather-postgres \
    -e POSTGRES_PASSWORD=adminpass \
    -v weather_pgdata:/var/lib/postgresql/data \
    -v $(pwd)/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql \
    postgres:16
   ```

7. Build weather fetcher image:
   docker build -t weather-fetcher-image ./weather-fetcher

8. Run weather fetcher container:
   ```
   docker run --rm \
    --network weather_net \
    --name weather-fetcher \
    --link weather-postgres \
    -e API_KEY=YOURAPIKEYHERE \
    weather-fetcher-image
   ```

    *An executable file has been included in the "weatherfetcher" directory named "weatherfetcher_cronjob.sh" for use 
    with user cronjobs. The docker executable has an absolute path of /usr/bin/docker. Adjust as needed.

10. Build visualization image:
   docker build -t weather-visualizer ./visualizer

11. Run visualization container:
   ```
   docker run --rm \
    --network weather_net \
    --link weather-postgres \
    -v $(pwd)/output:/output \
    weather-visualizer
   ```

Note: The Python scripts are configured to fetch and label data for Clovis, CA by default. To use a different location, update the location-specific values within the scripts accordingly.

