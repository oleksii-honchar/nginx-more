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

# PCRE version 8.42
wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz && tar xzvf pcre-8.42.tar.gz

# zlib version 1.2.11
wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz

# OpenSSL version 1.1.0h
wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz && tar xzvf openssl-1.1.0h.tar.gz

wget "http://nginx.org/download/$NGINX_VERSION.tar.gz" && tar -xzvf "$NGINX_VERSION.tar.gz"

rm -rf *.tar.gz
