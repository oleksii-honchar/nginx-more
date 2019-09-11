#!/usr/bin/env bash
set -e

cd "$NGINX_VERSION/"

make install

mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/proxy_temp /var/cache/nginx/scgi_temp /var/cache/nginx/uwsgi_temp
chmod 700 /var/cache/nginx/*

cd ..
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm -rf "$NGINX_VERSION/" openssl-1.1.0h/ pcre-8.42/ zlib-1.2.11/

mkdir -p /var/log/nginx/
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

apt-get purge -y build-essential software-properties-common
apt-get autoremove -y --purge
apt-get clean
