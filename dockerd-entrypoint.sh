#!/bin/sh
set -e

# 127.0.0.1:5001
registry serve /etc/docker/registry/config.yml &>/var/log/registry.log &

# 127.0.0.1:5000
reproxy \
    -l 127.0.0.1:5000 \
    --logger.stdout \
    --static.enabled \
    --static.rule='*,/v2/library/,http://127.0.0.1:5001/v2/docker/library' \
    --static.rule='*,/v2/,http://127.0.0.1:5001/v2' \
    &>/var/log/reproxy.log &

/usr/local/bin/dockerd \
	--registry-mirror http://127.0.0.1:5000 \
	--insecure-registry http://127.0.0.1:5000 \
	--host=unix:///var/run/docker.sock \
	--host=tcp://127.0.0.1:2375 \
	--storage-driver=overlay2 &>/var/log/docker.log &


tries=0
d_timeout=60
until docker info >/dev/null 2>&1
do
	if [ "$tries" -gt "$d_timeout" ]; then
                cat /var/log/docker.log
		echo 'Timed out trying to connect to internal docker host.' >&2
		exit 1
	fi
        tries=$(( $tries + 1 ))
	sleep 1
done

eval "$@"
