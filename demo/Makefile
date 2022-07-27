
IMAGE = blink
BINS = \
  blink.bin \
  7seg1.bin

all: $(BINS)

burn: $(IMAGE).bin
	minipro -p AT28C256 -w $(IMAGE).bin

%.bin: %.s
	vasm6502_oldstyle -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin
