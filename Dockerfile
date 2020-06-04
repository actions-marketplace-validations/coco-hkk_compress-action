FROM alpine:3.10

LABEL maintainer="coco-hkk@github.com"

RUN apk update

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
