FROM golang:1.18-alpine as BUILD

WORKDIR /root

# Copy the files from host
COPY relayer relayer

# Update and install needed deps prioir to installing the binary.
RUN apk update && \
  apk --no-cache add make git build-base && \
  cd relayer && make install

FROM alpine:latest

# Define working directory
WORKDIR /root

COPY start.sh .
COPY --from=BUILD /go/bin/rly /usr/bin/rly

ENTRYPOINT /root/start.sh
