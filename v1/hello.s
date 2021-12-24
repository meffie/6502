;
; Display a message on the HD4478U LCD module.
; Based on Ben Eater's 6502 example.
;
; Limitations:
; * This version avoids the use of call/return op codes since that requires RAM.
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

    ; Send instruction to display.
    lda #%00000001     ; Clear display.
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Pulse E (enable bit)
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA

    ; Send instruction to display.
    lda #%00111000      ; Function set: 8-bits, 2 lines, 5x8 font
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Pulse E (enable bit)
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA

    ; Send instruction to display.
    lda #%00001110      ; Turn display on, cursor on, turn blink off
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Pulse E (enable bit)
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA

    ; Send instruction to display.
    lda #%00000110      ; Increment cursor right, no scroll
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Pulse E (enable bit)
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA

    ; Write data to display
    lda #"H"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"e"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"l"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"l"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"o"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #" "
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"w"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"o"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"r"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"l"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"d"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

    lda #"!"
    sta PORTB
    lda #RS             ; Set RS, clear RW, E
    sta PORTA
    lda #(RS | E)       ; Pulse E
    sta PORTA
    lda #RS             ; Set RS, clear RW, E
    sta PORTA

loop:
    nop
    jmp loop

    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Padding so our image is exactly the size of the ROM.
