import os
import requests
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime, UTC

API_KEY = os.environ["API_KEY"]

DB_URL = (
    "postgresql+psycopg2://weather_app:weatherpass@"
    "weather-postgres:5432/dataforcedb"
)

url = (
    "https://api.openweathermap.org/data/2.5/weather"
    "?lat=36.8818&lon=-119.7759"
    f"&appid={API_KEY}&units=metric"
)

data = requests.get(url).json()

weather = {
    "city": "Clovis",
    "temperature": data["main"]["temp"],
    "humidity": data["main"]["humidity"],
    "weather_description": data["weather"][0]["description"],
}

df = pd.DataFrame([weather])

engine = create_engine(DB_URL)
df.to_sql(
    "weather_readings",
    engine,
    schema="weather",
    if_exists="append",
    index=False,
)

print("Weather data inserted")


