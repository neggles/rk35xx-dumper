#ifndef UART_H
#define UART_H

#include <stdint.h>

#ifdef QEMU_BUILD
    #pragma message "Compiling for QEMU"
    #define UART_BASE 0xe0000000
#else
    #pragma message "Compiling for baremetal"
    #define UART_BASE 0xfe660000
#endif

#define UART_FCR_FIFO_EN       (1 << 0)
#define UART_FCR_RX_FIFO_RESET (1 << 1)
#define UART_FCR_TX_FIFO_RESET (1 << 2)

#define UART_LSR_RX_FIFO_VALID (1 << 0)
#define UART_LSR_TX_REG_EMPTY  (1 << 5)
#define UART_LSR_TX_FIFO_EMPTY (1 << 6)

void setupUart(void);
int puts(const char *s);

#endif
