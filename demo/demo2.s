;
; 6502 demo
;

; Definitions
PB   .equ $6000   ; i/o port b
DDRB .equ $6002   ; data direction resgister for port b

    .org $8000    ; start of ROM

start:
    lda #$ff      ; set port b pins to output mode
    sta DDRB

    lda #%00000001 ; initialize
next:
    sta PB        ; write byte to port b
    asl           ; shift left for next byte
    jmp next

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k
