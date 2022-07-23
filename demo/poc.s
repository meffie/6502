;
; Proof a concept assembler source.
;
; To convert this to machine code:
;
;    ./poc-asm.sh < poc.s
;

start:           ; start label
    lda 08       ; load a value in the accumulator
    sta 0200     ; write the value to a memory location
loop:
    nop          ; delay
    jmp loop     ; loop forever
