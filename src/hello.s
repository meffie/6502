;
; Display a message on the LCD module.
;

    .org $8000  ; Start of code

reset:
    ; Initialize the display.
    jsr lcd_setup

    ; Write chars to the display.
    ldx #0
next:
    lda message,x
    beq done
    jsr lcd_print_char
    inx
    jmp next

done:
    nop
    jmp done  ; Just spin forever

    .include lcd.inc

nmi:
    rti

irq:
    rti

message:
    .asciiz "Hello World!"

    .org $fffa    ; Start of vectors
    .word nmi
    .word reset
    .word irq
