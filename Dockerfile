FROM rust:1.91.1-alpine3.23 AS builder

RUN apk add --no-cache linux-headers make musl-dev

RUN cargo install uiua@0.18.1

FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk add --no-cache jq

COPY --from=builder /usr/local/cargo/bin/uiua /usr/local/bin

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
