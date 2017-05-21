FROM quay.io/armswarm/docker:{{DOCKER_VERSION}}

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

RUN curl -fsSL "https://raw.githubusercontent.com/docker/docker/{{DIND_COMMIT}}/hack/dind" -o /usr/local/bin/dind \
	&& chmod +x /usr/local/bin/dind

COPY dockerd-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
