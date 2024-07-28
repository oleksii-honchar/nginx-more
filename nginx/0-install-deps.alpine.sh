#!/usr/bin/env sh
set -e

apk update && apk upgrade && apk add --no-cache \
  openssl \
  perl perl-dev gd-dev geoip-dev libxml2-dev libxslt-dev \
  build-base pcre-dev zlib-dev openssl-dev wget curl clang

mkdir -p modules/nginx-module-vts && wget https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v0.2.2.tar.gz && cd modules/nginx-module-vts && tar xzvf ../../v0.2.2.tar.gz --strip-components=1 && cd ../..

mkdir -p modules/headers-more-nginx && wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v0.37.tar.gz && cd modules/headers-more-nginx && tar xzvf ../../v0.37.tar.gz --strip-components=1 && cd ../..

mkdir pcre && wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.43/pcre2-10.43.tar.gz && cd pcre && tar xzvf ../pcre2-10.43.tar.gz --strip-components=1 && cd ..

mkdir zlib && wget https://www.zlib.net/zlib-1.3.1.tar.gz && cd zlib &&  tar xzvf ../zlib-1.3.1.tar.gz --strip-components=1 && cd ..

# Set your desired NGINX version using the NGINX_VERSION build argument
wget "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" && tar -xzvf "nginx-$NGINX_VERSION.tar.gz"

rm -rf *.tar.gz