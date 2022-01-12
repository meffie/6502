all: rom.bin

HEXDUMP=od -A x -t x1z

dump: rom.bin
	@$(HEXDUMP) rom.bin

burn: rom.bin
	minipro -p AT28C256 -w rom.bin

rom.bin: makerom
	./makerom

clean:
	rm -rf makerom rom.bin
