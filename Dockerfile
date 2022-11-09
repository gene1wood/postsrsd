FROM ghcr.io/linuxserver/baseimage-alpine:3.16

ARG POSTSRSD_PACKAGE_VERSION=1.11-r0
RUN apk add --no-cache postsrsd=$POSTSRSD_PACKAGE_VERSION

ENV SRS_DOMAIN set-this-to-yourdomain.example.com

COPY root/ /

# forward SRS lookup
EXPOSE 10001/tcp
# reverse SRS lookup
EXPOSE 10002/tcp

VOLUME ["/config"]
