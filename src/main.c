#include <stdio.h>

#include "uart.h"

int main(void) {
    setupUart();
    puts("hello\n");
    while (1) {}
    return 0;
}
