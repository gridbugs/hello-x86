FROM alpine

RUN apk add binutils make gcc git musl-dev zip qemu-system-x86_64

RUN git clone --depth=1 https://gitlab.com/bztsrc/bootboot.git /tmp/bootboot && \
  cd /tmp/bootboot/mkbootimg && \
  make && \
  mkdir -p ~/bin && \
  cp mkbootimg /usr/local/bin

RUN adduser -D user
USER user
COPY --chown=user . src
WORKDIR src

RUN make clean && make kernel.img
RUN make run
