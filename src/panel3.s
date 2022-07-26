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
PA   .equ $6001      ; Output Register A
DDRA .equ $6003      ; Data Direction Register A
PCR  .equ $600c      ; Peripheral Control Register
IFR  .equ $600d      ; Interrupt Flag Register
IER  .equ $600e      ; Interrupt Enable Register

; Page 0 assignments
NIBBLE   .equ $00
STATE    .equ $01
OFFSET   .equ $02

; Memory locations
BASE     .equ $0200


    .org $8000      ; ROM memory mapped location

start:
    ; Initialization
    lda #$00
    sta STATE
    sta OFFSET

    ; Setup port A data pins.
    lda #%11110000  ; Set port A pins 0 to 3 to input, 4 to 7 to output
    sta DDRA

    ; Setup port A read handshake.
    lda #%00001000  ; CA1=negative active edge, CA2=handshake output
    sta PCR
    lda #%10000010  ; Enable interrupt on CA1 activation
    sta IER
    lda #%01111101  ; Disable all other interrupts
    sta IER

    cli             ; Enable interrupts

spin:               ; main loop
    nop             ;  just hangout and wait for interrupts
    jmp spin        ;  until the end of time

irq:                ; Interrupt handler
    pha             ; Save accumulator on the stack
    txa             ; Save the x index
    pha             ;   on the stack
;    lda IFR         ; Read interrupt flags
;    nop             ; todo: check for CA1 flag
;
;    ldx #$01        ; Debounce delay loop
;delay:
;    nop
;    dex
;    bne delay       ; Loop until zero

    lda STATE
    bne low_nibble  ; have high nibble? yes: get low nibble

high_nibble
    lda PA          ; Read port A and clear the interrupt
    and #$0f        ; Mask; we only have 4 switches
    clc             ; Clear carry flag
    rol             ; Shift low nibble to high nibble
    rol
    rol
    rol
    sta NIBBLE      ; Save high nibble
    lda #$01        ; Set state to 1 (have high nibble)
    jmp done

low_nibble:
    nop
    nop
    lda PA          ; Read port A and clear the interrupt
    and #$0f        ; Mask the low nibble
    ora NIBBLE      ; Haul in the high nibble
    ldx OFFSET      ; Get index
    sta BASE,x      ; Store the byte at the next location
    inx             ; Bump the offset to point to the next location
    stx OFFSET      ; Save the offset
    lda #$00        ; Set state to 0 (do not have high nibble)

done:
    sta STATE
    pla             ; Restore the x index
    tax             ;   from the stack
    pla             ; Restore the accumulator
    rti             ; Done

    .org $fffa      ; Vectors
    .word $0000     ; Non-maskable interrupt is not implemented
    .word start     ; Reset vector
    .word irq       ; Interrupt Request vector
