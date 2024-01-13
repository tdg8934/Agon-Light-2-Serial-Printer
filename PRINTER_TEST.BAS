   10 REM SERIAL SEND EXAMPLE FOR A (TTL SERIAL) MINI THERMAL RECEIPT PRINTER
   20 REM RICHARD TURNNIDGE 2023 - ADAPTED FOR A SERIAL PRINTER BY TIM GILMORE
   21 REM This version is for 16-bit basic but you could adapt
   22 REM Check if we are running in 24-bit BASIC
   24 :
   25 IF HIMEM > &FFFF PRINT "This code will only run on BBC BASIC for Z80": STOP
   30 :
   31 REM ---------------------------------------------------------
   32 REM This is the user assembly code 
   33 REM ---------------------------------------------------------
   36 :
   38 REM allocate plenty of memory spaces for the machine code commands
   39 :
   40 DIM openuart% 64
   50 DIM closeuart% 64
   60 DIM senduart% 64
   70 DIM menu% 512
   80 :
   90 REM This routine is for opening the uart
  100 FOR I%=0 TO 3 STEP 3
  110   P%=openuart%
  120   [
  130   OPT I%
  140   :
  150   LD IX, uartstruct ; Address of the uart struct
  160   ld a, &15
  170   RST &08 ; mos_uopen
  180   RET
  190   .uartstruct
  200   DEFB &00 ; LONG (3 bytes) to store baud rate (19200)
  210   DEFB &4B
  220   DEFB &00
  230   DEFB 8 ; data bits
  240   DEFB 1 ; stop bits
  250   DEFB 0 ; parity bits
  260   DEFB 0 ; flow control
  270   DEFB 0 ; interrupt bits
  280   ]
  290 NEXT
  500 :
  510 REM This routine is to close the uart
  580 FOR I%=0 TO 3 STEP 3
  590   P%=closeuart%
  600   [
  610   OPT I%
  620   :
  630   ld a, &16
  640   RST &08 ; mos_uclose
  650   RET
  660   ]
  670 NEXT
  680 :
  800 REM This routine is to send uart data
  810 FOR I%=0 TO 3 STEP 3
  820   P%=senduart%
  830   [
  840   OPT I%
  850   :
  860   ld c, 65 ; char to send is stored here
  870   ld a, &18
  880   RST &08 ; mos_uputc
  890   RET
  900   ]
  910 NEXT
  920 :
 1000 REM This routine is a try at assembly language - MENU LISTING (Tim)
 1010 FOR I%=0 TO 3 STEP 3
 1020   P%=menu%
 1030   [
 1040   OPT I%
 1100   ld hl, menu_str1
 1110   ld bc, 0
 1120   ld a, 0
 1130   RST &18
 1140   ld hl, 0
 1150   RET
 1210   :
 1220   .menu_str1
 1230   DEFM "(1) Print a message to the printer" : DEFB 13 : DEFB 10
 1240   DEFM "(2) Print and feed (5) lines up" : DEFB 13 : DEFB 10
 1250   DEFM "(3) Select Left, Centering or Right print justification" : DEFB 13 : DEFB 10
 1260   DEFM "(4) Select character size height and width multiplier" : DEFB 13 : DEFB 10
 1270   DEFM "(5) Select (white/black) reverse text printing mode" : DEFB 13 : DEFB 10
 1280   DEFM "(6) Upside-Down text printing mode" : DEFB 13 : DEFB 10
 1290   DEFM "(7) NOT WORKING YET - Select 90 Deg clockwise text printing mode" : DEFB 13 : DEFB 10
 1300   DEFM "(8) Initialize the printer (defaults)" : DEFB 13 : DEFB 10
 1310   DEFM "(9) Print a Selftest page" : DEFB 13 : DEFB 10
 1320   DEFM "(10) Exit the program" : DEFB 13 : DEFB 10
 1330   DEFB 0
 1340   ]
 1350 NEXT
 4999 :
 5000 REM ---------------------------------------------------------
 5010 REM This is the user Basic program - Demo of a serial printer
 5020 REM ---------------------------------------------------------
 5030 A = senduart% +1 : REM this is second byte into the routine, store char to send here
 5040 CALL openuart%
 5050 :
 5100 CLS
 5110 X=USR(menu%)
 5130 J$ = "" : H = 0 : W = 0 : R$ = "" : U$ = "" : CW$ = "" : I$ = ""
 5140 INPUT M
 5150 IF M = 1 THEN GOTO 5500
 5160 IF M = 2 THEN ?A = 27 : CALL senduart% : ?A = 100 : CALL senduart% : ?A = 5 : CALL senduart% : GOTO 5100 : REM Print and line feed up (5) times
 5200 IF M = 3 THEN PRINT "(L)eft, (C)entering, (R)ight print justification: " : INPUT J$ 
 5210 IF M = 3 AND J$ = "L" THEN ?A = 27 : CALL senduart% : ?A = 97 : CALL senduart% : ?A = 48 : CALL senduart% : GOTO 5100
 5220 IF M = 3 AND J$ = "C" THEN ?A = 27 : CALL senduart% : ?A = 97 : CALL senduart% : ?A = 49 : CALL senduart% : GOTO 5100
 5230 IF M = 3 AND J$ = "R" THEN ?A = 27 : CALL senduart% : ?A = 97 : CALL senduart% : ?A = 50 : CALL senduart% : GOTO 5100
 5300 IF M = 4 THEN PRINT "Character height multiplier (0-7): " : INPUT H
 5310 IF M = 4 THEN PRINT "Character width multiplier (0-7): " : INPUT W
 5320 IF M = 4 THEN ?A = 29 : CALL senduart% : ?A = 33 : CALL senduart% : ?A = H : CALL senduart% : REM Set character height multiplier 
 5330 IF M = 4 THEN ?A = 29 : CALL senduart% : ?A = 33 : CALL senduart% : ?A = W*8 : CALL senduart% : GOTO 5100: REM Set character width multiplier 
 5340 IF M = 5 THEN PRINT "Reverse printing? (Y/N) " : INPUT R$
 5350 IF M = 5 AND R$ = "N" THEN ?A = 29 : CALL senduart% : ?A = 66 : CALL senduart% : ?A = 0 : CALL senduart% : GOTO 5100 : REM Normal printing
 5360 IF M = 5 AND R$ = "Y" THEN ?A = 29 : CALL senduart% : ?A = 66 : CALL senduart% : ?A = 1 : CALL senduart% : GOTO 5100 : REM Reverse/Inverse printing
 5370 IF M = 6 THEN PRINT "Upside-Down printing? (Y/N) " : INPUT U$
 5380 IF M = 6 AND U$ = "N" THEN ?A = 27 : CALL senduart% : ?A = 123 : CALL senduart% : ?A = 0 : CALL senduart% : GOTO 5100 : REM Normal printing
 5390 IF M = 6 AND U$ = "Y" THEN ?A = 27 : CALL senduart% : ?A = 123 : CALL senduart% : ?A = 1 : CALL senduart% : GOTO 5100 : REM Upside-Down printing
 5400 IF M = 7 THEN PRINT "90 Deg clockwise rotation printing? (Y/N) " : INPUT CW$
 5410 IF M = 7 AND CW$ = "N" THEN ?A = 27 : CALL senduart% : ?A = 86 : CALL senduart% : ?A = 0 : CALL senduart% : ?A = 48 : CALL senduart% : GOTO 5100 : REM Normal printing
 5420 IF M = 7 AND CW$ = "Y" THEN ?A = 27 : CALL senduart% : ?A = 86 : CALL senduart% : ?A = 1 : CALL senduart% : ?A = 49 : CALL senduart% : GOTO 5100 : REM 90 Deg clockwise rotation printing
 5430 IF M = 8 THEN PRINT "Initialize the printer? (Y/N) " : INPUT I$
 5440 IF M = 8 AND I$ = "N" THEN GOTO 5100 : REM No changes
 5450 IF M = 8 AND I$ = "Y" THEN ?A = 27 : CALL senduart% : ?A = 64 : CALL senduart% : GOTO 5100 : REM Initialize printer to defaults
 5480 IF M = 9 THEN ?A = 18 : CALL senduart% : ?A = 84 : CALL senduart% : GOTO 5100
 5490 IF M = 10 THEN GOTO 5980
 5500 CLS : REM Just to make screen clear
 5510 PRINT "Serial printer uart send example."
 5520 PRINT "There are 32 characters per line."
 5530 PRINT
 5560 INPUT "Type a message to the serial printer: " S$
 5570 FOR S = 1 TO LEN(S$)
 5580   ?A = ASC(MID$(S$,S,1))
 5590   CALL senduart% : REM send the data byte
 5600 NEXT
 5610 ?A = 13
 5620 CALL senduart% : REM Carriage Return
 5630 ?A = 10
 5640 CALL senduart% : REM Line Feed
 5650 GOTO 5100
 5680 :
 5980 CALL closeuart%
 5990 END
