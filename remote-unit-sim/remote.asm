
_main:

;remote.c,23 :: 		void main() {
;remote.c,25 :: 		long unsigned int analogval =0;
	CLRF       main_analogval_L0+0
	CLRF       main_analogval_L0+1
	CLRF       main_analogval_L0+2
	CLRF       main_analogval_L0+3
;remote.c,27 :: 		init();  //initialise hardware
	CALL       _init+0
;remote.c,29 :: 		while(1)
L_main0:
;remote.c,32 :: 		Delay_ms(100);
	MOVLW      130
	MOVWF      R12
	MOVLW      221
	MOVWF      R13
L_main2:
	DECFSZ     R13, 1
	GOTO       L_main2
	DECFSZ     R12, 1
	GOTO       L_main2
	NOP
	NOP
;remote.c,34 :: 		analogval = wlevel;    //simulate read value from sensor
	MOVF       _wlevel+0, 0
	MOVWF      main_analogval_L0+0
	MOVF       _wlevel+1, 0
	MOVWF      main_analogval_L0+1
	CLRF       main_analogval_L0+2
	CLRF       main_analogval_L0+3
;remote.c,35 :: 		if(TMR1H > 200)        //add a little random variation
	MOVF       TMR1H+0, 0
	SUBLW      200
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;remote.c,37 :: 		analogval++;
	MOVLW      1
	ADDWF      main_analogval_L0+0, 1
	MOVLW      0
	ADDWFC     main_analogval_L0+1, 1
	ADDWFC     main_analogval_L0+2, 1
	ADDWFC     main_analogval_L0+3, 1
;remote.c,38 :: 		}
	GOTO       L_main4
L_main3:
;remote.c,39 :: 		else if(TMR1H < 90)
	MOVLW      90
	SUBWF      TMR1H+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main5
;remote.c,41 :: 		analogval--;
	MOVLW      1
	SUBWF      main_analogval_L0+0, 1
	MOVLW      0
	SUBWFB     main_analogval_L0+1, 1
	SUBWFB     main_analogval_L0+2, 1
	SUBWFB     main_analogval_L0+3, 1
;remote.c,42 :: 		}
L_main5:
L_main4:
;remote.c,43 :: 		processrequest(analogval);   //perform behaviour requested by command from master if recieved
	MOVF       main_analogval_L0+0, 0
	MOVWF      FARG_processrequest_analogval+0
	MOVF       main_analogval_L0+1, 0
	MOVWF      FARG_processrequest_analogval+1
	CALL       _processrequest+0
;remote.c,44 :: 		asm CLRWDT;          // clear the watchdog timer
	CLRWDT
;remote.c,45 :: 		}
	GOTO       L_main0
;remote.c,46 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:

;remote.c,48 :: 		void interrupt()
;remote.c,53 :: 		if(PIR1.RCIF)          //if charachter recieved
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt6
;remote.c,55 :: 		inchr = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      interrupt_inchr_L0+0
;remote.c,57 :: 		if(inchr != 10)       //if char is not a linefeed then write into buffer
	MOVF       interrupt_inchr_L0+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
;remote.c,59 :: 		inbuf[bufpointer] = inchr;
	MOVLW      _inbuf+0
	MOVWF      FSR1L
	MOVLW      hi_addr(_inbuf+0)
	MOVWF      FSR1H
	MOVF       _bufpointer+0, 0
	ADDWF      FSR1L, 1
	BTFSC      STATUS+0, 0
	INCF       FSR1H, 1
	MOVF       interrupt_inchr_L0+0, 0
	MOVWF      INDF1+0
;remote.c,60 :: 		bufpointer ++;
	INCF       _bufpointer+0, 1
;remote.c,61 :: 		if(bufpointer > 9)
	MOVF       _bufpointer+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt8
;remote.c,63 :: 		bufpointer = 9;
	MOVLW      9
	MOVWF      _bufpointer+0
;remote.c,64 :: 		}
L_interrupt8:
;remote.c,65 :: 		}
	GOTO       L_interrupt9
L_interrupt7:
;remote.c,68 :: 		if(inbuf[0] == 't')     //if moisture level requeted
	MOVF       _inbuf+0, 0
	XORLW      116
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt10
;remote.c,69 :: 		datarequested = 2;    //set transmit moisture level action flag
	MOVLW      2
	MOVWF      _datarequested+0
	GOTO       L_interrupt11
L_interrupt10:
;remote.c,70 :: 		else if(inbuf[0] == 'w')   //if watering commanded
	MOVF       _inbuf+0, 0
	XORLW      119
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt12
;remote.c,72 :: 		strncpy(&procbuf,&inbuf[1],strlen(inbuf) ); //copy all except first char to procbuf
	MOVLW      _inbuf+0
	MOVWF      FARG_strlen_s+0
	MOVLW      hi_addr(_inbuf+0)
	MOVWF      FARG_strlen_s+1
	CALL       _strlen+0
	MOVF       R0, 0
	MOVWF      FARG_strncpy_size+0
	MOVF       R1, 0
	MOVWF      FARG_strncpy_size+1
	MOVLW      _procbuf+0
	MOVWF      FARG_strncpy_to+0
	MOVLW      hi_addr(_procbuf+0)
	MOVWF      FARG_strncpy_to+1
	MOVLW      _inbuf+1
	MOVWF      FARG_strncpy_from+0
	MOVLW      hi_addr(_inbuf+1)
	MOVWF      FARG_strncpy_from+1
	CALL       _strncpy+0
;remote.c,73 :: 		procbuf[bufpointer-1] = 0;                  //add null string ending to procbuf
	MOVLW      1
	SUBWF      _bufpointer+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	SUBWFB     R1, 1
	MOVLW      _procbuf+0
	ADDWF      R0, 0
	MOVWF      FSR1L
	MOVLW      hi_addr(_procbuf+0)
	ADDWFC     R1, 0
	MOVWF      FSR1H
	CLRF       INDF1+0
;remote.c,74 :: 		outputcounter = atoi(procbuf);             //convert value to integer and put in outputcounter
	MOVLW      _procbuf+0
	MOVWF      FARG_atoi_s+0
	MOVLW      hi_addr(_procbuf+0)
	MOVWF      FARG_atoi_s+1
	CALL       _atoi+0
	MOVF       R0, 0
	MOVWF      _outputcounter+0
	MOVF       R1, 0
	MOVWF      _outputcounter+1
;remote.c,75 :: 		wlevel = wlevel + ((int)outputcounter * waterconst);
	CALL       _Int2Double+0
	MOVLW      154
	MOVWF      R4
	MOVLW      153
	MOVWF      R5
	MOVLW      25
	MOVWF      R6
	MOVLW      125
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       R0, 0
	MOVWF      FLOC__interrupt+0
	MOVF       R1, 0
	MOVWF      FLOC__interrupt+1
	MOVF       R2, 0
	MOVWF      FLOC__interrupt+2
	MOVF       R3, 0
	MOVWF      FLOC__interrupt+3
	MOVF       _wlevel+0, 0
	MOVWF      R0
	MOVF       _wlevel+1, 0
	MOVWF      R1
	CALL       _Word2Double+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      R4
	MOVF       FLOC__interrupt+1, 0
	MOVWF      R5
	MOVF       FLOC__interrupt+2, 0
	MOVWF      R6
	MOVF       FLOC__interrupt+3, 0
	MOVWF      R7
	CALL       _Add_32x32_FP+0
	CALL       _Double2Word+0
	MOVF       R0, 0
	MOVWF      _wlevel+0
	MOVF       R1, 0
	MOVWF      _wlevel+1
;remote.c,76 :: 		datarequested = 1;                      //set request watering action flag
	MOVLW      1
	MOVWF      _datarequested+0
;remote.c,77 :: 		}
	GOTO       L_interrupt13
L_interrupt12:
;remote.c,80 :: 		datarequested = 3;                       //set display watering time action flag
	MOVLW      3
	MOVWF      _datarequested+0
;remote.c,81 :: 		}
L_interrupt13:
L_interrupt11:
;remote.c,82 :: 		bufpointer = 0;                         //clear buffer
	CLRF       _bufpointer+0
;remote.c,83 :: 		}
L_interrupt9:
;remote.c,85 :: 		PIR1.RCIF = 0;                          //clear interrupt flag
	BCF        PIR1+0, 5
;remote.c,87 :: 		}
L_interrupt6:
;remote.c,89 :: 		if(PIR1.TMR1IF)                          //if timer overflowed
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt14
;remote.c,91 :: 		TMR1H = 0x0B;                         //load timer start value
	MOVLW      11
	MOVWF      TMR1H+0
;remote.c,92 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;remote.c,94 :: 		if(outputcounter > 0)                 //decrement output counter
	MOVF       _outputcounter+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt49
	MOVF       _outputcounter+0, 0
	SUBLW      0
L__interrupt49:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt15
;remote.c,96 :: 		outputcounter = outputcounter -1;
	MOVLW      1
	SUBWF      _outputcounter+0, 1
	MOVLW      0
	SUBWFB     _outputcounter+1, 1
;remote.c,97 :: 		}
L_interrupt15:
;remote.c,99 :: 		halfsecondscount++;
	INCF       _halfsecondscount+0, 1
	BTFSC      STATUS+0, 2
	INCF       _halfsecondscount+1, 1
;remote.c,100 :: 		if(halfsecondscount > 1200)
	MOVF       _halfsecondscount+1, 0
	SUBLW      4
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt50
	MOVF       _halfsecondscount+0, 0
	SUBLW      176
L__interrupt50:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt16
;remote.c,102 :: 		wlevel = wlevel - tendec;
	MOVLW      2
	SUBWF      _wlevel+0, 1
	MOVLW      0
	SUBWFB     _wlevel+1, 1
;remote.c,103 :: 		halfsecondscount = 0;
	CLRF       _halfsecondscount+0
	CLRF       _halfsecondscount+1
;remote.c,104 :: 		}
L_interrupt16:
;remote.c,106 :: 		PIR1.TMR1IF =0;                      //clear interrupt
	BCF        PIR1+0, 0
;remote.c,109 :: 		}
L_interrupt14:
;remote.c,112 :: 		}
L_end_interrupt:
L__interrupt48:
	RETFIE     %s
; end of _interrupt

_Serial_display_value:

;support.c,9 :: 		void Serial_display_value ( unsigned int value)//transmit value as ascii on via UART
;support.c,12 :: 		started = 0;
	CLRF       Serial_display_value_started_L0+0
;support.c,15 :: 		units = value % 10 ;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_units_L0+0
;support.c,16 :: 		value = value / 10 ;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       R1, 0
	MOVWF      FARG_Serial_display_value_value+1
;support.c,17 :: 		tens = value % 10 ;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_tens_L0+0
;support.c,18 :: 		value = value / 10 ;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       R1, 0
	MOVWF      FARG_Serial_display_value_value+1
;support.c,19 :: 		hunds = value % 10 ;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_hunds_L0+0
;support.c,20 :: 		value = value / 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       R1, 0
	MOVWF      FARG_Serial_display_value_value+1
;support.c,21 :: 		thousands = value % 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_thousands_L0+0
;support.c,22 :: 		value = value / 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       R1, 0
	MOVWF      FARG_Serial_display_value_value+1
;support.c,23 :: 		tenthous = value % 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_tenthous_L0+0
;support.c,24 :: 		value = value / 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_Serial_display_value_value+0, 0
	MOVWF      R0
	MOVF       FARG_Serial_display_value_value+1, 0
	MOVWF      R1
	CALL       _Div_16x16_U+0
	MOVF       R0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       R1, 0
	MOVWF      FARG_Serial_display_value_value+1
;support.c,25 :: 		hundthous = value % 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_U+0
	MOVF       R8, 0
	MOVWF      R0
	MOVF       R9, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      Serial_display_value_hundthous_L0+0
;support.c,28 :: 		if(hundthous > 0)
	MOVF       R0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_Serial_display_value17
;support.c,31 :: 		UART1_Write('0' + hundthous);
	MOVF       Serial_display_value_hundthous_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,32 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,33 :: 		}
L_Serial_display_value17:
;support.c,34 :: 		if((tenthous > 0) || (started))
	MOVF       Serial_display_value_tenthous_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value45
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value45
	GOTO       L_Serial_display_value20
L__Serial_display_value45:
;support.c,37 :: 		UART1_Write('0' + tenthous);
	MOVF       Serial_display_value_tenthous_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,38 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,39 :: 		}
L_Serial_display_value20:
;support.c,40 :: 		if((thousands > 0) || (started))
	MOVF       Serial_display_value_thousands_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value44
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value44
	GOTO       L_Serial_display_value23
L__Serial_display_value44:
;support.c,43 :: 		UART1_Write('0' + thousands);
	MOVF       Serial_display_value_thousands_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,44 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,45 :: 		}
L_Serial_display_value23:
;support.c,46 :: 		if((hunds > 0) || (started))
	MOVF       Serial_display_value_hunds_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value43
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value43
	GOTO       L_Serial_display_value26
L__Serial_display_value43:
;support.c,49 :: 		UART1_Write('0' + hunds);
	MOVF       Serial_display_value_hunds_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,50 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,51 :: 		}
L_Serial_display_value26:
;support.c,52 :: 		if((tens > 0) || started)
	MOVF       Serial_display_value_tens_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value42
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value42
	GOTO       L_Serial_display_value29
L__Serial_display_value42:
;support.c,55 :: 		UART1_Write('0' + tens);
	MOVF       Serial_display_value_tens_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,56 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,57 :: 		}
L_Serial_display_value29:
;support.c,60 :: 		UART1_Write('0' + units);
	MOVF       Serial_display_value_units_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,61 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,62 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,64 :: 		}
L_end_Serial_display_value:
	RETURN
; end of _Serial_display_value

_init:

;support.c,68 :: 		void init()   //initialise hardware
;support.c,70 :: 		TRISA = 0x00;
	CLRF       TRISA+0
;support.c,71 :: 		TRISC = 0x28;//0x2c;
	MOVLW      40
	MOVWF      TRISC+0
;support.c,72 :: 		ANSELC = 0x00; //0x0c;
	CLRF       ANSELC+0
;support.c,73 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;support.c,74 :: 		UART1_Init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      103
	MOVWF      SPBRG+0
	MOVLW      0
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;support.c,75 :: 		Delay_ms(2);
	MOVLW      3
	MOVWF      R12
	MOVLW      151
	MOVWF      R13
L_init30:
	DECFSZ     R13, 1
	GOTO       L_init30
	DECFSZ     R12, 1
	GOTO       L_init30
	NOP
	NOP
;support.c,76 :: 		RCSTA.SPEN = 1;  //setup serial comms
	BSF        RCSTA+0, 7
;support.c,77 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;support.c,78 :: 		TXSTA.SYNC = 0;
	BCF        TXSTA+0, 4
;support.c,79 :: 		INTCON = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;support.c,80 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;support.c,81 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;support.c,83 :: 		T1CON = 0x31; //setup timer1 prescale 8, fosc/4
	MOVLW      49
	MOVWF      T1CON+0
;support.c,84 :: 		T1GCON = 0x00; //no gated timer
	CLRF       T1GCON+0
;support.c,86 :: 		PIE1.TMR1IE = 1; //enable timer overflow interrupt
	BSF        PIE1+0, 0
;support.c,88 :: 		ADCON0 = 0x1D;
	MOVLW      29
	MOVWF      ADCON0+0
;support.c,89 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;support.c,90 :: 		WDTCON = 0x19; //enable watchdog timer 4 second timeout
	MOVLW      25
	MOVWF      WDTCON+0
;support.c,93 :: 		}
L_end_init:
	RETURN
; end of _init

_readanalog:

;support.c,95 :: 		int readanalog()       //read an averaged analog value from ADC
;support.c,97 :: 		unsigned int analogvalh = 0;
	CLRF       readanalog_analogvalh_L0+0
	CLRF       readanalog_analogvalh_L0+1
	CLRF       readanalog_analogvall_L0+0
	CLRF       readanalog_analogvall_L0+1
	CLRF       readanalog_analogval_L0+0
	CLRF       readanalog_analogval_L0+1
	CLRF       readanalog_analogval_L0+2
	CLRF       readanalog_analogval_L0+3
	CLRF       readanalog_countloop_L0+0
;support.c,102 :: 		for(countloop = 0;countloop <= 99;countloop++)
	CLRF       readanalog_countloop_L0+0
L_readanalog31:
	MOVF       readanalog_countloop_L0+0, 0
	SUBLW      99
	BTFSS      STATUS+0, 0
	GOTO       L_readanalog32
;support.c,104 :: 		ADCON0.GO =1;
	BSF        ADCON0+0, 1
;support.c,105 :: 		while(ADCON0.GO);
L_readanalog34:
	BTFSS      ADCON0+0, 1
	GOTO       L_readanalog35
	GOTO       L_readanalog34
L_readanalog35:
;support.c,106 :: 		analogvalh =ADRESH ;
	MOVF       ADRESH+0, 0
	MOVWF      readanalog_analogvalh_L0+0
	CLRF       readanalog_analogvalh_L0+1
;support.c,107 :: 		analogvall = ADRESL;
	MOVF       ADRESL+0, 0
	MOVWF      readanalog_analogvall_L0+0
	CLRF       readanalog_analogvall_L0+1
;support.c,108 :: 		analogval = analogval + ((analogvalh << 8) | (analogvall));
	MOVF       readanalog_analogvalh_L0+0, 0
	MOVWF      R1
	CLRF       R0
	MOVF       readanalog_analogvall_L0+0, 0
	IORWF       R0, 1
	MOVF       readanalog_analogvall_L0+1, 0
	IORWF       R1, 1
	MOVF       R0, 0
	ADDWF      readanalog_analogval_L0+0, 1
	MOVF       R1, 0
	ADDWFC     readanalog_analogval_L0+1, 1
	MOVLW      0
	ADDWFC     readanalog_analogval_L0+2, 1
	ADDWFC     readanalog_analogval_L0+3, 1
;support.c,109 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12
	MOVLW      75
	MOVWF      R13
L_readanalog36:
	DECFSZ     R13, 1
	GOTO       L_readanalog36
	DECFSZ     R12, 1
	GOTO       L_readanalog36
;support.c,102 :: 		for(countloop = 0;countloop <= 99;countloop++)
	INCF       readanalog_countloop_L0+0, 1
;support.c,110 :: 		}
	GOTO       L_readanalog31
L_readanalog32:
;support.c,112 :: 		analogval = (int)(analogval / 100.0);
	MOVF       readanalog_analogval_L0+0, 0
	MOVWF      R0
	MOVF       readanalog_analogval_L0+1, 0
	MOVWF      R1
	MOVF       readanalog_analogval_L0+2, 0
	MOVWF      R2
	MOVF       readanalog_analogval_L0+3, 0
	MOVWF      R3
	CALL       _Longword2Double+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      72
	MOVWF      R6
	MOVLW      133
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	CALL       _Double2Int+0
	MOVF       R0, 0
	MOVWF      readanalog_analogval_L0+0
	MOVF       R1, 0
	MOVWF      readanalog_analogval_L0+1
	MOVLW      0
	BTFSC      readanalog_analogval_L0+1, 7
	MOVLW      255
	MOVWF      readanalog_analogval_L0+2
	MOVWF      readanalog_analogval_L0+3
;support.c,113 :: 		return analogval;
	MOVF       readanalog_analogval_L0+0, 0
	MOVWF      R0
	MOVF       readanalog_analogval_L0+1, 0
	MOVWF      R1
;support.c,115 :: 		}
L_end_readanalog:
	RETURN
; end of _readanalog

_processrequest:

;support.c,117 :: 		void processrequest(int analogval)
;support.c,120 :: 		if(datarequested == 2)
	MOVF       _datarequested+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest37
;support.c,122 :: 		Serial_display_value(analogval);
	MOVF       FARG_processrequest_analogval+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       FARG_processrequest_analogval+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,124 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,125 :: 		}
L_processrequest37:
;support.c,126 :: 		if(datarequested == 1)
	MOVF       _datarequested+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest38
;support.c,128 :: 		Serial_display_value(outputcounter);
	MOVF       _outputcounter+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       _outputcounter+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,129 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,131 :: 		}
L_processrequest38:
;support.c,132 :: 		if(datarequested == 3)
	MOVF       _datarequested+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest39
;support.c,134 :: 		Serial_display_value(outputcounter);
	MOVF       _outputcounter+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       _outputcounter+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,135 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,137 :: 		}
L_processrequest39:
;support.c,138 :: 		if(outputcounter > 0)
	MOVF       _outputcounter+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__processrequest55
	MOVF       _outputcounter+0, 0
	SUBLW      0
L__processrequest55:
	BTFSC      STATUS+0, 0
	GOTO       L_processrequest40
;support.c,140 :: 		PORTC.B2 = 1;
	BSF        PORTC+0, 2
;support.c,141 :: 		}
	GOTO       L_processrequest41
L_processrequest40:
;support.c,144 :: 		PORTC.B2 = 0;
	BCF        PORTC+0, 2
;support.c,145 :: 		}
L_processrequest41:
;support.c,146 :: 		}
L_end_processrequest:
	RETURN
; end of _processrequest
