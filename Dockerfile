FROM pandoc/extra:latest-alpine

RUN apk add --no-cache make

WORKDIR /data
