FROM mysql:8.0-debian

MAINTAINER me

ENV MYSQL_ALLOW_EMPTY_PASSWORD="yes"

ADD schema.sql /docker-entrypoint-initdb.d

EXPOSE 3306