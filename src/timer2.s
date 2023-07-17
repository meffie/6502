;
; 65C22 Timer 2 pulse countdown test.
;
; A debounced push button is connected to PB6 to generate
; countdown pulses, and a push button (normally high) is
; connected to CA1 to start a T2 countdown.
;

; 65C22 Registers
VIA_BASE   = $6000             ; The VIA 65C22 base address
VIA_PORT_B = VIA_BASE + $0     ; Port B (ORB/IRB)
VIA_PORT_A = VIA_BASE + $1     ; Port A (ORA/IRA)
VIA_DDRB   = VIA_BASE + $2     ; Data Direction Register B
VIA_DDRA   = VIA_BASE + $3     ; Data Direction Register A
VIA_T2CL   = VIA_BASE + $8     ; T2 Low Latch/Counter
VIA_T2CH   = VIA_BASE + $9     ; T2 High Counter
VIA_ACR    = VIA_BASE + $b     ; Auxiliary Control Register
VIA_PCR    = VIA_BASE + $c     ; Peripheral Control Register
VIA_IFR    = VIA_BASE + $d     ; Interrupt Flag Register
VIA_IER    = VIA_BASE + $e     ; Interrupt Enable Register

    .org $8000      ; Start of ROM
reset:
    lda #%11111111  ; Set PA0-PA7 to input
    sta VIA_DDRA
    lda #%00000010  ; Set PB6 to input
    sta VIA_DDRB
    lda #%00001000  ; CA1=negative active edge
    sta VIA_PCR
    lda #%10000010  ; Enable interrupt on CA1 activation
    sta VIA_IER
    lda #%01111101  ; Disable all other interrupts
    sta VIA_IER
    cli             ; Enable interrupts

loop:               ; Main loop
    nop             ;  just hangout and wait for interrupts
    jmp loop        ;  until the end of time

irq:
    pha
    lda VIA_IFR
    and #%10000000  ; 65C22 interrupt raised?
    beq irq_done    ;   no: exit irq handler
    lda VIA_IFR
    and #%00000010  ; Is CA1 active?
    beq irq_done    ;   no: exit irq handler
    lda VIA_PORT_A  ; Clear interrupt
    ; todo: start timer 2
    nop
    nop
irq_done:
    pla
    rti

nmi:
    rti

    .org $fffa
vectors:
    .word nmi       ; Non-maskable interrupt
    .word reset     ; Reset
    .word irq       ; Interrupt Request
