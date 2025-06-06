FROM rust:1.87.0-alpine3.20 AS builder

RUN apk add --no-cache linux-headers make musl-dev

RUN cargo install uiua@0.16.0

FROM alpine:3.20

RUN apk add --no-cache jq

COPY --from=builder /usr/local/cargo/bin/uiua /usr/local/bin

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
