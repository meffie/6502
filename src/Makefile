
IMAGE = hello.bin

BINS = \
  hello.bin \
  memtest.bin \
  hex.bin \
  irq.bin

all: $(BINS)

dump: $(IMAGE)
	@od -A x -t x1z $(IMAGE)

burn: $(IMAGE)
	minipro -p AT28C256 -w $(IMAGE)

%.bin: %.s
	vasm6502_oldstyle -dotdir -Fbin -o $@ $<

hello.bin: hello.s lcd.s
memtest.bin: memtest.s lcd.s
hex.bin: hex.s lcd.s
irq.bin: irq.s lcd.s

clean:
	rm -rf *.bin
