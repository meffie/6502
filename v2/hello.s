;
; Display a message on the HD4478U LCD module.
; Based on Ben Eater's 6502 example.
;
; Limitations:
; * This version only works with a slow clock rate (~200Hz) since we do
;   not check the LCD busy flag before writing.
;

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; Control pins
E  = %10000000
RW = %01000000
RS = %00100000


    .org $8000
reset:
    ; Setup I/O ports.
    lda #%11111111      ; Port B; output mode on all pins
    sta DDRB
    lda #%11100000      ; Port A; output mode on top 3 pins
    sta DDRA

    lda #%00000001      ; Clear display.
    jsr lcd_instruction

    lda #%00111000      ; Function set: 8-bits, 2 lines, 5x8 font
    jsr lcd_instruction

    lda #%00001110      ; Turn display on, cursor on, turn blink off
    jsr lcd_instruction

    lda #%00000110      ; Increment cursor right, no scroll
    jsr lcd_instruction

    lda #"H"
    jsr lcd_char

    lda #"e"
    jsr lcd_char

    lda #"l"
    jsr lcd_char

    lda #"l"
    jsr lcd_char

    lda #"o"
    jsr lcd_char

    lda #" "
    jsr lcd_char

    lda #"w"
    jsr lcd_char

    lda #"o"
    jsr lcd_char

    lda #"r"
    jsr lcd_char

    lda #"l"
    jsr lcd_char

    lda #"d"
    jsr lcd_char

    lda #"!"
    jsr lcd_char

done:
    jmp done

lcd_instruction:
    ; Instruction must be loaded in A.
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Set E to execute instruction
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    rts

lcd_char:
    ; Char to write must be loaded in A.
    sta PORTB
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    lda #(RS | E)       ; Set RS and E to send char
    sta PORTA
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    rts


    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Padding so our image is exactly the size of the ROM.
