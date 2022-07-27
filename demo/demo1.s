;
; 6502 demo
;

    .org $8000    ; start of ROM

start:
    lda #$10      ; pin 5 is output
    sta $6002     ; Data Direction Resister B (DDRB)

loop:
    lda #$10      ; Turn on pin 5
    sta $6000     ; Write to port B
    lda #$00      ; Turn off pin 5
    sta $6000     ; Write to port B.
    jmp loop      ; Loop forever

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k
