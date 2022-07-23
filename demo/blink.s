;
; To create rom:
;
;  vasm6502_oldstyle -dotdir -Fbin -o blink.bin blink.s
;  minipro -p AT28C256 -w blink.bin
;

    .org $8000

start:
    lda #$ff      ; set all bits to be output
    sta $6003     ; Data Direction Resister A (DDRA)

loop:
    lda #$55      ; Turn on every other bit.
    sta $6001     ; Write to port A
    lda #$aa      ; Toggle bits.
    sta $6001     ; Write to port A.
    jmp loop      ; Loop forever

    .org $fffc
    .word start   ; Reset vector.
    .word $0000   ; Padding
