;
; 7 segment led
;
;

PB   .equ $6000
DDRB .equ $6002

    .org $8000

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

reset:
    lda #$ff      ; Set port pins to output mode
    sta DDRB

begin:
    ldx #$00

next:
    lda segments,x
    sta PB

    inx
    cpx #$10
    bne next

    jmp begin

    .org $fffc
    .word reset   ; Reset vector
    .word $0000   ; Padding
