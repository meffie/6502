# 6502 Breadboard Computer

![6502](images/6502.jpg?raw=true "6502 breadboard")

This is my notes and code for a 6502 breadboard computer built from [Ben Eater's
6502 kit](https://eater.net/6502).

The BE6502 design prioritizes simplicity. The address decoding is implemented
with only three NAND gates. However, only 16K out of the the 32K provided by the
static RAM chip is accessible. Also, largish chunk of the memory map is
allocated for I/O, but the 65C22 VIA has only 16 registers The full 32K of the
ROM is available, which is probably far more than is needed for this computer.
The ROM is located on the bottom half of the memory map so the reset vector is
available in ROM on power up.

Garth Wilson's [address decoding](http://wilsonminesco.com/6502primer/addr_decoding.html) document is
an invaluable resource for learning more about 6502 address decoding design.

Changes from BE6502:

* Power-on Reset Circuit
* RS-232 Interface (in-progress)

Parts List
----------

<table>
  <thead>
    <tr>
      <th>Id</th>
      <th>Part number</th>
      <th>Description</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>U1</td>
      <td>WDC65C02S</td>
      <td>6502 Microprocessor (CMOS)</td>
      <td></td>
    </tr>
    <tr>
      <td>U2</td>
      <td>AT28C265</td>
      <td>32K x 8 EEPROM</td>
      <td></td>
    </tr>
    <tr>
      <td>U3</td>
      <td>HM65256B</td>
      <td>32K x 8 Static RAM</td>
      <td></td>
    </tr>
    <tr>
      <td>U4</td>
      <td>W65C22</td>
      <td>Versatile Interface Adapter (VIA)</td>
      <td></td>
    </tr>
    <tr>
      <td>U5</td>
      <td>74HC00</td>
      <td>Quad 2-Input NAND gate</td>
      <td></td>
    </tr>
    <tr>
      <td>C1</td>
      <td>OSC1</td>
      <td>1 MHz clock oscillator</td>
      <td></td>
    </tr>
  </tbody>
</table>

Memory Map
----------

<table>
  <thead>
    <tr>
      <th>Address</th>
      <th>Region</th>
      <th>Device</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>$0000 - $3fff</td>
      <td>RAM</td>
      <td>62256 SRAM</td>
      <td>16K used out of 32K</td>
    </tr>
    <tr>
      <td>$4000 - $5fff</td>
      <td>-</td>
      <td>-</td>
      <td>Reserved for future use.</td>
    </tr>
    <tr>
      <td>$6000 - $7fff</td>
      <td>I/O</td>
      <td>65C22 VIA</td>
      <td>16 registers</td>
    </tr>
    <tr>
      <td>$8000 - $ffff</td>
      <td>ROM</td>
      <td>AT28C256</td>
      <td>32K EEPROM</td>
    </tr>
  </tbody>
</table>

Address Decoding Logic
----------------------

The following logic table shows the address decoding logic combinations.

<table>
  <thead>
    <tr>
      <th colspan=4>Address pins</th>
      <th colspan=2>ROM</th>
      <th colspan=3>RAM</th>
      <th colspan=3>VIA</th>
      <th colspan=2>Selected</th>
    </tr>
    <tr>
      <th>A15</th>
      <th>A14</th>
      <th>A13</th>
      <th></th>
      <th>/CS</th>
      <th></th>
      <th>/CS</th>
      <th>/OE</th>
      <th></th>
      <th>CS1</th>
      <th>/CS2</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>RAM</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>RAM</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>Not used</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>1</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>VIA</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'></td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'></td>
      <td align='center'>ROM</td>
    </tr>
  </tbody>
</table>

ROM is selected when /CS is low.

    /CS = not(A15)

RAM is selected when /CS is low and /OE is low.
/CS is tied to the clock signal to ensure the data lines are quiescent
before the RAM is selected.

    /CS = nand(not(A15), CLK)
    /OE = A14

VIA is selected when CS1 is high and /CS2 is low.

    CS1 = A13
    /CS2 = nand(A14, not(A15))

![address decode circuit](images/addr-decode.png?raw=true "Address decode circuit")

6522 VIA Registers
------------------

The 65C22 VIA is enabled when the address lines are the range $6000 to $7fff,
however only the bottom four address lines (A0 to A3) are connected to the
register selection pins.  The registers could be selected when the address bits
are in that range, but as a convention the registers are only accessed when in
the address range $6000 to $600E.

<table>
  <tr>
    <td>$6000</td>
    <td>ORB/IRB Output Register "B" Input Register "B"</td>
  </tr>
  <tr>
    <td>$6001</td>
    <td>ORA/IRA Output Register "A" Input Register "A"</td>
  </tr>
  <tr>
    <td>$6002</td>
    <td>DDRB Data Direction Register "B"</td>
  </tr>
  <tr>
    <td>$6003</td>
    <td>DDRA Data Direction Register "A"</td>
  </tr>
  <tr>
    <td>$6004 - $600B</td>
    <td>Not used</td>
  <tr>
    <td>$600C</td>
    <td>PCR Peripheral Control Register</td>
  </tr>
  <tr>
    <td>$600D</td>
    <td>IFR Interrupt Flag Register</td>
  </tr>
  <tr>
    <td>$600E</td>
    <td>IER Interrupt Enable Register</td>
  </tr>
</table>

Power-on Reset Circuit
----------------------

TODO
