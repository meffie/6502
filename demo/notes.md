Part 1: Machine code
====================

Create a blank rom.

    cat /dev/zero | dd of=rom.bin bs=1024 count=32

Create a rom filled with NOPs

    NOP is $ea = 1110 1010 = 11|101|010 = 352 octal

    cat /dev/zero | tr '\000' '\352' | dd of=rom.bin bs=1024 count=32

Burn the rom with minipro:

	minipro -p AT28C256 -w rom.bin

Show reset vector fffc,fffd jump to eaea then pc increments.

Next, here's simple program, load a value in A, then write to ram.

   a9 08     <- load hex 8 in the accumulator
   8d 00 02  <- store accumulator in memory address 0x0200
   ea        <- no op
   ea        <- no op
   4c 05 80  <- jmp to no op (spin)

   a908 8d00 02ea ea4c 0580    <-program

Create a dump file with xxd that can be edited.

   xxd rom.bin > rom.dump

   vi rom.dump
   0000:   a908 8d00 02ea ea4c 0580    <-program

   fffc:   0080                        <-reset vector

   xxd -r rom.dump rom.bin
   minipro -p AT28C256 -w rom.bin


Part 2: Assembler
=================

We will use the vasm assembler to create the rom.

    .org $8000    ; start of ROM

start:
    lda #$08      ; read a byte
    sta $0200     ; write a byte
    jmp start

    .org $fffc    ; reset vector
    .word start   ; jump to start on reset
    .word $0000   ; padding so image is 32k

