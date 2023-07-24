;
; Ring buffer example
;

RB_HEAD = $10
RB_TAIL = $11
RB_FULL_L = $12
RB_FULL_H = $13
RB_BASE = $0300
RB_MAX = $f0

RESULT = $40

    .org $8000      ; Start of ROM

reset:
    cld    ; Enable binary mode
    ; Initialize the ring buffer indices.
    lda #$00
    sta RB_HEAD
    sta RB_TAIL
    sta RB_FULL_L
    sta RB_FULL_H
    jmp version2

;=========================================================================
; Version 1
;=========================================================================
version1:

    jsr rb_length
    sta RESULT

    ; Put some bytes in the ring buffer
    lda #'h'
    jsr rb_write
    lda #'e'
    jsr rb_write
    lda #'l'
    jsr rb_write
    lda #'l'
    jsr rb_write
    lda #'o'
    jsr rb_write

    jsr rb_length
    sta RESULT

    ; Remove some bytes from the ring buffer
    jsr rb_read
    sta RESULT
    jsr rb_read
    sta RESULT

    jsr rb_length
    sta RESULT

    ; Write some more bytes.
    lda #'w'
    jsr rb_write
    lda #'o'
    jsr rb_write

spin:
    nop
    jmp spin

;------------------------------------------------------------------------------
; Get the number of bytes in the ring buffer.
rb_length:
    sec              ; Clear the borrow bit
    lda RB_HEAD
    sbc RB_TAIL      ; Size = Head - Tail
    rts

;------------------------------------------------------------------------------
; Write byte to ring buffer.
rb_write:
    ldx RB_HEAD
    sta RB_BASE,x
    inc RB_HEAD
    rts

;------------------------------------------------------------------------------
; Read byte from ring buffer.
rb_read:
    ldx RB_TAIL
    lda RB_BASE,x
    inc RB_TAIL
    rts

;=========================================================================
; Version 2
;=========================================================================

message:
    .asciiz "Hello World"

version2:
    ldx #0
.next:
    lda message,x
    beq .done
    jsr rb_write2
    ; cmp
    inx
    jmp .next

.done:
    nop
    jmp .done



rb_is_full:
    sec              ; Clear the borrow bit
    lda RB_HEAD      ; Load head index
    sbc RB_TAIL      ; Calculate the number of bytes in the ring buffer (head - tail, modulo 256)
    cmp #RB_MAX      ; Is ring buffer nearly full?
    bcs .rb_is_full  ; Yes:
    lda #$00
    rts
.rb_is_full
    lda #$01
    rts

;------------------------------------------------------------------------------
rb_write2:
    phx              ; Save caller's X
    tay              ; Save byte to write
    sec              ; Clear the borrow bit
    lda RB_HEAD      ; Load head index
    sbc RB_TAIL      ; Find number of bytes in the ring buffer.
    sta RESULT
    cmp #RB_MAX      ; Is ring buffer (nearly) full?
    bcs .full        ; Yes: Bail
    ; Write byte to ring buffer.
    tya              ; Get byte to write
    ldx RB_HEAD      ; Load current head index
    sta RB_BASE,x    ; Put byte into ring buffer
    inc RB_HEAD      ; Advance head index
    jmp .done
.full
    ; Ring buffer is full.
    inc RB_FULL_L
    bne .done
    inc RB_FULL_H
.done
    lda RESULT
    plx              ; Restore caller's X
    rts


;------------------------------------------------------------------------------
vectors:
    .org $fffa
    .word $0000     ; Non-maskable Interrupt (not implemented)
    .word reset     ; Reset
    .word $0000     ; Interrupt Request (not implemented)
