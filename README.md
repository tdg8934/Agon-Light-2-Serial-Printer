# Agon-Light-2-Serial-Printer
Mini Thermal Receipt Printer (Serial RxD) to Agon Light / Agon Light 2 computer using Agon UART send code by Richard Turnnidge 

Many thanks to Richard Turnnidge for his Agon UART send Assembly Basic code. From this I was able communicate with a 3.3v - 5v tolerant Mini Thermal Receipt Printer (serial Rx / Tx) that used to be sold by Adafruit but was discontinued along with its starter pack (printer, thermal paper, power supply, connector/ wires) . However I found a company Electromaker that still carries it and it is pretty quick in delivering via UPS for about $80 total. 
Using Richard’s code, I was able to get it working within a few hours. Richard’s code is set up for 9600 baud through 3 long bytes in little endian format. Those bytes were changed to &00 &4B &00 for 19200 baud. The older printers were 9600 baud but I received a newer one at 19200 baud. 
Other than that it was just writing simple example code to print a self test page as well as send a message you input to the serial printer. 
In the printer manual, arduino/ pi drivers there are a ton of settings that can be made. You can also print high resolution graphics and bar codes and more.

Richard has created a program listing MOSlet for the printer you can see on his GitHub site: https://github.com/richardturnnidge/LLIST
There are 2 parameter settings depending if the user has a 9600 baud (default) or 19200 baud Mini Thermal Receipt Printer. Read the documentation. 

Mini Thermal Receipt Printer (starter pack):
https://www.electromaker.io/shop/product/mini-thermal-receipt-printer-starter-pack?gad_source=1&gclid=CjwKCAiAs6-sBhBmEiwA1Nl8s7WgNRFRTTuOfL7HAStYqrdWFSnN6erERbzFKS4c0n1K96QgKvtWvBoCSMcQAvD_BwE&fbclid=IwAR1idm1_4siQWm0Y45-V9CAQrlBODqR9aeuo2CbUDOYcwm7sUF5E42Qa6lA

Printer hookup guide (Arduino / Pi drivers and code):
https://learn.adafruit.com/mini-thermal-receipt-printer/

Printer manual:
https://cdn-shop.adafruit.com/datasheets/CSN-A2%20User%20Manual.pdf?fbclid=IwAR1idm1_4siQWm0Y45-V9CAQrlBODqR9aeuo2CbUDOYcwm7sUF5E42Qa6lA
