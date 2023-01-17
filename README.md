# 6502 Breadboard Computer

![6502](images/6502.jpg?raw=true "6502 breadboard")

This is my notes and code for a 6502 breadboard computer built from [Ben Eater's
6502 kit](https://eater.net/6502).


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
      <td>6502 Microprocessor, CMOS</td>
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
      <th colspan=2>Address (hex)</th>
      <th>Region</th>
      <th>Device</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>$0000</td><td>$3fff</td>
      <td>RAM</td>
      <td>62256 SRAM</td>
      <td>Only 16K used out of 32K available.</td>
    </tr>
    <tr>
      <td>$4000</td><td>$5fff</td>
      <td>-</td>
      <td>-</td>
      <td>Reserved for future use.</td>
    </tr>
    <tr>
      <td>$6000</td><td>$7fff</td>
      <td>I/O</td>
      <td>65C22 VIA</td>
      <td>16 Registers, 2 8-bit I/O ports</td>
    </tr>
    <tr>
      <td>$8000</td><td>$ffff</td>
      <td>ROM</td>
      <td>AT28C256 EEPROM</td>
      <td>32K x 8 EEPROM</td>
    </tr>
  </tbody>
</table>

Address Decoding Logic
----------------------

See Garth Wilson's [address decoding
document](http://wilsonminesco.com/6502primer/addr_decoding.html) to learn about
6502 address decoding design.

The BE6502 design prioritizes simplicity over functionality. The address
decoding is implemented using a single quad-NAND gate. However, the trade off
for this simplicity is lack of efficiency. Only 16K of RAM is accessible, even
though the HM65256B provides 32K, and 2k of the memory map is allocated for I/O,
but the 65C22 VIA has only 16 addressable registers.

The full 32K of the ROM is available, which is probably far more than is needed
for this computer.  The ROM is located on the bottom half of the memory map so
the reset vector is available in ROM on power up.

A more sophisticated address decoding scheme would make better use of the
resources, but at a cost of increased complexity and chip count.

The following describes the BE6502 decoding logic:

The ROM is selected when ROM /CS is low. The ROM /CS pin is set low when the A15
address line is high, so the ROM is selected in the 32K address range
$8000 to $ffff.

The RAM is selected when the RAM /CS and /OE are both low. The RAM /CS pin is
set low when the A15 address line is low, and the RAM /OE pin is set low when
the A14 address line is low, so the RAM is selected in the 16k address range
$0000 to $3fff.  In addition, the RAM /CS is tied to the clock signal to ensure
the address and data lines are quiescent before the RAM is selected. This helps
to prevent writing garbage to RAM memory. The RAM /CS will be set low only when
A15 is low and the clock is high.

The VIA is selected when the VIA CS1 is high and VIA /CS2 is low. The CS1 pin is
set to high when the A13 line is high and the /CS2 pin is set to low when the
A15 line is low and the A14 line is high, so the VIA is selected in when the
address lines are set to any address in the range of $6000 to $7fff (8k).

![address decode circuit](images/addr-decode.png?raw=true "Address decode circuit")

The following logic table shows the address decoding logic combinations.

<table>
  <thead>
    <tr>
      <th colspan=3>Address pins</th>
      <th colspan=1>Clock</th>
      <th colspan=1>ROM</th>
      <th colspan=2>RAM</th>
      <th colspan=2>VIA</th>
      <th colspan=1>Selected</th>
    </tr>
    <tr>
      <th>A15</th>
      <th>A14</th>
      <th>A13</th>
      <th>CLK</th>
      <th>/CS</th>
      <th>/CS</th>
      <th>/OE</th>
      <th>CS1</th>
      <th>/CS2</th>
      <th> </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>RAM</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>RAM</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>x</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>Not used</td>
    </tr>
    <tr>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>x</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center' bgcolor='#ccc;'>1</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>VIA</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>x</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>x</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>x</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>ROM</td>
    </tr>
    <tr>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>x</td>
      <td align='center' bgcolor='#ccc;'>0</td>
      <td align='center'>1</td>
      <td align='center'>0</td>
      <td align='center'>1</td>
      <td align='center'>1</td>
      <td align='center'>ROM</td>
    </tr>
  </tbody>
</table>


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
    <td>$6004 - $600b</td>
    <td>Not used</td>
  <tr>
    <td>$600c</td>
    <td>PCR Peripheral Control Register</td>
  </tr>
  <tr>
    <td>$600d</td>
    <td>IFR Interrupt Flag Register</td>
  </tr>
  <tr>
    <td>$600e</td>
    <td>IER Interrupt Enable Register</td>
  </tr>
  <tr>
    <td>$600f</td>
    <td>Not used.</td>
  </tr>
  <tr>
    <td>$6010 - $7fff</td>
    <td>Reserved.</td>
  </td>
</table>
