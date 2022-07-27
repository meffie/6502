
IMAGE = demo0
BINS := $(patsubst %.s,%.bin,$(wildcard demo*.s))

all: $(BINS)

burn: $(IMAGE).bin
	minipro -p AT28C256 -w $(IMAGE).bin

%.bin: %.s
	vasm6502_oldstyle -quiet -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin
