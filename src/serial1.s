;
; Serial communications test.
;

;----------------------------------------------------------------------------
; ACIA 6551 Registers     | RWB = Low               | RWB = High
;----------------------------------------------------------------------------
UART_DATA     .equ $4000  ; Write Transmit Data     | Read Receiver Data
UART_RESET    .equ $4001  ; Write Programmed Reset  | Read Status Register
UART_COMMAND  .equ $4002  ; Write Command Register  | Read Command Register
UART_CONTROL  .equ $4003  ; Write Control Register  | Read Control Register

;----------------------------------------------------------------------------
; Control Register Flags
;
UART_1_STOP_BIT    .equ %00000000
UART_2_STOP_BITS   .equ %10000000

UART_8_DATA_BITS   .equ %00000000
UART_7_DATA_BITS   .equ %00100000
UART_6_DATA_BITS   .equ %01000000
UART_5_DATA_BITS   .equ %01100000

UART_EXTERNAL_CLK  .equ %00000000
UART_BAUD_RATE     .equ %00010000

UART_BAUD_115K     .equ %00000000
UART_BAUD_50       .equ %00000001
UART_BAUD_75       .equ %00000010
UART_BAUD_109      .equ %00000011
UART_BAUD_134      .equ %00000100
UART_BAUD_150      .equ %00000101
UART_BAUD_300      .equ %00000110
UART_BAUD_600      .equ %00000111
UART_BAUD_1200     .equ %00001000
UART_BAUD_1800     .equ %00001001
UART_BAUD_2400     .equ %00001010
UART_BAUD_3600     .equ %00001011
UART_BAUD_4800     .equ %00001100
UART_BAUD_7200     .equ %00001101
UART_BAUD_9600     .equ %00001110
UART_BAUD_19200    .equ %00001111

;----------------------------------------------------------------------------
; Command Resister Flags
;
UART_NO_PARITY           .equ %00000000  ; Parity bit is not supported by W65c51.

UART_NORMAL_MODE         .equ %00000000  ; Receiver normal mode
UART_ECHO_MODE           .equ %00010000  ; Receiver echo mode bits 2 and 3 must be zero.

UART_NOT_READY_TO_SENT   .equ %00000000
UART_READY_TO_SEND       .equ %00001000

UART_IRQ_ENABLED         .equ %00000000
UART_IRQ_DISABLED        .equ %00000010

UART_TERMINAL_READY      .equ %00000000
UART_TERMINAL_NOT_READY  .equ %00000001

;----------------------------------------------------------------------------
; Begin code.
;
    .org $8000

setup:
    lda #(UART_1_STOP_BIT | UART_8_DATA_BITS | UART_BAUD_RATE | UART_BAUD_9600)
    sta UART_CONTROL

    lda #(UART_NO_PARITY | UART_NORMAL_MODE | UART_READY_TO_SEND | UART_IRQ_ENABLED | UART_TERMINAL_READY)
    sta UART_COMMAND

    ;cli       ; Enable interrupts

spin:
    nop
    nop
    nop
    jmp spin

irq:
    lda UART_STATUS
    ;lda UART_RX
    rti

    .org $fffa          ; Vectors
    .word $0000         ; Non-maskable interrupt is not implemented
    .word setup         ; Reset vector
    .word irq           ; Interrupt Request vector
