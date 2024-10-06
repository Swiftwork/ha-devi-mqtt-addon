# Build arguments
ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2

FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Get packages
RUN apk add --no-cache jq dos2unix wget

# Get ha-devi-mqtt.jar
RUN wget https://github.com/igor-podpalchenko/ha-devi-mqtt/releases/download/v${BUILD_VERSION}/ha-devi-mqtt.jar

# Download and extract auto-discovery-templates
RUN wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/archive/main.zip -O temp.zip && \
  mkdir -p /app/config/auto-discovery-templates && \
  unzip -j temp.zip ha-devi-mqtt-main/auto-discovery-templates/* -d /app/config/auto-discovery-templates && \
  rm temp.zip

COPY run.sh .
RUN dos2unix ./run.sh
RUN chmod a+x ./run.sh

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Erik Hughes <erik.hughes@trutoo.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Trutoo AB" \
    org.opencontainers.image.authors="Erik Hughes <erik.hughes@trutoo.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

CMD ["./run.sh"]