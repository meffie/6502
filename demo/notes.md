
Create a blank rom.

    cat /dev/zero | dd of=rom.bin bs=1024 count=32

Create a rom filled with NOPs

    NOP is $ea = 1110 1010 = 11|101|010 = 352 octal

    cat /dev/zero | tr '\000' '\352' | dd of=rom.bin bs=1024 count=32

Burn the rom with minipro:

	minipro -p AT28C256 -w rom.bin

Show reset vector fffc,fffd jump to eaea then pc increments.


Next, simple program, load a value in A, then write to ram.

Create a dump file with xxd that can be edited.

   xxd -g1 rom.bin > rom.dump


   a9 08  <- load hex 8 in the accumulator
   8d 00 02  <- store accumulator in memory address 0x0200

0000:   a9 08 8d 00 02     <-program
fffc:   00 08              <-reset vector

Next, simple count down.

   a2 08  <- load hex 8 in register X
   ca     <- decrement X
          <- jump back if not zero
