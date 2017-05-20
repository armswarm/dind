FROM quay.io/armswarm/alpine:3.5

RUN apk add --no-cache \
		ca-certificates \
		curl \
		openssl

ARG DOCKER_VERSION
ARG DIND_COMMIT

# install docker from binaries
# TODO: switch to alpine package
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) dockerArch=armel ;; \
		*) echo >&2 "error: unknown Docker static binary arch $apkArch"; exit 1 ;; \
	esac; \
	curl -fsSLO "https://get.docker.com/builds/Linux/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; \
    curl -fsSLO "https://get.docker.com/builds/Linux/armel/docker-${DOCKER_VERSION}.tgz.sha256"; \
	sha256sum -c "docker-${DOCKER_VERSION}.tgz.sha256"; \
	tar -xzvf "docker-${DOCKER_VERSION}.tgz"; \
	mv docker/* /usr/local/bin/; \
	rmdir docker; \
	rm "docker-${DOCKER_VERSION}.tgz"; \
	docker -v

COPY docker-entrypoint.sh /usr/local/bin/

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
# TODO: add aufs-util
RUN apk add --no-cache \
		btrfs-progs \
		e2fsprogs \
		e2fsprogs-extra \
		iptables \
		xfsprogs \
		xz

# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
	&& addgroup -S dockremap \
	&& adduser -S -G dockremap dockremap \
	&& echo 'dockremap:165536:65536' >> /etc/subuid \
	&& echo 'dockremap:165536:65536' >> /etc/subgid

RUN curl -fsSL "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -o /usr/local/bin/dind \
	&& chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
