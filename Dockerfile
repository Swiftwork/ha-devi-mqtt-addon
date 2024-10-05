FROM podpalch/ha-devi-mqtt:latest

RUN apk add --no-cache jq dos2unix wget

WORKDIR /app

COPY run.sh .
RUN dos2unix ./run.sh
RUN chmod a+x ./run.sh

CMD ["./run.sh"]