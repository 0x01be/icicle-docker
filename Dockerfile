FROM 0x01be/yosys as yosys
FROM 0x01be/nextpnr:ecp5 as nextpnr
FROM 0x01be/riscv-gnu-toolchain as riscv

FROM 0x01be/prjtrellis

COPY --from=riscv /opt/riscv/ /opt/riscv/
COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/

RUN apk --no-cache add \
    build-base \
    git \
    gettext-dev \
    readline-dev \
    libffi-dev \
    tk \
    boost-dev

RUN git clone https://github.com/grahamedgecombe/icicle.git /icicle

WORKDIR /icicle

ENV PATH $PATH:/opt/yosys/bin/:/opt/prjtrellis/bin/:/opt/nextpnr/bin/:/opt/riscv/bin/

RUN make BOARD=ecp5-evn

