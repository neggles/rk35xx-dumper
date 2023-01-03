#include "types.h"
#include "uart.h"

rk_uart_t *uart2 = (rk_uart_t *)UART_BASE;

/*
 * The UART has a FIFO, which the bootROM may or may not have enabled, but the
 * same register bit is used for "FIFO empty" and "transmit holding register empty",
 * so we can just pretend it's always disabled.
 */

// Send a character out the UART
void uartPutc(char c) {
    // Wait for the TX register to be empty
    while (!(uart2->lsr & UART_LSR_TX_HOLD_REG_EMPTY)) {}
    // Write the character to the TX FIFO
    uart2->buf = c;
}

// tinyprintf calls putchar() to print a character.
void putchar(char c) {
    if (c == '\n') uartPutc('\r');
    uartPutc(c);
}

// picolibc's printf() calls puts() to print a string.
int puts(const char *s) {
    while (*s != '\0') {
        putchar(*s);
        s++;
    }
    return 0;
}
