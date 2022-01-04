;
; Interrupt test
;
; Button connected to CA1 on 65C22.
;

counter = $0200  ; Test counter, 2 bytes

; 65C22 memory mapped addresses.
PCR = $600c      ; Peripheral Control Register
IFR = $600d      ; Interrupt Flag Register
IER = $600e      ; Interrupt Enable Flag


    .org $8000
    .asciiz "irq test"

reset:
    jsr lcd_setup
    lda #$00
    sta counter
    sta counter + 1
    lda #<counter
    ldx #>counter
    jsr lcd_print_address

    ; Setup 65C22 for IRQ.
    lda #00
    sta PCR   ; Set CA1 to neg edge triggered.
    lda #$82  ; Set/Clear=1, CA1=1
    sta IER   ; Enable CA1 input

    cli       ; Enable interrupts

spin:
    jmp spin

nmi:
    rti

irq:
    ; Save registers on stack.
    pha
    txa
    pha
    tya
    pha
    ; Increment our test counter.
    inc counter            ; Always increment the low counter byte.
    bne irq_inc_done       ; Did the low counter byte roll over?
    inc counter + 1        ; Yes: Increment high counter byte too.
irq_inc_done:              ; No: Skip high counter byte.
    jsr lcd_home
    lda #<counter
    ldx #>counter
    jsr lcd_print_address  ; Update display
    lda PORTA              ; Read port a to clear the interrupt.
    ; Restore registers.
    pla
    tay
    pla
    tax
    pla
    rti


    .include "lcd.s"

    .org $fffa
    .word nmi     ; Non-maskable Interrupt Request vector.
    .word reset   ; Reset vector.
    .word irq     ; Interrupt Request vector.
