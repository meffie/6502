;
; 6502 demo
;

; Definitions
PB   .equ $6000   ; i/o port b
DDRB .equ $6002   ; data direction resgister for port b

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

zero:
    ldx #$00        ; x = 0

next:
    lda segments,x  ; convert x to bitmap
    sta PB          ; write byte to display
    inx             ; increment x
    cpx #$10        ; is x > $0f ?
    bne next        ; no: keep going
    jmp zero        ; yes: go back to zero

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k
