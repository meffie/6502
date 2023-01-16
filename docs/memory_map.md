The BE6502 design priorities simplicity over efficiency.  The design requires
only three nand gates to implement.  As a trade off, only 16K of the 32K memory
provided by the 62256 chip is available for use, and a large chunk of the
memory map is used to access only 16 registers of the 65C22 VIA.

All of the 32K of the ROM is available, which is probably far more than is
needed for this computer.  The ROM is located on the bottom half of the memory
map so the reset vector is available in ROM on power up.

Garth Wilson's [address decoding](http://wilsonminesco.com/6502primer/addr_decoding.html) document is
an invaluable resource for learning more about 6502 address decoding design.

Memory Map
----------

    Address         Map   Device       Comments
    =============   ===   ==========   ================
    $0000 - $3fff   RAM   62256 SRAM   16K used out of 32K
    $4000 - $5fff   -     -            Reserved for future use
    $6000 - $7fff   I/O   65C22 VIA    16 registers
    $8000 - $ffff   ROM   AT28C256     32K EEPROM

Address Decoding Logic
----------------------

    +------------------+-------+-----------+-----------+----------+
    |                  |  ROM  |    RAM    |    VIA    | Selected |
    |  A15  A14  A13   |  /CS  |  /CS /OE  | /CS2 CS1  |          |
    +------------------+-------+-----------+-----------+----------+
    |   0    0    0    |   1   |   0   0   |   1   0   |   RAM    |
    |   0    0    1    |   1   |   0   0   |   1   1   |   RAM    |
    |   0    1    0    |   1   |   0   1   |   0   0   |          |
    |   0    1    1    |   1   |   0   1   |   0   1   |   VIA    |
    |   1    0    0    |   0   |   1   0   |   1   0   |   ROM    |
    |   1    0    1    |   0   |   1   0   |   1   1   |   ROM    |
    |   1    1    0    |   0   |   1   0   |   1   0   |   ROM    |
    |   1    1    1    |   0   |   1   0   |   1   1   |   ROM    |
    +------------------+-------+-----------+-----------+----------+

ROM is selected when /CS is low.

    /CS = not(A15)

RAM is selected when /CS is low and /OE is low.
/CS is tied to clock for proper timing.

    /CS = nand(not(A15), CLK)
    /OE = A14

VIA is selected when CS1 is high and /CS2 is low.

    CS1 = A13
    /CS2 = nand(A14, not(A15))


![address decode circuit](../images/addr-decode.png?raw=true "Address decode circuit")


6522 VIA Registers
------------------

The 65C22 VIA is enabled when the address lines are the range $6000 to $7fff,
however only the bottom four address lines (A0 to A3) are connected to the
register selection pins.  The registers could be selected when the address bits
are in that range, but as a convention the registers are only accessed when in
the address range $6000 to $600E.

    $6000  ORB/IRB Output Register "B" Input Register "B"
    $6001  ORA/IRA Output Register "A" Input Register "A"
    $6002  DDRB Data Direction Register "B"
    $6003  DDRA Data Direction Register "A"
    ...    (not used)
    $600C  PCR Peripheral Control Register
    $600D  IFR Interrupt Flag Register
    $600E  IER Interrupt Enable Register
