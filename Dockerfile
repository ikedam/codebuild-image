FROM public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0

# Install reproxy
# https://github.com/umputun/reproxy/releases
RUN wget -O reproxy.rpm https://github.com/umputun/reproxy/releases/download/v0.11.0/reproxy_v0.11.0_linux_amd64.rpm \
    && yum install -y ./reproxy.rpm \
    && rm reproxy.rpm

COPY dockerd-entrypoint.sh /usr/local/bin/
