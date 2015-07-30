//********************************************************************************
//  Author: Richard Laybourn
//  Date: 20 June 2015
//  summary: functions to support irrigation controller project
//
//********************************************************************************


    void Serial_display_value ( unsigned int value)//transmit value as ascii on via UART
{
    unsigned char hundthous,tenthous,thousands, hunds, tens, units,started ;
    started = 0;
    /*  first ,  the digits  */

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

    /*  now display them      */
    if(hundthous > 0)
    {
      //LCD_putch('0' + hundthous);
      UART1_Write('0' + hundthous);
      started = 1;
     }
    if((tenthous > 0) || (started))
    {
      //LCD_putch('0' + tenthous);
      UART1_Write('0' + tenthous);
      started = 1;
    }
    if((thousands > 0) || (started))
    {
      //LCD_putch('0' + thousands ) ;
      UART1_Write('0' + thousands);
      started = 1;
    }
    if((hunds > 0) || (started))
    {
      //LCD_putch('0' + hunds ) ;
      UART1_Write('0' + hunds);
      started = 1;
    }
    if((tens > 0) || started)
    {
      //LCD_putch('0' + tens);
      UART1_Write('0' + tens);
      started = 1;
    }

    //LCD_putch('0' + units);
    UART1_Write('0' + units);
    UART1_Write(13);
    UART1_Write(10);

}



void init()   //initialise hardware
{
TRISA = 0x00;
TRISC = 0x28;//0x2c;
ANSELC = 0x00; //0x0c;
ANSELA = 0x00;
UART1_Init(9600);
Delay_ms(2);
RCSTA.SPEN = 1;  //setup serial comms
TXSTA.TXEN = 1;
TXSTA.SYNC = 0;
INTCON = 0xC0;
PIE1.RCIE = 1;
RCSTA.CREN = 1;

T1CON = 0x31; //setup timer1 prescale 8, fosc/4
T1GCON = 0x00; //no gated timer

PIE1.TMR1IE = 1; //enable timer overflow interrupt

ADCON0 = 0x1D;
ADCON1 = 0x80;
WDTCON = 0x19; //enable watchdog timer 4 second timeout


}

int readanalog()       //read an averaged analog value from ADC
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