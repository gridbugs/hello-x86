void putc(char c);

static void puts(const char* s) {
    for (const char *c = s; *c; c++) {
        putc(*c);
    }
}

void _start() {
    puts("Hello, World!\n");
    while(1);
}
