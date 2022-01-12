
TARGET=hello
IMAGE=$(TARGET).bin

all: $(IMAGE)

dump: $(IMAGE)
	@od -A x -t x1z $(IMAGE)

burn: $(IMAGE)
	minipro -p AT28C256 -w $(IMAGE)

%.bin: %.s
	vasm6502_oldstyle -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin
