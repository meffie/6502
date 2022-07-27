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
   4c 05 80  <- jump to no op (spin)

   a9088d0002ea4c0580    <-program

Edit method:

Create a dump file with xxd that can be edited, edit
the dump, and revert back to binary.

   xxd rom.bin > rom.dump

   vi rom.dump
   0000:   a908 8d00 02ea ea4c 0580    <-program
   7ffc:   0080                        <-reset vector

   xxd -r rom.dump rom.bin
   minipro -p AT28C256 -w rom.bin

Patch method:

If the output is a file (not stdout), xxd will patch it.

    cat /dev/zero | dd of=rom.bin bs=1024 count=32
    echo a9088d0002ea4c0580 | xxd -r -p - rom.bin
    echo 0080 | xxd -r -p -s 0x7ffc - rom.bin


Part 1b: Proof of concept assembler
===================================

Converting by hand is hard and error prone.  What if we made
a program to convert text to the machine code?

    ;
    ; Proof of concept assembler source.
    ;
    
    start:           ; start label
        lda 08       ; load a value in the accumulator
        sta 0200     ; write the value to a memory location
    
    loop:
        nop          ; delay
        jmp loop     ; loop forever
    

    #!/bin/bash
    # Proof of concept assembler.
    sed 's/;.*//' |
    sed 's/  *$//' |
    grep -v '^$' |
    while read op arg; do
        case $op in
        lda) echo -n "a9${arg}" ;;
        sta) echo -n "8d${arg:2:2}${arg:0:2}" ;;
        nop) echo -n "ea" ;;
        jmp) echo -n "4c0000" ;;
        *) ;;
        esac
    done
    echo ""

    cat poc.s | ./pasm.sh
    a9088d0002ea4c0000
                  ^^^^ todo

To convert this to machine code:

    cat /dev/zero | dd of=rom.bin bs=1024 count=32
    cat poc.s | ./poc-asm.sh | xxd -r -p - rom.bin
    echo 0080 | xxd -r -p -s 0x7ffc - rom.bin

This assember runs on the "host" and generates op codes for the "target".  What
if the input program was an implementation for an assembler? Then we would could
self-host.

Part 2: Assembler
=================

We will use the vasm assembler to create the rom.

demos

0. convert our machine code to assembly
1. turn on a led on port b
2. connect 7 segment display to port b
3. display numbers on 7 segment
4. use interrupts to read port a
5. read toggle switches on port a, write output on port b
