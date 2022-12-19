FROM ubuntu

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  zip \
  gcc-multilib-x86-64-linux-gnu \
  qemu-system-x86 \
  bash \
  sudo \
  file \
  ;

# Install the bootboot tool
RUN git clone https://gitlab.com/bztsrc/bootboot.git /tmp/bootboot && \
  cd /tmp/bootboot/mkbootimg && \
  git checkout 6b56345f01de7081f4021fd60d969c2df0932674 && \
  make && \
  cp mkbootimg /usr/local/bin

# Make a non-root user and copy the code into their home directory
RUN useradd --create-home --shell /bin/bash --gid users --groups sudo user
USER user
ADD --chown=user . src
WORKDIR src

ENV CC=x86_64-linux-gnu-gcc
ENV LD=x86_64-linux-gnu-ld
ENV STRIP=x86_64-linux-gnu-strip

RUN make
