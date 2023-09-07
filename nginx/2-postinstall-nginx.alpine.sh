#!/usr/bin/env sh
set -e

mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/proxy_temp /var/cache/nginx/scgi_temp /var/cache/nginx/uwsgi_temp
chmod 700 /var/cache/nginx/*

rm -rf /tmp/* /var/cache/apk/*

mkdir -p /var/log/nginx/
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
