;
; HD4478U LCD module routines
; Based on Ben Eater's 6502 videos.
;

; Zero page registers.
lcd_string = $0
lcd_address = $2

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; Control pins
E  = %10000000
RW = %01000000
RS = %00100000


lcd_setup:
    ; Setup I/O ports.
    pha
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
    pla
    rts

lcd_clear:
    pha
    lda #%00000001      ; Clear display.
    jsr lcd_instruction
    pla
    rts

lcd_home:
    pha
    lda #%00000010      ; Move cursor to home position.
    jsr lcd_instruction
    pla
    rts

lcd_print_string:
    ; Display a string at the current cursor.
    ; (A, X) = string address (lo, hi)
    sta lcd_string       ; string address, lo byte
    stx lcd_string + 1   ; string address, hi byte
    ldy #$0
    lda #RS              ; Set RS, clear RW and E
    sta PORTA
lcd_next_char:
    lda (lcd_string),y   ; Load next char
    beq lcd_done         ; String is nul terminated
    jsr _lcd_wait         ; Wait until display is ready
    sta PORTB            ; Output char to display
    lda #(RS | E)        ; Set RS and E to send char
    sta PORTA
    lda #RS              ; Clear E, Keep RS set
    sta PORTA
    iny                  ; Next char index
    jmp lcd_next_char    ; Continue printing chars
lcd_done:
    rts                  ; Nul char found

_lcd_wait:
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
    ; Instruction is loaded in A.
    jsr _lcd_wait
    sta PORTB
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    lda #E              ; Set E to execute instruction
    sta PORTA
    lda #$0             ; Clear RS, RW, E bits
    sta PORTA
    rts

lcd_print_char:
    ; Char to print is loaded in A.
    pha
    jsr _lcd_wait
    sta PORTB
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    lda #(RS | E)       ; Set RS and E to send char
    sta PORTA
    lda #RS             ; Set RS, clear RW and E
    sta PORTA
    pla
    rts

;-----------------------------------------------------------------------------
; Print memory address and values as hex digits.
;
; A, X = address to print (lo, hi)
;
lcd_print_address:
    sta lcd_address      ; address lo byte
    stx lcd_address + 1  ; address hi byte
    lda lcd_address + 1
    jsr lcd_print_byte   ; Print address hi byte
    lda lcd_address
    jsr lcd_print_byte   ; Print address lo byte
    lda #":"
    jsr lcd_print_char   ; Print separator
    ldy #$00
    lda (lcd_address),y
    jsr lcd_print_byte   ; Print address[0]
    lda #" "
    jsr lcd_print_char   ; Print separator
    iny
    lda (lcd_address),y
    jsr lcd_print_byte   ; Print address[1]
    lda #" "
    jsr lcd_print_char   ; Print separator
    iny
    lda (lcd_address),y
    jsr lcd_print_byte   ; Print address[2]
    lda #" "
    jsr lcd_print_char   ; Print separator
    iny
    lda (lcd_address),y
    jsr lcd_print_byte   ; Print address[3]
    rts

;-----------------------------------------------------------------------------
; Print A as hex digits.
;
; A = value to print
;
lcd_print_byte:
    pha                  ; Save A
    phx                  ; Save X
    pha                  ; Save A for low nibble
    lsr                  ; Shift four times to get high nibble
    lsr
    lsr
    lsr
    tax                  ; Move high nibble to index
    lda lcd_hexdigits,x  ; Lookup hex digit character for high nibble
    jsr lcd_print_char   ; Display high nibble hex char
    pla                  ; Restore A for low nibble
    and #$0f             ; Mask off high nibble to get low nibble
    tax                  ; Move low nibble to index
    lda lcd_hexdigits,x  ; Lookup hex digit character for low nibble
    jsr lcd_print_char   ; Display low nibble
    plx                  ; Restore X
    pla                  ; Restore A
    rts

lcd_hexdigits:
    .byte "0123456789abcdef"
