/usr/bin/docker run --rm   --network weather_net   --name weather-fetcher   --link weather-postgres   -e API_KEY=4d84bf26cdd9cef56c2e8e84d72a92e4   weather-fetcher-image
