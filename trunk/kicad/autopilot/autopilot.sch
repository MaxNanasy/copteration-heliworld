EESchema Schematic File Version 2
LIBS:power,/home/max-nanasy/src/copteration-heliworld/trunk/kicad/autopilot,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,dsp,microchip,analog_switches,motorola,texas,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,valves,./autopilot.cache
EELAYER 24  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "25 mar 2009"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Kmarq B 3950 3450 "Warning Pin passive Unconnected" F=1
Kmarq B 1350 1400 "Warning Pin input Unconnected" F=1
Kmarq B 1350 1600 "Warning Pin input Unconnected" F=1
Kmarq B 3050 1200 "Warning Pin input Unconnected" F=1
Kmarq B 3050 1400 "Warning Pin input Unconnected" F=1
Kmarq B 3050 2000 "Warning Pin power_in Unconnected" F=1
Kmarq B 3050 2200 "Warning Pin power_in Unconnected" F=1
Kmarq B 1100 4850 "Warning Pin output Unconnected" F=1
Kmarq B 1100 5050 "Warning Pin input Unconnected" F=1
Kmarq B 1100 5250 "Warning Pin input Unconnected" F=1
Kmarq B 1100 5450 "Warning Pin power_in Unconnected" F=1
Kmarq B 1100 5650 "Warning Pin input Unconnected" F=1
Kmarq B 1100 5850 "Warning Pin input Unconnected" F=1
Kmarq B 1100 6050 "Warning Pin output Unconnected" F=1
Kmarq B 2300 4850 "Warning Pin output Unconnected" F=1
Kmarq B 2300 5050 "Warning Pin input Unconnected" F=1
Kmarq B 2300 5250 "Warning Pin input Unconnected" F=1
Kmarq B 2300 5450 "Warning Pin power_in Unconnected" F=1
Kmarq B 2300 5650 "Warning Pin input Unconnected" F=1
Kmarq B 2300 5850 "Warning Pin input Unconnected" F=1
Kmarq B 2300 6050 "Warning Pin output Unconnected" F=1
NoConn ~ 1350 2800
NoConn ~ 1350 2200
NoConn ~ 1350 2000
NoConn ~ 1350 1800
NoConn ~ 3050 1600
NoConn ~ 3050 1800
NoConn ~ 3050 3000
NoConn ~ 3050 2400
NoConn ~ 3050 3200
NoConn ~ 1350 1000
NoConn ~ 3050 1000
NoConn ~ 3050 2800
Wire Wire Line
	3550 4150 950  4150
Wire Wire Line
	950  4150 950  1200
Wire Wire Line
	950  1200 1350 1200
Wire Wire Line
	4050 4150 4450 4150
Wire Wire Line
	4450 4150 4450 3450
NoConn ~ 1550 1000
NoConn ~ 3050 2600
NoConn ~ 1350 3200
NoConn ~ 1350 3000
NoConn ~ 1350 2600
NoConn ~ 1350 2400
$Comp
L NTE859 U1
U 1 1 49C9DFFD
P 1700 5450
F 0 "U1" H 1700 6250 60  0001 C C
F 1 "NTE859" H 1700 4650 60  0000 C C
	1    1700 5450
	1    0    0    -1  
$EndComp
$Comp
L IMU U2
U 1 1 49C9DF7C
P 2200 2100
F 0 "U2" H 2200 3400 60  0001 C C
F 1 "IMU" H 2200 800 60  0000 C C
	1    2200 2100
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 49C9DD36
P 4200 3450
F 0 "R2" V 4280 3450 50  0000 C C
F 1 "20k" V 4200 3450 50  0000 C C
	1    4200 3450
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 49C9DD8B
P 3800 4150
F 0 "R1" V 3880 4150 50  0000 C C
F 1 "15k" V 3800 4150 50  0000 C C
	1    3800 4150
	0    1    1    0   
$EndComp
$EndSCHEMATC
