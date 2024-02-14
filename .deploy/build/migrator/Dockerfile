FROM alpine:3.19.1

WORKDIR /bin/migrator

ARG version="v4.17.0"
ARG archive="migrate.linux-amd64.tar.gz"

RUN apk update  \
    && apk add bash curl  \
    && curl -L https://github.com/golang-migrate/migrate/releases/download/${version}/${archive} | tar xvz \
    && chmod +x migrate

COPY build/migrator/entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/bin/migrator/entrypoint.sh"]
