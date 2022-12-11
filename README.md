# Hello x86

This is a simple x86 kernel-mode program which prints hello-world. The intention
of this project is to serve as a starting point for more complex projects that
demonstrates compiling the code, generating a bootable image, and booting the
image in qemu.

## Build natively and run in qemu

```
make run
```

## Build in container and run in qemu

```
docker run --rm -it $(docker build -q .) make run
```
