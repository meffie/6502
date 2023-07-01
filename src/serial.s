;
; Serial communications test.
;

;-----------------------------------------------------------------------
; ACIA 6551 Registers     | On store (RWB is low)   | On load (RWB is high)
;------------------------------------------------------------------------
ACIA_DATA     = $4000     ; Write Transmit Data     | Read Receiver Data
ACIA_STATUS   = $4001     ; Write Programmed Reset  | Read Status Register
ACIA_COMMAND  = $4002     ; Write Command Register  | Read Command Register
ACIA_CONTROL  = $4003     ; Write Control Register  | Read Control Register

    .org $8000            ; Begin code

reset:
    ; Initialize the display.
    jsr lcd_setup

    ; Initialize the ACIA.
    lda #$00        ; Reset
    sta ACIA_STATUS

    lda #$1e        ; 1 stop, 8 data, 9600
    sta ACIA_CONTROL

    lda #$09        ; no parity, no echo,
    sta ACIA_COMMAND

read_data:
    nop
    lda ACIA_STATUS
    and #$08
    beq read_data

    lda ACIA_DATA
    sta ACIA_DATA
    jsr lcd_print_char
    jmp read_data

    .include lcd.s

    .org $fffa          ; Vectors
    .word $0000         ; Pad (Non-maskable interrupt vector)
    .word reset
    .word $0000         ; Pad (IRQ vector)
