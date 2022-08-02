
See Garth Wilson's [address decoding](http://wilsonminesco.com/6502primer/addr_decoding.html)
for general background and design info.

Memory Map
----------

    Address lines A15-A0   Address range   Device
    ====================   =============   =======
    00xx xxxx xxxx xxxx    $0000 - $3fff   RAM - 16K used out of 32K
    010x xxxx xxxx xxxx    $4000 - $5fff   Reserved
    011x xxxx xxxx yyyy    $6000 - $7fff   I/O - 6522 VIA, 16 registers
    1xxx xxxx xxxx xxxx    $8000 - $ffff   ROM - 32K

    x = may be 0 or 1
    y = 6522 register selection, 16 bytes

6522 VIA Registers
--------------

    $6000  ORB/IRB Output Register "B" Input Register "B"
    $6001  ORA/IRA Output Register "A" Input Register "A"
    $6002  DDRB Data Direction Register "B"
    $6003  DDRA Data Direction Register "A"
    ...
    $600C  PCR Peripheral Control Register
    $600D  IFR Interrupt Flag Register
    $600E  IER Interrupt Enable Register


Address decoding logic
----------------------

    +----------------------+-------+-----------+-----------+
    |                      |  ROM  |    RAM    |    VIA    |
    |  A15  A14  A13  CLK  |  CSB  |  CSB OEB  | CS2B  CS1 |
    +----------------------+-------+-----------+-----------+
    |   0    0    0    0   |   1   |   1   0   |   1   0   |
    |   0    0    0    1   |   1   |   0   0 * |   1   0   |
    |   0    0    1    0   |   1   |   1   0   |   1   1   |
    |   0    0    1    1   |   1   |   0   0 * |   1   1   |
    |   0    1    0    0   |   1   |   1   1   |   0   0   |
    |   0    1    0    1   |   1   |   0   1   |   0   0   |
    |   0    1    1    0   |   1   |   1   1   |   0   1 * |
    |   0    1    1    1   |   1   |   0   1   |   0   1 * |
    |   1    0    0    0   |   0 * |   1   0   |   1   0   |
    |   1    0    0    1   |   0 * |   1   0   |   1   0   |
    |   1    0    1    0   |   0 * |   1   0   |   1   1   |
    |   1    0    1    1   |   0 * |   1   0   |   1   1   |
    |   1    1    0    0   |   0 * |   1   0   |   1   0   |
    |   1    1    0    1   |   0 * |   1   0   |   1   0   |
    |   1    1    1    0   |   0 * |   1   0   |   1   1   |
    |   1    1    1    1   |   0 * |   1   0   |   1   1   |
    +----------------------+-------+-----------+-----------+


![address decode circuit](../images/addr-decode.png?raw=true "Address decode circuit")
