;
; Serial port example program using receiver IRQ.
;

; ACIA 65C51 Registers
ACIA_BASE     = $4000           ; Base address of the 65C51
ACIA_DATA     = ACIA_BASE       ; Transmit/Receiver Data Register
ACIA_STATUS   = ACIA_BASE + $1  ; Programmed Reset/Status Register
ACIA_COMMAND  = ACIA_BASE + $2  ; Command Register
ACIA_CONTROL  = ACIA_BASE + $3  ; Control Register

; Zero page registers.
RX_START = $4
RX_END = $5

; Receive circular buffer (page $02)
RX_BUFFER = $0200

    .org $8000           ; Start of ROM

reset:
    ; Initialize the ACIA.
    lda #%00000000
    sta ACIA_STATUS      ; Soft reset

    lda #%00011110       ; 8 data bits, 1 stop bit, 9600 baud
    sta ACIA_CONTROL

    lda #%00001001       ; No parity, no echo mode, enable receive IRQ, disable transmit IRQ
    sta ACIA_COMMAND

    cli                  ; Enable interrupts

main_loop:
    nop
    jmp main_loop

irq:
    pha
    lda ACIA_STATUS      ; Read ACIA status register
; TODO: Just check the IRQ flag for now. I should also check the RDRF flag.
    and #%10000000
    beq irq_done         ;
    lda ACIA_DATA        ; Read the received byte
; TODO: write the byte into the circular buffer
irq_done:
    pla
    rti

nmi:
    rti

    .org $fffa   ; Start of vectors
    .word nmi
    .word reset
    .word irq
