
_main:

;remote.c,12 :: 		void main() {
;remote.c,14 :: 		long unsigned int analogval =0;
	CLRF       main_analogval_L0+0
	CLRF       main_analogval_L0+1
	CLRF       main_analogval_L0+2
	CLRF       main_analogval_L0+3
;remote.c,16 :: 		init();
	CALL       _init+0
;remote.c,18 :: 		while(1)
L_main0:
;remote.c,21 :: 		Delay_ms(100);
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
;remote.c,23 :: 		analogval = readanalog();
	CALL       _readanalog+0
	MOVF       R0, 0
	MOVWF      main_analogval_L0+0
	MOVF       R1, 0
	MOVWF      main_analogval_L0+1
	MOVLW      0
	BTFSC      main_analogval_L0+1, 7
	MOVLW      255
	MOVWF      main_analogval_L0+2
	MOVWF      main_analogval_L0+3
;remote.c,24 :: 		processrequest(analogval);
	MOVF       main_analogval_L0+0, 0
	MOVWF      FARG_processrequest_analogval+0
	MOVF       main_analogval_L0+1, 0
	MOVWF      FARG_processrequest_analogval+1
	CALL       _processrequest+0
;remote.c,25 :: 		asm CLRWDT;          // clear the watchdog timer
	CLRWDT
;remote.c,26 :: 		}
	GOTO       L_main0
;remote.c,27 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:

;remote.c,29 :: 		void interrupt()
;remote.c,34 :: 		if(PIR1.RCIF)          //if charachter recieved
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt3
;remote.c,36 :: 		inchr = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      interrupt_inchr_L0+0
;remote.c,38 :: 		if(inchr != 10)       //if char is not a linefeed then write into buffer
	MOVF       interrupt_inchr_L0+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt4
;remote.c,40 :: 		inbuf[bufpointer] = inchr;
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
;remote.c,41 :: 		bufpointer ++;
	INCF       _bufpointer+0, 1
;remote.c,42 :: 		if(bufpointer > 9)
	MOVF       _bufpointer+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt5
;remote.c,44 :: 		bufpointer = 9;
	MOVLW      9
	MOVWF      _bufpointer+0
;remote.c,45 :: 		}
L_interrupt5:
;remote.c,46 :: 		}
	GOTO       L_interrupt6
L_interrupt4:
;remote.c,49 :: 		if(inbuf[0] == 't')     //if moisture level requeted
	MOVF       _inbuf+0, 0
	XORLW      116
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
;remote.c,50 :: 		datarequested = 2;    //set transmit moisture level action flag
	MOVLW      2
	MOVWF      _datarequested+0
	GOTO       L_interrupt8
L_interrupt7:
;remote.c,51 :: 		else if(inbuf[0] == 'w')   //if watering commanded
	MOVF       _inbuf+0, 0
	XORLW      119
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;remote.c,53 :: 		strncpy(&procbuf,&inbuf[1],strlen(inbuf) ); //copy all except first char to procbuf
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
;remote.c,54 :: 		procbuf[bufpointer-1] = 0;                  //add null string ending to procbuf
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
;remote.c,55 :: 		outputcounter = atoi(procbuf);             //convert value to integer and put in outputcounter
	MOVLW      _procbuf+0
	MOVWF      FARG_atoi_s+0
	MOVLW      hi_addr(_procbuf+0)
	MOVWF      FARG_atoi_s+1
	CALL       _atoi+0
	MOVF       R0, 0
	MOVWF      _outputcounter+0
	MOVF       R1, 0
	MOVWF      _outputcounter+1
;remote.c,56 :: 		datarequested = 1;                      //set request watering action flag
	MOVLW      1
	MOVWF      _datarequested+0
;remote.c,57 :: 		}
	GOTO       L_interrupt10
L_interrupt9:
;remote.c,60 :: 		datarequested = 3;                       //set display watering time action flag
	MOVLW      3
	MOVWF      _datarequested+0
;remote.c,61 :: 		}
L_interrupt10:
L_interrupt8:
;remote.c,62 :: 		bufpointer = 0;                         //clear buffer
	CLRF       _bufpointer+0
;remote.c,63 :: 		}
L_interrupt6:
;remote.c,65 :: 		PIR1.RCIF = 0;                          //clear interrupt flag
	BCF        PIR1+0, 5
;remote.c,67 :: 		}
L_interrupt3:
;remote.c,69 :: 		if(PIR1.TMR1IF)                          //if timer overflowed
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt11
;remote.c,71 :: 		TMR1H = 0x0B;                         //load timer start value
	MOVLW      11
	MOVWF      TMR1H+0
;remote.c,72 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;remote.c,74 :: 		if(outputcounter > 0)                 //decrement output counter
	MOVF       _outputcounter+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt45
	MOVF       _outputcounter+0, 0
	SUBLW      0
L__interrupt45:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt12
;remote.c,76 :: 		outputcounter = outputcounter -1;
	MOVLW      1
	SUBWF      _outputcounter+0, 1
	MOVLW      0
	SUBWFB     _outputcounter+1, 1
;remote.c,77 :: 		}
L_interrupt12:
;remote.c,79 :: 		PIR1.TMR1IF =0;                      //clear interrupt
	BCF        PIR1+0, 0
;remote.c,82 :: 		}
L_interrupt11:
;remote.c,85 :: 		}
L_end_interrupt:
L__interrupt44:
	RETFIE     %s
; end of _interrupt

_Serial_display_value:

;support.c,1 :: 		void Serial_display_value ( unsigned int value)
;support.c,4 :: 		started = 0;
	CLRF       Serial_display_value_started_L0+0
;support.c,7 :: 		units = value % 10 ;
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
;support.c,8 :: 		value = value / 10 ;
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
;support.c,9 :: 		tens = value % 10 ;
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
;support.c,10 :: 		value = value / 10 ;
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
;support.c,11 :: 		hunds = value % 10 ;
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
;support.c,12 :: 		value = value / 10;
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
;support.c,13 :: 		thousands = value % 10;
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
;support.c,14 :: 		value = value / 10;
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
;support.c,15 :: 		tenthous = value % 10;
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
;support.c,16 :: 		value = value / 10;
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
;support.c,17 :: 		hundthous = value % 10;
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
;support.c,20 :: 		if(hundthous > 0)
	MOVF       R0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_Serial_display_value13
;support.c,23 :: 		UART1_Write('0' + hundthous);
	MOVF       Serial_display_value_hundthous_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,24 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,25 :: 		}
L_Serial_display_value13:
;support.c,26 :: 		if((tenthous > 0) || (started))
	MOVF       Serial_display_value_tenthous_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value41
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value41
	GOTO       L_Serial_display_value16
L__Serial_display_value41:
;support.c,29 :: 		UART1_Write('0' + tenthous);
	MOVF       Serial_display_value_tenthous_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,30 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,31 :: 		}
L_Serial_display_value16:
;support.c,32 :: 		if((thousands > 0) || (started))
	MOVF       Serial_display_value_thousands_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value40
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value40
	GOTO       L_Serial_display_value19
L__Serial_display_value40:
;support.c,35 :: 		UART1_Write('0' + thousands);
	MOVF       Serial_display_value_thousands_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,36 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,37 :: 		}
L_Serial_display_value19:
;support.c,38 :: 		if((hunds > 0) || (started))
	MOVF       Serial_display_value_hunds_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value39
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value39
	GOTO       L_Serial_display_value22
L__Serial_display_value39:
;support.c,41 :: 		UART1_Write('0' + hunds);
	MOVF       Serial_display_value_hunds_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,42 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,43 :: 		}
L_Serial_display_value22:
;support.c,44 :: 		if((tens > 0) || started)
	MOVF       Serial_display_value_tens_L0+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__Serial_display_value38
	MOVF       Serial_display_value_started_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Serial_display_value38
	GOTO       L_Serial_display_value25
L__Serial_display_value38:
;support.c,47 :: 		UART1_Write('0' + tens);
	MOVF       Serial_display_value_tens_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,48 :: 		started = 1;
	MOVLW      1
	MOVWF      Serial_display_value_started_L0+0
;support.c,49 :: 		}
L_Serial_display_value25:
;support.c,52 :: 		UART1_Write('0' + units);
	MOVF       Serial_display_value_units_L0+0, 0
	ADDLW      48
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,53 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,54 :: 		UART1_Write(10);
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;support.c,56 :: 		}
L_end_Serial_display_value:
	RETURN
; end of _Serial_display_value

_init:

;support.c,60 :: 		void init()
;support.c,62 :: 		TRISA = 0x00;
	CLRF       TRISA+0
;support.c,63 :: 		TRISC = 0x28;//0x2c;
	MOVLW      40
	MOVWF      TRISC+0
;support.c,64 :: 		ANSELC = 0x00; //0x0c;
	CLRF       ANSELC+0
;support.c,65 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;support.c,66 :: 		UART1_Init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      103
	MOVWF      SPBRG+0
	MOVLW      0
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;support.c,67 :: 		Delay_ms(2);
	MOVLW      3
	MOVWF      R12
	MOVLW      151
	MOVWF      R13
L_init26:
	DECFSZ     R13, 1
	GOTO       L_init26
	DECFSZ     R12, 1
	GOTO       L_init26
	NOP
	NOP
;support.c,68 :: 		RCSTA.SPEN = 1;  //setup serial comms
	BSF        RCSTA+0, 7
;support.c,69 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;support.c,70 :: 		TXSTA.SYNC = 0;
	BCF        TXSTA+0, 4
;support.c,71 :: 		INTCON = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;support.c,72 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;support.c,73 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;support.c,75 :: 		T1CON = 0x31; //setup timer1 prescale 8, fosc/4
	MOVLW      49
	MOVWF      T1CON+0
;support.c,76 :: 		T1GCON = 0x00; //no gated timer
	CLRF       T1GCON+0
;support.c,78 :: 		PIE1.TMR1IE = 1; //enable timer overflow interrupt
	BSF        PIE1+0, 0
;support.c,80 :: 		ADCON0 = 0x1D;
	MOVLW      29
	MOVWF      ADCON0+0
;support.c,81 :: 		ADCON1 = 0x80;
	MOVLW      128
	MOVWF      ADCON1+0
;support.c,82 :: 		WDTCON = 0x19; //enable watchdog timer 4 second timeout
	MOVLW      25
	MOVWF      WDTCON+0
;support.c,85 :: 		}
L_end_init:
	RETURN
; end of _init

_readanalog:

;support.c,87 :: 		int readanalog()
;support.c,89 :: 		unsigned int analogvalh = 0;
	CLRF       readanalog_analogvalh_L0+0
	CLRF       readanalog_analogvalh_L0+1
	CLRF       readanalog_analogvall_L0+0
	CLRF       readanalog_analogvall_L0+1
	CLRF       readanalog_analogval_L0+0
	CLRF       readanalog_analogval_L0+1
	CLRF       readanalog_analogval_L0+2
	CLRF       readanalog_analogval_L0+3
	CLRF       readanalog_countloop_L0+0
;support.c,94 :: 		for(countloop = 0;countloop <= 99;countloop++)
	CLRF       readanalog_countloop_L0+0
L_readanalog27:
	MOVF       readanalog_countloop_L0+0, 0
	SUBLW      99
	BTFSS      STATUS+0, 0
	GOTO       L_readanalog28
;support.c,96 :: 		ADCON0.GO =1;
	BSF        ADCON0+0, 1
;support.c,97 :: 		while(ADCON0.GO);
L_readanalog30:
	BTFSS      ADCON0+0, 1
	GOTO       L_readanalog31
	GOTO       L_readanalog30
L_readanalog31:
;support.c,98 :: 		analogvalh =ADRESH ;
	MOVF       ADRESH+0, 0
	MOVWF      readanalog_analogvalh_L0+0
	CLRF       readanalog_analogvalh_L0+1
;support.c,99 :: 		analogvall = ADRESL;
	MOVF       ADRESL+0, 0
	MOVWF      readanalog_analogvall_L0+0
	CLRF       readanalog_analogvall_L0+1
;support.c,100 :: 		analogval = analogval + ((analogvalh << 8) | (analogvall));
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
;support.c,101 :: 		Delay_ms(1);
	MOVLW      2
	MOVWF      R12
	MOVLW      75
	MOVWF      R13
L_readanalog32:
	DECFSZ     R13, 1
	GOTO       L_readanalog32
	DECFSZ     R12, 1
	GOTO       L_readanalog32
;support.c,94 :: 		for(countloop = 0;countloop <= 99;countloop++)
	INCF       readanalog_countloop_L0+0, 1
;support.c,102 :: 		}
	GOTO       L_readanalog27
L_readanalog28:
;support.c,104 :: 		analogval = (int)(analogval / 100.0);
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
;support.c,105 :: 		return analogval;
	MOVF       readanalog_analogval_L0+0, 0
	MOVWF      R0
	MOVF       readanalog_analogval_L0+1, 0
	MOVWF      R1
;support.c,107 :: 		}
L_end_readanalog:
	RETURN
; end of _readanalog

_processrequest:

;support.c,109 :: 		void processrequest(int analogval)
;support.c,112 :: 		if(datarequested == 2)
	MOVF       _datarequested+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest33
;support.c,114 :: 		Serial_display_value(analogval);
	MOVF       FARG_processrequest_analogval+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       FARG_processrequest_analogval+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,116 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,117 :: 		}
L_processrequest33:
;support.c,118 :: 		if(datarequested == 1)
	MOVF       _datarequested+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest34
;support.c,120 :: 		Serial_display_value(outputcounter);
	MOVF       _outputcounter+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       _outputcounter+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,121 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,123 :: 		}
L_processrequest34:
;support.c,124 :: 		if(datarequested == 3)
	MOVF       _datarequested+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_processrequest35
;support.c,126 :: 		Serial_display_value(outputcounter);
	MOVF       _outputcounter+0, 0
	MOVWF      FARG_Serial_display_value_value+0
	MOVF       _outputcounter+1, 0
	MOVWF      FARG_Serial_display_value_value+1
	CALL       _Serial_display_value+0
;support.c,127 :: 		datarequested = 0;
	CLRF       _datarequested+0
;support.c,129 :: 		}
L_processrequest35:
;support.c,130 :: 		if(outputcounter > 0)
	MOVF       _outputcounter+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__processrequest50
	MOVF       _outputcounter+0, 0
	SUBLW      0
L__processrequest50:
	BTFSC      STATUS+0, 0
	GOTO       L_processrequest36
;support.c,132 :: 		PORTC.B2 = 1;
	BSF        PORTC+0, 2
;support.c,133 :: 		}
	GOTO       L_processrequest37
L_processrequest36:
;support.c,136 :: 		PORTC.B2 = 0;
	BCF        PORTC+0, 2
;support.c,137 :: 		}
L_processrequest37:
;support.c,138 :: 		}
L_end_processrequest:
	RETURN
; end of _processrequest
