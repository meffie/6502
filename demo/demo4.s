;
; 6502 demo
;

; Definitions
PB   .equ $6000   ; i/o port b
PA   .equ $6001   ; i/o port a
DDRB .equ $6002   ; data direction resgister for port b
DDRA .equ $6003   ; data direction resgister for port a
PCR  .equ $600c   ; peripheral control register
IFR  .equ $600d   ; interrupt flag register
IER  .equ $600e   ; interrupt enable register

INPUT .equ $0200  ; our input value


    .org $8000    ; start of ROM

; 7 segment led table
segments:
    .byte %01111101 ; 0
    .byte %00110000 ; 1
    .byte %01011011 ; 2
    .byte %01111010 ; 3
    .byte %00110110 ; 4
    .byte %01101110 ; 5
    .byte %01101111 ; 6
    .byte %00111000 ; 7
    .byte %01111111 ; 8
    .byte %00111110 ; 9
    .byte %00111111 ; a
    .byte %01100111 ; b
    .byte %01000011 ; c
    .byte %01110011 ; d
    .byte %01001111 ; e
    .byte %00001111 ; f

start:
    lda #$ff      ; set port b pins to output mode
    sta DDRB

    lda #%11110000  ; set port a pins 0 to 3 to input mode
    sta DDRA

    ; Setup port A read handshake.
    lda #%00001000  ; CA1=negative active edge, CA2=handshake output
    sta PCR
    lda #%10000010  ; Enable interrupt on CA1 activation
    sta IER
    lda #%01111101  ; Disable all other interrupts
    sta IER

    lda #$00        ; Initalize the input value
    sta INPUT

    cli             ; Enable interrupts

main_loop:
    ldx #$00        ; x = 0

next:
    lda segments,x  ; convert x to bitmap
    sta PB          ; write byte to display
    inx             ; increment x
    cpx #$10        ; is x > $0f ?
    bne next        ; no: keep going
    jmp main_loop   ; yes: go back to zero


irq:                ; Interrupt handler
    pha             ; save a
    lda PA          ; read port A and clear the interrupt
    and #$0f        ; we only have 4 switches
    sta INPUT       ;
    pla             ; restore
    rti


    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word irq     ; interrupt request vector
