FROM rust:1.87.0-alpine3.20 AS builder

RUN apk add --no-cache linux-headers make musl-dev

# TODO: install stable version > 0.17.0-dev.1 once available
RUN cargo install --git https://github.com/uiua-lang/uiua --rev aa6310c uiua

FROM alpine:3.20

RUN apk add --no-cache jq

COPY --from=builder /usr/local/cargo/bin/uiua /usr/local/bin

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
