#!/usr/bin/env bash
set -e

apt-get update && apt-get install -y software-properties-common

add-apt-repository -y ppa:maxmind/ppa
apt-get update && apt-get upgrade -y
apt-get install -y \
    perl libperl-dev libgd3 libgd-dev libgeoip1 libgeoip-dev geoip-bin \
    libxml2 libxml2-dev libxslt1.1 libxslt1-dev \
    software-properties-common build-essential zlib1g-dev \
    wget mc curl

# PCRE version 8.44
wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz && tar xzvf pcre-8.44.tar.gz

# zlib version 1.2.11
wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz

# OpenSSL version 1.1.1k
wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && tar xzvf openssl-1.1.1k.tar.gz

wget "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" && tar -xzvf "nginx-$NGINX_VERSION.tar.gz"

rm -rf *.tar.gz
