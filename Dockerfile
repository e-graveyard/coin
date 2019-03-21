FROM alpine:3.9.2 AS base
MAINTAINER Caian R. Ertl <hi@caian.org>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update
RUN apk add build-base libc-dev \
        zlib-dev openssl-dev readline-dev gmp-dev yaml-dev libxml2-dev \
        crystal shards

FROM base AS build
COPY . /app
WORKDIR /app
RUN make shards
RUN make static

FROM scratch AS run
COPY --from=build /app/coin /coin
ENTRYPOINT ["/coin"]
