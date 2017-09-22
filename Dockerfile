FROM quay.io/armswarm/alpine:{{ALPINE_VERSION}}


ENV DOCKER_CHANNEL stable \
    DOCKER_VERSION {{DOCKER_VERSION}}

RUN apk add \
        --no-cache \
        ca-certificates \
        docker={{DOCKER_PACKAGE}} \
    && docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
