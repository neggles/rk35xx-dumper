#include "types.h"
#include "uart.h"

rk_uart_t *uart2 = (rk_uart_t *)UART_BASE;

/*
 * This is completely unnecessary. The FIFO sets the same status bit when empty
 * as the TX register does, so we can just pretend the FIFO doesn't exist.
 * May as well, though.
 */
void setupUart(void) {
    // If the TX FIFO is enabled, reset and disable it.
    // if ((*uart_fcr & UART_FCR_FIFO_EN) == 1) { *uart_fcr ^= UART_FCR_FIFO_EN; }
    return;
}

// Put a character in the UART TX register
void uartPutc(char c) {
    // Wait for the TX register to be empty
    while (!(uart2->lsr & UART_LSR_TX_HOLD_REG_EMPTY)) {}
    // Write the character to the TX FIFO
    uart2->buf = c;
}

void putchar(char c) {
    if (c == '\n') uartPutc('\r');
    uartPutc(c);
}

// picolibc's printf() calls puts() to print a string, so we need to implement it.
int puts(const char *s) {
    while (*s != '\0') {
        if (*s == '\n') uartPutc('\r');
        uartPutc(*s); /* Send char to UART */
        s++;          /* Next char */
    }
    return 0;
}
