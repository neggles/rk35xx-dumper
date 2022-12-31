#include <stdint.h>

#include "uart.h"

#define DEFINE_PORT(name, address) volatile uint32_t *name = (volatile uint32_t *)address

DEFINE_PORT(uart_thr, UART_BASE);
DEFINE_PORT(uart_fcr, UART_BASE + 0x08);
DEFINE_PORT(uart_lsr, UART_BASE + 0x14);

/*
 * This is completely unnecessary. The FIFO sets the same status bit when empty
 * as the TX register does, so we can just pretend the FIFO doesn't exist.
 * May as well, though.
 */
void setupUart(void) {
    // If the TX FIFO is enabled, reset and disable it.
    // if ((*uart_fcr & UART_FCR_FIFO_EN) == 1) { *uart_fcr ^= UART_FCR_FIFO_EN; }
}

// Put a character in the UART TX register
void uartPutc(char c) {
    // Wait for the TX register to be empty
    while (!(*uart_lsr & UART_LSR_TX_REG_EMPTY)) {}
    // Write the character to the TX FIFO
    *uart_thr = c;
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
