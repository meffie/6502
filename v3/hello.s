;
; Display a message on the HD4478U LCD module.
; Based on Ben Eater's 6502 example.
;
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
message:
    .asciiz "    Happy                                  New Year!                            "

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


    ldx #$0
print_string:
    lda message,x       ; Load next char
    beq spin            ; Nul char terminates string
    jsr print_char      ; Print the char
    inx                 ; Next char
    jmp print_string    ; Print next char

lcd_wait:
    ; Wait until the LCD busy flag is clear before sending
    ; next instruction or data.
    pha
    lda #%00000000
    sta DDRB            ; Set port B to input mode on all pins
lcd_busy_retry:
    lda #RW
    sta PORTA           ; Set RS=0, RW=1, E=0
    lda #(RW | E)
    sta PORTA           ; Set E to execute
    lda PORTB           ; Read data from LCD
    and #%10000000      ; Is the busy flag set?
    bne lcd_busy_retry  ; Yes: retry
    lda #RW
    sta PORTA           ; Clear E to stop reading.
    lda #%11111111
    sta DDRB            ; Restore port B to output mode on all pins
    pla
    rts

lcd_instruction:
    ; Instruction must be loaded in A.
    jsr lcd_wait
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Set E to execute instruction
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    rts

print_char:
    ; Char to write must be loaded in A.
    sta PORTB
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    lda #(RS | E)       ; Set RS and E to send char
    sta PORTA
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    rts

spin:
    jmp spin

    .org $fffc
    .word reset   ; Reset vector.
    .word $0000   ; Padding so our image is exactly the size of the ROM.
