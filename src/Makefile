
IMAGE ?= hello

burn: rom

rom: $(IMAGE).bin
	minipro -p AT28C256 -w $(IMAGE).bin

%.bin: %.s
	vasm6502_oldstyle -wdc02 -quiet -dotdir -Fbin -o $@ $<

clean:
	rm -rf *.bin

hello.bin: lcd.s
memtest.bin: lcd.s
hex.bin: lcd.s
irq.bin: lcd.s
serial.bin: lcd.s
