;
; Blink an led connected to port A.
;
; To create rom:
;
;  vasm6502_oldstyle -dotdir -Fbin -o blink.bin blink.s
;  minipro -p AT28C256 -w blink.bin
;

    .org $8000

start:
    lda #$10      ; pin 5 is output
    sta $6003     ; Data Direction Resister A (DDRA)

loop:
    lda #$10      ; Turn on pin 5
    sta $6001     ; Write to port A
    lda #$00      ; Turn off pin 5
    sta $6001     ; Write to port A.
    jmp loop      ; Loop forever

    .org $fffc
    .word start   ; Reset vector
    .word $0000   ; Padding
