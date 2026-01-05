import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine

DB_URL = (
    "postgresql+psycopg2://weather_app:weatherpass@"
    "weather-postgres:5432/dataforcedb"
)

engine = create_engine(DB_URL)

query = """
SELECT city, temperature, humidity, recorded_at
FROM weather.weather_readings
ORDER BY recorded_at
"""

df = pd.read_sql(query, engine)

# Convert UTC → Pacific Time for display
df["recorded_at"] = (
    pd.to_datetime(df["recorded_at"], utc=True)
      .dt.tz_convert("America/Los_Angeles")
)

city_df = df[df["city"] == "Clovis"]

plt.figure(figsize=(10, 5))
plt.plot(city_df["recorded_at"], city_df["temperature"])
plt.title("Temperature in Clovis Over Time")
plt.xlabel("Date")
plt.ylabel("Temperature (°C)")
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig("/output/clovis_temperature.png")

