FROM alpine

RUN apk add binutils make gcc git musl-dev zip qemu-system-x86_64

# Install the bootboot tool
RUN git clone https://gitlab.com/bztsrc/bootboot.git /tmp/bootboot && \
  cd /tmp/bootboot/mkbootimg && \
  git checkout 6b56345f01de7081f4021fd60d969c2df0932674 && \
  make && \
  cp mkbootimg /usr/local/bin

# Make a non-root user and copy the code into their home directory
RUN adduser -D user
USER user
ADD --chown=user . src
WORKDIR src

# Build this project
RUN make clean && make kernel.img
