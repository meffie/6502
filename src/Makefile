
IMAGE ?= hello

burn: rom

rom: $(IMAGE).rom
	minipro -p AT28C256 -w $(IMAGE).rom

%.rom: %.s
	vasm6502_oldstyle -wdc02 -quiet -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin *.rom

hello.bin: lcd.inc
memtest.bin: lcd.inc
hex.bin: lcd.inc
irq.bin: lcd.inc
serial.bin: lcd.inc
