FROM alpine:latest AS builder
RUN apk --no-cache add \
        git \
        cmake \
        libuv-dev \
        hwloc-dev \
        openssl-dev \
        libc-dev \
        linux-headers \
        build-base && \
      git clone --depth=1 https://github.com/xmrig/xmrig && \
      cd xmrig && \
      mkdir build && \
      cmake -DCMAKE_BUILD_TYPE=Release . && \
      make

FROM alpine:latest
RUN apk --no-cache add tini libuv hwloc
RUN adduser -S -D -H -h /xmrig miner
WORKDIR /xmrig
COPY --from=builder /xmrig/xmrig .
USER miner

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./xmrig"]
