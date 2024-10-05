#!/bin/bash

# Download and extract auto-discovery-templates
rm -rf /data/auto-discovery-templates
mkdir -p /data/auto-discovery-templates
wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/archive/main.zip -O temp.zip && \
  unzip -j temp.zip "ha-devi-mqtt-main/auto-discovery-templates/*" -d /data/auto-discovery-templates && \
  rm temp.zip

# Read options.json and split into config.json and mqtt.json
jq '.devi' /data/options.json > /data/devi_config.json
jq '.mqtt' /data/options.json > /data/mqtt_config.json

# Run the application
java -cp ha-devi-mqtt.jar io.homeassistant.devi.mqtt.service.ConsoleRunner \
  --auto-discovery-templates /data/auto-discovery-templates \
  --mqtt-config /data/mqtt_config.json \
  --devi-config /data/devi_config.json