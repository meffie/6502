;
; Minimal 6502 image to write data to port b on the i/o interface.
; Based on Ben Eater's 6502 example.
;
    .org $8000
reset:
    lda #$ff      ; Set all 8 bits to write to port.
    sta $6002     ; Data Direction Resister B (DDRB)
loop:
    lda #$55      ; Turn on every other bit.
    sta $6000     ; Write to Port B.
    lda #$aa      ; Toggle bits.
    sta $6000     ; Write to Port B.
    jmp loop      ; Loop forever or till reset or power fail, which ever is first.

    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Padding so our image is exactly the size of the ROM.
