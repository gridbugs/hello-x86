.global putc

#define COM1 $0x3F8

.text

putc:
    mov %rdi, %rax
    mov COM1, %dx
    out %al,(%dx)
    ret
