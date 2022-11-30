FROM python:3.11.0-alpine

ENV UID=0
ENV GID=0

ENV USER=webdav
ENV PASSWORD=webdav

ENV FIX_DATA_PERMISSIONS=false

EXPOSE 80
VOLUME /data

RUN pip install WsgiDAV==4.1.0 cheroot==9.0.0 lxml==4.9.1

RUN apk add --no-cache sudo

RUN cp /etc/passwd /etc/passwd.orig \
    && cp /etc/group /etc/group.orig

COPY ./entrypoint.sh ./entrypoint.sh

ENTRYPOINT sh entrypoint.sh
