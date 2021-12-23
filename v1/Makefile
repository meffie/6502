all: rom.bin

HEXDUMP=od -A x -t x1z

dump: rom.bin
	@$(HEXDUMP) rom.bin

burn: rom.bin
	minipro -p AT28C256 -w rom.bin

rom.bin: blink.s
	vasm6502_oldstyle -dotdir -Fbin -o rom.bin blink.s

clean:
	rm -rf rom.bin
