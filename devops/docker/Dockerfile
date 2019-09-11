#--- BUILD ---
FROM ubuntu:18.04 AS build

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV NGINX_VERSION="nginx-1.13.6"

EXPOSE 80
CMD ["/usr/sbin/nginx"]

RUN mkdir -p /usr/src/nginx
WORKDIR /usr/src/nginx

COPY ./devops/nginx/modules ./modules
COPY ./devops/nginx/build.sh ./build.sh
COPY ./devops/nginx/install-deps.sh ./install-deps.sh
COPY ./devops/nginx/install.sh ./install.sh
RUN rm -rf /etc/nginx & mkdir -p /etc/nginx
COPY ./devops/nginx/config /etc/nginx
RUN bash ./install-deps.sh && bash ./build.sh && bash ./install.sh
