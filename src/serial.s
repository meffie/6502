;
; Serial communications test.
;

; ACIA 6551 Registers
ACIA_DATA     = $4000     ; Transmit/Receiver Data Register
ACIA_STATUS   = $4001     ; Programmed Reset/Status Register
ACIA_COMMAND  = $4002     ; Command Register
ACIA_CONTROL  = $4003     ; Control Register

    .org $8000            ; Start of ROM

reset:
    ; Initialize the LCD display.
    jsr lcd_setup

    ; Initialize the ACIA.
    lda #%00000000     ; Soft reset
    sta ACIA_STATUS
    lda #%00011110     ; 8 data bits, 1 stop bit, 9600 baud
    sta ACIA_CONTROL
    lda #%00001001     ; No parity, No echo mode
    sta ACIA_COMMAND

; Send banner.
    ldx #0
banner_next:
    lda banner,x
    beq read_data
    jsr send_byte
    inx
    jmp banner_next
;
; Display and echo each byte received on the serial port.
;
read_data:
    lda ACIA_STATUS    ; Read ACIA status register
    and #%00001000     ; Get the receiver data full flag
    beq read_data      ; Loop until byte received

    lda ACIA_DATA      ; Read the received byte
    jsr lcd_print_char ; Display the received byte
    jsr send_byte      ; Echo byte back
    jmp read_data      ; Loop forever.

;
; Send one byte on the serial port.
;
; Delay after each transmission to work around the notorious W65C51
; Transmitter Data Register Empty (TDRE) flag bug.
;
send_byte:
    sta ACIA_DATA  ; Write byte to transmit register.
    phx
    ldx #180       ; Delay for 9600 baud transmission.
delay:
    nop
    dex
    bne delay
    plx
    rts

    .include lcd.s

nmi:
    rti

irq:
    rti

banner:
    .asciiz "Hello World!"

    .org $fffa   ; Start of vectors
    .word nmi
    .word reset
    .word irq
