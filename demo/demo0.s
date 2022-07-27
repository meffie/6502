;
; 6502 demo
;

    .org $8000    ; start of ROM

start:            ; start label
    lda #$08      ; load a value in the accumulator
    sta $0200     ; write the value to a memory location

loop:
    nop           ; delay
    jmp loop      ; loop forever

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k
