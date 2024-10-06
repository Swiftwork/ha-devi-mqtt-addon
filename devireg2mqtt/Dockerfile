ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Setup base
RUN apk add --no-cache \
  jq=1.7.1-r0 \
  dos2unix=7.5.2-r0 \
  wget=1.24.5-r0

# Build arguments
ARG BUILD_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Get ha-devi-mqtt.jar
RUN wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/releases/download/v${BUILD_VERSION}/ha-devi-mqtt.jar \
  -O /usr/bin/ha-devi-mqtt.jar

# Download and extract auto-discovery-templates
RUN wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/archive/main.zip -O temp.zip && \
  mkdir -p /app/config/auto-discovery-templates && \
  unzip -j temp.zip ha-devi-mqtt-main/auto-discovery-templates/* -d /app/config/auto-discovery-templates && \
  rm temp.zip