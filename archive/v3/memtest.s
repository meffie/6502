;
; Memory test.

; Write then read a test byte to each addressable memory location in RAM.  First
; test page zero ($0000 to $00ff) using page zero address modes.  Then test the
; rest of the pages ($0010 to $3fff) using indirect y-index address mode. The
; base pointer is stored in bytes $0000 and $00ff. This test takes a while to
; run, and of course clobbers all the the memory in the system, including the
; stack at $0100 to $01ff.
;
page = $00             ; Current page pointer
pagelo = page          ; Current page pointer low byte
pagehi = page + 1      ; Current page pointer high byte
pattern = $cb          ; Test pattern
maxpage = $3f          ; Last page

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; Control pins
E  = %10000000
RW = %01000000
RS = %00100000


    .org $8000
title:
    .asciiz "memtest 12/32/2021"
ok_msg:
    .asciiz "ok"
fail_msg:
    .asciiz "fail"

mem_test:
    jsr lcd_setup

    ; Test page $00.
    lda #pattern       ; Initialize the test pattern byte.
    ldx #$00           ; Loop from $00 to $ff.
next_zp_index:
    sta $00,x          ; Write test byte
    lda $00,x          ; Read test byte
    cmp #pattern       ; Is the byte correct?
    bne fail           ; No: test failed
    inx                ; Yes: next index
    bne next_zp_index  ; Loop until index rolls over to $00

    ; Test pages $01 to $3f.
    lda #$00           ; Initialize page pointer
    sta pagelo
    lda #$01           ; Start at page 1
    sta pagehi
    ldx #maxpage + 1   ; Initialize end sentinel
next_page:
    lda #pattern       ; Initialize our test pattern
    ldy #$00           ; Loop index from $00 to $ff
next_index:
    sta (page),y       ; Write test byte
    lda (page),y       ; Read test byte
    cmp #pattern       ; Is the byte correct?
    bne fail           ; No: test failed
    iny                ; Yes: next index
    bne next_index     ; Loop until index rolls over to $00
    inc pagehi         ; Next page
    cpx pagehi         ; Was that the last page to be tested?
    bne next_page      ; No: test next page
    jmp ok


lcd_setup:
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
    rts

ok:
    ldx #$0
ok_next:
    lda ok_msg,x       ; Load next char
    beq spin            ; Nul char terminates string
    jsr print_char      ; Print the char
    inx                 ; Next char
    jmp ok_next        ; Print next char

fail:
    ldx #$0
fail_next:
    lda fail_msg,x       ; Load next char
    beq spin            ; Nul char terminates string
    jsr print_char      ; Print the char
    inx                 ; Next char
    jmp fail_next        ; Print next char

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
    .word mem_test   ; Reset vector
    .word $0000      ; ROM image padding
