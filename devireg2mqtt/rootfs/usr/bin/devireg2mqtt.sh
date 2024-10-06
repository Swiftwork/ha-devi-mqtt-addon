#!/bin/bash

# Read options.json and split into config.json and mqtt.json
jq '.devi + {rooms: .devi_rooms}' /data/options.json > /app/config/devi_config.json
jq '.mqtt' /data/options.json > /app/config/mqtt_config.json

# Run the application
java -cp /app/ha-devi-mqtt.jar io.homeassistant.devi.mqtt.service.ConsoleRunner \
  --auto-discovery-templates /app/config/auto-discovery-templates \
  --mqtt-config /app/config/mqtt_config.json \
  --devi-config /app/config/devi_config.json