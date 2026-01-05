/usr/bin/docker run --rm   --network weather_net   --name weather-fetcher   --link weather-postgres   -e API_KEY=#YourAPIKeyHere   weather-fetcher-image
