;
;
; Front panel switch test.
;
; Toggle switches connected to PA0 to PA3 (4 bits) on 65C22
; Push button (normally high) connected to CA1 65C22.
; LED connected to CA2 (handshake output).
; 6522 base address is $6000.
;

; 65C22 registers
PA   .equ $6001      ; Output Register A
DDRA .equ $6003      ; Data Direction Register A
PCR  .equ $600c      ; Peripheral Control Register
IFR  .equ $600d      ; Interrupt Flag Register
IER  .equ $600e      ; Interrupt Enable Register

; Variables (page 0)
INPUT .equ $00

    .org $8000      ; ROM memory mapped location

start:
    ; Setup port A data pins.
    lda #%11110000  ; Set port A pins 0 to 3 to input, 4 to 7 to output
    sta DDRA

    ; Setup port A read handshake.
    lda #%00001000  ; CA1=negative active edge, CA2=handshake output
    sta PCR
    lda #%10000010  ; Enable interrupt on CA1 activation
    sta IER
    lda #%01111101  ; Disable all other interrupts
    sta IER

    cli             ; Enable interrupts

spin:               ; main loop
    nop             ;  just hangout and wait for interrupts
    jmp spin        ;  until the end of time

irq:                ; Interrupt handler
    lda IFR         ; Read interrupt flags
    nop             ; todo: check for CA1 flag
    nop             ; todo: debounce delay
    lda PA          ; Read port A and clears the interrupt
    and #$0f        ; We have only 4 input switches
    sta INPUT       ; Store the input nibble
    rti             ; Done

    .org $fffa      ; Vectors
    .word $0000     ; Non-maskable interrupt is not implemented
    .word start     ; Reset vector
    .word irq       ; Interrupt Request vector
