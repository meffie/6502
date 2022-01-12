;
; Display a message on the HD4478U LCD module.
; Based on Ben Eater's 6502 example.
;

    .org $8000
message:
    .asciiz "Hello world!"

reset:
    jsr lcd_setup
    lda #<message  ; lo byte
    ldx #>message  ; hi byte
    jsr lcd_print_string

spin:
    jmp spin

    .include lcd.s

    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Image padding.
