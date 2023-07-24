;
; W65C51S transmit bug work-around with interrupts
;
; The WDC W65C51N has a infamous hardware bug which makes it impossible to know
; when it is safe to write the next byte into the transmit register.  To
; work-around this hardware bug, we need to delay for some baud-rate dependent
; time before writing the next byte to send, otherwise, the transmit shift
; register will be overwritten before the previous byte is fully transmitted.
; This bug also makes it impossible to use the W65C51N interrupt to transmit
; data.
;
; A simple work-around for this bug is to add a software delay when writing
; bytes to the transmit register. A software delay is easy to implement, but
; the code depends on the clock rate and the baud rate, and the 6502 is stalled
; during the delay, which is not great.
;
; As an alternative, this test program demonstrates how to use the 65C22 VIA to
; generate an interrupt when it is safe to write the next byte into the
; transmit register. This work-around was first suggested by GaBuZoMeu on the
; 6502.org forum [1].  A nice feature of this work-around is that it is
; independent of the baud rate and clock speed.
;
; The 65C22 features a pulse countdown timer. After N+1 pulses on the PB6 line,
; an interrupt is generated.  The W65C51N RxC (pin 5) generates pulses at a
; rate of 16 times the baud rate. The 65C51C RxC pin is connected to the 65C22
; PB6 and the pulses are counted down when a byte is being transmitted. When
; the timer interrupt occurs, we know enough time has lapsed to make it safe to
; write the next byte.  Currently, I am using a 9600 baud rate, which is slow
; enough for the countdown timer when running at a 1Mz clock.
;
; Note that the PB6 pin must be available, so the LCD module must be removed or
; the ports swapped so the PB6 line is available.
;
; [1]: http://forum.6502.org/viewtopic.php?f=1&t=5482&p=66433#p66433
;

;----------------------------------------------------------------------
; 65C22 Registers
;
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

;----------------------------------------------------------------------
; 65C51 Registers
;
ACIA_BASE     = $4000           ; Base address of the 65C51
ACIA_DATA     = ACIA_BASE       ; Transmit/Receiver Data Register
ACIA_STATUS   = ACIA_BASE + $1  ; Programmed Reset/Status Register
ACIA_COMMAND  = ACIA_BASE + $2  ; Command Register
ACIA_CONTROL  = ACIA_BASE + $3  ; Control Register

;----------------------------------------------------------------------
; Transmit ring buffer
;
RING_BUFFER_WRITE = $01
RING_BUFFER_READ = $02
RING_BUFFER_BASE = $0300

;----------------------------------------------------------------------
; Initialization
;
    .org $8000      ; Start of ROM
reset:
    ; Setup the 65C22
    lda #%00000010  ; Set PB6 to input mode
    sta VIA_DDRB
    lda #%00100000  ; Set T2 to pulse countdown mode
    sta VIA_ACR
    lda #$ff        ; Set the T2 countdown (counter low byte)
    sta VIA_T2CL
    lda #%01011111  ; Disable all interrupts except T2 (don't change T2)
    sta VIA_IER
    lda #%10100000  ; Enable the T2 interrupt (don't change others)
    sta VIA_IER

    ; Enable interrupts.
    cli


;----------------------------------------------------------------------
; Main loop
;
; This is just a test program. Just loop while waiting for interrupts.
;
    ; Start counting
    ; lda #$00          ; Start counting pulses again
    ; sta VIA_T2CH      ;   and clear the T2 interrupt flag
main_loop:
    nop
    jmp main_loop

;----------------------------------------------------------------------
; Ring buffer routines
;

ring_buffer_write:
    phx
    ldx RING_BUFFER_WRITE
    sta RING_BUFFER_BASE,x
    plx
    rts

ring_buffer_read:
    plx
    ldx RING_BUFFER_READ
    lda RING_BUFFER_BASE,x
    phx
    rts

;----------------------------------------------------------------------
; Interrupt handlers
;
irq_handler:
    pha
    lda #%00100000    ; Set the bit mask to check the T2 interrupt flag (IFR5)
    bit VIA_IFR       ; Copy IRF7 to the N flag, copy IFR5 to the Z flag
    bpl irq_done      ; Done when IFR7 is 0 (N=0)
    beq irq_done      ; Done when IFR5 is 0 (Z=0)

    ; Transmit next byte
    ; if bytes in buffer,
    ;lda xxx ; todo: grab next byte from tx ring buffer
    ;sta ACIA_DATA

    ; Restart Timer 2 (T2)
    lda #$00          ; Start counting pulses again
    sta VIA_T2CH      ;   and clear the T2 interrupt flag

irq_done:
    pla
    rti

;----------------------------------------------------------------------
; Non-maskable Interrupt handler
;
nmi_handler:
    rti     ; Not implemented

;----------------------------------------------------------------------
; Vectors
;
    .org $fffa
    .word nmi_handler       ; Non-maskable interrupt
    .word reset             ; Reset
    .word irq_handler       ; Interrupt Request
