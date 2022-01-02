
TARGET=hello
IMAGE=$(TARGET).bin

all: $(IMAGE)

dump: $(IMAGE)
	@od -A x -t x1z $(IMAGE)

burn: $(IMAGE)
	minipro -p AT28C256 -w $(IMAGE)

hello.bin: hello.s lcd.s
	vasm6502_oldstyle -dotdir -Fbin -o hello.bin hello.s

memtest.bin: memtest.s lcd.s
	vasm6502_oldstyle -dotdir -Fbin -o memtest.bin memtest.s

clean:
	rm -rf *.bin
