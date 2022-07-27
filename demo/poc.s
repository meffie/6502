;
; 6502 demo (proof of concept assembly)
;

    lda 08        ; load a value in the accumulator
    sta 0200      ; write the value to a memory location

loop:
    nop           ; delay
    jmp loop      ; loop forever
