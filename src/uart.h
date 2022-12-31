#ifndef UART_H
#define UART_H

#define UART_BASE                  0xfe660000

#define UART_FCR_FIFO_EN           (1 << 0)
#define UART_FCR_RX_FIFO_RESET     (1 << 1)
#define UART_FCR_TX_FIFO_RESET     (1 << 2)

#define UART_LSR_RX_FIFO_VALID     (1 << 0)
#define UART_LSR_TX_HOLD_REG_EMPTY (1 << 5)
#define UART_LSR_TX_FIFO_EMPTY     (1 << 6)

typedef struct rk_uart {
    volatile uint32_t buf;
    volatile uint32_t ier;
    volatile uint32_t iir;
    volatile uint32_t lcr;
    volatile uint32_t mcr;
    volatile uint32_t lsr;
    volatile uint32_t msr;
} rk_uart_t;

void setupUart(void);
int puts(const char *s);
void putchar(char c);

#endif
