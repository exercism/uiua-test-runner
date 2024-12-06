FROM alpine:3.20 AS builder

RUN apk add --no-cache curl

ARG VERSION=0.14.0-dev.6
RUN curl -L -o uiua.zip https://github.com/uiua-lang/uiua/releases/download/${VERSION}/uiua-bin-x86_64-unknown-linux-gnu-no-audio.zip && \
    unzip uiua.zip && \
    mv uiua /usr/local/bin 

FROM alpine:3.20

RUN apk add --no-cache gcompat jq libgcc

COPY --from=builder /usr/local/bin/uiua /usr/local/bin

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
