;
; Display memory location in hex.
;


    .org $8000
    .asciiz "hex test"

reset:
    jsr lcd_setup

    lda #$cb       ; Test value
    sta $2200      ; Test address

    lda #$00
    ldx #$22
    jsr lcd_print_address

spin:
    jmp spin

    .include "lcd.s"

    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Image padding.
