FROM rust:1.86.0-alpine3.21 AS builder

RUN apk add --no-cache linux-headers make musl-dev

RUN cargo install uiua@0.15.0

FROM alpine:3.21

RUN apk add --no-cache jq

COPY --from=builder /usr/local/cargo/bin/uiua /usr/local/bin

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
