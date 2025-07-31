FROM --platform=linux/amd64 debian:bullseye AS builder

ARG BIN_NAME
WORKDIR /src

COPY ${BIN_NAME}/deps.txt /deps.txt

RUN apt-get update && \
    xargs apt-get install -y < /deps.txt && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /out

COPY ${BIN_NAME}/build.sh /build.sh
RUN chmod +x /build.sh && /build.sh

FROM scratch
ARG BIN_NAME
COPY --from=builder /out/${BIN_NAME} /${BIN_NAME}
ENTRYPOINT ["/${BIN_NAME}"]
