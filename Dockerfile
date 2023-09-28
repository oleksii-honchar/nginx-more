#--- BUILD ---
FROM alpine:latest AS build

ARG NGINX_VERSION

RUN mkdir -p /usr/src/nginx
WORKDIR /usr/src/nginx

COPY ./nginx/0-install-deps.alpine.sh ./0-install-deps.alpine.sh
COPY ./nginx/1-build-nginx.alpine.sh ./1-build-nginx.alpine.sh
RUN rm -rf /etc/nginx & mkdir -p /etc/nginx
COPY ./nginx/config /etc/nginx
RUN sh ./0-install-deps.alpine.sh && sh ./1-build-nginx.alpine.sh

#--- FINAL IMAGE ---
FROM alpine:latest

RUN apk add --no-cache openssl tzdata

RUN addgroup --system nginx && adduser --system --no-create-home --ingroup nginx nginx

COPY --from=build /etc/nginx /etc/nginx
COPY --from=build /usr/sbin/nginx /usr/sbin/nginx
COPY ./nginx/config /etc/nginx

COPY ./nginx/2-postinstall-nginx.alpine.sh /var/tmp/2-postinstall-nginx.alpine.sh
RUN sh /var/tmp/2-postinstall-nginx.alpine.sh

EXPOSE 80 443

CMD ["/usr/sbin/nginx"]