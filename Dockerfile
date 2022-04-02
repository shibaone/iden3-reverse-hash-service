# Build builder container
FROM golang:1.18.0-alpine3.15 as builder

RUN apk add --no-cache git

COPY . /src
WORKDIR /src

RUN go build -o /reverse-hash-service

# Build running container
FROM alpine:3.15.3

COPY --from=builder /reverse-hash-service /reverse-hash-service
COPY --from=builder /src/schema.sql /schema.sql

RUN apk add --no-cache ca-certificates tzdata
RUN adduser -D -g '' appuser
USER appuser

ENTRYPOINT ["/reverse-hash-service"]
