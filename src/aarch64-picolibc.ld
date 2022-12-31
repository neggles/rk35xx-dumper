__flash = 0x00000000;   /* starting address of "flash" */
__flash_size = 0x10000; /* length of "flash" */
__ram = 0x20000000;     /* starting address of "RAM" */
__ram_size = 0x10000;   /* length of "RAM" */
__stack_size = 4k;      /* size of stack */

INCLUDE picolibc.ld
