CC ?= gcc
LD ?= ld
STRIP ?= strip
MKBOOTIMG ?= mkbootimg
QEMU ?= qemu-system-x86_64

CFLAGS = -Werror -Wall -fpic -ffreestanding -fno-stack-protector -fcf-protection=none -nostdlib -fno-builtin -O2

all: kernel.img

kernel.elf: putc.S main.c
	$(CC) $(CFLAGS) -mno-red-zone -c main.c -o main.o
	$(CC) $(CFLAGS) -mno-red-zone -c putc.S -o putc.o
	$(LD) -nostdlib -z noexecstack -T link.ld main.o putc.o -o $@
	$(STRIP) -s -K mmio -K fb -K bootboot -K environment $@

kernel.img: mkbootimg.json kernel.elf
	$(MKBOOTIMG) check kernel.elf
	$(MKBOOTIMG) mkbootimg.json $@

clean:
	rm -rf *.o *.elf *.img

run: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none -no-shutdown -no-reboot -d int

run-graphical: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio

run-debug: kernel.img
	$(QEMU) -drive file=$^,format=raw -serial stdio -display none -no-shutdown -no-reboot -d int -s -S

gdb-kernel:
	gdb -x kernel.gdb

.PHONY: clean run run-graphical run-debug all
