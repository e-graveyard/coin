FROM crystallang/crystal:latest-alpine AS build
MAINTAINER Caian R. Ertl <hi@caian.org>

COPY . /app
WORKDIR /app
RUN make static

FROM scratch AS run
COPY --from=build /app/coin /coin
ENTRYPOINT ["/coin"]
