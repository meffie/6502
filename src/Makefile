
IMAGE ?= hello

burn: rom

rom: $(IMAGE).rom
	minipro -p AT28C256 -w $(IMAGE).rom

%.rom: %.s
	vasm6502_oldstyle -wdc02 -quiet -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin *.rom

hello.bin: lcd.s
memtest.bin: lcd.s
hex.bin: lcd.s
irq.bin: lcd.s
serial.bin: lcd.s
