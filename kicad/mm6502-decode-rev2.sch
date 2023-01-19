EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "MM6502"
Date "2023-01-18"
Rev "1"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HC00 U5
U 1 1 63C280F7
P 5400 4300
F 0 "U5" H 5400 4300 50  0000 C CNN
F 1 "74HC00" H 5450 4100 50  0000 C CNN
F 2 "" H 5400 4300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 5400 4300 50  0001 C CNN
	1    5400 4300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U5
U 2 1 63C29299
P 5400 4900
F 0 "U5" H 5400 4900 50  0000 C CNN
F 1 "74HC00" H 5400 4700 50  0000 C CNN
F 2 "" H 5400 4900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 5400 4900 50  0001 C CNN
	2    5400 4900
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U5
U 3 1 63C29F59
P 5400 3500
F 0 "U5" H 5400 3500 50  0000 C CNN
F 1 "74HC00" H 5400 3300 50  0000 C CNN
F 2 "" H 5400 3500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 5400 3500 50  0001 C CNN
	3    5400 3500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U5
U 4 1 63C2BB7E
P 4550 3000
F 0 "U5" H 4550 3000 50  0000 C CNN
F 1 "74HC00" H 4550 2750 50  0000 C CNN
F 2 "" H 4550 3000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 4550 3000 50  0001 C CNN
	4    4550 3000
	1    0    0    -1  
$EndComp
Text GLabel 4000 3000 0    50   Input ~ 0
A15
Text GLabel 4000 3350 0    50   Input ~ 0
A14
Text GLabel 4000 3900 0    50   Input ~ 0
A13
Text GLabel 4000 2550 0    50   Input ~ 0
CLK
Wire Wire Line
	4250 2900 4250 3000
Wire Wire Line
	4000 3000 4250 3000
Connection ~ 4250 3000
Wire Wire Line
	4250 3000 4250 3100
Wire Wire Line
	4850 3000 4850 3600
Wire Wire Line
	4850 4200 5100 4200
Wire Wire Line
	5100 3600 4850 3600
Connection ~ 4850 3600
Wire Wire Line
	4850 3600 4850 4200
Wire Wire Line
	4000 2550 5100 2550
Wire Wire Line
	5100 2550 5100 3400
Wire Wire Line
	5100 4400 4650 4400
Wire Wire Line
	4650 4400 4650 3750
Wire Wire Line
	4650 3350 4000 3350
Text GLabel 5900 3000 2    50   Output ~ 0
ROMCSB
Text GLabel 5900 3500 2    50   Output ~ 0
RAMCEB
Text GLabel 5900 3750 2    50   Output ~ 0
RAMOEB
Text GLabel 5900 4100 2    50   Output ~ 0
VIACS1
Text GLabel 5900 4300 2    50   Output ~ 0
VIACS2B
Wire Wire Line
	4850 3000 5900 3000
Connection ~ 4850 3000
Wire Wire Line
	5700 3500 5900 3500
Wire Wire Line
	5900 3750 4650 3750
Connection ~ 4650 3750
Wire Wire Line
	4650 3750 4650 3350
Wire Wire Line
	5800 3900 5800 4100
Wire Wire Line
	5800 4100 5900 4100
Wire Wire Line
	5700 4300 5800 4300
Wire Wire Line
	4000 3900 4500 3900
Wire Wire Line
	5100 4800 5100 4900
Wire Wire Line
	5100 4900 4500 4900
Wire Wire Line
	4500 4900 4500 3900
Connection ~ 5100 4900
Wire Wire Line
	5100 4900 5100 5000
Connection ~ 4500 3900
Wire Wire Line
	4500 3900 5800 3900
Text GLabel 5900 4900 2    50   Output ~ 0
ACIACS1
Wire Wire Line
	5900 4900 5700 4900
Text GLabel 5900 4700 2    50   Output ~ 0
ACIACS2B
Connection ~ 5800 4300
Wire Wire Line
	5800 4300 5900 4300
Wire Wire Line
	5800 4700 5900 4700
Wire Wire Line
	5800 4300 5800 4700
$EndSCHEMATC
