;
;
; Front panel switch test.
;
; Toggle switches connected to PA0 to PA3 (4 bits) on 65C22
; Push button (normally high) connected to CA1 65C22.
; LED connected to CA2 (handshake output).
; 6522 base address is $6000.
;

; 65C22 registers
PA   .equ $6001      ; Output Fegister A
DDRA .equ $6003      ; Data Direction Register A
PCR  .equ $600c      ; Peripheral Control Register
IFR  .equ $600d      ; Interrupt Flag Register
IER  .equ $600e      ; Interrupt Enable Register

; Variables (page 0)
INPUT .equ $00

    .org $8000      ; ROM memory mapped location

start:
    ; Setup read handshake on port A.
    lda #%00001000  ; CA1=negative active edge, CA2=handshake output
    sta PCR
    lda #%10000010  ; Enable interrupt on CA1 activation
    sta IER
    cli             ; Enable interrupts

spin:               ; main loop
    nop             ;  just hangout and wait for interrupts
    jmp spin

nmi:                ; Non-maskable interrupt handler
    rti             ; Done

irq:                ; Interrupt handler
    pha             ; Save A register on the stack
    lda IFR         ; Read interrupt flags
    nop             ;  todo: check for CA1 flag
    lda PA          ; Read port A, clear the interrupt
    and #$0f        ; Only 4 input switches
    sta INPUT       ; Store the input nibble
    pla             ; Restore A register from the stack
    rti             ; Done

    .org $fffa      ; Vectors
    .word nmi       ; Non-maskable Interrupt Request vector
    .word start     ; Reset vector
    .word irq       ; Interrupt Request vector
