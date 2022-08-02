
See Garth Wilson's [address decoding](http://wilsonminesco.com/6502primer/addr_decoding.html)
for general background and design info.



Memory Map

    Adress lines A15-A0    Address range   Device
    ====================   =============   =======
    00xx xxxx  xxxx xxxx   $0000 - $3fff   RAM - 16K addressable
    010x xxxx  xxxx xxxx   $4000 - $5fff   Reserved
    011x xxxx  xxxx yyyy   $6000 - $7fff   I/O - 6522 VIA, 16 registers
    1xxx xxxx  xxxx xxxx   $8000 - $ffff   ROM - 32K

    x = dont care
    y = 6522 register selection

6522 Registers

    $00  ORB/IRB Output Register "B" Input Register "B"
    $01  ORA/IRA Output Register "A" Input Register "A"
    $02  DDRB Data Direction Register "B"
    $03  DDRA Data Direction Register "A"
    ...
    $0C  PCR Peripheral Control Register
    $0D  IFR Interrupt Flag Register
    $0E  IER Interrupt Enable Register
