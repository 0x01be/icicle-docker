FROM 0x01be/yosys as yosys
FROM 0x01be/icestorm as icestorm
FROM 0x01be/nextpnr:ice40 as nextpnr
FROM 0x01be/riscv-gnu-toolchain as riscv

FROM alpine:3.12.0

COPY --from=riscv /opt/riscv/ /opt/riscv/
COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=icestorm /opt/icestorm/ /opt/icestorm/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    build-base \
    git \
    gettext-dev \
    readline-dev \
    libffi-dev \
    tk \
    boost-dev

RUN git clone https://github.com/grahamedgecombe/icicle.git /icicle

WORKDIR /icicle

ENV PATH $PATH:/opt/yosys/bin/:/opt/icestorm/bin/:/opt/nextpnr/bin/:/opt/riscv/bin/

RUN make BOARD=ice40hx8k-b-evn ARCH=ice40

