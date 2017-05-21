FROM quay.io/armswarm/alpine:{{ALPINE_VERSION}}

RUN apk add \
        --no-cache \
        --repository http://dl-3.alpinelinux.org/alpine/edge/community \
        ca-certificates \
        docker={{DOCKER_PACKAGE}} \
    && docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
