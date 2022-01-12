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
    lda #"o"
    sta $02
    lda #"k"
    sta $03
    lda #$00
    sta $04
    jmp spin

fail:
    lda #"f"
    sta $02
    lda #"a"
    sta $03
    lda #"i"
    sta $04
    lda #"l"
    sta $05
    lda #$0
    sta $06

spin:
    jmp spin

    .org $fffc
    .word mem_test   ; Reset vector
    .word $0000      ; ROM image padding
