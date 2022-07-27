;
; To create rom:
;
;  vasm6502_oldstyle -dotdir -Fbin -o first.bin first.s
;  minipro -p AT28C256 -w first.bin
;

    .org $8000    ; start of ROM

start:
    lda #$08      ; read a byte
    sta $0200     ; write a byte
    jmp start

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k
