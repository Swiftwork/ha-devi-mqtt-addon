ARG BUILD_FROM
FROM $BUILD_FROM

# Copy root filesystem
COPY rootfs /

# Setup base
RUN set -eux; \
    apk add --no-cache \
      jq=1.7.1-r0 \
      dos2unix=7.5.2-r0 \
      wget=1.24.5-r0
    ; \
    rm -rf /var/cache/apk/*

# Build arguments
ARG BUILD_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Get ha-devi-mqtt.jar
RUN set -eux; \
    wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/releases/download/v${BUILD_VERSION}/ha-devi-mqtt.jar \
      -O /usr/bin/ha-devi-mqtt.jar

# Download and extract auto-discovery-templates
RUN set -eux; \
    wget -q https://github.com/igor-podpalchenko/ha-devi-mqtt/archive/main.zip -O temp.zip && \
      mkdir -p /app/config/auto-discovery-templates && \
      unzip -j temp.zip ha-devi-mqtt-main/auto-discovery-templates/* -d /app/config/auto-discovery-templates && \
      rm temp.zip

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV JAVA_VERSION=jdk-23+37

RUN set -eux; \
    ARCH="$(apk --print-arch)"; \
    case "${ARCH}" in \
       aarch64) \
         ESUM='858aa6b255164e535e2fd6cc8dfbf129327a9126ebb9e8f24115c2089efd36f3'; \
         BINARY_URL='https://github.com/adoptium/temurin23-binaries/releases/download/jdk-23%2B37/OpenJDK23U-jre_aarch64_alpine-linux_hotspot_23_37.tar.gz'; \
         ;; \
       x86_64) \
         ESUM='7acbc972b0dd84ca10ec6f192b20e76445a22f4c5558e1657ff393e4868e9343'; \
         BINARY_URL='https://github.com/adoptium/temurin23-binaries/releases/download/jdk-23%2B37/OpenJDK23U-jre_x64_alpine-linux_hotspot_23_37.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    wget -O /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p "$JAVA_HOME"; \
    tar --extract \
        --file /tmp/openjdk.tar.gz \
        --directory "$JAVA_HOME" \
        --strip-components 1 \
        --no-same-owner \
    ; \
    rm -f /tmp/openjdk.tar.gz ${JAVA_HOME}/lib/src.zip;

RUN set -eux; \
    echo "Verifying install ..."; \
    echo "java --version"; java --version; \
    echo "Complete."