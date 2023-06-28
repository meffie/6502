;
; Serial communications test.
;

;----------------------------------------------------------------------------
; ACIA 6551 Registers     | On store (RWB is low)   | On load (RWB is high)
;----------------------------------------------------------------------------
ACIA_DATA     .equ $4000  ; Write Transmit Data     | Read Receiver Data
ACIA_STATUS   .equ $4001  ; Write Programmed Reset  | Read Status Register
ACIA_COMMAND  .equ $4002  ; Write Command Register  | Read Command Register
ACIA_CONTROL  .equ $4003  ; Write Control Register  | Read Control Register

;----------------------------------------------------------------------------
; Begin code.
;
    .org $8000

acia_setup:
    lda #$1e           ; 1 stop bit, 8 data bits, 9600 baud rate
                       ; Use internal baud rate for receiver clock source (bit 4)
    sta ACIA_CONTROL

    lda #$09           ; No parity, Normal receiver mode (no echo)
                       ; Receiver input IRQ enabled, Raise RTS and DTR
    sta ACIA_COMMAND


spin:
    nop
    lda ACIA_STATUS
    nop
    lda ACIA_DATA
    nop
    jmp spin

    .org $fffa          ; Vectors
    .word $0000         ; Pad (Non-maskable interrupt vector)
    .word acia_setup    ; Reset vector
    .word $0000         ; Pad (IRQ vector)
