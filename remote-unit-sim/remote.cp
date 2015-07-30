#line 1 "Z:/home/richard/mikroc/remote-unit-sim/remote.c"
#line 1 "z:/home/richard/mikroc/remote-unit-sim/support.h"







 void Serial_display_value ( unsigned int value);
 void init();
 int readanalog();
 void processrequest(int analogval);
#line 13 "Z:/home/richard/mikroc/remote-unit-sim/remote.c"
char inchr;
char inbuf[10] = {0,0,0,0,0,0,0,0,0,0};
char procbuf[10] = {0,0,0,0,0,0,0,0,0,0};
char bufpointer = 0;
unsigned char datarequested = 0;
unsigned int outputcounter = 0;
unsigned int halfsecondscount = 0;
unsigned int wlevel = 600;


void main() {

long unsigned int analogval =0;

init();

while(1)
{

 Delay_ms(100);

 analogval = wlevel;
 if(TMR1H > 200)
 {
 analogval++;
 }
 else if(TMR1H < 90)
 {
 analogval--;
 }
 processrequest(analogval);
 asm CLRWDT;
}
}

void interrupt()
{
char inchr;


 if(PIR1.RCIF)
 {
 inchr = RCREG;

 if(inchr != 10)
 {
 inbuf[bufpointer] = inchr;
 bufpointer ++;
 if(bufpointer > 9)
 {
 bufpointer = 9;
 }
 }
 else
 {
 if(inbuf[0] == 't')
 datarequested = 2;
 else if(inbuf[0] == 'w')
 {
 strncpy(&procbuf,&inbuf[1],strlen(inbuf) );
 procbuf[bufpointer-1] = 0;
 outputcounter = atoi(procbuf);
 wlevel = wlevel + ((int)outputcounter *  0.3 );
 datarequested = 1;
 }
 else
 {
 datarequested = 3;
 }
 bufpointer = 0;
 }

 PIR1.RCIF = 0;

 }

 if(PIR1.TMR1IF)
 {
 TMR1H = 0x0B;
 TMR1L = 0xDC;

 if(outputcounter > 0)
 {
 outputcounter = outputcounter -1;
 }

 halfsecondscount++;
 if(halfsecondscount > 1200)
 {
 wlevel = wlevel -  2 ;
 halfsecondscount = 0;
 }

 PIR1.TMR1IF =0;


 }


}
#line 1 "z:/home/richard/mikroc/remote-unit-sim/support.c"








 void Serial_display_value ( unsigned int value)
{
 unsigned char hundthous,tenthous,thousands, hunds, tens, units,started ;
 started = 0;


 units = value % 10 ;
 value = value / 10 ;
 tens = value % 10 ;
 value = value / 10 ;
 hunds = value % 10 ;
 value = value / 10;
 thousands = value % 10;
 value = value / 10;
 tenthous = value % 10;
 value = value / 10;
 hundthous = value % 10;


 if(hundthous > 0)
 {

 UART1_Write('0' + hundthous);
 started = 1;
 }
 if((tenthous > 0) || (started))
 {

 UART1_Write('0' + tenthous);
 started = 1;
 }
 if((thousands > 0) || (started))
 {

 UART1_Write('0' + thousands);
 started = 1;
 }
 if((hunds > 0) || (started))
 {

 UART1_Write('0' + hunds);
 started = 1;
 }
 if((tens > 0) || started)
 {

 UART1_Write('0' + tens);
 started = 1;
 }


 UART1_Write('0' + units);
 UART1_Write(13);
 UART1_Write(10);

}



void init()
{
TRISA = 0x00;
TRISC = 0x28;
ANSELC = 0x00;
ANSELA = 0x00;
UART1_Init(9600);
Delay_ms(2);
RCSTA.SPEN = 1;
TXSTA.TXEN = 1;
TXSTA.SYNC = 0;
INTCON = 0xC0;
PIE1.RCIE = 1;
RCSTA.CREN = 1;

T1CON = 0x31;
T1GCON = 0x00;

PIE1.TMR1IE = 1;

ADCON0 = 0x1D;
ADCON1 = 0x80;
WDTCON = 0x19;


}

int readanalog()
{
 unsigned int analogvalh = 0;
 unsigned int analogvall = 0;
 long unsigned int analogval =0;
 char countloop = 0;

 for(countloop = 0;countloop <= 99;countloop++)
 {
 ADCON0.GO =1;
 while(ADCON0.GO);
 analogvalh =ADRESH ;
 analogvall = ADRESL;
 analogval = analogval + ((analogvalh << 8) | (analogvall));
 Delay_ms(1);
 }

 analogval = (int)(analogval / 100.0);
 return analogval;

}

void processrequest(int analogval)
{

 if(datarequested == 2)
 {
 Serial_display_value(analogval);

 datarequested = 0;
 }
 if(datarequested == 1)
 {
 Serial_display_value(outputcounter);
 datarequested = 0;

 }
 if(datarequested == 3)
 {
 Serial_display_value(outputcounter);
 datarequested = 0;

 }
 if(outputcounter > 0)
 {
 PORTC.B2 = 1;
 }
 else
 {
 PORTC.B2 = 0;
 }
}
