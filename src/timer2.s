;
; 65C22 Timer 2 pulse countdown test.
;
; A debounced push button is connected to PB6 to generate
; countdown pulses.
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
    ; Setup 65C22
    lda #%00000010  ; Set PB6 to input mode
    sta VIA_DDRB

    lda #%00100000  ; Set T2 to pulse countdown mode
    sta VIA_ACR

    lda #%01011111  ; Disable all interrupts except T2 (don't change T2)
    sta VIA_IER

    lda #%10100000  ; Enable the T2 interrupt (don't change others)
    sta VIA_IER

    ; Enable interrupts.
    cli

    ; Set the T2 countdown
    lda #$04        ; Set latch low byte
    sta VIA_T2CL
    lda #$00        ; Set T2 counter high byte and set low byte from latch
    sta VIA_T2CH    ; Start counting pulses

main_loop:
    nop             ; Just wait for interrupts
    jmp main_loop

irq_handler:
    pha

    ; Non-optimized version.
    ; lda VIA_IFR
    ; and #%10000000  ; 65C22 interrupt?
    ; beq irq_done    ; no: exit handler

    ; lda VIA_IFR
    ; and #%00100000  ; T2 interrupt?
    ; beq irq_done    ; no: exit handler

    ; Optimized version. Use the BIT instruction to
    ; avoid extra IFR accesses. The BIT instruction
    ; transfers the IFR7 bit to the N flag, and sets
    ; the Z flag based on the logical and of the A
    ; register.
    lda #%00100000    ; Set the bit mask to check the T2 interrupt flag (IFR5)
    bit VIA_IFR       ; Set the N to IRF7 and Z to IFR5
    bpl irq_done      ; Done when IFR7 is 0 (N=0)
    beq irq_done      ; Done when IFR5 is 0 (Z=0)

    ; Restart timer 2.
    ; Low latch is already setup. The low latch is written
    ; to the counter low byte when the high byte (VIA_T2CH)
    ; is written.
    lda #$00        ; Start counting pulses
    sta VIA_T2CH    ; and clear the T2 interrupt flag

irq_done:
    pla
    rti

nmi_handler:
    rti

    .org $fffa
vectors:
    .word nmi_handler       ; Non-maskable interrupt
    .word reset             ; Reset
    .word irq_handler       ; Interrupt Request
