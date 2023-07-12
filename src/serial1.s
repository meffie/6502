;
; Serial port example program.
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
; TODO: Interrupt driven!
;
read_data:
    lda ACIA_STATUS    ; Read ACIA status register
    and #%00001000     ; Get the receiver data full flag
    beq read_data      ; Loop until byte received

    lda ACIA_DATA      ; Read the received byte
    jsr display_byte   ; Display the received byte
    jsr send_byte      ; Echo byte back
    cmp #$0d           ; Did we get a carriage return?
    bne read_data      ;   No: Wait for next character
    lda #$0a           ;   Yes: Send a line feed too
    jsr send_byte
    jmp read_data      ; Loop forever.

;
; Send one byte on the serial port.
;
; Delay after each transmission to work around the notorious W65C51
; Transmitter Data Register Empty (TDRE) flag bug.
;
send_byte:
    phx
    sta ACIA_DATA  ; Write byte to transmit register.
; if not wdc chip with bug
    ; lda ACIA_STATUS
    ; and #%00010000 ; Get the transmit data empty flag
    ; ...
; endif
    ldx #180       ; Delay for 9600 baud transmission.
delay:
    nop
    dex
    bne delay
    plx
    rts

    .include lcd.inc

display_byte:
    pha
    jsr lcd_home
    jsr lcd_print_char ; Display the received byte
    pha
    lda #$20           ; Space char
    jsr lcd_print_char ; Print space
    pla
    jsr lcd_print_byte
    pla
    rts

nmi:
    rti

irq:
    rti

banner:
    .ascii "Welcome to the 6502 Breadboard Computer!", $0d, $0a, $00

    .org $fffa   ; Start of vectors
    .word nmi
    .word reset
    .word irq
