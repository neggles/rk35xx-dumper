#include "types.h"
#include "uart.h"
#include "printf.h"

#define BOOTROM_BASE 0xFFFF0000

unsigned char *bootrom      = (unsigned char *)BOOTROM_BASE;
const uint32_t bootrom_size = 0x5000;

void hexDump(size_t offset, void *addr, int len);

void _start(void) {
    printf("dumping bootrom!\n");

    hexDump(BOOTROM_BASE, bootrom, bootrom_size);

    while (1) {}
}


void hexDump(size_t offset, void *addr, int len) {
    int i;
    unsigned char bufferLine[17];
    unsigned char *pc = (unsigned char *)addr;

    for (i = 0; i < len; i++) {
        if ((i % 16) == 0) {
            if (i != 0) printf(" %s\n", bufferLine);
            printf("%08x: ", offset);
            offset += (i % 16 == 0) ? 16 : i % 16;
        }

        printf("%02x", pc[i]);
        if ((i % 2) == 1) printf(" ");

        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            bufferLine[i % 16] = '.';
        else
            bufferLine[i % 16] = pc[i];


        bufferLine[(i % 16) + 1] = '\0';
    }

    while ((i % 16) != 0) {
        printf("  ");
        if (i % 2 == 1) putchar(' ');
        i++;
    }
    printf(" %s\n", bufferLine);
}
