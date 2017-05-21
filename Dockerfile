FROM quay.io/armswarm/alpine:{{ALPINE_VERSION}}

RUN apk add --no-cache \
		ca-certificates \
		curl \
		openssl

# install docker from binaries
# TODO: switch to alpine package
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) dockerArch=armel ;; \
		*) echo >&2 "error: unknown Docker static binary arch $apkArch"; exit 1 ;; \
	esac; \
	curl -fsSLO "https://get.docker.com/builds/Linux/${dockerArch}/docker-{{DOCKER_VERSION}}.tgz"; \
    curl -fsSLO "https://get.docker.com/builds/Linux/armel/docker-{{DOCKER_VERSION}}.tgz.sha256"; \
	sha256sum -c "docker-{{DOCKER_VERSION}}.tgz.sha256"; \
	tar -xzvf "docker-{{DOCKER_VERSION}}.tgz"; \
	mv docker/* /usr/local/bin/; \
	rmdir docker; \
	rm "docker-{{DOCKER_VERSION}}.tgz"; \
	docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
