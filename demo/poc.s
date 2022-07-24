;
; Proof of concept assembler source.
;
; To convert this to machine code:
;
;    cat poc.s | ./poc-asm.sh | xxd -r -p > poc.bin
;

start:           ; start label
    lda 08       ; load a value in the accumulator
    sta 0200     ; write the value to a memory location
loop:
    nop          ; delay
    jmp loop     ; loop forever
