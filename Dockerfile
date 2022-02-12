FROM public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0

# Install registry
# https://github.com/distribution/distribution/releases
RUN wget -O registry.tar.gz https://github.com/distribution/distribution/releases/download/v2.8.0/registry_2.8.0_linux_amd64.tar.gz \
    && tar --extract --verbose --file registry.tar.gz --directory /usr/local/bin/ registry \
    && rm registry.tar.gz \
    && registry --version

# Install reproxy
# https://github.com/umputun/reproxy/releases
RUN wget -O reproxy.rpm https://github.com/umputun/reproxy/releases/download/v0.11.0/reproxy_v0.11.0_linux_amd64.rpm \
    && yum install -y ./reproxy.rpm \
    && rm reproxy.rpm

COPY ./registry-config.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000

COPY dockerd-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/etc/docker/registry/config.yml"]

COPY dockerd-entrypoint.sh /usr/local/bin/
