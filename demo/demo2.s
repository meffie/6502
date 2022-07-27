;
; 7 segment led
;
; To create rom:
;
;  vasm6502_oldstyle -dotdir -Fbin -o 7seg.bin 7seg.s
;  minipro -p AT28C256 -w 7seg.bin
;

PB   .equ $6000
DDRB .equ $6002

    .org $8000

start:
    lda #$ff      ; Set port pins to output mode
    sta DDRB

    lda #%00000001
loop:
    sta PB
    asl
    jmp loop

    .org $fffc
    .word start   ; Reset vector
    .word $0000   ; Padding
