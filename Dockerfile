FROM 0x01be/yosys as yosys
FROM 0x01be/icestorm as icestorm
FROM 0x01be/nextpnr:ice40 as nextpnr
FROM 0x01be/riscv-gnu-toolchaian:rv32if as riscv

FROM alpine

COPY --from=riscv /opt/riscv/ /opt/riscv/
COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=icestorm /opt/icestorm/ /opt/icestorm/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/

RUN apk add --no-cache --virtual icicle-build-dependencies \
    git \
    build-base \
    gettext-dev \
    readline-dev \
    libffi-dev \
    boost-dev \
    tk

ENV ICICLE_REVISION master
RUN git clone --depth 1 --branch ${ICICLE_REVISION} https://github.com/grahamedgecombe/icicle.git /icicle

WORKDIR /icicle

ENV PATH $PATH:/opt/yosys/bin/:/opt/icestorm/bin/:/opt/nextpnr/bin/:/opt/riscv/bin/

RUN make BOARD=ice40hx8k-b-evn ARCH=ice40

