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

    .org $8000
title:
    .asciiz "memtest 01/01/2022"
ok_msg:
    .asciiz "Pass"
fail_msg:
    .asciiz "Fail"

reset:
    jsr lcd_setup

mem_test:
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

ok:
    lda #<ok_msg
    ldx #>ok_msg
    jsr lcd_print_string
    jmp spin

fail:
    lda #<fail_msg
    ldx #>fail_msg
    jsr lcd_print_string

spin:
    jmp spin

    .include lcd.s

    .org $fffc
    .word reset      ; Reset vector
    .word $0000      ; ROM image padding
